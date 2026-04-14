import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;

import 'base_repository.dart';

class AllergyIntoleranceRepository
    extends BaseRepository<fhir.AllergyIntolerance> {
  AllergyIntoleranceRepository() : super(resourceType: 'AllergyIntolerance');

  List<fhir.AllergyIntolerance> getActiveByPatient(String patientRef) {
    return parseLocalResources(patientRef: patientRef).where((a) {
      final status = a.clinicalStatus?.coding?.firstOrNull?.code?.value;
      return status == 'active';
    }).toList();
  }

  List<fhir.AllergyIntolerance> getByCriticality(
      String patientRef, String criticality) {
    return parseLocalResources(patientRef: patientRef).where((a) {
      return a.criticality?.value == criticality;
    }).toList();
  }
}

final allergyIntoleranceRepositoryProvider =
    Provider<AllergyIntoleranceRepository>((ref) {
  return AllergyIntoleranceRepository();
});
