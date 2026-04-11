import 'package:serverpod/serverpod.dart';

import '../errors/app_exceptions.dart';
import '../generated/protocol.dart';

class AdminEndpoint extends Endpoint {
  /// List pending practitioner verifications.
  Future<List<UserAccount>> listPendingVerifications(Session session) async {
    return await UserAccount.db.find(
      session,
      where: (t) => t.isPractitioner.equals(true) & t.isVerified.equals(false),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Approve a practitioner.
  Future<UserAccount> approvePractitioner(Session session, int id) async {
    final account = await UserAccount.db.findById(session, id);
    if (account == null) throw NotFoundException('Account not found.');
    final updated = account.copyWith(
      isVerified: true,
      updatedAt: DateTime.now(),
    );
    return await UserAccount.db.updateRow(session, updated);
  }

  /// Reject a practitioner.
  Future<UserAccount> rejectPractitioner(Session session, int id) async {
    final account = await UserAccount.db.findById(session, id);
    if (account == null) throw NotFoundException('Account not found.');
    final updated = account.copyWith(
      isPractitioner: false,
      isVerified: false,
      updatedAt: DateTime.now(),
    );
    return await UserAccount.db.updateRow(session, updated);
  }

  /// Get dashboard stats.
  Future<Map<String, int>> getDashboardStats(Session session) async {
    final allUsers = await UserAccount.db.count(session);
    final pending = await UserAccount.db.count(
      session,
      where: (t) => t.isPractitioner.equals(true) & t.isVerified.equals(false),
    );
    final approved = await UserAccount.db.count(
      session,
      where: (t) => t.isPractitioner.equals(true) & t.isVerified.equals(true),
    );

    return {
      'totalUsers': allUsers,
      'pendingVerifications': pending,
      'approvedPractitioners': approved,
    };
  }

  /// List all verified practitioners.
  Future<List<UserAccount>> listVerifiedPractitioners(Session session) async {
    return await UserAccount.db.find(
      session,
      where: (t) => t.isPractitioner.equals(true) & t.isVerified.equals(true),
      orderBy: (t) => t.displayName,
    );
  }
}
