import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class PhrEndpoint extends Endpoint {
  Future<Map<String, dynamic>> getSummary(Session session, String patientRef) async {
    final resources = await FhirResourceRecord.db.find(
      session,
      where: (t) => t.patientReference.equals(patientRef),
      orderBy: (t) => t.lastUpdated,
      orderDescending: true,
      limit: 100,
    );

    final conditions = <Map<String, dynamic>>[];
    final medications = <Map<String, dynamic>>[];
    final allergies = <Map<String, dynamic>>[];
    final vitals = <Map<String, dynamic>>[];
    final encounters = <Map<String, dynamic>>[];

    for (final r in resources) {
      try {
        final json = jsonDecode(r.jsonData) as Map<String, dynamic>;
        switch (r.resourceType) {
          case 'Condition': conditions.add(json); break;
          case 'MedicationRequest': medications.add(json); break;
          case 'AllergyIntolerance': allergies.add(json); break;
          case 'Observation':
            if (r.category == 'vital-signs') vitals.add(json);
            break;
          case 'Encounter': encounters.add(json); break;
        }
      } catch (_) {}
    }

    return {
      'patientRef': patientRef,
      'activeConditions': conditions.where((c) {
        final s = c['clinicalStatus']?['coding']?.first?['code'];
        return s == 'active' || s == null;
      }).toList(),
      'activeMedications': medications.where((m) => m['status'] == 'active').toList(),
      'allergies': allergies,
      'latestVitals': vitals.take(10).toList(),
      'recentEncounters': encounters.take(5).toList(),
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  Future<List<Map<String, dynamic>>> getVitals(Session session, String patientRef) async {
    final resources = await FhirResourceRecord.db.find(
      session,
      where: (t) => t.patientReference.equals(patientRef) & t.category.equals('vital-signs'),
      orderBy: (t) => t.lastUpdated,
      orderDescending: true,
    );
    return resources.map((r) {
      try { return jsonDecode(r.jsonData) as Map<String, dynamic>; } catch (_) { return <String, dynamic>{}; }
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getRecords(Session session, String patientRef, {String? resourceType}) async {
    List<FhirResourceRecord> resources;
    if (resourceType != null) {
      resources = await FhirResourceRecord.db.find(
        session,
        where: (t) => t.patientReference.equals(patientRef) & t.resourceType.equals(resourceType),
        orderBy: (t) => t.lastUpdated,
        orderDescending: true,
      );
    } else {
      resources = await FhirResourceRecord.db.find(
        session,
        where: (t) => t.patientReference.equals(patientRef),
        orderBy: (t) => t.lastUpdated,
        orderDescending: true,
      );
    }
    return resources.map((r) {
      try { return jsonDecode(r.jsonData) as Map<String, dynamic>; } catch (_) { return <String, dynamic>{}; }
    }).toList();
  }
}
