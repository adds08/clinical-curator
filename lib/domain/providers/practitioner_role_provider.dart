import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/isar_service.dart';
import '../../data/collections/practitioner_role_collection.dart';

/// Roles for a specific practitioner (which organizations they work at).
final rolesByPractitionerProvider =
    Provider.family<List<PractitionerRoleLocal>, String>((ref, practRef) {
  final box = DatabaseService.practitionerRoles;
  return box.values
      .where((r) => r.practitionerRef == practRef && r.syncStatus != 2)
      .toList();
});

/// Staff at a specific organization.
final rolesByOrgProvider =
    Provider.family<List<PractitionerRoleLocal>, String>((ref, orgRef) {
  final box = DatabaseService.practitionerRoles;
  return box.values
      .where((r) =>
          r.organizationRef == orgRef && r.active && r.syncStatus != 2)
      .toList();
});

/// Practitioners with a given specialty (across all organizations).
final practitionersBySpecialtyProvider =
    Provider.family<List<PractitionerRoleLocal>, String>((ref, specialty) {
  final box = DatabaseService.practitionerRoles;
  return box.values
      .where((r) =>
          r.specialty == specialty && r.active && r.syncStatus != 2)
      .toList();
});

/// All active practitioner roles.
final allPractitionerRolesProvider =
    Provider<List<PractitionerRoleLocal>>((ref) {
  final box = DatabaseService.practitionerRoles;
  return box.values
      .where((r) => r.active && r.syncStatus != 2)
      .toList();
});
