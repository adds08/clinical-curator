import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/appointment_collection.dart';

class AppointmentState {
  final List<AppointmentLocal> appointments;
  final bool isLoading;
  final String? errorMessage;

  const AppointmentState({
    this.appointments = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  AppointmentState copyWith({
    List<AppointmentLocal>? appointments,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AppointmentState(
      appointments: appointments ?? this.appointments,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AppointmentNotifier extends StateNotifier<AppointmentState> {
  AppointmentNotifier() : super(const AppointmentState());

  Future<void> bookAppointment({
    required String patientRef,
    required String practitionerRef,
    required String practitionerName,
    required String patientName,
    required String appointmentType,
    required DateTime scheduledAt,
    required int durationMinutes,
    String? specialty,
    String? notes,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final box = DatabaseService.appointments;
      final now = DateTime.now();

      final appointment = AppointmentLocal()
        ..patientRef = patientRef
        ..practitionerRef = practitionerRef
        ..practitionerName = practitionerName
        ..patientName = patientName
        ..appointmentType = appointmentType
        ..status = 'booked'
        ..scheduledAt = scheduledAt
        ..durationMinutes = durationMinutes
        ..specialty = specialty
        ..notes = notes
        ..createdAt = now
        ..syncStatus = 1;

      await box.add(appointment);

      state = state.copyWith(
        isLoading: false,
        appointments: box.values.toList(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to book appointment: $e',
      );
    }
  }

  Future<void> cancelAppointment(int hiveKey) async {
    try {
      final box = DatabaseService.appointments;
      final appointment = box.get(hiveKey);
      if (appointment == null) return;

      appointment
        ..status = 'cancelled'
        ..updatedAt = DateTime.now()
        ..syncStatus = 1;

      await appointment.save();

      state = state.copyWith(appointments: box.values.toList());
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to cancel appointment: $e',
      );
    }
  }

  Future<void> completeAppointment(int hiveKey) async {
    try {
      final box = DatabaseService.appointments;
      final appointment = box.get(hiveKey);
      if (appointment == null) return;

      appointment
        ..status = 'completed'
        ..updatedAt = DateTime.now()
        ..syncStatus = 1;

      await appointment.save();

      state = state.copyWith(appointments: box.values.toList());
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to complete appointment: $e',
      );
    }
  }

  void listForPatient(String patientRef) {
    final box = DatabaseService.appointments;
    final results = box.values
        .where((a) => a.patientRef == patientRef)
        .toList()
      ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));

    state = state.copyWith(appointments: results);
  }

  void listForPractitioner(String practitionerRef) {
    final box = DatabaseService.appointments;
    final results = box.values
        .where((a) => a.practitionerRef == practitionerRef)
        .toList()
      ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));

    state = state.copyWith(appointments: results);
  }

  void listTodayForPractitioner(String practitionerRef) {
    final box = DatabaseService.appointments;
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final results = box.values
        .where((a) =>
            a.practitionerRef == practitionerRef &&
            a.scheduledAt.isAfter(todayStart) &&
            a.scheduledAt.isBefore(todayEnd) &&
            a.status != 'cancelled')
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    state = state.copyWith(appointments: results);
  }
}

final appointmentProvider =
    StateNotifierProvider<AppointmentNotifier, AppointmentState>((ref) {
  return AppointmentNotifier();
});
