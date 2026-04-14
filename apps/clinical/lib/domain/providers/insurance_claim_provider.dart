import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/insurance_claim_collection.dart';

class InsuranceClaimState {
  final List<InsuranceClaimLocal> claims;
  final bool isLoading;
  final String? errorMessage;

  const InsuranceClaimState({
    this.claims = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  InsuranceClaimState copyWith({
    List<InsuranceClaimLocal>? claims,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return InsuranceClaimState(
      claims: claims ?? this.claims,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class InsuranceClaimNotifier extends StateNotifier<InsuranceClaimState> {
  InsuranceClaimNotifier() : super(const InsuranceClaimState());

  Future<void> submitClaim({
    required String patientRef,
    required String claimType,
    required String provider,
    required String policyNumber,
    required double amount,
    String? description,
    String? documentsJson,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final box = DatabaseService.insuranceClaims;
      final now = DateTime.now();

      final claim = InsuranceClaimLocal()
        ..patientRef = patientRef
        ..claimType = claimType
        ..provider = provider
        ..policyNumber = policyNumber
        ..amount = amount
        ..status = 'submitted'
        ..description = description
        ..documentsJson = documentsJson
        ..createdAt = now
        ..syncStatus = 1;

      await box.add(claim);

      state = state.copyWith(
        isLoading: false,
        claims: box.values.toList(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to submit insurance claim: $e',
      );
    }
  }

  Future<void> updateStatus(int hiveKey, String newStatus) async {
    try {
      final box = DatabaseService.insuranceClaims;
      final claim = box.get(hiveKey);
      if (claim == null) return;

      claim
        ..status = newStatus
        ..updatedAt = DateTime.now()
        ..syncStatus = 1;

      await claim.save();

      state = state.copyWith(claims: box.values.toList());
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to update insurance claim status: $e',
      );
    }
  }

  void listForPatient(String patientRef) {
    final box = DatabaseService.insuranceClaims;
    final results = box.values
        .where((c) => c.patientRef == patientRef)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    state = state.copyWith(claims: results);
  }
}

final insuranceClaimProvider =
    StateNotifierProvider<InsuranceClaimNotifier, InsuranceClaimState>((ref) {
  return InsuranceClaimNotifier();
});
