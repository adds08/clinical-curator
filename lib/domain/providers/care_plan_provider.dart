import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/isar_service.dart';
import '../../data/collections/care_plan_collection.dart';

/// Active care plans for a patient.
final activeCarePlansProvider =
    Provider.family<List<CarePlanLocal>, String>((ref, patientRef) {
  final box = DatabaseService.carePlans;
  return box.values
      .where((cp) =>
          cp.patientRef == patientRef &&
          cp.syncStatus != 2 &&
          cp.status == 'active')
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
});

/// All care plans for a patient.
final allCarePlansProvider =
    Provider.family<List<CarePlanLocal>, String>((ref, patientRef) {
  final box = DatabaseService.carePlans;
  return box.values
      .where((cp) => cp.patientRef == patientRef && cp.syncStatus != 2)
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
});

/// Single care plan by fhirId.
final carePlanDetailProvider =
    Provider.family<CarePlanLocal?, String>((ref, fhirId) {
  final box = DatabaseService.carePlans;
  try {
    return box.values.firstWhere((cp) => cp.fhirId == fhirId);
  } catch (_) {
    return null;
  }
});
