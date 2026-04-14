import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/audit_event_collection.dart';

/// Utility for logging audit events to the local Hive store.
class AuditLogger {
  AuditLogger._();

  static Future<void> log({
    required String action,
    required String agentRef,
    required String agentName,
    String type = 'rest',
    String? entityRef,
    String? entityType,
    String? detail,
    String outcome = 'success',
  }) async {
    final now = DateTime.now();
    final event = AuditEventLocal()
      ..fhirId = 'audit-${now.millisecondsSinceEpoch}'
      ..type = type
      ..action = action
      ..recorded = now
      ..agentRef = agentRef
      ..agentName = agentName
      ..entityRef = entityRef
      ..entityType = entityType
      ..outcome = outcome
      ..detail = detail
      ..createdAt = now
      ..syncStatus = 1;

    await DatabaseService.auditEvents.add(event);
  }

  static Future<void> logLogin(String userId, String userName) =>
      log(
        type: 'user-auth',
        action: 'login',
        agentRef: userId,
        agentName: userName,
        detail: 'User logged in',
      );

  static Future<void> logLogout(String userId, String userName) =>
      log(
        type: 'user-auth',
        action: 'logout',
        agentRef: userId,
        agentName: userName,
        detail: 'User logged out',
      );

  static Future<void> logDataAccess({
    required String userId,
    required String userName,
    required String entityRef,
    required String entityType,
    String? detail,
  }) =>
      log(
        type: 'data-access',
        action: 'read',
        agentRef: userId,
        agentName: userName,
        entityRef: entityRef,
        entityType: entityType,
        detail: detail,
      );

  static Future<void> logCreate({
    required String userId,
    required String userName,
    required String entityRef,
    required String entityType,
    String? detail,
  }) =>
      log(
        action: 'create',
        agentRef: userId,
        agentName: userName,
        entityRef: entityRef,
        entityType: entityType,
        detail: detail,
      );

  static Future<void> logAdminAction({
    required String userId,
    required String userName,
    required String action,
    String? entityRef,
    String? entityType,
    String? detail,
  }) =>
      log(
        type: 'admin',
        action: action,
        agentRef: userId,
        agentName: userName,
        entityRef: entityRef,
        entityType: entityType,
        detail: detail,
      );
}
