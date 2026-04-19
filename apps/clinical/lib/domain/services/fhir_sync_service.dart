import 'dart:async';
import 'dart:convert';

import 'package:clinical_curator_client/clinical_curator_client.dart' as api;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/fhir_resource_collection.dart';

import '../providers/auth_provider.dart';
import '../providers/serverpod_provider.dart';
import 'audit_logger.dart';

/// Resource types supported by [FhirSyncEndpoint.since/push].
const List<String> kSyncResourceTypes = [
  'Patient',
  'Observation',
  'MedicationRequest',
  'AllergyIntolerance',
  'Immunization',
  'Encounter',
  'Condition',
  'DiagnosticReport',
];

class SyncReport {
  final int upserted;
  final int pushed;
  final int conflicts;
  final Map<String, int> perType;
  final Duration elapsed;
  final DateTime completedAt;
  final bool skippedOffline;
  final String? errorMessage;

  const SyncReport({
    this.upserted = 0,
    this.pushed = 0,
    this.conflicts = 0,
    this.perType = const {},
    this.elapsed = Duration.zero,
    required this.completedAt,
    this.skippedOffline = false,
    this.errorMessage,
  });

  factory SyncReport.offline() =>
      SyncReport(completedAt: DateTime.now(), skippedOffline: true);
}

class FhirSyncState {
  final bool isOnline;
  final bool isSyncing;
  final SyncReport? lastReport;
  final String? errorMessage;

  const FhirSyncState({
    this.isOnline = true,
    this.isSyncing = false,
    this.lastReport,
    this.errorMessage,
  });

