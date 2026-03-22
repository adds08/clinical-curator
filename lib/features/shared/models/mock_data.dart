import 'package:fhir/r4.dart';

class MockData {
  static Patient get patient {
    return Patient(
      name: [
        HumanName(
          use: HumanNameUse.official,
          text: 'Siddhartha Thapa',
          family: 'Thapa',
          given: ['Siddhartha'],
        ),
      ],
      gender: FhirCode('male'),
      birthDate: FhirDate(DateTime.now().subtract(const Duration(days: 365 * 32))),
    );
  }

  static Practitioner get practitioner {
    return Practitioner(
      name: [
        HumanName(
          text: 'Dr. Arpan K. Sharma',
          prefix: ['Dr.'],
          given: ['Arpan', 'K.'],
          family: 'Sharma',
        ),
      ],
      qualification: [
        PractitionerQualification(
          code: CodeableConcept(
            text: 'Senior Consultant • Cardiology',
          ),
        ),
      ],
    );
  }

  static List<Observation> get vitalSigns {
    return [
      Observation(
        status: FhirCode('final'),
        category: [
          CodeableConcept(
            coding: [
              Coding(
                system: FhirUri('http://terminology.hl7.org/CodeSystem/observation-category'),
                code: FhirCode('vital-signs'),
                display: 'Vital Signs',
              ),
            ],
          ),
        ],
        code: CodeableConcept(text: 'Heart Rate'),
        valueQuantity: Quantity(value: FhirDecimal(72), unit: 'bpm'),
        effectiveDateTime: FhirDateTime(DateTime.now()),
      ),
      Observation(
        status: FhirCode('final'),
        category: [
          CodeableConcept(
            coding: [
              Coding(
                system: FhirUri('http://terminology.hl7.org/CodeSystem/observation-category'),
                code: FhirCode('vital-signs'),
                display: 'Vital Signs',
              ),
            ],
          ),
        ],
        code: CodeableConcept(text: 'Blood Pressure'),
        component: [
          ObservationComponent(
            code: CodeableConcept(text: 'Systolic Blood Pressure'),
            valueQuantity: Quantity(value: FhirDecimal(120), unit: 'mmHg'),
          ),
          ObservationComponent(
            code: CodeableConcept(text: 'Diastolic Blood Pressure'),
            valueQuantity: Quantity(value: FhirDecimal(80), unit: 'mmHg'),
          ),
        ],
        effectiveDateTime: FhirDateTime(DateTime.now()),
      ),
    ];
  }

  static List<DiagnosticReport> get diagnosticReports {
    return [
      DiagnosticReport(
        status: FhirCode('final'),
        code: CodeableConcept(text: 'Full Lipid Panel'),
        subject: Reference(reference: 'Patient/MED-88291', display: 'Siddhartha Thapa'),
        resultsInterpreter: [Reference(display: 'Dr. Aris Thorne')],
        effectiveDateTime: FhirDateTime('2023-10-24'),
        result: [
          Reference(display: 'LDL Cholesterol'),
        ],
        category: [
          CodeableConcept(text: 'Lab Report'),
        ],
      ),
      DiagnosticReport(
        status: FhirCode('final'),
        code: CodeableConcept(text: 'Chest X-Ray'),
        subject: Reference(reference: 'Patient/MED-88291', display: 'Siddhartha Thapa'),
        performer: [Reference(display: "St. Mary's Radiology")],
        effectiveDateTime: FhirDateTime('2023-09-30'),
        category: [
          CodeableConcept(text: 'Imaging'),
        ],
      ),
    ];
  }

  static List<MedicationRequest> get prescriptions {
    return [
      MedicationRequest(
        status: FhirCode('active'),
        intent: FhirCode('order'),
        medicationCodeableConcept: CodeableConcept(text: 'Amoxicillin'),
        subject: Reference(reference: 'Patient/MED-88291', display: 'Siddhartha Thapa'),
        authoredOn: FhirDateTime('2023-11-12'),
        requester: Reference(display: 'City General Clinic'),
        dosageInstruction: [
          Dosage(
            text: '500mg • 3x Day for 10 Days',
            timing: Timing(
              repeat: TimingRepeat(
                frequency: FhirPositiveInt(3),
                period: FhirDecimal(1),
                periodUnit: TimingRepeatPeriodUnit.d,
              ),
            ),
          ),
        ],
      ),
    ];
  }

  static List<Immunization> get immunizations {
    return [
      Immunization(
        status: FhirCode('completed'),
        vaccineCode: CodeableConcept(text: 'Influenza Vaccine'),
        patient: Reference(reference: 'Patient/MED-88291', display: 'Siddhartha Thapa'),
        occurrenceDateTime: FhirDateTime('2023-10-05'),
        location: Reference(display: 'CVS Pharmacy'),
        note: [
          Annotation(text: FhirMarkdown('Annual quadrivalent flu shot administered. Patient observed for 15 minutes; no adverse reactions recorded.')),
        ],
      ),
    ];
  }

  static Observation get ldlCholesterolObservation {
    return Observation(
      status: FhirCode('final'),
      code: CodeableConcept(text: 'LDL Cholesterol'),
      valueQuantity: Quantity(value: FhirDecimal(142), unit: 'mg/dL'),
      referenceRange: [
        ObservationReferenceRange(
          high: Quantity(value: FhirDecimal(100), unit: 'mg/dL'),
          text: '<100',
        ),
      ],
      interpretation: [
        CodeableConcept(text: 'High'),
      ],
    );
  }
}
