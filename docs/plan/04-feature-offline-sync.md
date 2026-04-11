# Feature 04 — Offline Sync

## Overview

Implement real bidirectional sync between the Hive local store and the Serverpod backend. Replace the current skeleton `SyncNotifier` with a queue-based sync engine that handles uploads, downloads, and conflict resolution. This is the bridge that connects the fully-functional offline app to the backend.

## Dependencies

- Feature 01 (Data Layer) — all Hive collections must exist
- Feature 03 (FHIR Resources) — repositories must support sync status

## What Already Exists

### Sync Service (Skeleton)
- `lib/core/network/sync_service.dart` — `SyncNotifier` with `SyncState` (status, pendingCount, errorMessage, lastSyncAt). `syncAll()` only counts pending items, never contacts the server. `markAllSynced()` exists for local-only operation.

### Connectivity
- `lib/domain/providers/connectivity_provider.dart` — `isOnlineProvider` using `connectivity_plus`

### Serverpod Client
- `lib/domain/providers/serverpod_provider.dart` — `Client` pointing at `localhost:8080`

### Sync Status Fields
- `FhirResource.syncStatus` — 0=synced, 1=pendingUpload, 2=pendingDelete (on all collections)
- All domain collections (`AppointmentLocal`, `PharmacyOrderLocal`, etc.) include `late int syncStatus`

### Server Endpoints
- `clinical_curator_server/lib/src/endpoints/fhir_resource_endpoint.dart` — has `getChangesSince()` returning records modified after a timestamp
- 12 total endpoints in `clinical_curator_server/lib/src/endpoints/`

## What Needs to Be Built

### 1. Sync Metadata Collection — `lib/data/collections/sync_metadata_collection.dart` (new)

```
TypeId: 26 (or use a plain Hive box without adapter)
Fields: collectionName, lastSyncAt, syncCursor, syncVersion
```

Track per-collection sync state so we know what to pull from the server.

### 2. Sync Engine — `lib/core/network/sync_engine.dart` (new)

Core sync orchestrator:

```
class SyncEngine {
  // Upload all records with syncStatus=1 to Serverpod
  Future<SyncResult> uploadPending(String collectionName);

  // Mark all records with syncStatus=2 for server deletion
  Future<SyncResult> deletePending(String collectionName);

  // Pull changes from server since last sync timestamp
  Future<SyncResult> pullChanges(String collectionName);

  // Conflict resolution: last-write-wins by lastUpdated timestamp
  FhirResource resolveConflict(FhirResource local, FhirResource remote);

  // Full sync cycle for one collection
  Future<SyncResult> syncCollection(String collectionName);

  // Full sync cycle for all collections
  Future<SyncResult> syncAll();
}
```

**Sync cycle per collection:**
1. Upload pending (syncStatus=1) records to Serverpod
2. Process pending deletes (syncStatus=2) on server
3. Pull server changes since `lastSyncAt` from sync metadata
4. For each pulled record, check for local conflict:
   - If no local version exists → insert locally
   - If local version exists and `syncStatus=0` → overwrite with server version
   - If local version has pending changes → compare `lastUpdated`, keep newer (last-write-wins)
5. Update sync metadata with new `lastSyncAt`

### 3. SyncNotifier Rewrite — `lib/core/network/sync_service.dart`

Replace skeleton with real implementation:
- Use `SyncEngine` internally
- Track sync state per collection type (not just global)
- `pendingByCollection` map for granular status
- Auto-sync on connectivity change (listen to `connectivityProvider`)
- Periodic background sync (configurable interval, default 5 minutes)
- Manual sync trigger
- Error handling with retry logic (exponential backoff)

```dart
class SyncState {
  final SyncStatus status;
  final int pendingCount;
  final Map<String, int> pendingByCollection;
  final String? errorMessage;
  final DateTime? lastSyncAt;
  final bool isAutoSyncEnabled;
}
```

