import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;

import 'base_repository.dart';

class ImmunizationRepository extends BaseRepository<fhir.Immunization> {
  ImmunizationRepository() : super(resourceType: 'Immunization');

  List<fhir.Immunization> getByPatient(String patientRef) {
    return parseLocalResources(patientRef: patientRef);
  }

  List<fhir.Immunization> getByVaccineCode(String patientRef, String code) {
    return parseLocalResources(patientRef: patientRef).where((imm) {
      return imm.vaccineCode.coding?.any((c) => c.code?.value == code) ?? false;
    }).toList();
  }
}

final immunizationRepositoryProvider = Provider<ImmunizationRepository>((ref) {
  return ImmunizationRepository();
});
