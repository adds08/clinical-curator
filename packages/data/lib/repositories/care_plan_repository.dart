import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;

import 'base_repository.dart';

class CarePlanRepository extends BaseRepository<fhir.CarePlan> {
  CarePlanRepository() : super(resourceType: 'CarePlan');

  List<fhir.CarePlan> getActiveByPatient(String patientRef) {
    return parseLocalResources(patientRef: patientRef).where((cp) {
      return cp.status?.value == 'active';
    }).toList();
  }

  List<fhir.CarePlan> getByStatus(String patientRef, String status) {
    return parseLocalResources(patientRef: patientRef).where((cp) {
      return cp.status?.value == status;
    }).toList();
  }
}

final carePlanRepositoryProvider = Provider<CarePlanRepository>((ref) {
  return CarePlanRepository();
});
