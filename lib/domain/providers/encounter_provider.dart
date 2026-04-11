import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/isar_service.dart';
import '../../data/collections/encounter_collection.dart';

/// All encounters for a given patient reference.
final encountersByPatientProvider =
    Provider.family<List<EncounterLocal>, String>((ref, patientRef) {
  final box = DatabaseService.encounters;
  return box.values
      .where((e) => e.patientRef == patientRef && e.syncStatus != 2)
      .toList()
    ..sort((a, b) => b.startDate.compareTo(a.startDate));
});

/// All encounters for a given practitioner reference.
final encountersByPractitionerProvider =
    Provider.family<List<EncounterLocal>, String>((ref, practRef) {
  final box = DatabaseService.encounters;
  return box.values
      .where((e) => e.practitionerRef == practRef && e.syncStatus != 2)
      .toList()
    ..sort((a, b) => b.startDate.compareTo(a.startDate));
});

/// Currently active (in-progress) encounter, if any.
final activeEncounterProvider = Provider<EncounterLocal?>((ref) {
  final box = DatabaseService.encounters;
  try {
    return box.values.firstWhere(
      (e) => e.status == 'in-progress' && e.syncStatus != 2,
    );
  } catch (_) {
    return null;
  }
});

/// Today's encounters for a practitioner.
final todayEncountersProvider =
    Provider.family<List<EncounterLocal>, String>((ref, practRef) {
  final box = DatabaseService.encounters;
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);
  final todayEnd = todayStart.add(const Duration(days: 1));
  return box.values
      .where((e) =>
          e.practitionerRef == practRef &&
          e.syncStatus != 2 &&
          e.startDate.isAfter(todayStart) &&
          e.startDate.isBefore(todayEnd))
      .toList()
    ..sort((a, b) => a.startDate.compareTo(b.startDate));
});
