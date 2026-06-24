# Phase 4: FHIR Interoperability (SMART, Bulk Export, Subscriptions)

**Status:** 🔴 Not started
**Priority:** P2 — External integration
**Effort:** ~3 weeks
**Depends on:** Phase 1 (FHIR REST API)

## Objective

Make Clinical Curator a FHIR-native system capable of interoperating with external EHRs, SMART on FHIR apps, and supporting bulk data export. This enables third-party app ecosystems and health information exchange.

## 4A: SMART on FHIR

### OAuth 2.0 + OpenID Connect

```dart
// clinical_curator_server/lib/src/auth/smart_auth.dart

class SmartAuthService {
  /// SMART App Launch — Standalone launch
  /// 1. App registers with launch URL
  /// 2. User authenticates via OAuth2
  /// 3. App receives access token with scoped permissions
  Future<AccessTokenResponse> launch(Session session, SmartLaunchRequest request) async {
    // Validate redirect_uri + client_id
    final client = await _validateClient(session, request.clientId, request.redirectUri);

    // Generate authorization code
    final code = _generateCode();

    // Store pending authorization
    await session.db.execute(
      'INSERT INTO fhir_smart_auth (code, client_id, user_id, scopes, expires_at) VALUES (@c, @client, @user, @scopes, @exp)',
      parameters: {
        'c': code, 'client': request.clientId,
        'user': session.auth.userId,
        'scopes': jsonEncode(request.scope?.split(' ') ?? []),
        'exp': DateTime.now().add(const Duration(minutes: 5)),
      },
    );

    // Redirect to app with code
    return AccessTokenResponse(
      redirect: '${request.redirectUri}?code=$code&state=${request.state}',
    );
  }

  /// Token exchange — authorization code → access token
  Future<TokenResponse> token(Session session, String code, String clientId) async {
    final auth = await session.db.query(
      'SELECT user_id, scopes FROM fhir_smart_auth WHERE code = @c AND client_id = @client AND expires_at > NOW()',
      parameters: {'c': code, 'client': clientId},
    );
    if (auth.isEmpty) throw AuthException('Invalid or expired code');

    final userId = auth.first[0] as String;
    final scopes = jsonDecode(auth.first[1] as String) as List<String>;

    // Generate JWT access token with FHIR scopes
    final token = _generateJwt(userId: userId, scopes: scopes);

    // Invalidate code
    await session.db.execute('DELETE FROM fhir_smart_auth WHERE code = @c', parameters: {'c': code});

    return TokenResponse(
      accessToken: token,
      tokenType: 'Bearer',
      expiresIn: 3600,
      scope: scopes.join(' '),
      patient: userId,
    );
  }

  /// Scope-based authorization check for FHIR endpoints.
  /// Scopes: 'patient/*.read', 'user/*.write', 'system/*.read'
  bool authorized(List<String> scopes, String resourceType, String operation) {
    for (final scope in scopes) {
      final parts = scope.split('/');
      if (parts.length != 2) continue;
      final context = parts[0]; // 'patient', 'user', 'system'
      final rights = parts[1];  // '*.read', 'Observation.write'

      if (context == 'system' && rights.contains(operation)) return true;
      // Patient/user-level scope checked against resource ownership
    }
    return false;
  }
}
```

### SMART Config Endpoint

```
GET /.well-known/smart-configuration

Response:
{
  "issuer": "https://clinicalcurator.com",
  "authorization_endpoint": "https://clinicalcurator.com/auth/authorize",
  "token_endpoint": "https://clinicalcurator.com/auth/token",
  "introspection_endpoint": "https://clinicalcurator.com/auth/introspect",
  "scopes_supported": [
    "openid", "profile", "fhirUser",
    "launch", "launch/patient",
    "patient/*.read", "patient/*.write",
    "user/*.read", "user/*.write",
    "system/*.read"
  ],
  "capabilities": [
    "launch-standalone", "launch-ehr",
    "client-confidential-symmetric",
    "sso-openid-connect",
    "context-standalone-patient",
    "permission-patient", "permission-user"
  ]
}
```

## 4B: FHIR Bulk Data Export

