import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/isar_service.dart';
import '../../data/collections/healthcare_service_collection.dart';

/// Healthcare services for a specific organization.
final servicesByOrgProvider =
    Provider.family<List<HealthcareServiceLocal>, String>((ref, orgRef) {
  final box = DatabaseService.healthcareServices;
  return box.values
      .where((s) => s.organizationRef == orgRef && s.syncStatus != 2)
      .toList()
    ..sort((a, b) => a.name.compareTo(b.name));
});

/// Healthcare services filtered by specialty.
final servicesBySpecialtyProvider =
    Provider.family<List<HealthcareServiceLocal>, String>((ref, specialty) {
  final box = DatabaseService.healthcareServices;
  return box.values
      .where(
          (s) => s.specialty == specialty && s.active && s.syncStatus != 2)
      .toList()
    ..sort((a, b) => a.name.compareTo(b.name));
});

/// All active healthcare services.
final allHealthcareServicesProvider =
    Provider<List<HealthcareServiceLocal>>((ref) {
  final box = DatabaseService.healthcareServices;
  return box.values
      .where((s) => s.active && s.syncStatus != 2)
      .toList()
    ..sort((a, b) => a.name.compareTo(b.name));
});
