# Phase 6: Backend Hardening — Audit Trail + Data Validation

**Status:** 🔴 Not started
**Priority:** P2 — Compliance + safety
**Effort:** ~2 weeks
**Depends on:** Phase 1 (FHIR storage layer)

## Objective

Implement FHIR-compliant audit trail with Provenance + AuditEvent resources, data validation against FHIR profiles, and terminology service for code validation. This ensures HIPAA-like compliance and clinical data quality.

## 6A: FHIR Audit Trail

### AuditEvent — Every Access Logged

```dart
// clinical_curator_server/lib/src/services/audit_service.dart

class AuditService {
  /// Record an audit event for every FHIR API interaction.
  Future<void> record({
    required Session session,
    required String action,      // 'C'=create, 'R'=read, 'U'=update, 'D'=delete, 'E'=execute
    required String resourceType,
    required String resourceFhirId,
    required String outcome,     // '0'=success, '4'=minor error, '8'=serious error
    String? patientFhirId,
    Map<String, dynamic>? detail,
  }) async {
    final auditEvent = {
      'resourceType': 'AuditEvent',
      'type': {
        'system': 'http://terminology.hl7.org/CodeSystem/audit-event-type',
        'code': 'rest',
        'display': 'RESTful Operation',
      },
      'subtype': [
        {
          'system': 'http://hl7.org/fhir/restful-interaction',
          'code': _actionCode(action),
        }
      ],
      'action': action,
      'recorded': DateTime.now().toUtc().toIso8601String(),
      'outcome': outcome,
      'outcomeDesc': _outcomeDesc(outcome),
      'agent': [
        {
          'who': {'reference': 'Practitioner/${session.auth.userId}'},
          'requestor': true,
        },
      ],
      'source': {
        'observer': {'reference': 'Device/clinical-curator-server'},
        'type': [{'system': 'http://terminology.hl7.org/CodeSystem/security-source-type', 'code': '3', 'display': 'Web Server'}],
      },
      'entity': [
        {
          'what': {'reference': '$resourceType/$resourceFhirId'},
          'type': {'system': 'http://hl7.org/fhir/resource-types', 'code': resourceType},
          'role': {'system': 'http://terminology.hl7.org/CodeSystem/object-role', 'code': '4', 'display': 'Domain Resource'},
        },
      ],
    };

    // Store as FHIR resource in our JSONB store
    await _store.create(session, auditEvent);

    // Also write to dedicated audit table for fast querying
    await session.db.execute(
      '''
      INSERT INTO fhir_audit_log (action, resource_type, resource_fhir_id, user_id, patient_fhir_id, outcome, detail, recorded_at)
      VALUES (@action, @type, @fhirId, @userId, @patientId, @outcome, @detail, NOW())
      ''',
      parameters: {
        'action': action, 'type': resourceType, 'fhirId': resourceFhirId,
        'userId': session.auth.userId, 'patientId': patientFhirId,
        'outcome': outcome, 'detail': jsonEncode(detail ?? {}),
      },
    );
  }

  String _actionCode(String action) => switch (action) {
    'C' => 'create', 'R' => 'read', 'U' => 'update', 'D' => 'delete', 'E' => 'search-type',
    _ => action,
  };
}
```

### FHIR Provenance — Every Change Traced

```dart
// clinical_curator_server/lib/src/services/provenance_service.dart

class ProvenanceService {
  /// Create a Provenance resource every time a clinical resource is modified.
  Future<void> recordChange({
    required Session session,
    required String targetResourceType,
    required String targetFhirId,
    required String activity,        // 'CREATE', 'UPDATE', 'DELETE'
    required int newVersionId,
    String? previousVersionId,
  }) async {
    final provenance = {
      'resourceType': 'Provenance',
      'target': [
        {'reference': '$targetResourceType/$targetFhirId'},
      ],
      'recorded': DateTime.now().toUtc().toIso8601String(),
      'activity': {
        'coding': [
          {'system': 'http://terminology.hl7.org/CodeSystem/v3-DataOperation', 'code': _activityCode(activity)},
        ],
      },
      'agent': [
        {
          'type': {'coding': [{'system': 'http://terminology.hl7.org/CodeSystem/provenance-participant-type', 'code': 'author'}]},
          'who': {'reference': 'Practitioner/${session.auth.userId}'},
        },
      ],
      'entity': [
        {
          'role': 'revision',
          'what': {
            'reference': '$targetResourceType/$targetFhirId/_history/$newVersionId',
          },
        },
      ],
    };

    await _store.create(session, provenance);
  }

  String _activityCode(String activity) => switch (activity) {
    'CREATE' => 'CREATE', 'UPDATE' => 'UPDATE', 'DELETE' => 'DELETE', _ => activity,
  };
}
```

