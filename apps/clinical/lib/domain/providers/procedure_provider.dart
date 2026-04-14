import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/procedure_collection.dart';

/// Procedures for a given patient.
final proceduresByPatientProvider =
    Provider.family<List<ProcedureLocal>, String>((ref, patientRef) {
  final box = DatabaseService.procedures;
  return box.values
      .where((p) => p.patientRef == patientRef && p.syncStatus != 2)
      .toList()
    ..sort((a, b) => (b.performedDate ?? b.createdAt)
        .compareTo(a.performedDate ?? a.createdAt));
});

/// Procedures linked to a specific encounter.
final proceduresByEncounterProvider =
    Provider.family<List<ProcedureLocal>, String>((ref, encounterRef) {
  final box = DatabaseService.procedures;
  return box.values
      .where((p) => p.encounterRef == encounterRef && p.syncStatus != 2)
      .toList();
});
