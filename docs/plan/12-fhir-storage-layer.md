app# Phase 1: FHIR-First Storage Layer

**Status:** 🔴 Not started  
**Priority:** P0 — Foundation for all other phases  
**Effort:** ~3 weeks  
**Depends on:** Nothing (net-new migration, replaced existing models)

## Objective

Replace 27 hand-written `*Local` Hive classes in `packages/fhir_models/lib/collections/` with a single PostgreSQL JSONB table that stores native FHIR R4 JSON. The existing `fhir: ^0.12.1` Dart package (already in `cc_core/pubspec.yaml`) handles all serialization.

## Current Problem

```
Current:  27 flat Dart classes (EncounterLocal, PatientLocal, ...)
          Each manually duplicates FHIR fields as HiveField annotations
          No FHIR validation, no search parameter indexing
          Not interoperable with any FHIR API

Target:   1 JSONB table + fhir package
          All FHIR resources as native JSON, validated
          GIN-indexed search params, versioned history
          FHIR REST API ready
```

## 1A: Database Schema

### Migration File: `202606XX_fhir_resource_store/`

```sql
-- fhir_resource: Primary FHIR resource store
CREATE TABLE fhir_resource (
  id              SERIAL PRIMARY KEY,
  fhir_id         UUID NOT NULL DEFAULT gen_random_uuid(),
  resource_type   VARCHAR(64) NOT NULL,
  resource_json   JSONB NOT NULL,
  search_params   JSONB NOT NULL DEFAULT '{}'::JSONB,
  version_id      INTEGER NOT NULL DEFAULT 1,
  last_updated    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  is_deleted      BOOLEAN NOT NULL DEFAULT false,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  UNIQUE(fhir_id, resource_type)
);

-- GIN index for FHIR search parameters
CREATE INDEX idx_fhir_search ON fhir_resource USING GIN (search_params jsonb_path_ops);

-- Lookup by type + last_updated (for _since sync)
CREATE INDEX idx_fhir_type_updated ON fhir_resource (resource_type, last_updated);

-- Lookup by type + fhir_id
CREATE INDEX idx_fhir_type_fhir_id ON fhir_resource (resource_type, fhir_id);

-- Full-text search on resource JSON
CREATE INDEX idx_fhir_json_gin ON fhir_resource USING GIN (resource_json);

-- fhir_resource_history: Version history
CREATE TABLE fhir_resource_history (
  id              SERIAL PRIMARY KEY,
  fhir_id         UUID NOT NULL,
  resource_type   VARCHAR(64) NOT NULL,
  resource_json   JSONB NOT NULL,
  version_id      INTEGER NOT NULL,
  recorded_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_fhir_history_lookup ON fhir_resource_history (fhir_id, resource_type, version_id);
```

### Search Parameter Extraction (Pseudocode)

```dart
/// Extracts FHIR search parameters from a resource JSON for indexing.
/// Each FHIR resource type defines its own search parameter set.
Map<String, dynamic> extractSearchParams(Map<String, dynamic> resourceJson) {
  final params = <String, dynamic>{};
  final type = resourceJson['resourceType'] as String;

  // By resource type, extract common search params
  switch (type) {
    case 'Patient':
      params['name'] = _extractNames(resourceJson);        // HumanName[] → string[]
      params['gender'] = resourceJson['gender'];            // 'male' | 'female' | 'other'
      params['birthdate'] = resourceJson['birthDate'];      // '1970-01-01'
      params['identifier'] = _extractIdentifiers(resourceJson); // Identifier[]
      break;
    case 'Observation':
      params['patient'] = resourceJson['subject']?['reference']; // 'Patient/123'
      params['code'] = _extractCodes(resourceJson['code']);       // CodeableConcept[]
      params['date'] = resourceJson['effectiveDateTime'];
      params['status'] = resourceJson['status'];
      params['value-quantity'] = resourceJson['valueQuantity']?['value'];
      break;
    case 'Encounter':
      params['patient'] = resourceJson['subject']?['reference'];
      params['date'] = resourceJson['period']?['start'];
      params['type'] = resourceJson['type'];               // CodeableConcept[]
      params['status'] = resourceJson['status'];
      params['practitioner'] = resourceJson['participant']
          ?.where((p) => p['individual']?['reference'] != null)
          ?.map((p) => p['individual']['reference']);
      break;
    case 'MedicationRequest':
      params['patient'] = resourceJson['subject']?['reference'];
      params['medication'] = resourceJson['medicationCodeableConcept'];
      params['status'] = resourceJson['status'];
      params['authoredon'] = resourceJson['authoredOn'];
      break;
    // ... all 10 FHIR resource types we support
  }

  return params;
}

List<String> _extractNames(Map<String, dynamic> r) =>
    (r['name'] as List?)
        ?.map((n) => ((n['given'] as List?)?.join(' ') ?? '') + ' ' + (n['family'] ?? ''))
        .map((s) => s.trim().toLowerCase())
        .toList() ?? [];

List<String> _extractIdentifiers(Map<String, dynamic> r) =>
    (r['identifier'] as List?)
        ?.map((i) => '${i['system']}|${i['value']}')
        .toList() ?? [];

List<String> _extractCodes(Map<String, dynamic>? coding) =>
    (coding?['coding'] as List?)
        ?.map((c) => '${c['system']}|${c['code']}')
        .toList() ?? [];
```

