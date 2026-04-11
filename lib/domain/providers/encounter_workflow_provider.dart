import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/isar_service.dart';
import '../../data/collections/encounter_collection.dart';

enum EncounterWorkflowStatus { idle, starting, active, finalizing }

class EncounterWorkflowState {
  final EncounterWorkflowStatus status;
  final EncounterLocal? activeEncounter;
  final String? errorMessage;

  const EncounterWorkflowState({
    this.status = EncounterWorkflowStatus.idle,
    this.activeEncounter,
    this.errorMessage,
  });

  EncounterWorkflowState copyWith({
    EncounterWorkflowStatus? status,
    EncounterLocal? activeEncounter,
    String? errorMessage,
    bool clearEncounter = false,
    bool clearError = false,
  }) {
    return EncounterWorkflowState(
      status: status ?? this.status,
      activeEncounter:
          clearEncounter ? null : (activeEncounter ?? this.activeEncounter),
      errorMessage:
          clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class EncounterWorkflowNotifier extends StateNotifier<EncounterWorkflowState> {
  EncounterWorkflowNotifier() : super(const EncounterWorkflowState()) {
    _loadActiveEncounter();
  }

  void _loadActiveEncounter() {
    final box = DatabaseService.encounters;
    try {
      final active = box.values.firstWhere(
        (e) => e.status == 'in-progress' && e.syncStatus != 2,
      );
      state = EncounterWorkflowState(
        status: EncounterWorkflowStatus.active,
        activeEncounter: active,
      );
    } catch (_) {
      // No active encounter
    }
  }

  Future<EncounterLocal> startEncounter({
    required String patientRef,
    required String practitionerRef,
    required String classCode,
    required String patientName,
    required String practitionerName,
    String? organizationRef,
    List<String>? reasons,
    String? serviceType,
  }) async {
    state = state.copyWith(
      status: EncounterWorkflowStatus.starting,
      clearError: true,
    );

    try {
      final box = DatabaseService.encounters;
      final now = DateTime.now();
      final fhirId = 'enc-${now.millisecondsSinceEpoch}';

      final encounter = EncounterLocal()
        ..fhirId = fhirId
        ..patientRef = patientRef
        ..practitionerRef = practitionerRef
        ..status = 'in-progress'
        ..classCode = classCode
        ..startDate = now
        ..organizationRef = organizationRef
        ..reasonJson = reasons != null ? reasons.join('|') : null
        ..serviceType = serviceType
        ..patientName = patientName
        ..practitionerName = practitionerName
        ..createdAt = now
        ..syncStatus = 1;

      await box.add(encounter);

      state = EncounterWorkflowState(
        status: EncounterWorkflowStatus.active,
        activeEncounter: encounter,
      );

      return encounter;
    } catch (e) {
      state = state.copyWith(
        status: EncounterWorkflowStatus.idle,
        errorMessage: 'Failed to start encounter: $e',
      );
      rethrow;
    }
  }

  Future<void> finalizeEncounter({String? notes}) async {
    final encounter = state.activeEncounter;
    if (encounter == null) return;

    state = state.copyWith(status: EncounterWorkflowStatus.finalizing);

    try {
      encounter
        ..status = 'finished'
        ..endDate = DateTime.now()
        ..notes = notes
        ..updatedAt = DateTime.now()
        ..syncStatus = 1;
      await encounter.save();

      state = const EncounterWorkflowState(
        status: EncounterWorkflowStatus.idle,
      );
    } catch (e) {
      state = state.copyWith(
        status: EncounterWorkflowStatus.active,
        errorMessage: 'Failed to finalize encounter: $e',
      );
    }
  }

  Future<void> cancelEncounter() async {
    final encounter = state.activeEncounter;
    if (encounter == null) return;

    encounter
      ..status = 'cancelled'
      ..endDate = DateTime.now()
      ..updatedAt = DateTime.now()
      ..syncStatus = 1;
    await encounter.save();

    state = const EncounterWorkflowState(
      status: EncounterWorkflowStatus.idle,
    );
  }
}

final encounterWorkflowProvider =
    StateNotifierProvider<EncounterWorkflowNotifier, EncounterWorkflowState>(
        (ref) {
  return EncounterWorkflowNotifier();
});