### Migration: Audit Tables

```sql
-- Dedicated audit log for fast querying
CREATE TABLE fhir_audit_log (
  id                SERIAL PRIMARY KEY,
  action            CHAR(1) NOT NULL,        -- C, R, U, D, E
  resource_type     VARCHAR(64) NOT NULL,
  resource_fhir_id  UUID NOT NULL,
  user_id           UUID NOT NULL,
  patient_fhir_id   UUID,
  outcome           CHAR(1) NOT NULL,
  detail            JSONB DEFAULT '{}'::JSONB,
  recorded_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_audit_user ON fhir_audit_log (user_id, recorded_at DESC);
CREATE INDEX idx_audit_type ON fhir_audit_log (resource_type, recorded_at DESC);
CREATE INDEX idx_audit_action ON fhir_audit_log (action, recorded_at DESC);
CREATE INDEX idx_audit_recorded ON fhir_audit_log (recorded_at DESC);
```

### Admin Audit View (ultimate_grid)

```dart
// Paginate with: fhir_audit_log ORDER BY recorded_at DESC LIMIT 100 OFFSET N
// Export as CSV for compliance reporting
```

## 6B: FHIR Data Validation

### Resource Validation Against Profiles

```dart
// clinical_curator_server/lib/src/services/fhir_validation_service.dart

class FhirValidationService {
  final List<String> _errors = [];

  /// Validate a FHIR resource before storage.
  Future<List<String>> validate(Map<String, dynamic> resource) async {
    _errors.clear();
    final type = resource['resourceType'] as String?;

    if (type == null) {
      _errors.add('resourceType is required');
      return _errors;
    }

    switch (type) {
      case 'Patient':
        _validateRequired(resource, ['name', 'gender', 'birthDate']);
        _validateIdentifiers(resource);
        _validateHumanNames(resource['name'] as List?);
        break;
      case 'Observation':
        _validateRequired(resource, ['status', 'code', 'subject']);
        _validateCodeableConcept(resource['code']);
        if (resource['valueQuantity'] != null) {
          _validateQuantity(resource['valueQuantity']);
        }
        break;
      case 'MedicationRequest':
        _validateRequired(resource, ['status', 'intent', 'subject', 'medicationCodeableConcept']);
        break;
      case 'Encounter':
        _validateRequired(resource, ['status', 'class', 'subject']);
        _validateEncounterStatus(resource['status']);
        break;
      case 'Condition':
        _validateRequired(resource, ['code', 'subject', 'clinicalStatus']);
        break;
      case 'AllergyIntolerance':
        _validateRequired(resource, ['code', 'patient', 'clinicalStatus']);
        break;
      case 'Immunization':
        _validateRequired(resource, ['vaccineCode', 'patient', 'status']);
        break;
      case 'DiagnosticReport':
        _validateRequired(resource, ['status', 'code', 'subject']);
        break;
      case 'Consent':
        _validateRequired(resource, ['status', 'scope', 'category', 'patient']);
        break;
    }

    return _errors;
  }

  void _validateRequired(Map<String, dynamic> resource, List<String> fields) {
    for (final field in fields) {
      if (resource[field] == null) {
        _errors.add('${resource['resourceType']}.$field is required');
      }
    }
  }

  void _validateIdentifiers(Map<String, dynamic> patient) {
    // Check for at least one identifier with system + value
    final identifiers = patient['identifier'] as List?;
    if (identifiers == null || identifiers.isEmpty) return;
    for (final id in identifiers) {
      if (id['system'] == null || id['value'] == null) {
        _errors.add('Patient.identifier must have system and value');
      }
    }
  }

  void _validateCodeableConcept(Map<String, dynamic>? concept) {
    if (concept == null) return;
    final codings = concept['coding'] as List?;
    if (codings == null || codings.isEmpty) {
      _errors.add('CodeableConcept must have at least one coding');
    }
  }

  void _validateQuantity(Map<String, dynamic>? quantity) {
    if (quantity == null) return;
    if (quantity['value'] == null || quantity['unit'] == null) {
      _errors.add('Quantity must have value and unit');
    }
  }

  void _validateEncounterStatus(String? status) {
    const valid = ['planned', 'arrived', 'triaged', 'in-progress', 'onleave', 'finished', 'cancelled'];
    if (status != null && !valid.contains(status)) {
      _errors.add('Encounter.status must be one of: $valid');
    }
  }

  void _validateHumanNames(List? names) {
    if (names == null || names.isEmpty) return;
    for (final name in names) {
      final given = name['given'] as List?;
      final family = name['family'] as String?;
      if ((given == null || given.isEmpty) && family == null) {
        _errors.add('HumanName must have at least given or family');
      }
    }
  }
}
```

