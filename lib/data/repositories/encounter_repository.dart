import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;

import 'base_repository.dart';

class EncounterRepository extends BaseRepository<fhir.Encounter> {
  EncounterRepository() : super(resourceType: 'Encounter');

  List<fhir.Encounter> getByPatient(String patientRef) {
    return parseLocalResources(patientRef: patientRef);
  }

  List<fhir.Encounter> getByPractitioner(String practitionerRef) {
    return parseLocalResources().where((e) {
      return e.participant?.any((p) =>
              p.individual?.reference == practitionerRef) ??
          false;
    }).toList();
  }

  List<fhir.Encounter> getByStatus(String status) {
    return parseLocalResources().where((e) {
      return e.status?.value == status;
    }).toList();
  }

  List<fhir.Encounter> getByDateRange(DateTime start, DateTime end) {
    return parseLocalResources().where((e) {
      final period = e.period;
      final eStart = period?.start?.value;
      if (eStart == null) return false;
      return eStart.isAfter(start) && eStart.isBefore(end);
    }).toList();
  }

  List<fhir.Encounter> getActive() {
    return getByStatus('in-progress');
  }
}

final encounterRepositoryProvider = Provider<EncounterRepository>((ref) {
  return EncounterRepository();
});
