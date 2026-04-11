import 'package:serverpod/serverpod.dart';

import '../errors/app_exceptions.dart';
import '../generated/protocol.dart';

class LabBookingEndpoint extends Endpoint {
  /// Create a lab booking.
  Future<LabBooking> create(Session session, LabBooking booking) async {
    final record = booking.copyWith(
      status: 'booked',
      createdAt: DateTime.now(),
    );
    return await LabBooking.db.insertRow(session, record);
  }

  /// List bookings for a patient.
  Future<List<LabBooking>> listForPatient(
    Session session,
    String patientRef,
  ) async {
    return await LabBooking.db.find(
      session,
      where: (t) => t.patientRef.equals(patientRef),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Update booking status.
  Future<LabBooking> updateStatus(
    Session session,
    int id,
    String status,
  ) async {
    final booking = await LabBooking.db.findById(session, id);
    if (booking == null) throw NotFoundException('Booking not found.');
    final updated = booking.copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );
    return await LabBooking.db.updateRow(session, updated);
  }

  /// Get booking by ID.
  Future<LabBooking?> getById(Session session, int id) async {
    return await LabBooking.db.findById(session, id);
  }
}
