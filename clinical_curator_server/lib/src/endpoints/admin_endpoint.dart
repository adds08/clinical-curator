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

  /// List all users, optionally filtered by `accountType`
  /// ('patient' | 'practitioner' | 'admin'). Pass null/empty for all.
  Future<List<UserAccount>> listAllUsers(
    Session session, {
    String? accountType,
  }) async {
    if (accountType == null || accountType.isEmpty) {
      return await UserAccount.db.find(
        session,
        orderBy: (t) => t.createdAt,
        orderDescending: true,
      );
    }
    return await UserAccount.db.find(
      session,
      where: (t) => t.accountType.equals(accountType),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Toggle a user's `isVerified` flag directly. Used by the admin
  /// manage-users screen for quick flips outside the verification flow.
  Future<UserAccount> setUserVerified(
    Session session,
    int id,
    bool isVerified,
  ) async {
    final account = await UserAccount.db.findById(session, id);
    if (account == null) throw NotFoundException('Account not found.');
    final updated = account.copyWith(
      isVerified: isVerified,
      updatedAt: DateTime.now(),
    );
    return await UserAccount.db.updateRow(session, updated);
  }

  /// Aggregate dashboard counts. Superset of `getDashboardStats` —
  /// includes patient/appointment/encounter counts in a single round-trip.
  Future<Map<String, int>> getAnalytics(Session session) async {
    final totalUsers = await UserAccount.db.count(session);
    final totalPatients = await UserAccount.db.count(
      session,
      where: (t) => t.accountType.equals('patient'),
    );
    final totalPractitioners = await UserAccount.db.count(
      session,
      where: (t) => t.isPractitioner.equals(true),
    );
    final verifiedPractitioners = await UserAccount.db.count(
      session,
      where: (t) => t.isPractitioner.equals(true) & t.isVerified.equals(true),
    );
    final pending = await UserAccount.db.count(
      session,
      where: (t) => t.isPractitioner.equals(true) & t.isVerified.equals(false),
    );

    // Appointments today — server may or may not have rows populated.
    final today = DateTime.now();
    final dayStart = DateTime(today.year, today.month, today.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    int appointmentsToday = 0;
    try {
      appointmentsToday = await Appointment.db.count(
        session,
        where: (t) =>
            t.scheduledAt.between(dayStart, dayEnd),
      );
    } catch (_) {
      appointmentsToday = 0;
    }

    // Active encounters.
    int activeEncounters = 0;
    try {
      activeEncounters = await Encounter.db.count(
        session,
        where: (t) => t.status.equals('in-progress'),
      );
    } catch (_) {
      activeEncounters = 0;
    }

    return {
      'totalUsers': totalUsers,
      'totalPatients': totalPatients,
      'totalPractitioners': totalPractitioners,
      'verifiedPractitioners': verifiedPractitioners,
      'pendingVerifications': pending,
      'appointmentsToday': appointmentsToday,
      'activeEncounters': activeEncounters,
    };
  }
}
