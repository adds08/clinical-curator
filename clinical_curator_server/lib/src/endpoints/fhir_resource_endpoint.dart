import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class FhirResourceEndpoint extends Endpoint {
  /// Create a new FHIR resource record.
  Future<FhirResourceRecord> create(
    Session session,
    FhirResourceRecord resource,
  ) async {
    final now = DateTime.now();
    final record = resource.copyWith(
      syncVersion: 1,
      lastUpdated: now,
      createdAt: now,
    );
    return await FhirResourceRecord.db.insertRow(session, record);
  }

  /// Read a single FHIR resource by fhirId and resourceType.
  Future<FhirResourceRecord?> read(
    Session session,
    String fhirId,
    String resourceType,
  ) async {
    final results = await FhirResourceRecord.db.find(
      session,
      where: (t) =>
          t.fhirId.equals(fhirId) & t.resourceType.equals(resourceType),
    );
    return results.isEmpty ? null : results.first;
  }

  /// Update an existing FHIR resource (matched by fhirId + resourceType).
  Future<FhirResourceRecord> update(
    Session session,
    FhirResourceRecord resource,
  ) async {
    final updated = resource.copyWith(
      syncVersion: resource.syncVersion + 1,
      lastUpdated: DateTime.now(),
    );
    return await FhirResourceRecord.db.updateRow(session, updated);
  }

  /// Delete a FHIR resource by its database ID.
  Future<void> deleteById(Session session, int id) async {
    await FhirResourceRecord.db.deleteWhere(
      session,
      where: (t) => t.id.equals(id),
    );
  }

  /// Search FHIR resources by resource type.
  Future<List<FhirResourceRecord>> searchByType(
    Session session,
    String resourceType, {
    int? limit,
    int? offset,
  }) async {
    return await FhirResourceRecord.db.find(
      session,
      where: (t) => t.resourceType.equals(resourceType),
      orderBy: (t) => t.lastUpdated,
      orderDescending: true,
      limit: limit ?? 100,
      offset: offset ?? 0,
    );
  }

  /// Search FHIR resources by patient reference.
  Future<List<FhirResourceRecord>> searchByPatient(
    Session session,
    String patientReference, {
    String? resourceType,
    int? limit,
  }) async {
    if (resourceType != null) {
      return await FhirResourceRecord.db.find(
        session,
        where: (t) =>
            t.patientReference.equals(patientReference) &
            t.resourceType.equals(resourceType),
        orderBy: (t) => t.lastUpdated,
        orderDescending: true,
        limit: limit ?? 100,
      );
    }
    return await FhirResourceRecord.db.find(
      session,
      where: (t) => t.patientReference.equals(patientReference),
      orderBy: (t) => t.lastUpdated,
      orderDescending: true,
      limit: limit ?? 100,
    );
  }

  /// Search FHIR resources by practitioner reference.
  Future<List<FhirResourceRecord>> searchByPractitioner(
    Session session,
    String practitionerReference, {
    String? resourceType,
    int? limit,
  }) async {
    if (resourceType != null) {
      return await FhirResourceRecord.db.find(
        session,
        where: (t) =>
            t.practitionerReference.equals(practitionerReference) &
            t.resourceType.equals(resourceType),
        orderBy: (t) => t.lastUpdated,
        orderDescending: true,
        limit: limit ?? 100,
      );
    }
    return await FhirResourceRecord.db.find(
      session,
      where: (t) => t.practitionerReference.equals(practitionerReference),
      orderBy: (t) => t.lastUpdated,
      orderDescending: true,
      limit: limit ?? 100,
    );
  }

  /// Get all resources modified after a given timestamp (for sync).
  Future<List<FhirResourceRecord>> getChangesSince(
    Session session,
    DateTime since,
  ) async {
    return await FhirResourceRecord.db.find(
      session,
      where: (t) => t.lastUpdated > since,
      orderBy: (t) => t.lastUpdated,
    );
  }
}
