import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/fhir_resource_collection.dart';

/// Refresh provider for patient chart data.
final patientChartRefreshProvider = StateProvider<int>((ref) => 0);

/// All FHIR resources for a given patient, grouped by type.
typedef PatientChartData = ({
  List<Map<String, dynamic>> vitals,
  List<Map<String, dynamic>> conditions,
  List<Map<String, dynamic>> medications,
  List<Map<String, dynamic>> encounters,
  List<Map<String, dynamic>> labs,
  List<Map<String, dynamic>> immunizations,
  List<Map<String, dynamic>> allergies,
  List<Map<String, dynamic>> reports,
});

final patientChartProvider = Provider.family<PatientChartData, String>((ref, patientId) {
  ref.watch(patientChartRefreshProvider);
  final box = DatabaseService.fhirResources;
  final resources = box.values.where((r) => r.patientReference == 'Patient/$patientId' && r.syncStatus != 2).toList();

  final vitals = <Map<String, dynamic>>[];
  final conditions = <Map<String, dynamic>>[];
  final medications = <Map<String, dynamic>>[];
  final encounters = <Map<String, dynamic>>[];
  final labs = <Map<String, dynamic>>[];
  final immunizations = <Map<String, dynamic>>[];
  final allergies = <Map<String, dynamic>>[];
  final reports = <Map<String, dynamic>>[];

  for (final r in resources) {
    try {
      final json = jsonDecode(r.jsonData) as Map<String, dynamic>;
      switch (r.resourceType) {
        case 'Observation':
          if (r.category == 'vital-signs') {
            vitals.add(json);
          } else if (r.category == 'laboratory') {
            labs.add(json);
          }
          break;
        case 'Condition':
          conditions.add(json);
          break;
        case 'MedicationRequest':
          medications.add(json);
          break;
        case 'Encounter':
          encounters.add(json);
          break;
        case 'Immunization':
          immunizations.add(json);
          break;
        case 'AllergyIntolerance':
          allergies.add(json);
          break;
        case 'DiagnosticReport':
          reports.add(json);
          break;
      }
    } catch (_) {
      // Skip malformed JSON
    }
  }

  // Sort encounters by date descending
  encounters.sort((a, b) {
    final aDate = _extractDate(a['period'] ?? a['effectiveDateTime']);
    final bDate = _extractDate(b['period'] ?? b['effectiveDateTime']);
    return bDate.compareTo(aDate);
  });

  return (
    vitals: vitals,
    conditions: conditions,
    medications: medications,
    encounters: encounters,
    labs: labs,
    immunizations: immunizations,
    allergies: allergies,
    reports: reports,
  );
});

DateTime _extractDate(dynamic periodOrDate) {
  try {
    if (periodOrDate is Map && periodOrDate.containsKey('start')) {
      return DateTime.parse(periodOrDate['start'] as String);
    }
    if (periodOrDate is String) {
      return DateTime.parse(periodOrDate);
    }
  } catch (_) {}
  return DateTime(2000);
}

/// Vitals time-series data for graphing.
final vitalsTimeSeriesProvider = Provider.family<List<FhirResource>, String>((ref, patientId) {
  ref.watch(patientChartRefreshProvider);
  final box = DatabaseService.fhirResources;
  return box.values.where((r) => r.patientReference == 'Patient/$patientId' && r.category == 'vital-signs' && r.syncStatus != 2).toList()
    ..sort((a, b) => a.lastUpdated.compareTo(b.lastUpdated));
});
