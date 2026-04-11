import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;

import 'base_repository.dart';

class PractitionerRoleRepository
    extends BaseRepository<fhir.PractitionerRole> {
  PractitionerRoleRepository() : super(resourceType: 'PractitionerRole');

  List<fhir.PractitionerRole> getByPractitioner(String practitionerRef) {
    return parseLocalResources().where((r) {
      return r.practitioner?.reference == practitionerRef;
    }).toList();
  }

  List<fhir.PractitionerRole> getByOrganization(String organizationRef) {
    return parseLocalResources().where((r) {
      return r.organization?.reference == organizationRef;
    }).toList();
  }

  List<fhir.PractitionerRole> getBySpecialty(String specialty) {
    return parseLocalResources().where((r) {
      return r.specialty?.any((sp) =>
              sp.coding?.any((c) => c.code?.value == specialty) ?? false) ??
          false;
    }).toList();
  }
}

final practitionerRoleRepositoryProvider =
    Provider<PractitionerRoleRepository>((ref) {
  return PractitionerRoleRepository();
});
