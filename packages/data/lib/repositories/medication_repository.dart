import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;

import 'base_repository.dart';

class MedicationRepository extends BaseRepository<fhir.MedicationRequest> {
  MedicationRepository() : super(resourceType: 'MedicationRequest');

  List<fhir.MedicationRequest> getActiveMedications(String patientRef) {
    return parseLocalResources(patientRef: patientRef).where((med) {
      return med.status?.value == 'active';
    }).toList();
  }
}

final medicationRepositoryProvider = Provider<MedicationRepository>((ref) {
  return MedicationRepository();
});
