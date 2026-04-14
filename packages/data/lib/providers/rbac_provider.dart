import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/rbac_permission_collection.dart';
import 'package:cc_fhir_models/models/rbac_permission.dart';

class RbacState {
  final String roleId;
  final Map<String, Set<String>> permissions; // resource → set of actions

  const RbacState({
    this.roleId = 'patient',
    this.permissions = const {},
  });

  bool hasPermission(String resource, String action) {
    return permissions[resource]?.contains(action) ?? false;
  }

  bool canRead(String resource) => hasPermission(resource, RbacActions.read);
  bool canCreate(String resource) => hasPermission(resource, RbacActions.create);
  bool canUpdate(String resource) => hasPermission(resource, RbacActions.update);
  bool canDelete(String resource) => hasPermission(resource, RbacActions.delete);
  bool canExport(String resource) => hasPermission(resource, RbacActions.export);
}

class RbacNotifier extends StateNotifier<RbacState> {
  RbacNotifier() : super(const RbacState());

  /// Load permissions for the given role from the local Hive box.
  void loadPermissionsForRole(String roleId) {
    final box = DatabaseService.rbacPermissions;
    final perms = <String, Set<String>>{};

    for (final p in box.values) {
      if (p.roleId == roleId && p.isAllowed) {
        perms.putIfAbsent(p.resource, () => <String>{}).add(p.action);
      }
    }

    state = RbacState(roleId: roleId, permissions: perms);
  }

  /// Update a single permission.
  Future<void> setPermission({
    required String roleId,
    required String roleName,
    required String resource,
    required String action,
    required bool isAllowed,
  }) async {
    final box = DatabaseService.rbacPermissions;

    // Find existing permission
    RbacPermissionLocal? existing;
    for (final p in box.values) {
      if (p.roleId == roleId &&
          p.resource == resource &&
          p.action == action) {
        existing = p;
        break;
      }
    }

    if (existing != null) {
      existing
        ..isAllowed = isAllowed
        ..updatedAt = DateTime.now();
      await existing.save();
    } else {
      await box.add(RbacPermissionLocal()
        ..roleId = roleId
        ..roleName = roleName
        ..resource = resource
        ..action = action
        ..isAllowed = isAllowed
        ..createdAt = DateTime.now());
    }

    // Reload if this is the current role
    if (roleId == state.roleId) {
      loadPermissionsForRole(roleId);
    }
  }

  /// Get all permissions for a specific role (for admin display).
  List<RbacPermissionLocal> getPermissionsForRole(String roleId) {
    final box = DatabaseService.rbacPermissions;
    return box.values.where((p) => p.roleId == roleId).toList();
  }
}

final rbacProvider = StateNotifierProvider<RbacNotifier, RbacState>((ref) {
  return RbacNotifier();
});

/// Convenience provider to check a specific permission.
final hasPermissionProvider =
    Provider.family<bool, ({String resource, String action})>((ref, params) {
  final rbac = ref.watch(rbacProvider);
  return rbac.hasPermission(params.resource, params.action);
});
