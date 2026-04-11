import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;

import 'api_client.dart';
import 'api_exceptions.dart';

class FhirApiService {
  final ApiClient _client;

  FhirApiService(this._client);

  // ---------------------------------------------------------------------------
  // Generic CRUD
  // ---------------------------------------------------------------------------

  Future<fhir.Resource> read(String resourceType, String id) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        '/$resourceType/$id',
      );
      return fhir.Resource.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<fhir.Resource> create(fhir.Resource resource) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        '/${resource.resourceType}',
        data: jsonEncode(resource.toJson()),
      );
      return fhir.Resource.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<fhir.Resource> update(fhir.Resource resource) async {
    try {
      final response = await _client.put<Map<String, dynamic>>(
        '/${resource.resourceType}/${resource.fhirId}',
        data: jsonEncode(resource.toJson()),
      );
      return fhir.Resource.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> delete(String resourceType, String id) async {
    try {
      await _client.delete('/$resourceType/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ---------------------------------------------------------------------------
  // Search
  // ---------------------------------------------------------------------------

  Future<fhir.Bundle> search(
    String resourceType, {
    Map<String, dynamic>? parameters,
  }) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        '/$resourceType',
        queryParameters: parameters,
      );
      return fhir.Bundle.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // ---------------------------------------------------------------------------
  // Convenience — typed search helpers
  // ---------------------------------------------------------------------------

  Future<List<fhir.Patient>> searchPatients({
    String? name,
    String? identifier,
  }) async {
    final params = <String, dynamic>{};
    if (name != null) params['name'] = name;
    if (identifier != null) params['identifier'] = identifier;

    final bundle = await search('Patient', parameters: params);
    return _extractResources<fhir.Patient>(bundle);
  }

  Future<List<fhir.Observation>> searchObservations({
    required String patientRef,
    String? category,
    String? code,
  }) async {
    final params = <String, dynamic>{
      'patient': patientRef,
      '_sort': '-date',
    };
    if (category != null) params['category'] = category;
    if (code != null) params['code'] = code;

    final bundle = await search('Observation', parameters: params);
    return _extractResources<fhir.Observation>(bundle);
  }

  Future<List<fhir.DiagnosticReport>> searchDiagnosticReports({
    required String patientRef,
  }) async {
    final bundle = await search('DiagnosticReport', parameters: {
      'patient': patientRef,
      '_sort': '-date',
    });
    return _extractResources<fhir.DiagnosticReport>(bundle);
  }

  Future<List<fhir.MedicationRequest>> searchMedicationRequests({
    required String patientRef,
  }) async {
    final bundle = await search('MedicationRequest', parameters: {
      'patient': patientRef,
      '_sort': '-date',
    });
    return _extractResources<fhir.MedicationRequest>(bundle);
  }

  Future<List<fhir.Immunization>> searchImmunizations({
    required String patientRef,
  }) async {
    final bundle = await search('Immunization', parameters: {
      'patient': patientRef,
      '_sort': '-date',
    });
    return _extractResources<fhir.Immunization>(bundle);
  }

  Future<List<fhir.AllergyIntolerance>> searchAllergyIntolerances({
    required String patientRef,
  }) async {
    final bundle = await search('AllergyIntolerance', parameters: {
      'patient': patientRef,
    });
    return _extractResources<fhir.AllergyIntolerance>(bundle);
  }

  Future<List<fhir.Consent>> searchConsents({
    required String patientRef,
  }) async {
    final bundle = await search('Consent', parameters: {
      'patient': patientRef,
    });
    return _extractResources<fhir.Consent>(bundle);
  }

  // ---------------------------------------------------------------------------
  // Clinical resource search helpers
  // ---------------------------------------------------------------------------

  Future<List<fhir.Encounter>> searchEncounters({
    String? patientRef,
    String? practitionerRef,
    String? status,
  }) async {
    final params = <String, dynamic>{'_sort': '-date'};
    if (patientRef != null) params['patient'] = patientRef;
    if (practitionerRef != null) params['participant'] = practitionerRef;
    if (status != null) params['status'] = status;

    final bundle = await search('Encounter', parameters: params);
    return _extractResources<fhir.Encounter>(bundle);
  }

  Future<List<fhir.Condition>> searchConditions({
    required String patientRef,
    String? clinicalStatus,
  }) async {
    final params = <String, dynamic>{
      'patient': patientRef,
      '_sort': '-recorded-date',
    };
    if (clinicalStatus != null) params['clinical-status'] = clinicalStatus;

    final bundle = await search('Condition', parameters: params);
    return _extractResources<fhir.Condition>(bundle);
  }

  Future<List<fhir.Procedure>> searchProcedures({
    required String patientRef,
    String? encounterRef,
  }) async {
    final params = <String, dynamic>{
      'patient': patientRef,
      '_sort': '-date',
    };
    if (encounterRef != null) params['encounter'] = encounterRef;

    final bundle = await search('Procedure', parameters: params);
    return _extractResources<fhir.Procedure>(bundle);
  }

  Future<List<fhir.CarePlan>> searchCarePlans({
    required String patientRef,
    String? status,
  }) async {
    final params = <String, dynamic>{
      'patient': patientRef,
      '_sort': '-date',
    };
    if (status != null) params['status'] = status;

    final bundle = await search('CarePlan', parameters: params);
    return _extractResources<fhir.CarePlan>(bundle);
  }

  Future<List<fhir.ServiceRequest>> searchServiceRequests({
    String? patientRef,
    String? requesterRef,
    String? status,
    String? category,
  }) async {
    final params = <String, dynamic>{'_sort': '-authored'};
    if (patientRef != null) params['patient'] = patientRef;
    if (requesterRef != null) params['requester'] = requesterRef;
    if (status != null) params['status'] = status;
    if (category != null) params['category'] = category;

    final bundle = await search('ServiceRequest', parameters: params);
    return _extractResources<fhir.ServiceRequest>(bundle);
  }

  Future<List<fhir.Location>> searchLocations({
    String? organizationRef,
    String? type,
  }) async {
    final params = <String, dynamic>{};
    if (organizationRef != null) params['organization'] = organizationRef;
    if (type != null) params['type'] = type;

    final bundle = await search('Location', parameters: params);
    return _extractResources<fhir.Location>(bundle);
  }

  Future<List<fhir.HealthcareService>> searchHealthcareServices({
    String? organizationRef,
    String? specialty,
  }) async {
    final params = <String, dynamic>{};
    if (organizationRef != null) params['organization'] = organizationRef;
    if (specialty != null) params['specialty'] = specialty;

    final bundle = await search('HealthcareService', parameters: params);
    return _extractResources<fhir.HealthcareService>(bundle);
  }

  Future<List<fhir.PractitionerRole>> searchPractitionerRoles({
    String? practitionerRef,
    String? organizationRef,
    String? specialty,
  }) async {
    final params = <String, dynamic>{};
    if (practitionerRef != null) params['practitioner'] = practitionerRef;
    if (organizationRef != null) params['organization'] = organizationRef;
    if (specialty != null) params['specialty'] = specialty;

    final bundle = await search('PractitionerRole', parameters: params);
    return _extractResources<fhir.PractitionerRole>(bundle);
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  List<T> _extractResources<T extends fhir.Resource>(fhir.Bundle bundle) {
    final entries = bundle.entry;
    if (entries == null) return [];
    return entries
        .map((e) => e.resource)
        .whereType<T>()
        .toList();
  }
}

final fhirApiServiceProvider = Provider<FhirApiService>((ref) {
  final client = ref.watch(apiClientProvider);
  return FhirApiService(client);
});