### FHIR Resource Service (Server-Side)

```dart
// clinical_curator_server/lib/src/services/fhir_store_service.dart

class FhirStoreService {
  /// Create a FHIR resource. Generates fhir_id, extracts search params.
  Future<Map<String, dynamic>> create(Session session, Map<String, dynamic> json) async {
    final resourceType = json['resourceType'] as String;
    final fhirId = Uuid().v4();
    final now = DateTime.now().toUtc();

    json['id'] = fhirId;
    json['meta'] = {
      'versionId': '1',
      'lastUpdated': now.toIso8601String(),
    };

    final searchParams = extractSearchParams(json);

    await session.db.execute(
      '''
      INSERT INTO fhir_resource (fhir_id, resource_type, resource_json, search_params, version_id, last_updated)
      VALUES (@fhirId, @resourceType, @json, @params, 1, @now)
      ''',
      parameters: {
        'fhirId': fhirId,
        'resourceType': resourceType,
        'json': jsonEncode(json),
        'params': jsonEncode(searchParams),
        'now': now,
      },
    );

    // Record initial history entry
    await session.db.execute(
      '''
      INSERT INTO fhir_resource_history (fhir_id, resource_type, resource_json, version_id)
      VALUES (@fhirId, @resourceType, @json, 1)
      ''',
      parameters: {
        'fhirId': fhirId,
        'resourceType': resourceType,
        'json': jsonEncode(json),
      },
    );

    return json;
  }

  /// Read a FHIR resource by type + fhir_id.
  Future<Map<String, dynamic>?> read(Session session, String resourceType, String fhirId) async {
    final result = await session.db.query(
      'SELECT resource_json FROM fhir_resource WHERE resource_type = @type AND fhir_id = @fhirId AND is_deleted = false',
      parameters: {'type': resourceType, 'fhirId': fhirId},
    );
    if (result.isEmpty) return null;
    return jsonDecode(result.first[0] as String);
  }

  /// Update a FHIR resource (creates new version).
  Future<Map<String, dynamic>> update(Session session, String resourceType, String fhirId, Map<String, dynamic> json) async {
    final existing = await session.db.query(
      'SELECT version_id FROM fhir_resource WHERE resource_type = @type AND fhir_id = @fhirId AND is_deleted = false',
      parameters: {'type': resourceType, 'fhirId': fhirId},
    );
    if (existing.isEmpty) throw NotFoundException('Resource not found');

    final newVersion = (existing.first[0] as int) + 1;
    final now = DateTime.now().toUtc();

    json['id'] = fhirId;
    json['meta'] = {
      'versionId': '$newVersion',
      'lastUpdated': now.toIso8601String(),
    };

    final searchParams = extractSearchParams(json);

    await session.db.execute(
      '''
      UPDATE fhir_resource
      SET resource_json = @json, search_params = @params, version_id = @version, last_updated = @now
      WHERE resource_type = @type AND fhir_id = @fhirId
      ''',
      parameters: {
        'type': resourceType, 'fhirId': fhirId,
        'json': jsonEncode(json), 'params': jsonEncode(searchParams),
        'version': newVersion, 'now': now,
      },
    );

    await session.db.execute(
      '''
      INSERT INTO fhir_resource_history (fhir_id, resource_type, resource_json, version_id)
      VALUES (@fhirId, @type, @json, @version)
      ''',
      parameters: {'fhirId': fhirId, 'type': resourceType, 'json': jsonEncode(json), 'version': newVersion},
    );

    return json;
  }

  /// Soft-delete a FHIR resource.
  Future<void> delete(Session session, String resourceType, String fhirId) async {
    await session.db.execute(
      'UPDATE fhir_resource SET is_deleted = true WHERE resource_type = @type AND fhir_id = @fhirId',
      parameters: {'type': resourceType, 'fhirId': fhirId},
    );
  }

  /// Search FHIR resources with query parameters.
  /// Handles: _count, _offset, and resource-specific search params.
  Future<SearchResult> search(
    Session session,
    String resourceType,
    Map<String, String> queryParams,
  ) async {
    final count = int.tryParse(queryParams['_count'] ?? '20') ?? 20;
    final offset = int.tryParse(queryParams['_offset'] ?? '0') ?? 0;

    // Build WHERE clauses from search params
    final conditions = <String>['resource_type = @type', 'is_deleted = false'];
    final parameters = <String, dynamic>{'type': resourceType};

    for (final entry in queryParams.entries) {
      if (entry.key.startsWith('_')) continue; // skip meta params
      final key = entry.key;
      final value = entry.value;
      // Support chained params like 'patient=Patient/123'
      if (value.contains('|')) {
        conditions.add("search_params @> jsonb_build_object(@key$key, @value$key)");
        parameters['key$key'] = key;
        parameters['value$key'] = value;
      } else {
        // Full-text match on resource_json
        conditions.add("resource_json @> jsonb_build_object(@jsonKey$key, @jsonValue$key)");
        parameters['jsonKey$key'] = key;
        parameters['jsonValue$key'] = value;
      }
    }

    final whereClause = conditions.join(' AND ');
    final entries = await session.db.query(
      'SELECT resource_json FROM fhir_resource WHERE $whereClause ORDER BY last_updated DESC LIMIT @count OFFSET @offset',
      parameters: {...parameters, 'count': count, 'offset': offset},
    );

    final total = await session.db.query(
      'SELECT COUNT(*) FROM fhir_resource WHERE $whereClause',
      parameters: parameters,
    );

    return SearchResult(
      entries: entries.map((r) => jsonDecode(r[0] as String)).toList(),
      total: total.first[0] as int,
    );
  }

  /// Get version history for a resource.
  Future<List<Map<String, dynamic>>> history(Session session, String resourceType, String fhirId) async {
    final rows = await session.db.query(
      'SELECT resource_json FROM fhir_resource_history WHERE resource_type = @type AND fhir_id = @fhirId ORDER BY version_id ASC',
      parameters: {'type': resourceType, 'fhirId': fhirId},
    );
    return rows.map((r) => jsonDecode(r[0] as String)).toList();
  }
}

class SearchResult {
  final List<Map<String, dynamic>> entries;
  final int total;
  SearchResult({required this.entries, required this.total});
}
```

