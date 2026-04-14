import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;

import 'base_repository.dart';

class HealthcareServiceRepository
    extends BaseRepository<fhir.HealthcareService> {
  HealthcareServiceRepository() : super(resourceType: 'HealthcareService');

  List<fhir.HealthcareService> getByOrganization(String organizationRef) {
    return parseLocalResources().where((s) {
      return s.providedBy?.reference == organizationRef;
    }).toList();
  }

  List<fhir.HealthcareService> getBySpecialty(String specialty) {
    return parseLocalResources().where((s) {
      return s.specialty?.any((sp) =>
              sp.coding?.any((c) => c.code?.value == specialty) ?? false) ??
          false;
    }).toList();
  }
}

final healthcareServiceRepositoryProvider =
    Provider<HealthcareServiceRepository>((ref) {
  return HealthcareServiceRepository();
});
