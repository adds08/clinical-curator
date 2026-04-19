/// Dashboard analytics snapshot. Raw counts only — trend charts require
/// a richer endpoint and are deferred until server-side time-series is
/// added. Callers treat missing keys as 0.
class AnalyticsSnapshot {
  final int totalUsers;
  final int totalPatients;
  final int totalPractitioners;
  final int verifiedPractitioners;
  final int pendingVerifications;
  final int appointmentsToday;
  final int activeEncounters;

  const AnalyticsSnapshot({
    this.totalUsers = 0,
    this.totalPatients = 0,
    this.totalPractitioners = 0,
    this.verifiedPractitioners = 0,
    this.pendingVerifications = 0,
    this.appointmentsToday = 0,
    this.activeEncounters = 0,
  });

  factory AnalyticsSnapshot.fromMap(Map<String, int> map) => AnalyticsSnapshot(
        totalUsers: map['totalUsers'] ?? 0,
        totalPatients: map['totalPatients'] ?? 0,
        totalPractitioners: map['totalPractitioners'] ?? 0,
        verifiedPractitioners: map['verifiedPractitioners'] ?? 0,
        pendingVerifications: map['pendingVerifications'] ?? 0,
        appointmentsToday: map['appointmentsToday'] ?? 0,
        activeEncounters: map['activeEncounters'] ?? 0,
      );
}

abstract class AnalyticsRepository {
  Future<AnalyticsSnapshot> getSnapshot();
}
