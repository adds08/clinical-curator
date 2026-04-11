import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;

import '../../core/database/isar_service.dart';
import '../../data/collections/fhir_resource_collection.dart';

// ---------------------------------------------------------------------------
// Patient Vitals
// ---------------------------------------------------------------------------

/// Returns all Observation resources categorised as "vital-signs" for the
/// given patient reference (e.g. "Patient/patient-arjun").
final patientVitalsProvider =
    Provider.family<List<fhir.Observation>, String>((ref, patientRef) {
  final box = DatabaseService.fhirResources;
  final observations = <fhir.Observation>[];

  for (final r in box.values) {
    if (r.resourceType == 'Observation' &&
        r.patientReference == patientRef &&
        r.category == 'vital-signs') {
      try {
        final resource =
            fhir.Resource.fromJson(jsonDecode(r.jsonData) as Map<String, dynamic>);
        if (resource is fhir.Observation) {
          observations.add(resource);
        }
      } catch (_) {
        // Skip malformed entries.
      }
    }
  }

  return observations;
});

// ---------------------------------------------------------------------------
// All Patient Records (raw FhirResource objects)
// ---------------------------------------------------------------------------

/// Returns every [FhirResource] linked to the given patient – regardless of
/// resource type.
final patientRecordsProvider =
    Provider.family<List<FhirResource>, String>((ref, patientRef) {
  final box = DatabaseService.fhirResources;
  return box.values
      .where((r) => r.patientReference == patientRef)
      .toList();
});

// ---------------------------------------------------------------------------
// Patient Labs (DiagnosticReport)
// ---------------------------------------------------------------------------

/// Returns parsed [fhir.DiagnosticReport] resources for the given patient.
final patientLabsProvider =
    Provider.family<List<fhir.DiagnosticReport>, String>((ref, patientRef) {
  final box = DatabaseService.fhirResources;
  final reports = <fhir.DiagnosticReport>[];

  for (final r in box.values) {
    if (r.resourceType == 'DiagnosticReport' &&
        r.patientReference == patientRef) {
      try {
        final resource =
            fhir.Resource.fromJson(jsonDecode(r.jsonData) as Map<String, dynamic>);
        if (resource is fhir.DiagnosticReport) {
          reports.add(resource);
        }
      } catch (_) {
        // Skip malformed entries.
      }
    }
  }

  return reports;
});

// ---------------------------------------------------------------------------
// Patient Medications (MedicationRequest)
// ---------------------------------------------------------------------------

/// Returns parsed [fhir.MedicationRequest] resources for the given patient.
final patientMedicationsProvider =
    Provider.family<List<fhir.MedicationRequest>, String>((ref, patientRef) {
  final box = DatabaseService.fhirResources;
  final medications = <fhir.MedicationRequest>[];

  for (final r in box.values) {
    if (r.resourceType == 'MedicationRequest' &&
        r.patientReference == patientRef) {
      try {
        final resource =
            fhir.Resource.fromJson(jsonDecode(r.jsonData) as Map<String, dynamic>);
        if (resource is fhir.MedicationRequest) {
          medications.add(resource);
        }
      } catch (_) {
        // Skip malformed entries.
      }
    }
  }

  return medications;
});

// ---------------------------------------------------------------------------
// Patient Immunizations
// ---------------------------------------------------------------------------

/// Returns parsed [fhir.Immunization] resources for the given patient.
final patientImmunizationsProvider =
    Provider.family<List<fhir.Immunization>, String>((ref, patientRef) {
  final box = DatabaseService.fhirResources;
  final immunizations = <fhir.Immunization>[];

  for (final r in box.values) {
    if (r.resourceType == 'Immunization' &&
        r.patientReference == patientRef) {
      try {
        final resource =
            fhir.Resource.fromJson(jsonDecode(r.jsonData) as Map<String, dynamic>);
        if (resource is fhir.Immunization) {
          immunizations.add(resource);
        }
      } catch (_) {
        // Skip malformed entries.
      }
    }
  }

  return immunizations;
});

// ---------------------------------------------------------------------------
// Patient Allergies (AllergyIntolerance)
// ---------------------------------------------------------------------------

