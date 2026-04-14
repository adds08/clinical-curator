import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cc_fhir_models/collections/practitioner_role_collection.dart';
import 'package:cc_fhir_models/collections/schedule_slot_collection.dart';

class BookingFlowState {
  final PractitionerRoleLocal? selectedDoctor;
  final String? selectedOrgRef;
  final String? selectedOrgName;
  final ScheduleSlotLocal? selectedSlot;
  final DateTime? selectedDate;
  final String? selectedTimeSlot;
  final String appointmentType;
  final String? reason;
  final String? prefilterSpecialty;
  final String? prefilterOrgRef;
  final bool isFromReferral;
  final String? referralServiceRequestId;

  const BookingFlowState({
    this.selectedDoctor,
    this.selectedOrgRef,
    this.selectedOrgName,
    this.selectedSlot,
    this.selectedDate,
    this.selectedTimeSlot,
    this.appointmentType = 'routine',
    this.reason,
    this.prefilterSpecialty,
    this.prefilterOrgRef,
    this.isFromReferral = false,
    this.referralServiceRequestId,
  });

  BookingFlowState copyWith({
    PractitionerRoleLocal? selectedDoctor,
    String? selectedOrgRef,
    String? selectedOrgName,
    ScheduleSlotLocal? selectedSlot,
    DateTime? selectedDate,
    String? selectedTimeSlot,
    String? appointmentType,
    String? reason,
    String? prefilterSpecialty,
    String? prefilterOrgRef,
    bool? isFromReferral,
    String? referralServiceRequestId,
    bool clearDoctor = false,
    bool clearSlot = false,
    bool clearDate = false,
    bool clearTime = false,
    bool clearOrg = false,
  }) {
    return BookingFlowState(
      selectedDoctor: clearDoctor ? null : (selectedDoctor ?? this.selectedDoctor),
      selectedOrgRef: clearOrg ? null : (selectedOrgRef ?? this.selectedOrgRef),
      selectedOrgName: clearOrg ? null : (selectedOrgName ?? this.selectedOrgName),
      selectedSlot: clearSlot ? null : (selectedSlot ?? this.selectedSlot),
      selectedDate: clearDate ? null : (selectedDate ?? this.selectedDate),
      selectedTimeSlot: clearTime ? null : (selectedTimeSlot ?? this.selectedTimeSlot),
      appointmentType: appointmentType ?? this.appointmentType,
      reason: reason ?? this.reason,
      prefilterSpecialty: prefilterSpecialty ?? this.prefilterSpecialty,
      prefilterOrgRef: prefilterOrgRef ?? this.prefilterOrgRef,
      isFromReferral: isFromReferral ?? this.isFromReferral,
      referralServiceRequestId: referralServiceRequestId ?? this.referralServiceRequestId,
    );
  }
}

class BookingFlowNotifier extends StateNotifier<BookingFlowState> {
  BookingFlowNotifier() : super(const BookingFlowState());

  void selectDoctor(PractitionerRoleLocal doctor) {
    state = state.copyWith(
      selectedDoctor: doctor,
      clearSlot: true,
      clearDate: true,
      clearTime: true,
    );
  }

  void selectOrganization(String orgRef, String orgName) {
    state = state.copyWith(
      selectedOrgRef: orgRef,
      selectedOrgName: orgName,
      clearSlot: true,
      clearDate: true,
      clearTime: true,
    );
  }

  void selectSlot(ScheduleSlotLocal slot, DateTime date, String timeSlot) {
    state = state.copyWith(
      selectedSlot: slot,
      selectedDate: date,
      selectedTimeSlot: timeSlot,
    );
  }

  void setReason(String reason) {
    state = state.copyWith(reason: reason);
  }

  void setAppointmentType(String type) {
    state = state.copyWith(appointmentType: type);
  }

  void setPrefilters({String? specialty, String? orgRef}) {
    state = state.copyWith(
      prefilterSpecialty: specialty,
      prefilterOrgRef: orgRef,
    );
  }

  void setReferralContext(String serviceRequestId) {
    state = state.copyWith(
      isFromReferral: true,
      referralServiceRequestId: serviceRequestId,
    );
  }

  void reset() {
    state = const BookingFlowState();
  }
}

final bookingFlowProvider =
    StateNotifierProvider<BookingFlowNotifier, BookingFlowState>((ref) {
  return BookingFlowNotifier();
});
