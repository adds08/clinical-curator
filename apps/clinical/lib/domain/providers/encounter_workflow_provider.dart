import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cc_core/constants/fhir_constants.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/composition_collection.dart';
import 'package:cc_fhir_models/collections/encounter_collection.dart';
import 'package:cc_fhir_models/collections/practitioner_role_collection.dart';
import 'package:cc_fhir_models/collections/provenance_collection.dart';
import 'package:cc_fhir_models/models/encounter_status.dart';

import '../services/audit_logger.dart';

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
        (e) =>
            e.status == EncounterStatus.inProgress.code && e.syncStatus != 2,
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
        ..status = EncounterStatus.inProgress.code
        ..classCode = classCode
        ..startDate = now
        ..organizationRef = organizationRef
        ..reasonJson = reasons?.join('|')
        ..serviceType = serviceType
        ..patientName = patientName
        ..practitionerName = practitionerName
        ..createdAt = now
        ..syncStatus = 1;

      await box.add(encounter);

      // Audit trail — records who started the encounter (FHIR AuditEvent).
      await AuditLogger.encounterCreated(
        encounterRef: 'Encounter/$fhirId',
        agentRef: practitionerRef,
        agentName: practitionerName,
      );

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

  /// Validates [next] against the FHIR Encounter status state machine before
  /// persisting. Throws [EncounterStatusTransitionException] on illegal moves.
  Future<void> transitionTo(EncounterStatus next) async {
    final encounter = state.activeEncounter;
    if (encounter == null) return;
    final current = EncounterStatus.fromCode(encounter.status);
    if (!current.canTransitionTo(next)) {
      throw EncounterStatusTransitionException(current, next);
    }
    encounter
      ..status = next.code
      ..updatedAt = DateTime.now()
      ..syncStatus = 1;
    await encounter.save();
  }

  Future<void> finalizeEncounter({String? notes}) async {
    final encounter = state.activeEncounter;
    if (encounter == null) return;

    final current = EncounterStatus.fromCode(encounter.status);
    if (!current.canTransitionTo(EncounterStatus.finished)) {
      state = state.copyWith(
        status: EncounterWorkflowStatus.active,
        errorMessage:
            'Cannot finalize from ${current.code} — invalid FHIR transition.',
      );
      return;
    }

    state = state.copyWith(status: EncounterWorkflowStatus.finalizing);

    try {
      final now = DateTime.now();

      encounter
        ..status = EncounterStatus.finished.code
        ..endDate = now
        ..notes = notes
        ..updatedAt = now
        ..syncStatus = 1;
      await encounter.save();

      // Wrap the note as a FHIR Composition with attester pointing at the
      // signing clinician — turns a free-form string into a referenceable
      // clinical document with proper authorship metadata.
      if (notes != null && notes.trim().isNotEmpty) {
        final composition = CompositionLocal()
          ..fhirId = 'comp-${now.millisecondsSinceEpoch}'
          ..status = FhirConstants.compositionStatusFinal
          ..typeLoincCode = FhirConstants.compositionTypeProgressNote
          ..typeDisplay = 'Progress note'
          ..subjectRef = encounter.patientRef
          ..encounterRef = 'Encounter/${encounter.fhirId}'
          ..dateAuthored = now
          ..authorPractitionerRef = encounter.practitionerRef
          ..authorPractitionerName = encounter.practitionerName
          ..title = 'Encounter ${encounter.fhirId} — progress note'
          ..attesterPractitionerRef = encounter.practitionerRef
          ..attesterMode = FhirConstants.compositionAttesterModePersonal
          ..plainText = notes
          ..createdAt = now
          ..syncStatus = 1;
        await DatabaseService.compositions.add(composition);
      }

      // Record who signed the encounter (FHIR Provenance) so audit can
      // answer "which clinician finalized this and in what role".
      final role = _practitionerRoleFor(encounter.practitionerRef);
      final provenance = ProvenanceLocal()
        ..fhirId = 'prov-${now.millisecondsSinceEpoch}'
        ..targetRef = 'Encounter/${encounter.fhirId}'
        ..recordedAt = now
        ..agentPractitionerRef = encounter.practitionerRef
        ..agentPractitionerName = encounter.practitionerName
        ..agentRoleSystem = role?.codeSystem ??
            FhirConstants.practitionerRoleSystem
        ..agentRoleCode = role?.code
        ..agentRoleDisplay = role?.codeDisplay
        ..activityCode = FhirConstants.provenanceActivitySign
        ..reasonText = 'Encounter finalized by clinician'
        ..createdAt = now
        ..syncStatus = 1;
      await DatabaseService.provenances.add(provenance);

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

    final current = EncounterStatus.fromCode(encounter.status);
    if (!current.canTransitionTo(EncounterStatus.cancelled)) {
      state = state.copyWith(
        errorMessage:
            'Cannot cancel from ${current.code} — invalid FHIR transition.',
      );
      return;
    }

    encounter
      ..status = EncounterStatus.cancelled.code
      ..endDate = DateTime.now()
      ..updatedAt = DateTime.now()
      ..syncStatus = 1;
    await encounter.save();

    state = const EncounterWorkflowState(
      status: EncounterWorkflowStatus.idle,
    );
  }

  PractitionerRoleLocal? _practitionerRoleFor(String practitionerRef) {
    try {
      return DatabaseService.practitionerRoles.values.firstWhere(
        (r) => r.practitionerRef == practitionerRef && r.active,
      );
    } catch (_) {
      return null;
    }
  }
}

final encounterWorkflowProvider =
    StateNotifierProvider<EncounterWorkflowNotifier, EncounterWorkflowState>(
        (ref) {
  return EncounterWorkflowNotifier();
});