## 1B: FHIR REST API Endpoints

### Serverpod Endpoint Definition

```dart
// clinical_curator_server/lib/src/generated/protocol.yaml
// (This is Serverpod's model definition file — the client SDK is generated from this)

# Already existing models we'll extend:
# - FhirResource  (keep, but point to JSONB store)
```

### Endpoint Implementation

```dart
// clinical_curator_server/lib/src/endpoints/fhir_api_endpoint.dart

import 'package:serverpod/serverpod.dart';
import '../services/fhir_store_service.dart';

/// FHIR R4 REST API endpoints.
/// Implements: read, create, update, delete, search, history, batch.
class FhirApiEndpoint extends Endpoint {
  final _store = FhirStoreService();

  /// GET /fhir/{resourceType}/{id}
  Future<Map<String, dynamic>?> read(Session session, String resourceType, String id) async {
    return await _store.read(session, resourceType, id);
  }

  /// POST /fhir/{resourceType}
  Future<Map<String, dynamic>> create(Session session, String resourceType, Map<String, dynamic> resource) async {
    if (resource['resourceType'] != resourceType) {
      throw InvalidRequestException('resourceType mismatch');
    }
    return await _store.create(session, resource);
  }

  /// PUT /fhir/{resourceType}/{id}
  Future<Map<String, dynamic>> update(Session session, String resourceType, String id, Map<String, dynamic> resource) async {
    return await _store.update(session, resourceType, id, resource);
  }

  /// DELETE /fhir/{resourceType}/{id}
  Future<void> delete(Session session, String resourceType, String id) async {
    await _store.delete(session, resourceType, id);
  }

  /// GET /fhir/{resourceType}?_count=N&_offset=N&param=value
  /// Returns a FHIR Bundle (searchset type).
  Future<Map<String, dynamic>> search(
    Session session,
    String resourceType, {
    int? count,
    int? offset,
    String? patient,
    String? date,
    String? status,
    // ... other FHIR search params
  }) async {
    final params = <String, String>{};
    if (count != null) params['_count'] = count.toString();
    if (offset != null) params['_offset'] = offset.toString();
    if (patient != null) params['patient'] = patient;
    if (date != null) params['date'] = date;
    if (status != null) params['status'] = status;

    final result = await _store.search(session, resourceType, params);

    // Return FHIR Bundle
    return {
      'resourceType': 'Bundle',
      'type': 'searchset',
      'total': result.total,
      'entry': result.entries.map((e) => {
        'resource': e,
      }).toList(),
    };
  }

  /// GET /fhir/{resourceType}/{id}/_history
  Future<Map<String, dynamic>> history(Session session, String resourceType, String id) async {
    final versions = await _store.history(session, resourceType, id);
    return {
      'resourceType': 'Bundle',
      'type': 'history',
      'total': versions.length,
      'entry': versions.map((v) => {'resource': v}).toList(),
    };
  }

  /// POST /fhir — Transaction Bundle
  Future<Map<String, dynamic>> batch(Session session, Map<String, dynamic> bundle) async {
    final type = bundle['type'] as String;
    final entries = bundle['entry'] as List;

    final results = <Map<String, dynamic>>[];
    for (final entry in entries) {
      final request = entry['request'];
      final method = request['method'] as String;
      final url = request['url'] as String;
      final resource = entry['resource'] as Map<String, dynamic>?;

      final parts = url.split('/');
      final resourceType = parts[1]; // e.g., "Patient" from "Patient/123"
      final id = parts.length > 2 ? parts[2] : null;

      switch (method) {
        case 'POST':
          results.add(await _store.create(session, resource!));
          break;
        case 'PUT':
          results.add(await _store.update(session, resourceType, id!, resource!));
          break;
        case 'DELETE':
          await _store.delete(session, resourceType, id!);
          results.add({});
          break;
        case 'GET':
          results.add((await _store.read(session, resourceType, id!))!);
          break;
      }
    }

    return {
      'resourceType': 'Bundle',
      'type': 'transaction-response',
      'entry': results.map((r) => {'resource': r}).toList(),
    };
  }

  /// GET /fhir/metadata — FHIR CapabilityStatement
  Future<Map<String, dynamic>> metadata(Session session) async {
    return {
      'resourceType': 'CapabilityStatement',
      'status': 'active',
      'date': '2026-01-01',
      'fhirVersion': '4.0.1',
      'format': ['json'],
      'rest': [
        {
          'mode': 'server',
          'resource': [
            {'type': 'Patient', 'interaction': [{'code': 'read'}, {'code': 'create'}, {'code': 'update'}, {'code': 'delete'}, {'code': 'search-type'}]},
            {'type': 'Observation', 'interaction': [/* ... */]},
            {'type': 'Encounter', 'interaction': [/* ... */]},
            {'type': 'MedicationRequest', 'interaction': [/* ... */]},
            {'type': 'Condition', 'interaction': [/* ... */]},
            {'type': 'AllergyIntolerance', 'interaction': [/* ... */]},
            {'type': 'Immunization', 'interaction': [/* ... */]},
            {'type': 'DiagnosticReport', 'interaction': [/* ... */]},
            {'type': 'Consent', 'interaction': [/* ... */]},
            {'type': 'Provenance', 'interaction': [/* ... */]},
          ],
        }
      ],
    };
  }
}
```

