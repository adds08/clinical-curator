import 'package:cc_core/constants/fhir_constants.dart';

/// FHIR R4 Encounter.status values + a state machine that mirrors
/// the workflow described in https://hl7.org/fhir/R4/encounter.html.
///
/// `canTransitionTo` rejects illegal transitions; the
/// EncounterWorkflowNotifier routes every status change through this enum
/// so that local writes cannot leave an Encounter in a non-FHIR state.
enum EncounterStatus {
  planned(FhirConstants.encounterStatusPlanned),
  arrived(FhirConstants.encounterStatusArrived),
  triaged(FhirConstants.encounterStatusTriaged),
  inProgress(FhirConstants.encounterStatusInProgress),
  onleave(FhirConstants.encounterStatusOnLeave),
  finished(FhirConstants.encounterStatusFinished),
  cancelled(FhirConstants.encounterStatusCancelled);

  const EncounterStatus(this.code);

  final String code;

  static EncounterStatus fromCode(String code) {
    return EncounterStatus.values.firstWhere(
      (e) => e.code == code,
      orElse: () => throw ArgumentError('Unknown Encounter.status: $code'),
    );
  }

  bool canTransitionTo(EncounterStatus next) {
    if (next == cancelled) {
      return this != finished && this != cancelled;
    }
    switch (this) {
      case planned:
        return next == arrived || next == cancelled;
      case arrived:
        return next == triaged || next == inProgress || next == cancelled;
      case triaged:
        return next == inProgress || next == cancelled;
      case inProgress:
        return next == onleave || next == finished || next == cancelled;
      case onleave:
        return next == inProgress || next == finished || next == cancelled;
      case finished:
      case cancelled:
        return false;
    }
  }
}

class EncounterStatusTransitionException implements Exception {
  EncounterStatusTransitionException(this.from, this.to);
  final EncounterStatus from;
  final EncounterStatus to;

  @override
  String toString() =>
      'Illegal Encounter.status transition: ${from.code} → ${to.code}';
}