```dart
// clinical_curator_server/lib/src/endpoints/fhir_export_endpoint.dart

class FhirExportEndpoint extends Endpoint {
  final _store = FhirStoreService();

  /// POST /fhir/Patient/$export — Kick off async export
  Future<Map<String, dynamic>> export(Session session, {
    String? _outputFormat, // 'application/fhir+ndjson'
    String? _since,
  }) async {
    // Create export job
    final jobId = Uuid().v4();
    await session.db.execute(
      'INSERT INTO fhir_export_jobs (job_id, status, created_by, created_at) VALUES (@id, @status, @user, NOW())',
      parameters: {'id': jobId, 'status': 'active', 'user': session.auth.userId},
    );

    // Start async export (in production: background worker)
    // For now: inline processing for small datasets
    final patients = await session.db.query(
      'SELECT fhir_id, resource_json FROM fhir_resource WHERE resource_type = @type AND is_deleted = false',
      parameters: {'type': 'Patient'},
    );

    // Write NDJSON files
    for (final row in patients) {
      final fhirId = row[0] as String;
      final json = row[1] as String;
      // In production: stream to cloud storage
      await _writeFile(jobId, 'Patient/$fhirId.ndjson', json);
    }

    // Update job status
    await session.db.execute(
      "UPDATE fhir_export_jobs SET status = 'completed', completed_at = NOW() WHERE job_id = @id",
      parameters: {'id': jobId},
    );

    return {
      'transactionTime': DateTime.now().toUtc().toIso8601String(),
      'request': '/fhir/Patient/\$export',
      'requiresAccessToken': true,
      'output': [
        {'type': 'Patient', 'url': '/fhir/export/$jobId/Patient.ndjson'},
      ],
    };
  }

  /// GET /fhir/export/{jobId}/status
  Future<Map<String, dynamic>> exportStatus(Session session, String jobId) async {
    final job = await session.db.query(
      'SELECT status, completed_at FROM fhir_export_jobs WHERE job_id = @id',
      parameters: {'id': jobId},
    );
    if (job.isEmpty) throw NotFoundException('Export job not found');
    return {
      'transactionTime': job.first[1]?.toString(),
      'request': '/fhir/Patient/\$export',
      'requiresAccessToken': true,
      'status': job.first[0],
    };
  }
}
```

## 4C: FHIR Subscriptions (WebSocket)

```dart
// clinical_curator_server/lib/src/endpoints/fhir_subscription_endpoint.dart

class FhirSubscriptionEndpoint extends Endpoint {
  /// Subscribe to resource changes for a patient.
  /// Returns a WebSocket stream of FHIR change notifications.
  Stream<Map<String, dynamic>> subscribe(Session session, String patientFhirId) async* {
    // In production: use Postgres LISTEN/NOTIFY
    while (true) {
      // Poll for new resources since last check (simplified)
      final changes = await session.db.query(
        '''
        SELECT resource_type, resource_json
        FROM fhir_resource
        WHERE search_params @> jsonb_build_object('patient', @patientRef)
          AND last_updated > @since
        ORDER BY last_updated ASC
        ''',
        parameters: {'patientRef': 'Patient/$patientFhirId', 'since': _lastPoll},
      );

      for (final row in changes) {
        yield {
          'resourceType': row[0],
          'resource': jsonDecode(row[1] as String),
        };
      }

      _lastPoll = DateTime.now().toUtc();
      await Future.delayed(const Duration(seconds: 2)); // Poll interval
    }
  }

  /// Create a FHIR Subscription resource.
  Future<Map<String, dynamic>> createSubscription(
    Session session,
    String patientFhirId,
    List<String> resourceTypes, // ['Observation', 'MedicationRequest']
  ) async {
    return await _store.create(session, {
      'resourceType': 'Subscription',
      'status': 'active',
      'criteria': resourceTypes.map((t) => '$t?patient=Patient/$patientFhirId').join(','),
      'channel': {
        'type': 'websocket',
        'endpoint': 'wss://clinicalcurator.com/fhir/subscription',
      },
    });
  }
}
```

## 4D: External System Integration

### HAPI FHIR Federation

```dart
// clinical_curator_server/lib/src/services/external_fhir_service.dart

class ExternalFhirService {
  final Dio _http = Dio(BaseOptions(
    headers: {'Accept': 'application/fhir+json'},
  ));

  /// Proxy read request to external FHIR server.
  Future<Map<String, dynamic>?> readFromExternal(
    String externalBaseUrl,
    String resourceType,
    String fhirId,
  ) async {
    final response = await _http.get('$externalBaseUrl/$resourceType/$fhirId');
    return response.data;
  }

  /// Fetch and cache external lab results.
  Future<void> syncExternalLabResults(String externalBaseUrl, String patientFhirId) async {
    final bundle = await _http.get(
      '$externalBaseUrl/Observation',
      queryParameters: {
        'patient': 'Patient/$patientFhirId',
        'category': 'laboratory',
        '_count': '100',
      },
    );

    for (final entry in bundle.data['entry'] ?? []) {
      final resource = entry['resource'];
      // Store locally in our FHIR store
      await _store.create(resource);
    }
  }
}
```

## Files to Create

| File | Purpose |
|------|---------|
| `clinical_curator_server/lib/src/auth/smart_auth.dart` | SMART OAuth2 authorization + token exchange |
| `clinical_curator_server/lib/src/endpoints/fhir_export_endpoint.dart` | Bulk data export |
| `clinical_curator_server/lib/src/endpoints/fhir_subscription_endpoint.dart` | WebSocket subscriptions |
| `clinical_curator_server/lib/src/services/external_fhir_service.dart` | External FHIR server federation |
| `clinical_curator_server/lib/src/endpoints/smart_config_endpoint.dart` | `.well-known/smart-configuration` endpoint |
| `clinical_curator_server/migrations/202606XX_smart_auth/` | SMART auth tables |
| `clinical_curator_server/migrations/202606XX_export_jobs/` | Export job tracking table |