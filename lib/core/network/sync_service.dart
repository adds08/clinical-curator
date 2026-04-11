import 'package:clinical_curator_client/clinical_curator_client.dart' as api;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/collections/fhir_resource_collection.dart';
import '../database/isar_service.dart';
import '../../domain/providers/serverpod_provider.dart';
import '../../domain/providers/connectivity_provider.dart';

enum SyncStatus { idle, syncing, success, error }

class SyncState {
  final SyncStatus status;
  final int pendingCount;
  final String? errorMessage;
  final DateTime? lastSyncAt;

  const SyncState({
    this.status = SyncStatus.idle,
    this.pendingCount = 0,
    this.errorMessage,
    this.lastSyncAt,
  });

  SyncState copyWith({
    SyncStatus? status,
    int? pendingCount,
    String? errorMessage,
    DateTime? lastSyncAt,
    bool clearError = false,
  }) {
    return SyncState(
      status: status ?? this.status,
      pendingCount: pendingCount ?? this.pendingCount,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }
}

/// Manages offline-first synchronization between local Hive store
/// and the Serverpod backend.
class SyncNotifier extends StateNotifier<SyncState> {
  final api.Client _client;
  final bool _isOnline;

  SyncNotifier(this._client, this._isOnline) : super(const SyncState());

  int get pendingCount {
    final box = DatabaseService.fhirResources;
    return box.values.where((r) => r.syncStatus != 0).length;
  }

  /// Mark all pending resources as synced (for local-only operation).
  Future<void> markAllSynced() async {
    final box = DatabaseService.fhirResources;
    final pending = box.values.where((r) => r.syncStatus != 0).toList();

    for (final resource in pending) {
      if (resource.syncStatus == 2) {
        await resource.delete();
      } else {
        resource.syncStatus = 0;
        await resource.save();
      }
    }

    state = state.copyWith(
      status: SyncStatus.success,
      pendingCount: 0,
      lastSyncAt: DateTime.now(),
    );
  }

  /// Sync all pending FHIR resources with the Serverpod backend.
  Future<void> syncAll() async {
    state = state.copyWith(
      status: SyncStatus.syncing,
      pendingCount: pendingCount,
      clearError: true,
    );

    if (!_isOnline) {
      state = state.copyWith(
        status: SyncStatus.idle,
        pendingCount: pendingCount,
        errorMessage: 'No internet connection. Changes saved locally.',
      );
      return;
    }

    try {
      final box = DatabaseService.fhirResources;
      final pending = box.values.where((r) => r.syncStatus != 0).toList();

      for (final resource in pending) {
        if (resource.syncStatus == 1) {
          // Pending upload — create or update on server
          final existing = await _client.fhirResource.read(
            resource.fhirId,
            resource.resourceType,
          );

          if (existing != null) {
            await _client.fhirResource.update(existing.copyWith(
              jsonData: resource.jsonData,
              patientReference: resource.patientReference,
              practitionerReference: resource.practitionerReference,
              category: resource.category,
            ));
          } else {
            await _client.fhirResource.create(api.FhirResourceRecord(
              fhirId: resource.fhirId,
              resourceType: resource.resourceType,
              jsonData: resource.jsonData,
              patientReference: resource.patientReference,
              practitionerReference: resource.practitionerReference,
              category: resource.category,
              syncVersion: 1,
              lastUpdated: DateTime.now(),
              createdAt: resource.createdAt ?? DateTime.now(),
            ));
          }

          resource.syncStatus = 0;
          await resource.save();
        } else if (resource.syncStatus == 2) {
          // Pending delete — remove from server and local
          final existing = await _client.fhirResource.read(
            resource.fhirId,
            resource.resourceType,
          );
          if (existing?.id != null) {
            await _client.fhirResource.deleteById(existing!.id!);
          }
          await resource.delete();
        }
      }

      // Pull server changes since last sync
      await _pullServerChanges();

      state = state.copyWith(
        status: SyncStatus.success,
        pendingCount: 0,
        lastSyncAt: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        status: SyncStatus.error,
        pendingCount: pendingCount,
        errorMessage: 'Sync failed: $e',
      );
    }
  }

  /// Pull resources from server that changed since last sync.
  Future<void> _pullServerChanges() async {
    final since = state.lastSyncAt ?? DateTime(2020);
    final serverChanges = await _client.fhirResource.getChangesSince(since);

    final box = DatabaseService.fhirResources;

    for (final serverRecord in serverChanges) {
      // Find local version
      final localMatch = box.values
          .where((r) =>
              r.fhirId == serverRecord.fhirId &&
              r.resourceType == serverRecord.resourceType)
          .toList();

      if (localMatch.isEmpty) {
        // New from server — save locally
        box.add(
          _toLocalResource(serverRecord),
        );
      } else {
        // Update local if not pending upload
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
