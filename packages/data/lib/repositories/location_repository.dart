import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;

import 'base_repository.dart';

class LocationRepository extends BaseRepository<fhir.Location> {
  LocationRepository() : super(resourceType: 'Location');

  List<fhir.Location> getByOrganization(String organizationRef) {
    return parseLocalResources().where((l) {
      return l.managingOrganization?.reference == organizationRef;
    }).toList();
  }

  List<fhir.Location> getByType(String type) {
    return parseLocalResources().where((l) {
      return l.type?.any(
              (t) => t.coding?.any((c) => c.code?.value == type) ?? false) ??
          false;
    }).toList();
  }
}

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepository();
});
