import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/audit_event_collection.dart';

/// Total patient count.
final totalPatientsProvider = Provider<int>((ref) {
  final box = DatabaseService.userAccounts;
  return box.values.where((a) => !a.isPractitioner && a.accountType != 'admin').length;
});

/// Total practitioner count.
final totalPractitionersProvider = Provider<int>((ref) {
  final box = DatabaseService.userAccounts;
  return box.values.where((a) => a.isPractitioner).length;
});

/// Verified practitioner count.
final verifiedPractitionersProvider = Provider<int>((ref) {
  final box = DatabaseService.userAccounts;
  return box.values.where((a) => a.isPractitioner && a.isVerified).length;
});

/// Pending verification count.
final pendingVerificationCountProvider = Provider<int>((ref) {
  final box = DatabaseService.userAccounts;
  return box.values.where((a) => a.isPractitioner && !a.isVerified).length;
});

/// Appointments today count.
final appointmentsTodayCountProvider = Provider<int>((ref) {
  final box = DatabaseService.appointments;
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);
  final todayEnd = todayStart.add(const Duration(days: 1));
  return box.values
      .where((a) =>
          a.scheduledAt.isAfter(todayStart) &&
          a.scheduledAt.isBefore(todayEnd))
      .length;
});

/// Total encounters count.
final totalEncountersProvider = Provider<int>((ref) {
  return DatabaseService.encounters.values
      .where((e) => e.syncStatus != 2)
      .length;
});

/// Active encounters count.
final activeEncountersCountProvider = Provider<int>((ref) {
  return DatabaseService.encounters.values
      .where((e) => e.status == 'in-progress' && e.syncStatus != 2)
      .length;
});

/// Recent audit events (latest 20).
final recentAuditEventsProvider = Provider<List<AuditEventLocal>>((ref) {
  final box = DatabaseService.auditEvents;
  final events = box.values.toList()
    ..sort((a, b) => b.recorded.compareTo(a.recorded));
  return events.take(20).toList();
});

/// Daily registration counts for the last 7 days.
final registrationTrendProvider = Provider<List<({DateTime date, int count})>>((ref) {
  final box = DatabaseService.userAccounts;
  final now = DateTime.now();
  final result = <({DateTime date, int count})>[];

  for (int i = 6; i >= 0; i--) {
    final day = DateTime(now.year, now.month, now.day - i);
    final nextDay = day.add(const Duration(days: 1));
    final count = box.values
        .where((a) =>
            a.createdAt.isAfter(day) && a.createdAt.isBefore(nextDay))
        .length;
    result.add((date: day, count: count));
  }

  return result;
});

/// Appointment counts per day for the last 7 days.
final appointmentTrendProvider = Provider<List<({DateTime date, int count})>>((ref) {
  final box = DatabaseService.appointments;
  final now = DateTime.now();
  final result = <({DateTime date, int count})>[];

  for (int i = 6; i >= 0; i--) {
    final day = DateTime(now.year, now.month, now.day - i);
    final nextDay = day.add(const Duration(days: 1));
    final count = box.values
        .where((a) =>
            a.scheduledAt.isAfter(day) && a.scheduledAt.isBefore(nextDay))
        .length;
    result.add((date: day, count: count));
  }

  return result;
});
