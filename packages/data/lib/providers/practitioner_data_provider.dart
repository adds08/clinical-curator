import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;

import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/appointment_collection.dart';
import 'package:cc_fhir_models/collections/schedule_slot_collection.dart';
import 'package:cc_fhir_models/collections/user_account_collection.dart';

// ---------------------------------------------------------------------------
// Refresh triggers — invalidate these to force providers to re-read Hive
// ---------------------------------------------------------------------------

/// Bump this to force patient-related providers to re-read from Hive.
final patientRefreshProvider = StateProvider<int>((ref) => 0);

/// Bump this to force appointment-related providers to re-read from Hive.
final appointmentRefreshProvider = StateProvider<int>((ref) => 0);

/// Bump this to force schedule slot providers to re-read from Hive.
final slotRefreshProvider = StateProvider<int>((ref) => 0);

// ---------------------------------------------------------------------------
// All Patients (doctor / practitioner view)
// ---------------------------------------------------------------------------

final allPatientsProvider = Provider<List<fhir.Patient>>((ref) {
  ref.watch(patientRefreshProvider); // re-evaluate when bumped
  final box = DatabaseService.fhirResources;
  final patients = <fhir.Patient>[];

  for (final r in box.values) {
    if (r.resourceType == 'Patient') {
      try {
        final resource = fhir.Resource.fromJson(jsonDecode(r.jsonData) as Map<String, dynamic>);
        if (resource is fhir.Patient) {
          patients.add(resource);
        }
      } catch (_) {}
    }
  }

  return patients;
});

// ---------------------------------------------------------------------------
// Patient Count
// ---------------------------------------------------------------------------

final patientCountProvider = Provider<int>((ref) {
  final patients = ref.watch(allPatientsProvider);
  return patients.length;
});

// ---------------------------------------------------------------------------
// Appointments for a Practitioner
// ---------------------------------------------------------------------------

/// All appointments for a given practitioner reference.
final practitionerAppointmentsProvider = Provider.family<List<AppointmentLocal>, String>((ref, practitionerRef) {
  ref.watch(appointmentRefreshProvider);
  final box = DatabaseService.appointments;
  final fullRef = practitionerRef.startsWith('Practitioner/') ? practitionerRef : 'Practitioner/$practitionerRef';
  return box.values.where((a) => a.practitionerRef == fullRef).toList()..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
});

/// Today's appointments for a practitioner, sorted by time.
final todayAppointmentsProvider = Provider.family<List<AppointmentLocal>, String>((ref, practitionerRef) {
  final all = ref.watch(practitionerAppointmentsProvider(practitionerRef));
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);
  final todayEnd = todayStart.add(const Duration(days: 1));
  return all.where((a) => !a.scheduledAt.isBefore(todayStart) && a.scheduledAt.isBefore(todayEnd)).toList();
});

/// Today's OPD (outpatient) appointments for a practitioner.
final todayOpdProvider = Provider.family<List<AppointmentLocal>, String>((ref, practitionerRef) {
  final today = ref.watch(todayAppointmentsProvider(practitionerRef));
  return today.where((a) => a.appointmentType == 'opd').toList();
});

// ---------------------------------------------------------------------------
// Schedule Slots for a Practitioner
// ---------------------------------------------------------------------------

final practitionerSlotsProvider = Provider.family<List<ScheduleSlotLocal>, String>((ref, practitionerRef) {
  ref.watch(slotRefreshProvider); // re-evaluate when bumped
  final box = DatabaseService.scheduleSlots;
  final fullRef = practitionerRef.startsWith('Practitioner/') ? practitionerRef : 'Practitioner/$practitionerRef';
  return box.values.where((s) => s.practitionerRef == fullRef).toList()..sort((a, b) => a.date.compareTo(b.date));
});

// ---------------------------------------------------------------------------
// Pending Practitioner Verifications
// ---------------------------------------------------------------------------

final pendingVerificationsProvider = Provider<List<UserAccount>>((ref) {
  final box = DatabaseService.userAccounts;
  return box.values.where((a) => a.isPractitioner && !a.isVerified).toList();
});
