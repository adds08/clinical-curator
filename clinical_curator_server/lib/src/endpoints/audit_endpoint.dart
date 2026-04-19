import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Audit trail read/write. Admin app uses this for the audit-log screen
/// and to record admin actions (e.g. demo-data purges, verification
/// approvals that go beyond `admin.approvePractitioner`).
class AuditEndpoint extends Endpoint {
  /// List audit events, newest first. Supports optional action filter.
  Future<List<AuditEvent>> list(
    Session session, {
    String? action,
    int? limit,
    int? offset,
  }) async {
    return await AuditEvent.db.find(
      session,
      where: (action != null && action.isNotEmpty)
          ? (t) => t.action.equals(action)
          : null,
      orderBy: (t) => t.recorded,
      orderDescending: true,
      limit: limit ?? 100,
      offset: offset ?? 0,
    );
  }

  /// Recent N events — used by dashboard "Recent Activity" panel.
  Future<List<AuditEvent>> recent(Session session, {int limit = 20}) async {
    return await AuditEvent.db.find(
      session,
      orderBy: (t) => t.recorded,
      orderDescending: true,
      limit: limit,
    );
  }

  /// Record a new audit event.
  Future<AuditEvent> record(Session session, AuditEvent event) async {
    return await AuditEvent.db.insertRow(session, event);
  }
}
