import 'package:serverpod/serverpod.dart';

import '../errors/app_exceptions.dart';
import '../generated/protocol.dart';

class AppointmentEndpoint extends Endpoint {
  /// Book a new appointment.
  Future<Appointment> book(Session session, Appointment appointment) async {
    final now = DateTime.now();
    final record = appointment.copyWith(
      status: 'booked',
      createdAt: now,
    );
    return await Appointment.db.insertRow(session, record);
  }

  /// Cancel an appointment by ID.
  Future<Appointment> cancel(Session session, int id) async {
    final appointment = await Appointment.db.findById(session, id);
    if (appointment == null) throw NotFoundException('Appointment not found.');
    final updated = appointment.copyWith(
      status: 'cancelled',
      updatedAt: DateTime.now(),
    );
    return await Appointment.db.updateRow(session, updated);
  }

  /// Complete an appointment.
  Future<Appointment> complete(Session session, int id) async {
    final appointment = await Appointment.db.findById(session, id);
    if (appointment == null) throw NotFoundException('Appointment not found.');
    final updated = appointment.copyWith(
      status: 'completed',
      updatedAt: DateTime.now(),
    );
    return await Appointment.db.updateRow(session, updated);
  }

  /// List appointments for a patient.
  Future<List<Appointment>> listForPatient(
    Session session,
    String patientRef,
  ) async {
    return await Appointment.db.find(
      session,
      where: (t) => t.patientRef.equals(patientRef),
      orderBy: (t) => t.scheduledAt,
      orderDescending: true,
    );
  }

  /// List appointments for a practitioner.
  Future<List<Appointment>> listForPractitioner(
    Session session,
    String practitionerRef,
  ) async {
    return await Appointment.db.find(
      session,
      where: (t) => t.practitionerRef.equals(practitionerRef),
      orderBy: (t) => t.scheduledAt,
      orderDescending: true,
    );
  }

  /// List today's appointments for a practitioner.
  Future<List<Appointment>> listTodayForPractitioner(
    Session session,
    String practitionerRef,
  ) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return await Appointment.db.find(
      session,
      where: (t) =>
          t.practitionerRef.equals(practitionerRef) &
          (t.scheduledAt >= startOfDay) &
          (t.scheduledAt < endOfDay),
      orderBy: (t) => t.scheduledAt,
    );
  }

  /// Get appointment by ID.
  Future<Appointment?> getById(Session session, int id) async {
    return await Appointment.db.findById(session, id);
  }
}
