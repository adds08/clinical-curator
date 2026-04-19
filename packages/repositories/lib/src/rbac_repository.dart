import 'package:clinical_curator_client/clinical_curator_client.dart';

/// RBAC resource identifiers used across the permission system.
class RbacResources {
  RbacResources._();

  static const String patients = 'patients';
  static const String encounters = 'encounters';
  static const String appointments = 'appointments';
  static const String organizations = 'organizations';
  static const String users = 'users';
  static const String auditLog = 'audit_log';
  static const String settings = 'settings';
  static const String reports = 'reports';

  static const List<String> all = [
    patients,
    encounters,
    appointments,
    organizations,
    users,
    auditLog,
    settings,
    reports,
  ];
}

/// RBAC action identifiers.
class RbacActions {
  RbacActions._();

  static const String read = 'read';
  static const String create = 'create';
  static const String update = 'update';
  static const String delete = 'delete';
  static const String export = 'export';

  static const List<String> all = [read, create, update, delete, export];
}

abstract class RbacRepository {
  Future<List<RbacPermission>> listAll();
  Future<List<RbacPermission>> listForRole(String roleId);
  Future<RbacPermission> setPermission({
    required String roleId,
    required String roleName,
    required String resource,
    required String action,
    required bool isAllowed,
  });
  Future<bool> deletePermission(int id);
}
