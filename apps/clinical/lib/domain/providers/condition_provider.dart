import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/condition_collection.dart';

/// Active conditions (problem list) for a patient.
final activeConditionsProvider =
    Provider.family<List<ConditionLocal>, String>((ref, patientRef) {
  final box = DatabaseService.conditions;
  return box.values
      .where((c) =>
          c.patientRef == patientRef &&
          c.syncStatus != 2 &&
          (c.clinicalStatus == 'active' ||
              c.clinicalStatus == 'recurrence' ||
              c.clinicalStatus == 'relapse'))
      .toList()
    ..sort((a, b) => b.recordedDate.compareTo(a.recordedDate));
});

/// Resolved conditions for a patient.
final resolvedConditionsProvider =
    Provider.family<List<ConditionLocal>, String>((ref, patientRef) {
  final box = DatabaseService.conditions;
  return box.values
      .where((c) =>
          c.patientRef == patientRef &&
          c.syncStatus != 2 &&
          (c.clinicalStatus == 'resolved' ||
              c.clinicalStatus == 'remission' ||
              c.clinicalStatus == 'inactive'))
      .toList()
    ..sort((a, b) => b.recordedDate.compareTo(a.recordedDate));
});

/// All conditions for a patient (active + resolved).
final allConditionsProvider =
    Provider.family<List<ConditionLocal>, String>((ref, patientRef) {
  final box = DatabaseService.conditions;
  return box.values
      .where((c) => c.patientRef == patientRef && c.syncStatus != 2)
      .toList()
    ..sort((a, b) => b.recordedDate.compareTo(a.recordedDate));
});