/// Returns parsed [fhir.AllergyIntolerance] resources for the given patient.
final patientAllergiesProvider =
    Provider.family<List<fhir.AllergyIntolerance>, String>((ref, patientRef) {
  final box = DatabaseService.fhirResources;
  final allergies = <fhir.AllergyIntolerance>[];

  for (final r in box.values) {
    if (r.resourceType == 'AllergyIntolerance' &&
        r.patientReference == patientRef) {
      try {
        final resource =
            fhir.Resource.fromJson(jsonDecode(r.jsonData) as Map<String, dynamic>);
        if (resource is fhir.AllergyIntolerance) {
          allergies.add(resource);
        }
      } catch (_) {
        // Skip malformed entries.
      }
    }
  }

  return allergies;
});

// ---------------------------------------------------------------------------
// Latest Heart Rate
// ---------------------------------------------------------------------------

/// Returns the most recent heart-rate value as a display string (e.g. "95")
/// for the given patient. Returns "--" when no data is found.
///
/// Heart rate is identified by LOINC code 8867-4.
final latestHeartRateProvider =
    Provider.family<String, String>((ref, patientRef) {
  final vitals = ref.watch(patientVitalsProvider(patientRef));

  // Filter to heart-rate observations (LOINC 8867-4).
  final heartRates = vitals.where((obs) {
    final codings = obs.code.coding;
    if (codings == null) return false;
    return codings.any((c) => c.code?.value == '8867-4');
  }).toList();

  if (heartRates.isEmpty) return '--';

  // Sort by effectiveDateTime descending to get the latest.
  heartRates.sort((a, b) {
    final aDate = a.effectiveDateTime?.value;
    final bDate = b.effectiveDateTime?.value;
    if (aDate == null && bDate == null) return 0;
    if (aDate == null) return 1;
    if (bDate == null) return -1;
    return bDate.compareTo(aDate);
  });

  final latest = heartRates.first;
  final value = latest.valueQuantity?.value?.value;
  if (value == null) return '--';

  // Return integer string when the value has no fractional part.
  return value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toString();
});

// ---------------------------------------------------------------------------
// Latest Blood Pressure
// ---------------------------------------------------------------------------

/// Returns the most recent blood-pressure reading as "systolic/diastolic"
/// (e.g. "120/80") for the given patient. Returns "--/--" when no data is
/// found.
///
/// Blood pressure is identified by LOINC code 85354-9.  Systolic and
/// diastolic values are extracted from the Observation's `component` list
/// using LOINC codes 8480-6 and 8462-4 respectively.
final latestBloodPressureProvider =
    Provider.family<String, String>((ref, patientRef) {
  final vitals = ref.watch(patientVitalsProvider(patientRef));

  // Filter to blood-pressure observations (LOINC 85354-9).
  final bpReadings = vitals.where((obs) {
    final codings = obs.code.coding;
    if (codings == null) return false;
    return codings.any((c) => c.code?.value == '85354-9');
  }).toList();

  if (bpReadings.isEmpty) return '--/--';

  // Sort by effectiveDateTime descending to get the latest.
  bpReadings.sort((a, b) {
    final aDate = a.effectiveDateTime?.value;
    final bDate = b.effectiveDateTime?.value;
    if (aDate == null && bDate == null) return 0;
    if (aDate == null) return 1;
    if (bDate == null) return -1;
    return bDate.compareTo(aDate);
  });

  final latest = bpReadings.first;
  final components = latest.component;
  if (components == null || components.isEmpty) return '--/--';

  String systolic = '--';
  String diastolic = '--';

  for (final comp in components) {
    final compCodings = comp.code.coding;
    if (compCodings == null) continue;

    final isSystolic = compCodings.any((c) => c.code?.value == '8480-6');
    final isDiastolic = compCodings.any((c) => c.code?.value == '8462-4');

    final val = comp.valueQuantity?.value?.value;
    if (val == null) continue;

    final display =
        val == val.roundToDouble() ? val.toInt().toString() : val.toString();

    if (isSystolic) systolic = display;
    if (isDiastolic) diastolic = display;
  }

  return '$systolic/$diastolic';
});
