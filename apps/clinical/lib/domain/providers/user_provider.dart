import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;

import 'package:cc_data/database/isar_service.dart';
import 'auth_provider.dart';

// ---------------------------------------------------------------------------
// Current User's FHIR Patient Resource
// ---------------------------------------------------------------------------

/// Resolves the FHIR [Patient] resource for the currently logged-in user by
/// looking up [AppUser.fhirPatientId] from the auth state.
///
/// Returns `null` when the user is not authenticated, has no linked FHIR
/// patient id, or the corresponding resource cannot be found in the local
/// Hive box.
final currentUserFhirPatientProvider = Provider<fhir.Patient?>((ref) {
  final authState = ref.watch(authProvider);
  final user = authState.user;
  if (user == null || user.fhirPatientId == null) return null;

  final patientId = user.fhirPatientId!;
  final box = DatabaseService.fhirResources;

  for (final r in box.values) {
    if (r.resourceType == 'Patient' && r.fhirId == patientId) {
      try {
        final resource =
            fhir.Resource.fromJson(jsonDecode(r.jsonData) as Map<String, dynamic>);
        if (resource is fhir.Patient) {
          return resource;
        }
      } catch (_) {
        // Malformed JSON – fall through to return null.
      }
    }
  }

  return null;
});

// ---------------------------------------------------------------------------
// Current User's FHIR Practitioner Resource
// ---------------------------------------------------------------------------

/// Resolves the FHIR [Practitioner] resource for the currently logged-in user
/// by looking up [AppUser.fhirPractitionerId] from the auth state.
///
/// Returns `null` when the user is not authenticated, is not a practitioner,
/// or the corresponding resource cannot be found in the local Hive box.
final currentUserFhirPractitionerProvider =
    Provider<fhir.Practitioner?>((ref) {
  final authState = ref.watch(authProvider);
  final user = authState.user;
  if (user == null || user.fhirPractitionerId == null) return null;

  final practitionerId = user.fhirPractitionerId!;
  final box = DatabaseService.fhirResources;

  for (final r in box.values) {
    if (r.resourceType == 'Practitioner' && r.fhirId == practitionerId) {
      try {
        final resource =
            fhir.Resource.fromJson(jsonDecode(r.jsonData) as Map<String, dynamic>);
        if (resource is fhir.Practitioner) {
          return resource;
        }
      } catch (_) {
        // Malformed JSON – fall through to return null.
      }
    }
  }

  return null;
});