### Validation Middleware

```dart
// clinical_curator_server/lib/src/services/validation_middleware.dart

/// Wrap FHIR API endpoint calls with validation.
extension ValidatedEndpoint on Endpoint {
  Future<Map<String, dynamic>> validateAndCreate(Session session, Map<String, dynamic> resource) async {
    final errors = await FhirValidationService().validate(resource);
    if (errors.isNotEmpty) {
      // Return FHIR OperationOutcome
      return {
        'resourceType': 'OperationOutcome',
        'issue': errors.map((e) => {
          'severity': 'error',
          'code': 'invalid',
          'diagnostics': e,
        }).toList(),
      };
    }
    return await _store.create(session, resource);
  }
}
```

## 6C: Terminology Service

### Local Code Cache

```dart
// clinical_curator_server/lib/src/services/terminology_service.dart

class TerminologyService {
  /// Validate a LOINC code.
  /// In production: query local cache, then fallback to FHIR terminology server.
  Future<bool> validateLoinc(String code) async {
    // Local cache of common LOINC codes used in Nepal
    const commonLoinc = {
      '8867-4': 'Heart rate', '85354-9': 'Blood pressure panel',
      '2708-6': 'Oxygen saturation', '8310-5': 'Body temperature',
      '57698-3': 'Lipid panel', '8480-6': 'Systolic blood pressure',
      '8462-4': 'Diastolic blood pressure', '718-7': 'Hemoglobin',
      '4548-4': 'HbA1c', '2345-7': 'Glucose',
      // ... ~100 common LOINC codes for primary care in Nepal
    };
    return commonLoinc.containsKey(code);
  }

  /// Validate a SNOMED CT code.
  Future<bool> validateSnomed(String code) async {
    const commonSnomed = {
      '764146007': 'Penicillin allergy',
      '38341003': 'Hypertension',
      '73211009': 'Diabetes mellitus',
      // ... common diagnoses and allergies
    };
    return commonSnomed.containsKey(code);
  }

  /// Validate an RxNorm code.
  Future<bool> validateRxNorm(String code) async {
    const commonRxNorm = {
      '723': 'Amoxicillin',
      '860975': 'Amlodipine',
      '6809': 'Metformin',
      // ... common medications used in Nepal
    };
    return commonRxNorm.containsKey(code);
  }

  /// Search for a code by display name.
  List<TerminologyEntry> searchLoinc(String query) {
    // Fuzzy match against local cache
    return commonLoinc.entries
        .where((e) => e.value.toLowerCase().contains(query.toLowerCase()))
        .map((e) => TerminologyEntry(system: 'http://loinc.org', code: e.key, display: e.value))
        .toList();
  }
}
```

## Files to Create

| File | Purpose |
|------|---------|
| `clinical_curator_server/lib/src/services/audit_service.dart` | FHIR AuditEvent recording |
| `clinical_curator_server/lib/src/services/provenance_service.dart` | FHIR Provenance recording |
| `clinical_curator_server/lib/src/services/fhir_validation_service.dart` | Resource validation against profiles |
| `clinical_curator_server/lib/src/services/terminology_service.dart` | Code validation (LOINC, SNOMED, RxNorm) |
| `clinical_curator_server/lib/src/services/validation_middleware.dart` | Validation middleware |
| `clinical_curator_server/lib/src/endpoints/audit_endpoint.dart` | Audit log query endpoint |
| `clinical_curator_server/migrations/202606XX_audit_log/` | Audit log table migration |