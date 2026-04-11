import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/isar_service.dart';
import '../../data/collections/lab_booking_collection.dart';

class LabBookingState {
  final List<LabBookingLocal> bookings;
  final bool isLoading;
  final String? errorMessage;

  const LabBookingState({
    this.bookings = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  LabBookingState copyWith({
    List<LabBookingLocal>? bookings,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LabBookingState(
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class LabBookingNotifier extends StateNotifier<LabBookingState> {
  LabBookingNotifier() : super(const LabBookingState());

  Future<void> createBooking({
    required String patientRef,
    required String testsJson,
    required double totalPrice,
    DateTime? scheduledAt,
    String? labName,
    String? notes,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final box = DatabaseService.labBookings;
      final now = DateTime.now();

      final booking = LabBookingLocal()
        ..patientRef = patientRef
        ..testsJson = testsJson
        ..status = 'pending'
        ..totalPrice = totalPrice
        ..scheduledAt = scheduledAt
        ..labName = labName
        ..notes = notes
        ..createdAt = now
        ..syncStatus = 1;

      await box.add(booking);

      state = state.copyWith(
        isLoading: false,
        bookings: box.values.toList(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create lab booking: $e',
      );
    }
  }

  Future<void> updateStatus(int hiveKey, String newStatus) async {
    try {
      final box = DatabaseService.labBookings;
      final booking = box.get(hiveKey);
      if (booking == null) return;

      booking
        ..status = newStatus
        ..updatedAt = DateTime.now()
        ..syncStatus = 1;

      await booking.save();

      state = state.copyWith(bookings: box.values.toList());
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to update lab booking status: $e',
      );
    }
  }

  void listForPatient(String patientRef) {
    final box = DatabaseService.labBookings;
    final results = box.values
        .where((b) => b.patientRef == patientRef)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    state = state.copyWith(bookings: results);
  }
}

final labBookingProvider =
    StateNotifierProvider<LabBookingNotifier, LabBookingState>((ref) {
  return LabBookingNotifier();
});
