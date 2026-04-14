import 'dart:async';

import 'package:clinical_curator_client/clinical_curator_client.dart'
    as server;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/ambulance_request_collection.dart';
import 'serverpod_provider.dart';

class AmbulanceState {
  final List<AmbulanceRequestLocal> requests;
  final AmbulanceRequestLocal? activeRequest;
  final bool isLoading;
  final String? errorMessage;

  const AmbulanceState({
    this.requests = const [],
    this.activeRequest,
    this.isLoading = false,
    this.errorMessage,
  });

  AmbulanceState copyWith({
    List<AmbulanceRequestLocal>? requests,
    AmbulanceRequestLocal? activeRequest,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool clearActive = false,
  }) {
    return AmbulanceState(
      requests: requests ?? this.requests,
      activeRequest: clearActive ? null : (activeRequest ?? this.activeRequest),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AmbulanceNotifier extends StateNotifier<AmbulanceState> {
  final server.Client? _client;
  Timer? _simulationTimer;

  AmbulanceNotifier(this._client) : super(const AmbulanceState()) {
    _refreshActive();
  }

  void _refreshActive() {
    final box = DatabaseService.ambulanceRequests;
    AmbulanceRequestLocal? active;
    for (final r in box.values) {
      if (r.status == 'requested' ||
          r.status == 'dispatched' ||
          r.status == 'enroute' ||
          r.status == 'arrived') {
        active = r;
        break;
      }
    }
    state = state.copyWith(
      activeRequest: active,
      clearActive: active == null,
      requests: box.values.toList(),
    );
  }

  Future<void> createRequest({
    required String patientRef,
    required String patientName,
    required String contactNumber,
    required String emergencyType,
    required String pickupLocation,
    double? latitude,
    double? longitude,
    String? notes,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final box = DatabaseService.ambulanceRequests;
      final now = DateTime.now();

      // Save to Hive first (offline-first)
      final request = AmbulanceRequestLocal()
        ..patientRef = patientRef
        ..patientName = patientName
        ..contactNumber = contactNumber
        ..emergencyType = emergencyType
        ..pickupLocation = pickupLocation
        ..status = 'requested'
        ..latitude = latitude
        ..longitude = longitude
        ..notes = notes
        ..assignedDriverName = 'Ram Bahadur'
        ..assignedVehicleNumber = 'BA 1 PA 2345'
        ..estimatedArrivalMinutes = 10
        ..createdAt = now
        ..syncStatus = 1;

      await box.add(request);

      state = state.copyWith(
        isLoading: false,
        activeRequest: request,
        requests: box.values.toList(),
      );

      // Try to push to server in background
      _pushToServer(request);

      // Start simulation
      _startSimulation(request);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create ambulance request: $e',
      );
    }
  }

  /// Push request to Serverpod backend. If it fails, syncStatus stays 1 for later sync.
  Future<void> _pushToServer(AmbulanceRequestLocal local) async {
    if (_client == null) return;
    try {
      final serverRequest = server.AmbulanceRequest(
        patientRef: local.patientRef,
        patientName: local.patientName,
        contactNumber: local.contactNumber,
        emergencyType: local.emergencyType,
        pickupLocation: local.pickupLocation,
        status: local.status,
        latitude: local.latitude,
        longitude: local.longitude,
        assignedDriverName: local.assignedDriverName,
        assignedVehicleNumber: local.assignedVehicleNumber,
        estimatedArrivalMinutes: local.estimatedArrivalMinutes,
        notes: local.notes,
        createdAt: local.createdAt,
      );
      final created = await _client.ambulance.request(serverRequest);
      // Store server ID and mark as synced
      local
        ..id = created.id
        ..syncStatus = 0;
      await local.save();
    } catch (_) {
      // Server unavailable — stays in Hive with syncStatus=1
    }
  }

  /// Simulates ambulance dispatch lifecycle:
  /// 0s: requested → 2s: dispatched → 5s: enroute → 10s: arrived (waits for user confirmation)
  void _startSimulation(AmbulanceRequestLocal request) {
    _simulationTimer?.cancel();

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      _updateRequestInPlace(request, 'dispatched', eta: 8);
    });

    Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      _updateRequestInPlace(request, 'enroute', eta: 5);
    });

    _simulationTimer = Timer(const Duration(seconds: 10), () {
      if (!mounted) return;
      _updateRequestInPlace(request, 'arrived', eta: 0);
    });
  }

  void _updateRequestInPlace(
    AmbulanceRequestLocal request,
    String newStatus, {
    int? eta,
  }) {
    request
      ..status = newStatus
      ..estimatedArrivalMinutes = eta ?? request.estimatedArrivalMinutes
      ..updatedAt = DateTime.now()
      ..syncStatus = 1;
    request.save();

    // Try to sync status to server
    _syncStatusToServer(request);

    final isActive = newStatus == 'requested' ||
        newStatus == 'dispatched' ||
        newStatus == 'enroute' ||
        newStatus == 'arrived';

    state = state.copyWith(
      activeRequest: isActive ? request : null,
      clearActive: !isActive,
      requests: DatabaseService.ambulanceRequests.values.toList(),
    );
  }

  /// Sync a status change to the server.
  Future<void> _syncStatusToServer(AmbulanceRequestLocal local) async {
    if (_client == null || local.id == null) return;
    try {
      await _client.ambulance.updateStatus(
        local.id!,
        local.status,
      );
      local.syncStatus = 0;
      await local.save();
    } catch (_) {
      // Will be synced later
    }
  }

  Future<void> updateStatus(int hiveKey, String newStatus) async {
    try {
      final box = DatabaseService.ambulanceRequests;
      final request = box.get(hiveKey);
      if (request == null) return;

      request
        ..status = newStatus
        ..updatedAt = DateTime.now()
        ..syncStatus = 1;

      await request.save();
      _syncStatusToServer(request);
      _refreshActive();
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to update ambulance status: $e',
      );
    }
  }

  Future<void> cancelRequest(int hiveKey) async {
    _simulationTimer?.cancel();
    await updateStatus(hiveKey, 'cancelled');
  }

  /// Cancel with a reason — saves locally + pushes to server.
  void cancelActiveRequestWithReason(String reason) {
    _simulationTimer?.cancel();
    final active = state.activeRequest;
    if (active != null) {
      active
        ..status = 'cancelled'
        ..cancellationReason = reason
        ..updatedAt = DateTime.now()
        ..syncStatus = 1;
      active.save();

      // Push to server
      _cancelOnServer(active, reason);
      _refreshActive();
    }
  }

  Future<void> _cancelOnServer(
      AmbulanceRequestLocal local, String reason) async {
    if (_client == null || local.id == null) return;
    try {
      await _client.ambulance.cancelWithReason(local.id!, reason);
      local.syncStatus = 0;
      await local.save();
    } catch (_) {}
  }

  void cancelActiveRequest() {
    cancelActiveRequestWithReason('User cancelled');
  }

  /// Complete the request with rating — saves locally + pushes to server.
  void completeWithRating({
    required String timeliness,
    required int helpfulness,
    String? feedbackNotes,
  }) {
    _simulationTimer?.cancel();
    final active = state.activeRequest;
    if (active != null) {
      active
        ..status = 'completed'
        ..timelinessRating = timeliness
        ..helpfulnessRating = helpfulness
        ..feedbackNotes = feedbackNotes
        ..updatedAt = DateTime.now()
        ..syncStatus = 1;
      active.save();

      // Push to server
      _completeOnServer(active, timeliness, helpfulness, feedbackNotes);
      _refreshActive();
    }
  }

  Future<void> _completeOnServer(
    AmbulanceRequestLocal local,
    String timeliness,
    int helpfulness,
    String? feedbackNotes,
  ) async {
    if (_client == null || local.id == null) return;
    try {
      await _client.ambulance.completeWithRating(
        local.id!,
        timeliness,
        helpfulness,
        feedbackNotes: feedbackNotes,
      );
      local.syncStatus = 0;
      await local.save();
    } catch (_) {}
  }

  void listRequests({String? patientRef}) {
    final box = DatabaseService.ambulanceRequests;
    List<AmbulanceRequestLocal> results;

    if (patientRef != null) {
      results =
          box.values.where((r) => r.patientRef == patientRef).toList();
    } else {
      results = box.values.toList();
    }

    results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = state.copyWith(requests: results);
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }
}

final ambulanceProvider =
    StateNotifierProvider<AmbulanceNotifier, AmbulanceState>((ref) {
  server.Client? client;
  try {
    client = ref.watch(serverpodClientProvider);
  } catch (_) {
    // Serverpod not available — run in offline-only mode
  }
  return AmbulanceNotifier(client);
});

/// Returns the currently active ambulance request (if any).
/// Reactive — updates when ambulanceProvider state changes.
final activeAmbulanceRequestProvider =
    Provider<AmbulanceRequestLocal?>((ref) {
  final ambulanceState = ref.watch(ambulanceProvider);
  return ambulanceState.activeRequest;
});
