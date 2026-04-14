import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/service_request_collection.dart';

/// Pending orders for a patient (active or draft).
final pendingOrdersProvider =
    Provider.family<List<ServiceRequestLocal>, String>((ref, patientRef) {
  final box = DatabaseService.serviceRequests;
  return box.values
      .where((sr) =>
          sr.patientRef == patientRef &&
          sr.syncStatus != 2 &&
          (sr.status == 'active' || sr.status == 'draft'))
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
});

/// Completed orders for a patient.
final completedOrdersProvider =
    Provider.family<List<ServiceRequestLocal>, String>((ref, patientRef) {
  final box = DatabaseService.serviceRequests;
  return box.values
      .where((sr) =>
          sr.patientRef == patientRef &&
          sr.syncStatus != 2 &&
          sr.status == 'completed')
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
});

/// Orders created by a specific practitioner.
final ordersByRequesterProvider =
    Provider.family<List<ServiceRequestLocal>, String>((ref, practRef) {
  final box = DatabaseService.serviceRequests;
  return box.values
      .where((sr) => sr.requesterRef == practRef && sr.syncStatus != 2)
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
});

/// Orders linked to a specific encounter.
final ordersByEncounterProvider =
    Provider.family<List<ServiceRequestLocal>, String>((ref, encounterRef) {
  final box = DatabaseService.serviceRequests;
  return box.values
      .where((sr) => sr.encounterRef == encounterRef && sr.syncStatus != 2)
      .toList();
});

/// Referral requests for a patient.
final referralsProvider =
    Provider.family<List<ServiceRequestLocal>, String>((ref, patientRef) {
  final box = DatabaseService.serviceRequests;
  return box.values
      .where((sr) =>
          sr.patientRef == patientRef &&
          sr.syncStatus != 2 &&
          sr.category == 'referral')
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
});
