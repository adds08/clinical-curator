import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;

import 'base_repository.dart';

class ProcedureRepository extends BaseRepository<fhir.Procedure> {
  ProcedureRepository() : super(resourceType: 'Procedure');

  List<fhir.Procedure> getByPatient(String patientRef) {
    return parseLocalResources(patientRef: patientRef);
  }

  List<fhir.Procedure> getByEncounter(String encounterRef) {
    return parseLocalResources().where((p) {
      return p.encounter?.reference == encounterRef;
    }).toList();
  }

  List<fhir.Procedure> getCompleted(String patientRef) {
    return parseLocalResources(patientRef: patientRef).where((p) {
      return p.status?.value == 'completed';
    }).toList();
  }
}

final procedureRepositoryProvider = Provider<ProcedureRepository>((ref) {
  return ProcedureRepository();
});