## 1C: Hive as Sync Cache (Not Primary Store)

### Architecture

```
┌──────────────────────────────────────────────────────────┐
│                     Server (PostgreSQL)                  │
│  fhir_resource table (JSONB) — source of truth          │
└──────────────────────┬───────────────────────────────────┘
                       │  FHIR REST API
                       │  GET /fhir/{type}/{id}
                       │  GET /fhir/{type}?_since=...
                       ▼
┌──────────────────────────────────────────────────────────┐
│  Clinical Flutter App                                    │
│                                                          │
│  ┌──────────────────────────────────────────────────┐   │
│  │  FhirSyncCache (Hive Box)                         │   │
│  │  Key: "{resourceType}/{fhirId}"                   │   │
│  │  Value: JSON string + lastSynced timestamp        │   │
│  │                                                   │   │
│  │  When online: pull _since, upsert into cache      │   │
│  │  When offline: read from cache directly           │   │
│  │  Dirty queue: local edits → push when online      │   │
│  └──────────────────────────────────────────────────┘   │
│                                                          │
│  Provider reads:                                         │
│    1. Try cache (instant, offline-safe)                 │
│    2. If cache miss → server call → populate cache      │
│    3. Server writes → invalidate cache entry             │
└──────────────────────────────────────────────────────────┘
```

