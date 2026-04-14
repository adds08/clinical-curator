import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/schedule_slot_collection.dart';

class ScheduleState {
  final List<ScheduleSlotLocal> slots;
  final bool isLoading;
  final String? errorMessage;

  const ScheduleState({
    this.slots = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ScheduleState copyWith({
    List<ScheduleSlotLocal>? slots,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ScheduleState(
      slots: slots ?? this.slots,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class ScheduleNotifier extends StateNotifier<ScheduleState> {
  ScheduleNotifier() : super(const ScheduleState());

  Future<void> createSlot({
    required String practitionerRef,
    required DateTime date,
    required String startTime,
    required String endTime,
    required int slotDurationMinutes,
    required int maxPatients,
    String? facilityName,
    bool isEmergencyOverride = false,
    bool isTelehealth = false,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final box = DatabaseService.scheduleSlots;
      final now = DateTime.now();

      final slot = ScheduleSlotLocal()
        ..practitionerRef = practitionerRef
        ..date = date
        ..startTime = startTime
        ..endTime = endTime
        ..slotDurationMinutes = slotDurationMinutes
        ..maxPatients = maxPatients
        ..bookedCount = 0
        ..facilityName = facilityName
        ..isEmergencyOverride = isEmergencyOverride
        ..isTelehealth = isTelehealth
        ..status = 'available'
        ..createdAt = now
        ..syncStatus = 1;

      await box.add(slot);

      state = state.copyWith(
        isLoading: false,
        slots: box.values.toList(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create schedule slot: $e',
      );
    }
  }

  Future<void> updateSlot(
    int hiveKey, {
    String? startTime,
    String? endTime,
    int? slotDurationMinutes,
    int? maxPatients,
    String? facilityName,
    bool? isEmergencyOverride,
    bool? isTelehealth,
    String? status,
  }) async {
    try {
      final box = DatabaseService.scheduleSlots;
      final slot = box.get(hiveKey);
      if (slot == null) return;

      if (startTime != null) slot.startTime = startTime;
      if (endTime != null) slot.endTime = endTime;
      if (slotDurationMinutes != null) {
        slot.slotDurationMinutes = slotDurationMinutes;
      }
      if (maxPatients != null) slot.maxPatients = maxPatients;
      if (facilityName != null) slot.facilityName = facilityName;
      if (isEmergencyOverride != null) {
        slot.isEmergencyOverride = isEmergencyOverride;
      }
      if (isTelehealth != null) slot.isTelehealth = isTelehealth;
      if (status != null) slot.status = status;

      slot
        ..updatedAt = DateTime.now()
        ..syncStatus = 1;

      await slot.save();

      state = state.copyWith(slots: box.values.toList());
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to update schedule slot: $e',
      );
    }
  }

  Future<void> deleteSlot(int hiveKey) async {
    try {
      final box = DatabaseService.scheduleSlots;
      await box.delete(hiveKey);
      state = state.copyWith(slots: box.values.toList());
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to delete schedule slot: $e',
      );
    }
  }

  void listSlots(String practitionerRef) {
    final box = DatabaseService.scheduleSlots;
    final results = box.values
        .where((s) => s.practitionerRef == practitionerRef)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    state = state.copyWith(slots: results);
  }

  void listAvailableSlots(String practitionerRef) {
    final box = DatabaseService.scheduleSlots;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final results = box.values
        .where((s) =>
            s.practitionerRef == practitionerRef &&
            s.status == 'available' &&
            !s.date.isBefore(today) &&
            s.bookedCount < s.maxPatients)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    state = state.copyWith(slots: results);
  }

  Future<void> bookSlot(int hiveKey) async {
    try {
      final box = DatabaseService.scheduleSlots;
      final slot = box.get(hiveKey);
      if (slot == null) return;

      if (slot.bookedCount >= slot.maxPatients) {
        state = state.copyWith(errorMessage: 'Slot is fully booked.');
        return;
      }

      slot
        ..bookedCount = slot.bookedCount + 1
        ..updatedAt = DateTime.now()
        ..syncStatus = 1;

      if (slot.bookedCount >= slot.maxPatients) {
        slot.status = 'full';
      }

      await slot.save();

      state = state.copyWith(slots: box.values.toList());
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to book slot: $e',
      );
    }
  }
}

final scheduleProvider =
    StateNotifierProvider<ScheduleNotifier, ScheduleState>((ref) {
  return ScheduleNotifier();
});
