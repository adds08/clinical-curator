import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;

import 'base_repository.dart';

class PatientRepository extends BaseRepository<fhir.Patient> {
  PatientRepository() : super(resourceType: 'Patient');

  List<fhir.Patient> searchPatients({String? name}) {
    final all = parseLocalResources();
    if (name == null || name.isEmpty) return all;
    final query = name.toLowerCase();
    return all.where((p) {
      final names = p.name ?? [];
      return names.any((n) {
        final full = '${n.given?.join(' ') ?? ''} ${n.family ?? ''}'.toLowerCase();
        return full.contains(query);
      });
    }).toList();
  }

  fhir.Patient? getLocalPatient(String fhirId) {
    return findByFhirId(fhirId);
  }
}

final patientRepositoryProvider = Provider<PatientRepository>((ref) {
  return PatientRepository();
});
