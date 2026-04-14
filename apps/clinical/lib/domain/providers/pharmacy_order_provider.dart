import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/pharmacy_order_collection.dart';

class PharmacyOrderState {
  final List<PharmacyOrderLocal> orders;
  final bool isLoading;
  final String? errorMessage;

  const PharmacyOrderState({
    this.orders = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  PharmacyOrderState copyWith({
    List<PharmacyOrderLocal>? orders,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PharmacyOrderState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class PharmacyOrderNotifier extends StateNotifier<PharmacyOrderState> {
  PharmacyOrderNotifier() : super(const PharmacyOrderState());

  Future<void> createOrder({
    required String patientRef,
    required String pharmacyName,
    required String itemsJson,
    required double totalPrice,
    String? deliveryAddress,
    String? notes,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final box = DatabaseService.pharmacyOrders;
      final now = DateTime.now();

      final order = PharmacyOrderLocal()
        ..patientRef = patientRef
        ..pharmacyName = pharmacyName
        ..itemsJson = itemsJson
        ..status = 'pending'
        ..totalPrice = totalPrice
        ..deliveryAddress = deliveryAddress
        ..notes = notes
        ..createdAt = now
        ..syncStatus = 1;

      await box.add(order);

      state = state.copyWith(
        isLoading: false,
        orders: box.values.toList(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create pharmacy order: $e',
      );
    }
  }

  Future<void> updateStatus(int hiveKey, String newStatus) async {
    try {
      final box = DatabaseService.pharmacyOrders;
      final order = box.get(hiveKey);
      if (order == null) return;

      order
        ..status = newStatus
        ..updatedAt = DateTime.now()
        ..syncStatus = 1;

      await order.save();

      state = state.copyWith(orders: box.values.toList());
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to update pharmacy order status: $e',
      );
    }
  }

  void listForPatient(String patientRef) {
    final box = DatabaseService.pharmacyOrders;
    final results = box.values
        .where((o) => o.patientRef == patientRef)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    state = state.copyWith(orders: results);
  }
}

final pharmacyOrderProvider =
    StateNotifierProvider<PharmacyOrderNotifier, PharmacyOrderState>((ref) {
  return PharmacyOrderNotifier();
});
