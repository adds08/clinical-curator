import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Role-based access control read/write. Admin app manages the
/// permission matrix here.
class RbacEndpoint extends Endpoint {
  /// List every RBAC permission entry (all roles).
  Future<List<RbacPermission>> listAll(Session session) async {
    return await RbacPermission.db.find(
      session,
      orderBy: (t) => t.roleId,
    );
  }

  /// List permissions scoped to one role.
  Future<List<RbacPermission>> listForRole(
    Session session,
    String roleId,
  ) async {
    return await RbacPermission.db.find(
      session,
      where: (t) => t.roleId.equals(roleId),
      orderBy: (t) => t.resource,
    );
  }

  /// Upsert a permission. Matches on (roleId, resource, action) and
  /// updates `isAllowed` if found, otherwise inserts.
  Future<RbacPermission> setPermission(
    Session session,
    String roleId,
    String roleName,
    String resource,
    String action,
    bool isAllowed,
  ) async {
    final existing = await RbacPermission.db.find(
      session,
      where: (t) =>
          t.roleId.equals(roleId) &
          t.resource.equals(resource) &
          t.action.equals(action),
      limit: 1,
    );
    final now = DateTime.now();
    if (existing.isNotEmpty) {
      final updated = existing.first.copyWith(
        isAllowed: isAllowed,
        roleName: roleName,
        updatedAt: now,
      );
      return await RbacPermission.db.updateRow(session, updated);
    }
    final row = RbacPermission(
      roleId: roleId,
      roleName: roleName,
      resource: resource,
      action: action,
      isAllowed: isAllowed,
      createdAt: now,
      updatedAt: now,
    );
    return await RbacPermission.db.insertRow(session, row);
  }

  /// Delete a permission entry.
  Future<bool> deletePermission(Session session, int id) async {
    final existing = await RbacPermission.db.findById(session, id);
    if (existing == null) return false;
    await RbacPermission.db.deleteRow(session, existing);
    return true;
  }

}
