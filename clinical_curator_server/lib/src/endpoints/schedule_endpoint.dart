import 'package:serverpod/serverpod.dart';

import '../errors/app_exceptions.dart';
import '../generated/protocol.dart';

class ScheduleEndpoint extends Endpoint {
  /// Create a new schedule slot.
  Future<ScheduleSlot> createSlot(Session session, ScheduleSlot slot) async {
    final record = slot.copyWith(
      bookedCount: 0,
      status: 'available',
      createdAt: DateTime.now(),
    );
    return await ScheduleSlot.db.insertRow(session, record);
  }

  /// Update a schedule slot.
  Future<ScheduleSlot> updateSlot(Session session, ScheduleSlot slot) async {
    final updated = slot.copyWith(updatedAt: DateTime.now());
    return await ScheduleSlot.db.updateRow(session, updated);
  }

  /// Delete a schedule slot.
  Future<void> deleteSlot(Session session, int id) async {
    await ScheduleSlot.db.deleteWhere(
      session,
      where: (t) => t.id.equals(id),
    );
  }

  /// List schedule slots for a practitioner.
  Future<List<ScheduleSlot>> listSlots(
    Session session,
    String practitionerRef,
  ) async {
    return await ScheduleSlot.db.find(
      session,
      where: (t) => t.practitionerRef.equals(practitionerRef),
      orderBy: (t) => t.date,
    );
  }

  /// List available slots for a practitioner on a given date.
  Future<List<ScheduleSlot>> listAvailableSlots(
    Session session,
    String practitionerRef,
    DateTime date,
  ) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return await ScheduleSlot.db.find(
      session,
      where: (t) =>
          t.practitionerRef.equals(practitionerRef) &
          (t.date >= startOfDay) &
          (t.date < endOfDay) &
          t.status.equals('available'),
      orderBy: (t) => t.date,
    );
  }

  /// Increment booked count for a slot.
  Future<ScheduleSlot> bookSlot(Session session, int slotId) async {
    final slot = await ScheduleSlot.db.findById(session, slotId);
    if (slot == null) throw NotFoundException('Slot not found.');
    if (slot.bookedCount >= slot.maxPatients) {
      throw ConflictException('Slot is full.');
    }

    final updated = slot.copyWith(
      bookedCount: slot.bookedCount + 1,
      status:
          slot.bookedCount + 1 >= slot.maxPatients ? 'fully_booked' : 'available',
      updatedAt: DateTime.now(),
    );
    return await ScheduleSlot.db.updateRow(session, updated);
  }
}
