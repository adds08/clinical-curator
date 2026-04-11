import 'package:flutter_test/flutter_test.dart';
import 'package:fhir/r4.dart' as fhir;
import 'package:clinical_curator/core/utils/fhir_helpers.dart';

void main() {
  group('FhirHelpers', () {
    group('extractPatientName', () {
      test('returns text field when available', () {
        final patient = fhir.Patient(
          name: [fhir.HumanName(text: 'Arjun Sharma')],
        );
        expect(FhirHelpers.extractPatientName(patient), 'Arjun Sharma');
      });

      test('combines given and family names', () {
        final patient = fhir.Patient(
          name: [
            fhir.HumanName(
              given: ['Arjun'],
              family: 'Sharma',
            ),
          ],
        );
        expect(FhirHelpers.extractPatientName(patient), 'Arjun Sharma');
      });

      test('returns Unknown Patient when no names', () {
        final patient = fhir.Patient();
        expect(FhirHelpers.extractPatientName(patient), 'Unknown Patient');
      });

      test('returns Unknown Patient for empty name list', () {
        final patient = fhir.Patient(name: []);
        expect(FhirHelpers.extractPatientName(patient), 'Unknown Patient');
      });
    });

    group('extractPractitionerName', () {
      test('returns text field when available', () {
        final practitioner = fhir.Practitioner(
          name: [fhir.HumanName(text: 'Dr. Priya Thapa')],
        );
        expect(FhirHelpers.extractPractitionerName(practitioner),
            'Dr. Priya Thapa');
      });

      test('returns Unknown Practitioner when no names', () {
        final practitioner = fhir.Practitioner();
        expect(FhirHelpers.extractPractitionerName(practitioner),
            'Unknown Practitioner');
      });
    });

    group('extractObservationValue', () {
      test('returns formatted value with unit', () {
        final obs = fhir.Observation(
          code: fhir.CodeableConcept(),
          status: fhir.FhirCode('final'),
          valueQuantity: fhir.Quantity(
            value: fhir.FhirDecimal(120),
            unit: 'mmHg',
          ),
        );
        expect(FhirHelpers.extractObservationValue(obs), '120.0 mmHg');
      });

      test('returns null when no value', () {
        final obs = fhir.Observation(
          code: fhir.CodeableConcept(),
          status: fhir.FhirCode('final'),
        );
        expect(FhirHelpers.extractObservationValue(obs), isNull);
      });
    });

    group('formatFhirDate', () {
      test('formats valid date', () {
        final date = fhir.FhirDate('2026-03-27');
        expect(FhirHelpers.formatFhirDate(date), 'Mar 27, 2026');
      });

      test('returns Unknown date for null', () {
        expect(FhirHelpers.formatFhirDate(null), 'Unknown date');
      });
    });

    group('generateHealthId', () {
      test('matches NEP-YYYY-XXXX-XX pattern', () {
        final id = FhirHelpers.generateHealthId();
        expect(id, matches(RegExp(r'^NEP-\d{4}-\d{4}-\d{2}$')));
      });

      test('includes current year', () {
        final id = FhirHelpers.generateHealthId();
        final year = DateTime.now().year.toString();
        expect(id, contains(year));
      });
    });

    group('generatePatientId', () {
      test('matches PID-XXXXX pattern', () {
        final id = FhirHelpers.generatePatientId();
        expect(id, matches(RegExp(r'^PID-\d{5}$')));
      });
    });
  });
}
