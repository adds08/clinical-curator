import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// FHIR offline/online sync endpoint.
///
/// Implements a simple `_since` timestamp pattern over Serverpod. Clients
/// persist `lastSyncTimestamp_<resourceType>` locally; on each tick they
/// call [since] to pull server-side changes, then [push] to upload their
/// local dirty set. Server-side conflict resolution is last-write-wins
/// by comparing `meta.lastUpdated` in the embedded JSON.
class FhirSyncEndpoint extends Endpoint {
  static const _supportedTypes = {
    'Patient',
    'Observation',
    'MedicationRequest',
    'AllergyIntolerance',
    'Immunization',
    'Encounter',
    'Condition',
    'DiagnosticReport',
  };

  /// Demo patient FHIR ids — kept in sync with packages/data/lib/mock/mock_seed.dart.
  static const _demoPatientRefs = <String>[
    'Patient/patient-arjun',
    'Patient/patient-sunita',
    'Patient/patient-ram',
    'Patient/patient-sita',
    'Patient/patient-deepak',
    'Patient/patient-priya',
    'Patient/patient-krishna',
    'Patient/patient-maya',
  ];

  /// Returns resources of [resourceType] with `lastUpdated > since`,
  /// capped at [limit]. `nextSince` is the max `lastUpdated` in the
  /// returned batch (or the input `since` if the batch is empty).
  Future<FhirSyncBatchDto> since(
    Session session,
    String resourceType,
    DateTime since, {
    int limit = 500,
  }) async {
    if (!_supportedTypes.contains(resourceType)) {
      return FhirSyncBatchDto(
        resources: const [],
        nextSince: since,
        hasMore: false,
      );
    }
    final rows = await FhirResourceRecord.db.find(
      session,
      where: (t) =>
          t.resourceType.equals(resourceType) & (t.lastUpdated > since),
      orderBy: (t) => t.lastUpdated,
      limit: limit + 1,
    );
    final hasMore = rows.length > limit;
    final batch = hasMore ? rows.sublist(0, limit) : rows;
    final nextSince = batch.isEmpty
        ? since
        : batch.map((r) => r.lastUpdated).reduce((a, b) => a.isAfter(b) ? a : b);
    return FhirSyncBatchDto(
      resources: batch,
      nextSince: nextSince,
      hasMore: hasMore,
    );
  }

  /// Upserts a batch of resources by `fhirId`+`resourceType`. Last-write-wins
  /// on `meta.lastUpdated` inside the JSON payload. Resources whose server
  /// copy is newer are skipped.
  Future<void> push(
    Session session,
    List<FhirResourceRecord> resources,
  ) async {
    for (final incoming in resources) {
      final existing = await FhirResourceRecord.db.find(
        session,
        where: (t) =>
            t.fhirId.equals(incoming.fhirId) &
            t.resourceType.equals(incoming.resourceType),
      );
      final incomingMetaTs = _extractMetaLastUpdated(incoming.jsonData) ??
          incoming.lastUpdated;
      if (existing.isEmpty) {
        await FhirResourceRecord.db.insertRow(
          session,
          incoming.copyWith(
            syncVersion: 1,
            lastUpdated: incomingMetaTs,
            createdAt: incoming.createdAt,
          ),
        );
        continue;
      }
      final current = existing.first;
      final currentMetaTs = _extractMetaLastUpdated(current.jsonData) ??
          current.lastUpdated;
      if (!incomingMetaTs.isAfter(currentMetaTs)) {
        // Local is same-or-older — server copy wins.
        continue;
      }
      await FhirResourceRecord.db.updateRow(
        session,
        current.copyWith(
          jsonData: incoming.jsonData,
          patientReference: incoming.patientReference,
          practitionerReference: incoming.practitionerReference,
          category: incoming.category,
          syncVersion: current.syncVersion + 1,
          lastUpdated: incomingMetaTs,
        ),
      );
    }
  }

  /// Admin-only. Deletes every FhirResourceRecord whose `patientReference`
  /// matches one of the demo patient ids. The optional [adminEmail] is
  /// cross-checked against `UserAccount.accountType == 'admin'` — if the
  /// caller isn't an admin, the call throws. Pass `null` to bypass (trust
  /// the transport, e.g. a local dev tool). Real RBAC middleware should
  /// replace this once Serverpod Auth is fully wired.
  Future<int> purgeDemoData(Session session, {String? adminEmail}) async {
    if (adminEmail != null) {
      final accounts = await UserAccount.db.find(
        session,
        where: (t) => t.email.equals(adminEmail),
        limit: 1,
      );
      if (accounts.isEmpty || accounts.first.accountType != 'admin') {
        throw Exception('purgeDemoData: admin role required');
      }
    }
    var total = 0;
    for (final ref in _demoPatientRefs) {
      final deleted = await FhirResourceRecord.db.deleteWhere(
        session,
        where: (t) => t.patientReference.equals(ref),
      );
      total += deleted.length;
    }
    return total;
  }

  DateTime? _extractMetaLastUpdated(String jsonData) {
    try {
      final map = jsonDecode(jsonData);
      if (map is! Map) return null;
      final meta = map['meta'];
      if (meta is! Map) return null;
      final lu = meta['lastUpdated'];
      if (lu is String) return DateTime.tryParse(lu);
    } catch (_) {}
    return null;
  }
}
