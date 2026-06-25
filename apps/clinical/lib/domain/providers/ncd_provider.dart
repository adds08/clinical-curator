import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/fhir_resource_collection.dart';

final ncdRefreshProvider = StateProvider<int>((ref) => 0);

final ncdConditionsProvider = Provider.family<List<FhirResource>, String>((ref, patientRef) {
  ref.watch(ncdRefreshProvider);
  final box = DatabaseService.fhirResources;
  return box.values.where((r) =>
    r.patientReference == patientRef &&
    r.resourceType == 'Condition' &&
    r.syncStatus != 2
  ).toList();
});

final ncdBpReadingsProvider = Provider.family<List<FhirResource>, String>((ref, patientRef) {
  ref.watch(ncdRefreshProvider);
  final box = DatabaseService.fhirResources;
  return box.values.where((r) =>
    r.patientReference == patientRef &&
    r.resourceType == 'Observation' &&
    r.category == 'vital-signs' &&
    r.syncStatus != 2
  ).toList()..sort((a, b) => a.lastUpdated.compareTo(b.lastUpdated));
});
