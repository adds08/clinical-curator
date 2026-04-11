import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/isar_service.dart';
import '../../data/collections/location_collection.dart';

/// Locations belonging to a specific organization.
final locationsByOrgProvider =
    Provider.family<List<LocationLocal>, String>((ref, orgRef) {
  final box = DatabaseService.locations;
  return box.values
      .where((l) => l.organizationRef == orgRef && l.syncStatus != 2)
      .toList()
    ..sort((a, b) => a.name.compareTo(b.name));
});

/// Locations filtered by type (building, wing, ward, room, etc.).
final locationsByTypeProvider =
    Provider.family<List<LocationLocal>, String>((ref, type) {
  final box = DatabaseService.locations;
  return box.values
      .where((l) => l.type == type && l.syncStatus != 2)
      .toList()
    ..sort((a, b) => a.name.compareTo(b.name));
});

/// All active locations.
final allLocationsProvider = Provider<List<LocationLocal>>((ref) {
  final box = DatabaseService.locations;
  return box.values
      .where((l) => l.status == 'active' && l.syncStatus != 2)
      .toList()
    ..sort((a, b) => a.name.compareTo(b.name));
});
