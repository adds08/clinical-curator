import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;

import 'base_repository.dart';

class ObservationRepository extends BaseRepository<fhir.Observation> {
  ObservationRepository() : super(resourceType: 'Observation');

  List<fhir.Observation> getVitals(String patientRef) {
    return parseLocalResources(patientRef: patientRef).where((obs) {
      return obs.category?.any((cat) =>
              cat.coding?.any((c) => c.code?.value == 'vital-signs') ??
              false) ??
          false;
    }).toList();
  }

  List<fhir.Observation> getLabResults(String patientRef) {
    return parseLocalResources(patientRef: patientRef).where((obs) {
      return obs.category?.any((cat) =>
              cat.coding?.any((c) => c.code?.value == 'laboratory') ??
              false) ??
          false;
    }).toList();
  }
}

final observationRepositoryProvider = Provider<ObservationRepository>((ref) {
  return ObservationRepository();
});
