import 'package:cc_data/database/isar_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Active clinician's PractitionerRole.code (e.g. "doctor", "nurse") —
/// null when the signed-in user is not a practitioner.
///
/// Defined here as a stub so cc_rbac stays app-agnostic; the clinical app
/// overrides it via `ProviderScope(overrides: [...])` with the real source
/// that reads `AppUser.practitionerType` from its auth layer.
final clinicianRoleCodeProvider = Provider<String?>((_) => null);

/// Application-layer permission check (NOT FHIR — FHIR has no auth concept).
///
/// Reads `RbacPermissionLocal` rows keyed by the active clinician's role code
/// for the given `resource.action` permission key. Default-deny on missing rows.
///
/// Watch via `ref.watch(canProvider('encounter.sign'))` or the imperative
/// shortcut `ref.can('encounter.sign')`.
final canProvider = Provider.family<bool, String>((ref, key) {
  final parts = key.split('.');
  if (parts.length != 2) {
    throw ArgumentError(
      'Permission keys must be "resource.action" — got "$key".',
    );
  }
  final resource = parts[0];
  final action = parts[1];

  final roleCode = ref.watch(clinicianRoleCodeProvider);
  if (roleCode == null) return false;

  try {
    final row = DatabaseService.rbacPermissions.values.firstWhere(
      (p) =>
          p.roleId == roleCode &&
          p.resource == resource &&
          p.action == action,
    );
    return row.isAllowed;
  } catch (_) {
    return false;
  }
});

extension CanRefExtension on WidgetRef {
  bool can(String permissionKey) => watch(canProvider(permissionKey));
}
