import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class FhirInteropEndpoint extends Endpoint {
  /// FHIR CapabilityStatement — GET /fhir/metadata equivalent
  Future<Map<String, dynamic>> getCapabilityStatement(Session session) async {
    return {
      'resourceType': 'CapabilityStatement',
      'status': 'active',
      'date': DateTime.now().toIso8601String(),
      'publisher': 'Clinical Curator',
      'kind': 'instance',
      'software': {
        'name': 'Clinical Curator',
        'version': '1.0.0',
      },
      'fhirVersion': '4.0.1',
      'format': ['application/fhir+json'],
      'rest': [
        {
          'mode': 'server',
          'resource': [
            {
              'type': 'Patient',
              'interaction': [
                {'code': 'read'},
                {'code': 'create'},
                {'code': 'update'},
                {'code': 'search-type'},
              ],
            },
            {
              'type': 'Encounter',
              'interaction': [
                {'code': 'read'},
                {'code': 'create'},
                {'code': 'update'},
                {'code': 'search-type'},
              ],
            },
            {
              'type': 'Observation',
              'interaction': [
                {'code': 'read'},
                {'code': 'create'},
              ],
            },
            {
              'type': 'Condition',
              'interaction': [
                {'code': 'read'},
                {'code': 'create'},
              ],
            },
            {
              'type': 'MedicationRequest',
              'interaction': [
                {'code': 'read'},
                {'code': 'create'},
              ],
            },
            {
              'type': 'AllergyIntolerance',
              'interaction': [
                {'code': 'read'},
                {'code': 'create'},
              ],
            },
            {
              'type': 'Immunization',
              'interaction': [
                {'code': 'read'},
                {'code': 'create'},
              ],
            },
            {
              'type': 'DiagnosticReport',
              'interaction': [
                {'code': 'read'},
                {'code': 'create'},
              ],
            },
            {
              'type': 'Appointment',
              'interaction': [
                {'code': 'read'},
                {'code': 'create'},
                {'code': 'update'},
              ],
            },
            {
              'type': 'Schedule',
              'interaction': [
                {'code': 'read'},
                {'code': 'search-type'},
              ],
            },
            {
              'type': 'Slot',
              'interaction': [
                {'code': 'read'},
                {'code': 'search-type'},
              ],
            },
          ],
        },
      ],
    };
  }

  /// Search FHIR resources and return a FHIR Bundle wrapper.
  Future<Map<String, dynamic>> searchAsBundle(
    Session session,
    String resourceType, {
    String? patientRef,
    String? practitionerRef,
    int? limit,
    int? offset,
  }) async {
    List<FhirResourceRecord> results;

    if (patientRef != null && practitionerRef != null) {
      results = await FhirResourceRecord.db.find(
        session,
        where: (t) =>
            t.resourceType.equals(resourceType) & t.patientReference.equals(patientRef) & t.practitionerReference.equals(practitionerRef),
        orderBy: (t) => t.lastUpdated,
        orderDescending: true,
        limit: limit ?? 100,
        offset: offset ?? 0,
      );
    } else if (patientRef != null) {
      results = await FhirResourceRecord.db.find(
        session,
        where: (t) => t.resourceType.equals(resourceType) & t.patientReference.equals(patientRef),
        orderBy: (t) => t.lastUpdated,
        orderDescending: true,
        limit: limit ?? 100,
        offset: offset ?? 0,
      );
    } else if (practitionerRef != null) {
      results = await FhirResourceRecord.db.find(
        session,
        where: (t) => t.resourceType.equals(resourceType) & t.practitionerReference.equals(practitionerRef),
        orderBy: (t) => t.lastUpdated,
        orderDescending: true,
        limit: limit ?? 100,
        offset: offset ?? 0,
      );
    } else {
      results = await FhirResourceRecord.db.find(
        session,
        where: (t) => t.resourceType.equals(resourceType),
        orderBy: (t) => t.lastUpdated,
        orderDescending: true,
        limit: limit ?? 100,
        offset: offset ?? 0,
      );
    }

    final total = await FhirResourceRecord.db.count(
      session,
      where: (t) => t.resourceType.equals(resourceType),
    );

    return {
      'resourceType': 'Bundle',
      'type': 'searchset',
      'total': total,
      'entry': results.map((r) {
        final parsed = jsonDecode(r.jsonData) as Map<String, dynamic>;
        return {
          'fullUrl': '/fhir/$resourceType/${r.fhirId}',
          'resource': parsed,
        };
      }).toList(),
    };
  }

  /// Get a FHIR resource by fhirId and return wrapped in a Bundle.
  Future<Map<String, dynamic>?> readAsBundle(
    Session session,
    String fhirId,
    String resourceType,
  ) async {
    final results = await FhirResourceRecord.db.find(
      session,
      where: (t) => t.fhirId.equals(fhirId) & t.resourceType.equals(resourceType),
    );
    if (results.isEmpty) return null;
    final resource = results.first;
    final parsed = jsonDecode(resource.jsonData) as Map<String, dynamic>;
    return {
      'resourceType': 'Bundle',
      'type': 'searchset',
      'total': 1,
      'entry': [
        {
          'fullUrl': '/fhir/$resourceType/${resource.fhirId}',
          'resource': parsed,
        },
      ],
    };
  }
}