### Hive Cache Model (Single Class Replaces 27)

```dart
// packages/data/lib/database/fhir_cache.dart

@HiveType(typeId: 0)
class FhirCacheEntry extends HiveObject {
  @HiveField(0)
  late String key; // "Patient/550e8400-e29b-41d4-a716-446655440000"

  @HiveField(1)
  late String resourceJson; // Full FHIR JSON string

  @HiveField(2)
  late String resourceType;

  @HiveField(3)
  late String fhirId;

  @HiveField(4)
  late DateTime lastSynced;

  /// Quick access to patient reference without full JSON parse.
  @HiveField(5)
  String? patientRef;

  /// Quick access to practitioner reference.
  @HiveField(6)
  String? practitionerRef;

  /// Sync status: synced, pending_upload, pending_delete
  @HiveField(7)
  late String syncStatus;
}

class FhirCacheService {
  late Box<FhirCacheEntry> _box;

  Future<void> init() async {
    _box = await Hive.openBox<FhirCacheEntry>('fhir_cache');
  }

  /// Read from cache (offline-first).
  FhirCacheEntry? readLocal(String resourceType, String fhirId) {
    return _box.get('$resourceType/$fhirId');
  }

  /// Read from server, populate cache.
  Future<Map<String, dynamic>?> readServer(String resourceType, String fhirId) async {
    final json = await _client.fhirApi.read(resourceType, fhirId);
    if (json != null) {
      _box.put('$resourceType/$fhirId', FhirCacheEntry(
        key: '$resourceType/$fhirId',
        resourceJson: jsonEncode(json),
        resourceType: resourceType,
        fhirId: fhirId,
        lastSynced: DateTime.now(),
        patientRef: _extractPatientRef(json),
        syncStatus: 'synced',
      ));
    }
    return json;
  }

  /// Search cache first, server fallback.
  Future<List<Map<String, dynamic>>> search(String resourceType, Map<String, String> params) async {
    // First try local cache (simple prefix match)
    final local = _box.values
        .where((e) => e.resourceType == resourceType)
        .where((e) => _matchesParams(e, params))
        .map((e) => jsonDecode(e.resourceJson))
        .toList();

    // Always try server for freshest data when online
    if (await isOnline()) {
      final serverResult = await _store.search(resourceType, params);
      // Update cache with server results
      for (final entry in serverResult.entries) {
        final fhirId = entry['id'] as String;
        _box.put('$resourceType/$fhirId', FhirCacheEntry(/* ... */));
      }
      return serverResult.entries;
    }

    return local;
  }

  /// Sync dirty local changes to server.
  Future<void> syncPending() async {
    final dirty = _box.values.where((e) => e.syncStatus != 'synced');
    for (final entry in dirty) {
      try {
        if (entry.syncStatus == 'pending_upload') {
          final json = jsonDecode(entry.resourceJson);
          await _client.fhirApi.update(entry.resourceType, entry.fhirId, json);
        } else if (entry.syncStatus == 'pending_delete') {
          await _client.fhirApi.delete(entry.resourceType, entry.fhirId);
        }
        entry.syncStatus = 'synced';
        entry.save();
      } catch (e) {
        // Keep as dirty, retry on next sync cycle
      }
    }
  }
}
```

## Files to Create

| File | Purpose |
|------|---------|
| `clinical_curator_server/migrations/202606XX_fhir_resource_store/` | SQL migration for JSONB table |
| `clinical_curator_server/lib/src/services/fhir_store_service.dart` | JSONB CRUD + search service |
| `clinical_curator_server/lib/src/endpoints/fhir_api_endpoint.dart` | FHIR REST API endpoint |
| `clinical_curator_server/lib/src/services/search_params.dart` | Search parameter extraction |
| `packages/data/lib/database/fhir_cache.dart` | Single Hive cache model |
| `packages/data/lib/database/fhir_cache.g.dart` | Generated Hive adapter |

## Files to Remove

- All 27 `*_collection.dart` + `*_collection.g.dart` files in `packages/fhir_models/lib/collections/`
- `clinical_curator_server/lib/src/endpoints/fhir_resource_endpoint.dart` (current flat endpoint)
- `clinical_curator_client/lib/src/protocol/fhir_resource.dart` (regenerate from new protocol)

## Validation & Rollback

- Migration is additive (CREATE TABLE, not ALTER existing). Safe to run on live DB.
- Old Hive data stays intact until Phase 1C migration script converts it.
- New FHIR API endpoints coexist with old endpoints until cutover.