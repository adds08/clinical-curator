import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/audit_event_collection.dart';

/// Lightweight helper that persists FHIR-shaped [AuditEventLocal] rows to
/// Hive. Call sites: auth flows, encounter create, prescription issue,
/// consent grant/revoke, etc.
///
/// Kept intentionally app-only (not in a shared package) so it can depend
/// on both `cc_data` and `cc_fhir_models` without polluting the domain layer.
class AuditLogger {
  AuditLogger._();

  /// Logs a single audit event. Fire-and-forget — any Hive errors are
  /// swallowed so audit logging can never break the primary user action.
  static Future<void> log({
    required String type,              // 'rest' | 'user-auth' | 'data-access' | …
    required String action,            // C / R / U / D / E / login / logout
    required String agentRef,          // e.g. 'Practitioner/practitioner-arpan'
    required String agentName,
    String? agentRole,
    String? entityRef,                 // e.g. 'Encounter/enc-123'
    String? entityType,
    String outcome = 'success',        // success | failure
    String? detail,
  }) async {
    try {
      final now = DateTime.now();
      final ev = AuditEventLocal()
        ..fhirId = 'audit-${now.microsecondsSinceEpoch}'
        ..type = type
        ..action = action
        ..recorded = now
        ..agentRef = agentRef
        ..agentName = agentRole == null ? agentName : '$agentName ($agentRole)'
        ..entityRef = entityRef
        ..entityType = entityType
        ..outcome = outcome
        ..detail = detail
        ..createdAt = now
        ..syncStatus = 0;
      await DatabaseService.auditEvents.add(ev);
    } catch (_) {
      // Never let audit logging bubble up — log to stderr at most.
    }
  }

  static Future<void> loginSuccess({required String email, String? role}) =>
      log(
        type: 'user-auth',
        action: 'login',
        agentRef: 'User/$email',
        agentName: email,
        agentRole: role,
      );

  static Future<void> loginFailure({required String email, String? reason}) =>
      log(
        type: 'user-auth',
        action: 'login',
        agentRef: 'User/$email',
        agentName: email,
        outcome: 'failure',
        detail: reason,
      );

  static Future<void> encounterCreated({
    required String encounterRef,
    required String agentRef,
    required String agentName,
    String? agentRole,
  }) =>
      log(
        type: 'rest',
        action: 'C',
        agentRef: agentRef,
        agentName: agentName,
        agentRole: agentRole,
        entityRef: encounterRef,
        entityType: 'Encounter',
      );

  static Future<void> prescriptionIssued({
    required String medicationRequestRef,
    required String agentRef,
    required String agentName,
    String? agentRole,
  }) =>
      log(
        type: 'rest',
        action: 'C',
        agentRef: agentRef,
        agentName: agentName,
        agentRole: agentRole,
        entityRef: medicationRequestRef,
        entityType: 'MedicationRequest',
      );

  static Future<void> consentGranted({
    required String consentRef,
    required String agentRef,
    required String agentName,
  }) =>
      log(
        type: 'rest',
        action: 'C',
        agentRef: agentRef,
        agentName: agentName,
        entityRef: consentRef,
        entityType: 'Consent',
        detail: 'grant',
      );

  static Future<void> practitionerVerified({
    required String practitionerRef,
    required String practitionerName,
    String? role,
  }) =>
      log(
        type: 'rest',
        action: 'U',
        agentRef: practitionerRef,
        agentName: practitionerName,
        agentRole: role,
        entityRef: practitionerRef,
        entityType: 'Practitioner',
        detail: 'verification-approved',
      );

  static Future<void> dataAccessed({
    required String entityRef,
    required String entityType,
    required String agentRef,
    required String agentName,
    String? agentRole,
  }) =>
      log(
        type: 'data-access',
        action: 'R',
        agentRef: agentRef,
        agentName: agentName,
        agentRole: agentRole,
        entityRef: entityRef,
        entityType: entityType,
      );

  static Future<void> dataExported({
    required String agentRef,
    required String agentName,
    required String destination, // 'local-json' | 'google-drive'
    required int resourceCount,
    String? filePath,
  }) =>
      log(
        type: 'data-access',
        action: 'E',
        agentRef: agentRef,
        agentName: agentName,
        entityRef: filePath,
        entityType: 'Bundle',
        detail: 'export→$destination count=$resourceCount',
      );

  static Future<void> dataImported({
    required String agentRef,
    required String agentName,
    required String source, // 'local-json' | 'google-drive'
    required int resourceCount,
    int conflicts = 0,
  }) =>
      log(
        type: 'data-access',
        action: 'C',
        agentRef: agentRef,
        agentName: agentName,
        entityType: 'Bundle',
        detail: 'import←$source count=$resourceCount conflicts=$conflicts',
      );

  static Future<void> dataDeleted({
    required String agentRef,
    required String agentName,
    required int resourceCount,
    String? detail,
  }) =>
      log(
        type: 'rest',
        action: 'D',
        agentRef: agentRef,
        agentName: agentName,
        entityType: 'Bundle',
        detail: detail == null
            ? 'purge count=$resourceCount'
            : '$detail count=$resourceCount',
      );

  static Future<void> dataConflict({
    required String entityRef,
    required String entityType,
    required String agentRef,
    required String agentName,
    String? detail,
  }) =>
      log(
        type: 'rest',
        action: 'U',
        agentRef: agentRef,
        agentName: agentName,
        entityRef: entityRef,
        entityType: entityType,
        outcome: 'failure',
        detail: detail ?? 'sync-conflict',
      );

  static Future<void> consentRevoked({
    required String consentRef,
    required String agentRef,
    required String agentName,
  }) =>
      log(
        type: 'rest',
        action: 'U',
        agentRef: agentRef,
        agentName: agentName,
        entityRef: consentRef,
        entityType: 'Consent',
        detail: 'revoke',
      );
}
