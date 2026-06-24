# Sync, Auth, Safety, and Testing

## 1. Offline ↔ Online Sync Protocol

### How It Works

```
OFFLINE STATE                     ONLINE STATE (connectivity restored)
────────────                      ──────────
Hive stores:                      FhirSyncService.check() fires:
  ├── Cached resources (read)     ├── Pull: GET /fhir/*?_since={timestamp}
  └── Dirty queue (write)         │   └── New/changed → upsert Hive
                                  │
                                  ├── Push: dirty queue → server
                                  │   ├── pending_upload → PUT/POST
                                  │   └── pending_delete → DELETE
                                  │
                                  └── Update lastSyncTimestamp_{type}
```

### Safety Guarantees

| Concern | Protection |
|---------|-----------|
| Sync interrupted mid-way | Each resource synced individually. Partial sync = some synced, some retry. |
| Two devices editing same patient | Server `meta.lastUpdated` wins. Local edit overridden → conflict UI. |
| Hive corruption | CRC checks. If corrupted, wipe cache → full re-sync. No data loss. |
| Server down | Dirty queue persists. Exponential backoff: 1s→2s→4s→30s→5min→1hr max. |
| Server data loss | PostgreSQL WAL + daily pg_dump to S3. Point-in-time recovery. |

### Offline-Only Mode (Opt-In)

```dart
// Settings toggle: "Keep my data on device only"
// SettingProvider.offlineOnly = true

When enabled:
  ├── SyncService.syncPending() → NOOP (never pushes)
  ├── Data lives in Hive only
  ├── Warning: "Your data is stored only on this device."
  └── Use case: Privacy-first patients, temporary use
```

## 2. Auth Offline

```dart
// First login (needs internet):
//   1. Send email+password to server
//   2. Server returns JWT access_token + refresh_token
//   3. Store both in flutter_secure_storage
//   4. Token valid for 30 days

// Repeated offline logins:
//   1. Read JWT from secure storage
//   2. Check expiry (local decode, no server call)
//   3. If valid → allow login, app works offline
//   4. If expired AND online → refresh → store new JWT
//   5. If expired AND offline → allow with warning banner

// PIN fallback (no server needed):
//   After first login: "Set PIN for offline access"
//   Store hashed PIN locally
//   Offline: enter PIN → compare hash → unlock Hive data
```

## 3. Failsafes

```dart
// Circuit breaker: 5xx x3 in 60 seconds → 5 minute pause
class SyncCircuitBreaker {
  int _failureCount = 0;
  DateTime? _openUntil;
  bool get isOpen => _openUntil != null && DateTime.now().isBefore(_openUntil!);

  Future<T> call<T>(Future<T> Function() fn) async {
    if (isOpen) throw CircuitOpenException();
    try { return await fn(); }
    catch (_) { _failureCount++; if (_failureCount >= 3) _openUntil = DateTime.now().add(const Duration(minutes: 5)); rethrow; }
  }
}

// Dead letter queue: 10 failed syncs → quarantine + user notification
class DeadLetterQueue {
  Future<void> processDirty(List<FhirCacheEntry> dirty) async {
    for (final entry in dirty) {
      try { await _syncEntry(entry); entry.retryCount = 0; }
      catch (_) { entry.retryCount++; if (entry.retryCount >= 10) entry.syncStatus = 'dead_letter'; }
      await entry.save();
    }
  }
}
```

## 4. Test Plan

```dart
// tests/core/services/sync_service_test.dart
group('FhirSyncService', () {
  test('pull_since_returns_only_new_resources', () {});
  test('push_uploads_dirty_entries', () {});
  test('conflict_server_wins_on_tie', () {});
  test('offline_only_never_syncs', () {});
  test('circuit_breaker_opens_after_3_failures', () {});
  test('dead_letter_after_10_retries', () {});
  test('sync_resumes_after_app_restart', () {});
});

// tests/core/services/auth_service_test.dart
group('AuthService', () {
  test('offline_login_with_cached_jwt', () {});
  test('offline_login_with_expired_jwt_and_no_network', () {});
  test('pin_unlock_works_offline', () {});
});

// tests/api/fhir_api_endpoint_test.dart
group('FhirApiEndpoint', () {
  test('create_patient_returns_201', () {});
  test('search_patient_by_gender_returns_filtered', () {});
  test('update_encounter_creates_new_version', () {});
  test('delete_observation_soft_deletes', () {});
  test('history_returns_all_versions', () {});
  test('validation_rejects_missing_required_fields', () {});
  test('bulk_export_creates_ndjson_files', () {});
});
```

## 5. Future EMR Analytics

```text
Monitoring: Serverpod Insights (built-in, port 8081)
  ├── Request latency, error rates, DB performance
  └── Redis metrics

Analytics (Phase 6+):
  ├── FHIR Bulk Export → NDJSON → analytics DB
  ├── Materialized views:
  │   ├── mv_disease_prevalence_by_district
  │   ├── mv_encounter_volume_by_month
  │   └── mv_medication_prescription_trends
  └── Metabase/Superset for MoHP reporting

Alerting:
  ├── Abnormal labs → push notification
  ├── Missed appointments → SMS (via Guff)
  └── Disease outbreak detection → MoHP alert