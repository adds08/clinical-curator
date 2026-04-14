import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/schedule_slot_collection.dart';

/// Available slots for a practitioner, optionally filtered by facility.
final availableSlotsProvider =
    Provider.family<List<ScheduleSlotLocal>, String>((ref, practitionerRef) {
  final box = DatabaseService.scheduleSlots;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return box.values
      .where((s) =>
          s.practitionerRef == practitionerRef &&
          s.status == 'available' &&
          !s.date.isBefore(today) &&
          s.bookedCount < s.maxPatients)
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));
});

/// Slots for a practitioner on a specific date.
final slotsByDateProvider =
    Provider.family<List<ScheduleSlotLocal>, ({String practitionerRef, DateTime date})>(
        (ref, params) {
  final box = DatabaseService.scheduleSlots;
  final dateOnly = DateTime(params.date.year, params.date.month, params.date.day);

  return box.values
      .where((s) =>
          s.practitionerRef == params.practitionerRef &&
          s.status == 'available' &&
          s.bookedCount < s.maxPatients &&
          DateTime(s.date.year, s.date.month, s.date.day) == dateOnly)
      .toList()
    ..sort((a, b) => a.startTime.compareTo(b.startTime));
});

/// Dates that have available slots for a practitioner (next 30 days).
final availableDatesProvider =
    Provider.family<Set<DateTime>, String>((ref, practitionerRef) {
  final slots = ref.watch(availableSlotsProvider(practitionerRef));
  return slots
      .map((s) => DateTime(s.date.year, s.date.month, s.date.day))
      .toSet();
});

/// Remaining capacity for a specific slot.
final slotRemainingProvider =
    Provider.family<int, int>((ref, hiveKey) {
  final box = DatabaseService.scheduleSlots;
  final slot = box.get(hiveKey);
  if (slot == null) return 0;
  return slot.maxPatients - slot.bookedCount;
});
