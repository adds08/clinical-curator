import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;

import 'base_repository.dart';

class ConditionRepository extends BaseRepository<fhir.Condition> {
  ConditionRepository() : super(resourceType: 'Condition');

  List<fhir.Condition> getActiveByPatient(String patientRef) {
    return parseLocalResources(patientRef: patientRef).where((c) {
      final status = c.clinicalStatus?.coding?.firstOrNull?.code?.value;
      return status == 'active' || status == 'recurrence' || status == 'relapse';
    }).toList();
  }

  List<fhir.Condition> getResolvedByPatient(String patientRef) {
    return parseLocalResources(patientRef: patientRef).where((c) {
      final status = c.clinicalStatus?.coding?.firstOrNull?.code?.value;
      return status == 'resolved' || status == 'remission' || status == 'inactive';
    }).toList();
  }

  List<fhir.Condition> getProblemList(String patientRef) {
    return getActiveByPatient(patientRef);
  }
}

final conditionRepositoryProvider = Provider<ConditionRepository>((ref) {
  return ConditionRepository();
});