  FhirSyncState copyWith({
    bool? isOnline,
    bool? isSyncing,
    SyncReport? lastReport,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FhirSyncState(
      isOnline: isOnline ?? this.isOnline,
      isSyncing: isSyncing ?? this.isSyncing,
      lastReport: lastReport ?? this.lastReport,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// FHIR `_since` sync service (Serverpod streaming + per-type timestamp).
class FhirSyncService extends StateNotifier<FhirSyncState>
    with WidgetsBindingObserver {
  FhirSyncService(this._ref) : super(const FhirSyncState()) {
    WidgetsBinding.instance.addObserver(this);
    _connectivitySub =
        Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
    _startPeriodicTimer();
    // Kick off an initial sync on a post-frame callback so the app has
    // time to mount providers.
    WidgetsBinding.instance.addPostFrameCallback((_) => syncAll());
  }

  final Ref _ref;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  Timer? _timer;
  DateTime? _lastSyncCompletedAt;
  bool _disposed = false;

  static const _debounce = Duration(seconds: 30);
  static const _interval = Duration(minutes: 5);
  static const _tsPrefix = 'lastSyncTimestamp_';

  void _startPeriodicTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(_interval, (_) {
      if (state.isOnline) syncAll();
    });
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final online = results.any((r) => r != ConnectivityResult.none);
    final wasOffline = !state.isOnline;
    state = state.copyWith(isOnline: online);
    if (online && wasOffline) syncAll();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && this.state.isOnline) syncAll();
  }

  /// Pulls + pushes every supported resource type.
  Future<SyncReport> syncAll() async {
    if (_disposed) {
      return SyncReport(completedAt: DateTime.now());
    }
    if (state.isSyncing) return SyncReport(completedAt: DateTime.now());
    if (!state.isOnline) {
      final r = SyncReport.offline();
      state = state.copyWith(lastReport: r);
      return r;
    }
    final last = _lastSyncCompletedAt;
    if (last != null &&
        DateTime.now().difference(last) < _debounce) {
      return state.lastReport ?? SyncReport(completedAt: DateTime.now());
    }
    state = state.copyWith(isSyncing: true, clearError: true);

    final stopwatch = Stopwatch()..start();
    final perType = <String, int>{};
    var upserted = 0;
    var pushed = 0;
    var conflicts = 0;
    String? err;

    try {
      final client = _ref.read(serverpodClientProvider);
      final prefs = await SharedPreferences.getInstance();
      final user = _ref.read(authProvider).user;
      final agentRef = user == null ? 'User/unknown' : 'User/${user.email}';
      final agentName = user?.displayName ?? user?.email ?? 'unknown';

      for (final type in kSyncResourceTypes) {
        final tsKey = '$_tsPrefix$type';
        final tsMillis = prefs.getInt(tsKey) ?? 0;
        var since = DateTime.fromMillisecondsSinceEpoch(tsMillis, isUtc: true);

        // Pull in a loop in case `hasMore`.
        while (true) {
          final batch = await client.fhirSync.since(type, since, limit: 500);
          for (final rec in batch.resources) {
            final result =
                await _upsertLocal(rec, agentRef: agentRef, agentName: agentName);
            if (result.isConflict) {
              conflicts++;
            } else {
              upserted++;
              perType[type] = (perType[type] ?? 0) + 1;
            }
          }
          // Advance the timestamp even if empty — `nextSince` will equal `since`.
          since = batch.nextSince;
          await prefs.setInt(tsKey, since.millisecondsSinceEpoch);
          if (!batch.hasMore) break;
        }
      }

      // Push: collect dirty rows for supported types.
      final dirty = DatabaseService.fhirResources.values
          .where((r) =>
              r.syncStatus != 0 && kSyncResourceTypes.contains(r.resourceType))
          .toList();

      if (dirty.isNotEmpty) {
        // Chunk into manageable pushes.
        const chunkSize = 100;
        for (var i = 0; i < dirty.length; i += chunkSize) {
          final slice = dirty.skip(i).take(chunkSize).toList();
          final payload = slice
              .map((r) => api.FhirResourceRecord(
                    fhirId: r.fhirId,
                    resourceType: r.resourceType,
                    jsonData: r.jsonData,
                    patientReference: r.patientReference,
                    practitionerReference: r.practitionerReference,
                    category: r.category,
                    syncVersion: 1,
                    lastUpdated: r.lastUpdated,
                    createdAt: r.createdAt ?? r.lastUpdated,
                  ))
              .toList();
          await client.fhirSync.push(payload);
          for (final r in slice) {
            r.syncStatus = 0;
            await r.save();
            pushed++;
          }
        }
      }
    } catch (e) {
      err = e.toString();
    }

    stopwatch.stop();
    final report = SyncReport(
      upserted: upserted,
      pushed: pushed,
      conflicts: conflicts,
      perType: perType,
      elapsed: stopwatch.elapsed,
      completedAt: DateTime.now(),
      errorMessage: err,
    );
    _lastSyncCompletedAt = report.completedAt;
    state = state.copyWith(
      isSyncing: false,
      lastReport: report,
      errorMessage: err,
    );
    return report;
  }

  Future<_UpsertResult> _upsertLocal(
    api.FhirResourceRecord incoming, {
    required String agentRef,
    required String agentName,
  }) async {
    final box = DatabaseService.fhirResources;
    FhirResource? local;
    for (final r in box.values) {
      if (r.fhirId == incoming.fhirId &&
          r.resourceType == incoming.resourceType) {
        local = r;
        break;
      }
    }
    final incomingMetaTs =
        _extractMetaLastUpdated(incoming.jsonData) ?? incoming.lastUpdated;

    if (local == null) {
      final fresh = FhirResource()
        ..fhirId = incoming.fhirId
        ..resourceType = incoming.resourceType
        ..jsonData = incoming.jsonData
        ..patientReference = incoming.patientReference
        ..practitionerReference = incoming.practitionerReference
        ..category = incoming.category
        ..syncStatus = 0
        ..isDownloadedOffline = true
        ..lastUpdated = incomingMetaTs
        ..createdAt = incoming.createdAt;
      await box.add(fresh);
      return const _UpsertResult.upserted();
    }

    final localMetaTs =
        _extractMetaLastUpdated(local.jsonData) ?? local.lastUpdated;
    if (localMetaTs.isAfter(incomingMetaTs)) {
      // Local is newer — skip, log conflict.
      await AuditLogger.dataConflict(
        entityRef: '${incoming.resourceType}/${incoming.fhirId}',
        entityType: incoming.resourceType,
        agentRef: agentRef,
        agentName: agentName,
        detail: 'local-newer; kept local',
      );
      return const _UpsertResult.conflict();
    }
    if (local.syncStatus != 0) {
      // Dirty local — let the push path ship it; don't overwrite yet.
      return const _UpsertResult.conflict();
    }
    local
      ..jsonData = incoming.jsonData
      ..patientReference = incoming.patientReference
      ..practitionerReference = incoming.practitionerReference
      ..category = incoming.category
      ..lastUpdated = incomingMetaTs;
    await local.save();
    return const _UpsertResult.upserted();
  }

  DateTime? _extractMetaLastUpdated(String jsonData) {
    try {
      final map = jsonDecode(jsonData);
      if (map is! Map) return null;
      final meta = map['meta'];
      if (meta is! Map) return null;
      final lu = meta['lastUpdated'];
      if (lu is String) return DateTime.tryParse(lu);
    } catch (_) {}
    return null;
  }

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySub?.cancel();
    _timer?.cancel();
    super.dispose();
  }
}

class _UpsertResult {
  final bool isConflict;
  const _UpsertResult.upserted() : isConflict = false;
  const _UpsertResult.conflict() : isConflict = true;
}

final fhirSyncServiceProvider =
    StateNotifierProvider<FhirSyncService, FhirSyncState>((ref) {
  return FhirSyncService(ref);
});
