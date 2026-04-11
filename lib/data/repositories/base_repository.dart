import 'dart:convert';

import 'package:fhir/r4.dart' as fhir;

import '../../core/database/isar_service.dart';
import '../collections/fhir_resource_collection.dart';

/// Base repository for FHIR resource CRUD operations.
/// Uses Hive as the primary local store with sync status tracking.
/// When a Serverpod backend is connected, the sync service will push
/// pending changes and pull updates.
abstract class BaseRepository<T extends fhir.Resource> {
  final String resourceType;

  BaseRepository({required this.resourceType});

  // ---------------------------------------------------------------------------
  // Local (offline-first) operations
  // ---------------------------------------------------------------------------

  List<FhirResource> getLocalResources({String? patientRef}) {
    final box = DatabaseService.fhirResources;
    return box.values.where((r) {
      if (r.resourceType != resourceType) return false;
      if (patientRef != null && r.patientReference != patientRef) return false;
      return r.syncStatus != 2; // exclude pending-delete
    }).toList();
  }

  List<T> parseLocalResources({String? patientRef}) {
    final locals = getLocalResources(patientRef: patientRef);
    final results = <T>[];
    for (final local in locals) {
      try {
        final resource = fhir.Resource.fromJson(
          jsonDecode(local.jsonData) as Map<String, dynamic>,
        );
        if (resource is T) results.add(resource);
      } catch (_) {}
    }
    return results;
  }

  Future<FhirResource> saveLocally(
    fhir.Resource resource, {
    String? patientRef,
    String? practitionerRef,
    String? category,
    int syncStatus = 1,
  }) async {
    final box = DatabaseService.fhirResources;
    final fhirId =
        resource.fhirId ?? 'local-${DateTime.now().millisecondsSinceEpoch}';

    // Check for existing local copy
    FhirResource? existing;
    for (final r in box.values) {
      if (r.fhirId == fhirId && r.resourceType == resourceType) {
        existing = r;
        break;
      }
    }

    if (existing != null) {
      existing
        ..jsonData = jsonEncode(resource.toJson())
        ..syncStatus = syncStatus
        ..lastUpdated = DateTime.now();
      await existing.save();
      return existing;
    }

    final local = FhirResource()
      ..fhirId = fhirId
      ..resourceType = resourceType
      ..jsonData = jsonEncode(resource.toJson())
      ..patientReference = patientRef
      ..practitionerReference = practitionerRef
      ..category = category
      ..syncStatus = syncStatus
      ..isDownloadedOffline = false
      ..lastUpdated = DateTime.now()
      ..createdAt = DateTime.now();

    await box.add(local);
    return local;
  }

  Future<void> deleteLocally(String fhirId) async {
    final box = DatabaseService.fhirResources;
    for (final r in box.values) {
      if (r.fhirId == fhirId && r.resourceType == resourceType) {
        r.syncStatus = 2; // Mark for deletion (sync will handle server-side)
        await r.save();
        return;
      }
    }
  }

  Future<void> removeLocally(String fhirId) async {
    final box = DatabaseService.fhirResources;
    final keys = <dynamic>[];
    for (final entry in box.toMap().entries) {
      final r = entry.value;
      if (r.fhirId == fhirId && r.resourceType == resourceType) {
        keys.add(entry.key);
      }
    }
    for (final key in keys) {
      await box.delete(key);
    }
  }

  T? findByFhirId(String fhirId) {
    final box = DatabaseService.fhirResources;
    for (final r in box.values) {
      if (r.fhirId == fhirId && r.resourceType == resourceType && r.syncStatus != 2) {
        try {
          final resource = fhir.Resource.fromJson(
            jsonDecode(r.jsonData) as Map<String, dynamic>,
          );
          if (resource is T) return resource;
        } catch (_) {}
      }
    }
    return null;
  }
}
