import 'package:shared_preferences/shared_preferences.dart';
import 'package:clinical_curator_client/clinical_curator_client.dart' as api;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cc_fhir_models/collections/fhir_resource_collection.dart';
import 'package:cc_fhir_models/collections/schedule_slot_collection.dart';
import 'package:cc_data/database/isar_service.dart';
import '../../domain/providers/serverpod_provider.dart';
import '../../domain/providers/connectivity_provider.dart';

enum SyncStatus { idle, syncing, success, error }

class SyncState {
  final SyncStatus status;
  final int pendingCount;
  final String? errorMessage;
  final DateTime? lastSyncAt;
  final bool syncEnabled;

  const SyncState({this.status = SyncStatus.idle, this.pendingCount = 0, this.errorMessage, this.lastSyncAt, this.syncEnabled = true});

  SyncState copyWith({
    SyncStatus? status,
    int? pendingCount,
    String? errorMessage,
    DateTime? lastSyncAt,
    bool clearError = false,
    bool? syncEnabled,
  }) {
    return SyncState(
      status: status ?? this.status,
      pendingCount: pendingCount ?? this.pendingCount,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      syncEnabled: syncEnabled ?? this.syncEnabled,
    );
  }
}

/// Manages offline-first synchronization between local Hive store
/// and the Serverpod backend.
class SyncNotifier extends StateNotifier<SyncState> {
  final api.Client _client;
  final bool _isOnline;

  SyncNotifier(this._client, this._isOnline) : super(const SyncState()) {
    _loadSyncEnabled();
  }

