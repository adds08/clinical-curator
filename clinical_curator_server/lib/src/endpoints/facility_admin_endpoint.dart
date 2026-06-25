import 'package:serverpod/serverpod.dart';

import '../errors/app_exceptions.dart';
import '../generated/protocol.dart';

class FacilityAdminEndpoint extends Endpoint {
  /// Create a new facility.
  Future<Organization> createFacility(
    Session session,
    String name,
    String slug,
    String address,
  ) async {
    final org = Organization(
      name: name,
      type: 'hospital',
      address: address,
      hasEmergency: false,
      isOpen24Hours: false,
      createdAt: DateTime.now(),
    );
    return await Organization.db.insertRow(session, org);
  }

  /// Update facility details.
  Future<Organization> updateFacility(
    Session session,
    int id,
    String name,
    String address,
  ) async {
    final existing = await Organization.db.findById(session, id);
    if (existing == null) throw NotFoundException('Organization not found');
    final updated = existing.copyWith(name: name, address: address);
    return await Organization.db.updateRow(session, updated);
  }

  /// Delete a facility.
  Future<bool> deleteFacility(Session session, int id) async {
    final existing = await Organization.db.findById(session, id);
    if (existing == null) throw NotFoundException('Organization not found');
    await Organization.db.deleteRow(session, existing);
    return true;
  }

  /// List all facilities.
  Future<List<Organization>> listFacilities(Session session) async {
    return await Organization.db.find(session);
  }

  /// Get dashboard stats.
  Future<Map<String, int>> getDashboardStats(Session session) async {
    final patientCount = await FhirResourceRecord.db.count(
      session,
      where: (t) => t.resourceType.equals('Patient'),
    );
    final encounterCount = await FhirResourceRecord.db.count(
      session,
      where: (t) => t.resourceType.equals('Encounter'),
    );
    final conditionCount = await FhirResourceRecord.db.count(
      session,
      where: (t) => t.resourceType.equals('Condition'),
    );

    return {
      'totalPatients': patientCount,
      'totalEncounters': encounterCount,
      'totalConditions': conditionCount,
    };
  }

  /// Generate DHIS2-compatible export.
  Future<Map<String, dynamic>> exportToDHIS2(
    Session session,
  ) async {
    final patientCount = await FhirResourceRecord.db.count(
      session,
      where: (t) => t.resourceType.equals('Patient'),
    );
    final encounterCount = await FhirResourceRecord.db.count(
      session,
      where: (t) => t.resourceType.equals('Encounter'),
    );

    return {
      'dhis2Version': '2.4',
      'period': DateTime.now().toIso8601String(),
      'dataValues': [
        {'dataElement': 'PAT_TOTAL', 'value': patientCount},
        {'dataElement': 'ENC_TOTAL', 'value': encounterCount},
        {'dataElement': 'OPD_VISITS', 'value': encounterCount},
      ],
    };
  }
}
