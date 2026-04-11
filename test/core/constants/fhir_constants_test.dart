import 'package:flutter_test/flutter_test.dart';
import 'package:clinical_curator/core/constants/fhir_constants.dart';

void main() {
  group('FhirConstants', () {
    test('LOINC system URI is correct', () {
      expect(FhirConstants.loincSystem, 'http://loinc.org');
    });

    test('SNOMED system URI is correct', () {
      expect(FhirConstants.snomedSystem, 'http://snomed.info/sct');
    });

    test('heart rate LOINC code is correct', () {
      expect(FhirConstants.heartRateCode, '8867-4');
    });

    test('blood pressure LOINC codes are correct', () {
      expect(FhirConstants.bloodPressureSystolicCode, '8480-6');
      expect(FhirConstants.bloodPressureDiastolicCode, '8462-4');
    });

    test('Nepal health ID system is correct', () {
      expect(
        FhirConstants.nepalHealthIdSystem,
        'http://health.gov.np/fhir/sid/patient-id',
      );
    });

    test('NMC system is correct', () {
      expect(
        FhirConstants.nmcSystem,
        'http://nmc.org.np/fhir/sid/practitioner-license',
      );
    });

    test('observation categories are defined', () {
      expect(FhirConstants.vitalSigns, 'vital-signs');
      expect(FhirConstants.laboratory, 'laboratory');
      expect(FhirConstants.imaging, 'imaging');
    });

    test('consent scopes are defined', () {
      expect(FhirConstants.consentScopePatientPrivacy, 'patient-privacy');
      expect(FhirConstants.consentScopeTreatment, 'treatment');
    });

    test('practitioner types are defined', () {
      expect(FhirConstants.practitionerTypeDoctor, 'doctor');
      expect(FhirConstants.practitionerTypeNurse, 'nurse');
    });
  });
}