### 4. Serverpod Sync Endpoint Extensions

Extend each endpoint with `getChangesSince(DateTime since)`:
- Already exists for `FhirResourceEndpoint`
- Need to add for: `AppointmentEndpoint`, `ScheduleEndpoint`, `AmbulanceEndpoint`, `PharmacyEndpoint`, `InsuranceEndpoint`, `LabBookingEndpoint`, `NotificationEndpoint`, `HealthTipEndpoint`, `OrganizationEndpoint`
- New endpoints for Feature 01 collections (Encounter, Condition, etc.) should include `getChangesSince()` from the start

Each endpoint needs:
```dart
Future<List<ModelType>> getChangesSince(Session session, DateTime since);
Future<ModelType> upsert(Session session, ModelType record);
Future<bool> deleteRecord(Session session, int id);
```

### 5. Connectivity-Aware Repository Mixin — `lib/data/repositories/sync_aware_mixin.dart` (new)

```dart
mixin SyncAwareMixin<T> {
  // After local save, queue for sync if online
  Future<void> saveAndSync(T resource);

  // After local delete, queue for sync
  Future<void> deleteAndSync(String id);
}
```

### 6. Sync Status UI — `lib/features/shared/widgets/sync_status_indicator.dart` (new)

- Shows pending count badge
- Last sync timestamp
- Sync-in-progress spinner
- Tap to force manual sync
- Error state with retry button

Place in `AppScaffold` app bar or as a floating indicator.

### 7. Sync Settings — `lib/features/profile/screens/profile_settings_screen.dart`

Add sync section to existing settings:
- Auto-sync toggle
- Sync interval picker (1min, 5min, 15min, 30min)
- Last sync time display
- Manual sync button
- Pending changes count

### 8. Batch Upload Optimization

Bundle multiple pending records into a single API call per collection to reduce network overhead:
```dart
Future<List<SyncResult>> batchUpload(String collection, List<Record> records);
```

## Implementation Order

1. Create sync metadata storage (collection or plain Hive box)
2. Create `SyncEngine` with upload/download/conflict logic
3. Rewrite `SyncNotifier` to use `SyncEngine`
4. Add `getChangesSince()` to all server endpoints
5. Create `SyncAwareMixin` for repositories
6. Create `SyncStatusIndicator` widget
7. Add sync settings to profile settings screen
8. Wire auto-sync to connectivity changes
9. Add batch upload optimization
10. Test full cycle: create offline → come online → verify sync → modify on "server" → pull changes

## Acceptance Criteria

- [ ] Changes made offline appear on server after sync
- [ ] Changes made on server appear locally after sync
- [ ] Conflict resolution follows last-write-wins by `lastUpdated` timestamp
- [ ] Auto-sync triggers when connectivity resumes (offline → online transition)
- [ ] Periodic background sync runs at configured interval
- [ ] Sync status is visible to the user (pending count, last sync time)
- [ ] Manual sync can be triggered from UI
- [ ] All 26+ collection types sync bidirectionally
- [ ] Sync errors are handled gracefully with retry logic
- [ ] No data loss during sync conflicts (losing version could be logged)

## FHIR Compliance Notes

Sync operates at the storage level (`FhirResource` box and domain-specific boxes), not at the FHIR protocol level. The system does not implement FHIR REST sync (`_history`, `_since`). However, the server endpoints could be extended to support standard FHIR search parameters in the future.

## Mock Data Requirements

For testing sync:
- Server must be running (`make db-up && make server-start`)
- Need matching data on server and client with different timestamps to test conflict resolution
- Create a sync test scenario in mock seed: some records synced (status=0), some pending upload (status=1), some pending delete (status=2)

## Complexity Estimate

**Very High** — core infrastructure that touches every data path in the app. Requires careful handling of concurrency, error states, conflict resolution, and connectivity changes. The most architecturally critical feature.