  Future<void> _loadSyncEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('sync_enabled') ?? true;
    state = state.copyWith(syncEnabled: enabled);
  }

  Future<void> toggleSync(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sync_enabled', enabled);
    state = state.copyWith(syncEnabled: enabled);
  }

  int get pendingCount {
    return _countPending(DatabaseService.fhirResources) + _countPending(DatabaseService.scheduleSlots);
  }

  int _countPending(dynamic box) {
    return box.values.where((r) => r.syncStatus != 0).length;
  }

  /// Mark all pending resources as synced (for local-only operation).
  Future<void> markAllSynced() async {
    await _markBoxSynced(DatabaseService.fhirResources);
    await _markBoxSynced(DatabaseService.scheduleSlots);

    state = state.copyWith(status: SyncStatus.success, pendingCount: 0, lastSyncAt: DateTime.now());
  }

  Future<void> _markBoxSynced(dynamic box) async {
    final pending = box.values.where((r) => r.syncStatus != 0).toList();
    for (final resource in pending) {
      if (resource.syncStatus == 2) {
        await resource.delete();
      } else {
        resource.syncStatus = 0;
        await resource.save();
      }
    }
  }

  /// Sync all pending FHIR resources and schedule slots with the server.
  Future<void> syncAll() async {
    if (!state.syncEnabled) {
      state = state.copyWith(status: SyncStatus.idle, errorMessage: 'Cloud sync is disabled in Settings.');
      return;
    }

    state = state.copyWith(status: SyncStatus.syncing, pendingCount: pendingCount, clearError: true);

    if (!_isOnline) {
      state = state.copyWith(
        status: SyncStatus.idle,
        pendingCount: pendingCount,
        errorMessage: 'No internet connection. Changes saved locally.',
      );
      return;
    }

    try {
      await _syncFhirResources();
      await _syncScheduleSlots();

      state = state.copyWith(status: SyncStatus.success, pendingCount: 0, lastSyncAt: DateTime.now());
    } catch (e) {
      state = state.copyWith(status: SyncStatus.error, pendingCount: pendingCount, errorMessage: 'Sync failed: $e');
    }
  }

  Future<void> _syncFhirResources() async {
    final box = DatabaseService.fhirResources;
    final pending = box.values.where((r) => r.syncStatus != 0).toList();

    for (final resource in pending) {
      if (resource.syncStatus == 1) {
        final existing = await _client.fhirResource.read(resource.fhirId, resource.resourceType);

        if (existing != null) {
          await _client.fhirResource.update(
            existing.copyWith(
              jsonData: resource.jsonData,
              patientReference: resource.patientReference,
              practitionerReference: resource.practitionerReference,
              category: resource.category,
            ),
          );
        } else {
          await _client.fhirResource.create(
            api.FhirResourceRecord(
              fhirId: resource.fhirId,
              resourceType: resource.resourceType,
              jsonData: resource.jsonData,
              patientReference: resource.patientReference,
              practitionerReference: resource.practitionerReference,
              category: resource.category,
              syncVersion: 1,
              lastUpdated: DateTime.now(),
              createdAt: resource.createdAt ?? DateTime.now(),
            ),
          );
        }

        resource.syncStatus = 0;
        await resource.save();
      } else if (resource.syncStatus == 2) {
        final existing = await _client.fhirResource.read(resource.fhirId, resource.resourceType);
        if (existing?.id != null) {
          await _client.fhirResource.deleteById(existing!.id!);
        }
        await resource.delete();
      }
    }

    // Pull server changes since last sync
    await _pullServerChanges();
  }

  Future<void> _syncScheduleSlots() async {
    final box = DatabaseService.scheduleSlots;
    final pending = box.values.where((r) => r.syncStatus != 0).toList();

    for (final slot in pending) {
      if (slot.syncStatus == 1) {
        try {
          await _client.schedule.createSlot(_localSlotToServer(slot));
        } catch (_) {
          // Slot may already exist — try update instead
          await _client.schedule.updateSlot(_localSlotToServer(slot));
        }
        slot.syncStatus = 0;
        await slot.save();
      } else if (slot.syncStatus == 2) {
        if (slot.id != null) {
          await _client.schedule.deleteSlot(slot.id!);
        }
        await slot.delete();
      }
    }
  }

  api.ScheduleSlot _localSlotToServer(ScheduleSlotLocal local) {
    return api.ScheduleSlot(
      practitionerRef: local.practitionerRef,
      date: local.date,
      startTime: local.startTime,
      endTime: local.endTime,
      slotDurationMinutes: local.slotDurationMinutes,
      maxPatients: local.maxPatients,
      bookedCount: local.bookedCount,
      facilityName: local.facilityName,
      isEmergencyOverride: local.isEmergencyOverride,
      isTelehealth: local.isTelehealth,
      status: local.status,
      createdAt: local.createdAt,
    );
  }

  /// Pull resources from server that changed since last sync.
  Future<void> _pullServerChanges() async {
    final since = state.lastSyncAt ?? DateTime(2020);
    final serverChanges = await _client.fhirResource.getChangesSince(since);

    final box = DatabaseService.fhirResources;

    for (final serverRecord in serverChanges) {
      final localMatch = box.values.where((r) => r.fhirId == serverRecord.fhirId && r.resourceType == serverRecord.resourceType).toList();

      if (localMatch.isEmpty) {
        box.add(_toLocalResource(serverRecord));
      } else {
        final local = localMatch.first;
        if (local.syncStatus == 0) {
          local
            ..jsonData = serverRecord.jsonData
            ..patientReference = serverRecord.patientReference
            ..practitionerReference = serverRecord.practitionerReference
            ..category = serverRecord.category
            ..lastUpdated = serverRecord.lastUpdated;
          await local.save();
        }
      }
    }
  }

  FhirResource _toLocalResource(api.FhirResourceRecord record) {
    return FhirResource()
      ..fhirId = record.fhirId
      ..resourceType = record.resourceType
      ..jsonData = record.jsonData
      ..patientReference = record.patientReference
      ..practitionerReference = record.practitionerReference
      ..category = record.category
      ..syncStatus = 0
      ..isDownloadedOffline = true
      ..lastUpdated = record.lastUpdated
      ..createdAt = record.createdAt;
  }

  void updatePendingCount() {
    state = state.copyWith(pendingCount: pendingCount);
  }
}

final syncProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  final client = ref.watch(serverpodClientProvider);
  final isOnline = ref.watch(isOnlineProvider);
  return SyncNotifier(client, isOnline);
});
