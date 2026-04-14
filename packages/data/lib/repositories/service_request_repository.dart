import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;

import 'base_repository.dart';

class ServiceRequestRepository extends BaseRepository<fhir.ServiceRequest> {
  ServiceRequestRepository() : super(resourceType: 'ServiceRequest');

  List<fhir.ServiceRequest> getPendingByPatient(String patientRef) {
    return parseLocalResources(patientRef: patientRef).where((sr) {
      final status = sr.status?.value;
      return status == 'active' || status == 'draft';
    }).toList();
  }

  List<fhir.ServiceRequest> getCompletedByPatient(String patientRef) {
    return parseLocalResources(patientRef: patientRef).where((sr) {
      return sr.status?.value == 'completed';
    }).toList();
  }

  List<fhir.ServiceRequest> getByRequester(String requesterRef) {
    return parseLocalResources().where((sr) {
      return sr.requester?.reference == requesterRef;
    }).toList();
  }

  List<fhir.ServiceRequest> getByEncounter(String encounterRef) {
    return parseLocalResources().where((sr) {
      return sr.encounter?.reference == encounterRef;
    }).toList();
  }

  List<fhir.ServiceRequest> getReferrals(String patientRef) {
    return parseLocalResources(patientRef: patientRef).where((sr) {
      return sr.category?.any((cat) =>
              cat.coding?.any((c) => c.code?.value == 'referral') ?? false) ??
          false;
    }).toList();
  }
}

final serviceRequestRepositoryProvider =
    Provider<ServiceRequestRepository>((ref) {
  return ServiceRequestRepository();
});
