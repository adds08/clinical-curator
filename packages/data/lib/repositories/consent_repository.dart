import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;

import 'base_repository.dart';

class ConsentRepository extends BaseRepository<fhir.Consent> {
  ConsentRepository() : super(resourceType: 'Consent');

  List<fhir.Consent> getActiveConsents(String patientRef) {
    return parseLocalResources(patientRef: patientRef).where((consent) {
      return consent.status?.value == 'active';
    }).toList();
  }
}

final consentRepositoryProvider = Provider<ConsentRepository>((ref) {
  return ConsentRepository();
});
