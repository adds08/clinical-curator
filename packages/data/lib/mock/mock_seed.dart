import 'dart:convert';

import 'package:fhir/r4.dart' as fhir;
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/fhir_resource_collection.dart';
import 'package:cc_fhir_models/collections/user_account_collection.dart';
import 'package:cc_fhir_models/collections/organization_collection.dart';
import 'package:cc_fhir_models/collections/health_tip_collection.dart';
import 'package:cc_fhir_models/collections/schedule_slot_collection.dart';
import 'package:cc_fhir_models/collections/appointment_collection.dart';
import 'package:cc_fhir_models/collections/notification_record_collection.dart';
import 'package:cc_fhir_models/collections/encounter_collection.dart';
import 'package:cc_fhir_models/collections/condition_collection.dart';
import 'package:cc_fhir_models/collections/procedure_collection.dart';
import 'package:cc_fhir_models/collections/care_plan_collection.dart';
import 'package:cc_fhir_models/collections/service_request_collection.dart';
import 'package:cc_fhir_models/collections/medication_request_collection.dart';
import 'package:cc_fhir_models/collections/location_collection.dart';
import 'package:cc_fhir_models/collections/healthcare_service_collection.dart';
import 'package:cc_fhir_models/collections/practitioner_role_collection.dart';
import 'package:cc_fhir_models/collections/slot_collection.dart';
import 'package:cc_fhir_models/collections/immunization_collection.dart';
import 'package:cc_fhir_models/collections/allergy_intolerance_collection.dart';
import 'package:cc_fhir_models/collections/audit_event_collection.dart';
import 'package:cc_fhir_models/collections/rbac_permission_collection.dart';
import 'package:cc_fhir_models/collections/insurance_claim_collection.dart';
import 'package:cc_fhir_models/collections/pharmacy_order_collection.dart';
import 'package:cc_fhir_models/collections/lab_booking_collection.dart';

/// Seeds the Hive local database with mock users and FHIR R4 resources
/// on first run.
///
/// Seed version: 2.0 — expanded with 16 users, 60+ FHIR resources,
/// encounters, conditions, medications, labs, immunizations, allergies,
/// diagnostic reports, appointments, notifications, insurance claims,
/// pharmacy orders, lab bookings, and schedule slots for all practitioners.
class MockSeed {
  MockSeed._();

  static Future<void> seedIfEmpty() async {
    final userBox = DatabaseService.userAccounts;
    final now = DateTime.now();

    // Seed appointments if they're missing (added after initial seed)
    if (userBox.isNotEmpty && DatabaseService.appointments.isEmpty) {
      await _seedAppointments(now);
    }

    // Seed insurance claims if missing
    if (userBox.isNotEmpty && DatabaseService.insuranceClaims.isEmpty) {
      await _seedInsuranceClaims(now);
    }

    // Seed pharmacy orders if missing
    if (userBox.isNotEmpty && DatabaseService.pharmacyOrders.isEmpty) {
      await _seedPharmacyOrders(now);
    }

    // Seed lab bookings if missing
    if (userBox.isNotEmpty && DatabaseService.labBookings.isEmpty) {
      await _seedLabBookings(now);
    }

    if (userBox.isNotEmpty) return;

    // -- User Accounts (16 total) --
    // DEV ONLY — plaintext passwords for local offline auth
    final accounts = [
      // -- Existing patients --
      UserAccount()
        ..email = 'arjun@example.com'
        ..passwordHash = 'password123'
        ..displayName = 'Arjun Maharjan'
        ..isPractitioner = false
        ..isVerified = false
        ..healthId = 'NEP-2024-8842-19'
        ..accountType = 'patient'
        ..fhirPatientId = 'patient-arjun'
        ..createdAt = now,
      UserAccount()
        ..email = 'sunita@example.com'
        ..passwordHash = 'password123'
        ..displayName = 'Sunita Rajbhandari'
        ..isPractitioner = false
        ..isVerified = false
        ..healthId = 'NEP-2024-7731-05'
        ..accountType = 'patient'
        ..fhirPatientId = 'patient-sunita'
        ..createdAt = now,
      // -- New patients --
      UserAccount()
        ..email = 'ram@example.com'
        ..passwordHash = 'password123'
        ..displayName = 'Ram Bahadur Thapa'
        ..isPractitioner = false
        ..isVerified = false
        ..healthId = 'NEP-2024-3341-07'
        ..accountType = 'patient'
        ..fhirPatientId = 'patient-ram'
        ..createdAt = now,
      UserAccount()
        ..email = 'sita@example.com'
        ..passwordHash = 'password123'
        ..displayName = 'Sita Devi Gurung'
        ..isPractitioner = false
        ..isVerified = false
        ..healthId = 'NEP-2024-4452-11'
        ..accountType = 'patient'
        ..fhirPatientId = 'patient-sita'
        ..createdAt = now,
      UserAccount()
        ..email = 'deepak@example.com'
        ..passwordHash = 'password123'
        ..displayName = 'Deepak Adhikari'
        ..isPractitioner = false
        ..isVerified = false
        ..healthId = 'NEP-2024-5563-23'
        ..accountType = 'patient'
        ..fhirPatientId = 'patient-deepak'
        ..createdAt = now,
      UserAccount()
        ..email = 'priya@example.com'
        ..passwordHash = 'password123'
        ..displayName = 'Priya Tamang'
        ..isPractitioner = false
        ..isVerified = false
        ..healthId = 'NEP-2024-6674-35'
        ..accountType = 'patient'
        ..fhirPatientId = 'patient-priya'
        ..createdAt = now,
      UserAccount()
        ..email = 'krishna@example.com'
        ..passwordHash = 'password123'
        ..displayName = 'Krishna Prasad Koirala'
        ..isPractitioner = false
        ..isVerified = false
        ..healthId = 'NEP-2024-7785-47'
        ..accountType = 'patient'
        ..fhirPatientId = 'patient-krishna'
        ..createdAt = now,
      UserAccount()
        ..email = 'maya@example.com'
        ..passwordHash = 'password123'
        ..displayName = 'Maya Rai'
        ..isPractitioner = false
        ..isVerified = false
        ..healthId = 'NEP-2024-8896-59'
        ..accountType = 'patient'
        ..fhirPatientId = 'patient-maya'
        ..createdAt = now,
      // -- Existing practitioners --
      UserAccount()
        ..email = 'arpan@example.com'
        ..passwordHash = 'password123'
        ..displayName = 'Dr. Arpan K. Sharma'
        ..isPractitioner = true
        ..isVerified = true
        ..practitionerType = 'doctor'
        ..accountType = 'practitioner'
        ..fhirPatientId = 'patient-arpan'
        ..fhirPractitionerId = 'practitioner-arpan'
        ..createdAt = now,
      UserAccount()
        ..email = 'elena@example.com'
        ..passwordHash = 'password123'
        ..displayName = 'Dr. Elena Vance'
        ..isPractitioner = true
        ..isVerified = true
        ..practitionerType = 'doctor'
        ..accountType = 'practitioner'
        ..fhirPatientId = 'patient-elena'
        ..fhirPractitionerId = 'practitioner-elena'
        ..createdAt = now,
      UserAccount()
        ..email = 'anjali@example.com'
        ..passwordHash = 'password123'
        ..displayName = 'Anjali Sharma'
        ..isPractitioner = true
        ..isVerified = true
        ..practitionerType = 'nurse'
        ..accountType = 'practitioner'
        ..fhirPatientId = 'patient-anjali'
        ..fhirPractitionerId = 'practitioner-anjali'
        ..createdAt = now,
      UserAccount()
        ..email = 'bikesh@example.com'
        ..passwordHash = 'password123'
        ..displayName = 'Dr. Bikesh Shrestha'
        ..isPractitioner = true
        ..isVerified = false
        ..practitionerType = 'doctor'
        ..accountType = 'practitioner'
        ..fhirPatientId = 'patient-bikesh'
        ..fhirPractitionerId = 'practitioner-bikesh'
        ..createdAt = now,
      // -- New practitioners --
      UserAccount()
        ..email = 'suman@example.com'
        ..passwordHash = 'password123'
        ..displayName = 'Dr. Suman Karki'
        ..isPractitioner = true
        ..isVerified = true
        ..practitionerType = 'doctor'
        ..accountType = 'practitioner'
        ..fhirPatientId = 'patient-suman'
        ..fhirPractitionerId = 'practitioner-suman'
        ..createdAt = now,
      UserAccount()
        ..email = 'nisha@example.com'
        ..passwordHash = 'password123'
        ..displayName = 'Dr. Nisha Poudel'
        ..isPractitioner = true
        ..isVerified = true
        ..practitionerType = 'doctor'
        ..accountType = 'practitioner'
        ..fhirPatientId = 'patient-nisha'
        ..fhirPractitionerId = 'practitioner-nisha'
        ..createdAt = now,
      UserAccount()
        ..email = 'rajesh@example.com'
        ..passwordHash = 'password123'
        ..displayName = 'Dr. Rajesh Manandhar'
        ..isPractitioner = true
        ..isVerified = true
        ..practitionerType = 'doctor'
        ..accountType = 'practitioner'
        ..fhirPatientId = 'patient-rajesh'
        ..fhirPractitionerId = 'practitioner-rajesh'
        ..createdAt = now,
      // -- Admin --
      UserAccount()
        ..email = 'admin@example.com'
        ..passwordHash = 'admin123'
        ..displayName = 'Admin User'
        ..isPractitioner = false
        ..isVerified = true
        ..accountType = 'admin'
        ..createdAt = now,
    ];

    for (final a in accounts) {
      await userBox.add(a);
    }

    // -- FHIR Resources --
    final resourceBox = DatabaseService.fhirResources;
    final resources = <FhirResource>[];

    // Patients (12 — 6 original + 6 new)
    for (final p in [
      _patient('patient-arjun', ['Arjun'], 'Maharjan', 'male', '1990-05-15', 'NEP-2024-8842-19', 'Kathmandu'),
      _patient('patient-sunita', ['Sunita'], 'Rajbhandari', 'female', '1985-11-22', 'NEP-2024-7731-05', 'Kathmandu'),
      _patient('patient-arpan', ['Arpan', 'K.'], 'Sharma', 'male', '1978-03-10', '', 'Kathmandu'),
      _patient('patient-elena', ['Elena'], 'Vance', 'female', '1982-07-04', '', 'Kathmandu'),
      _patient('patient-anjali', ['Anjali'], 'Sharma', 'female', '1993-01-28', '', 'Kathmandu'),
      _patient('patient-bikesh', ['Bikesh'], 'Shrestha', 'male', '1988-09-14', '', 'Kathmandu'),
      _patient('patient-ram', ['Ram', 'Bahadur'], 'Thapa', 'male', '1961-03-20', 'NEP-2024-3341-07', 'Pokhara'),
      _patient('patient-sita', ['Sita', 'Devi'], 'Gurung', 'female', '1981-08-12', 'NEP-2024-4452-11', 'Bhaktapur'),
      _patient('patient-deepak', ['Deepak'], 'Adhikari', 'male', '1994-01-05', 'NEP-2024-5563-23', 'Kathmandu'),
      _patient('patient-priya', ['Priya'], 'Tamang', 'female', '1998-06-18', 'NEP-2024-6674-35', 'Lalitpur'),
      _patient('patient-krishna', ['Krishna', 'Prasad'], 'Koirala', 'male', '1971-11-30', 'NEP-2024-7785-47', 'Chitwan'),
      _patient('patient-maya', ['Maya'], 'Rai', 'female', '1954-04-08', 'NEP-2024-8896-59', 'Dharan'),
    ]) {
      resources.add(p);
    }

    // Practitioners (7 — 4 original + 3 new)
    for (final p in [
      _practitioner('practitioner-arpan', ['Dr.'], ['Arpan', 'K.'], 'Sharma', 'Cardiology', 'NMC-12345', '394579002'),
      _practitioner('practitioner-elena', ['Dr.'], ['Elena'], 'Vance', 'Internal Medicine', 'NMC-67890', '394802001'),
      _practitioner('practitioner-anjali', [], ['Anjali'], 'Sharma', 'ICU Nursing', 'NNC-44321', '394618009'),
      _practitioner('practitioner-bikesh', ['Dr.'], ['Bikesh'], 'Shrestha', 'Orthopedics', 'NMC-99887', '394801008'),
      _practitioner('practitioner-suman', ['Dr.'], ['Suman'], 'Karki', 'Pediatrics', 'NMC-55431', '394537008'),
      _practitioner('practitioner-nisha', ['Dr.'], ['Nisha'], 'Poudel', 'OB/GYN', 'NMC-66789', '394586005'),
      _practitioner('practitioner-rajesh', ['Dr.'], ['Rajesh'], 'Manandhar', 'Psychiatry', 'NMC-77234', '394587001'),
    ]) {
      resources.add(p);
    }

    // Arjun's vitals
    resources.add(_vitalSign('obs-arjun-hr', 'Patient/patient-arjun', 'Heart Rate', '8867-4', 95, 'bpm', '/min', now));
    resources.add(_bloodPressure('obs-arjun-bp', 'Patient/patient-arjun', 120, 80, now));
    resources.add(_vitalSign('obs-arjun-temp', 'Patient/patient-arjun', 'Body Temperature', '8310-5', 98.6, '\u00b0F', '[degF]', now));
    resources.add(_vitalSign('obs-arjun-spo2', 'Patient/patient-arjun', 'Oxygen Saturation', '2708-6', 98, '%', '%', now));

    // Sunita's vitals
    resources.add(_vitalSign('obs-sunita-hr', 'Patient/patient-sunita', 'Heart Rate', '8867-4', 112, 'bpm', '/min', now));
    resources.add(_bloodPressure('obs-sunita-bp', 'Patient/patient-sunita', 142, 95, now));
    resources.add(_vitalSign('obs-sunita-spo2', 'Patient/patient-sunita', 'Oxygen Saturation', '2708-6', 91, '%', '%', now));

    // New patient vitals
    resources.add(_vitalSign('obs-ram-hr', 'Patient/patient-ram', 'Heart Rate', '8867-4', 78, 'bpm', '/min', now));
    resources.add(_vitalSign('obs-krishna-temp', 'Patient/patient-krishna', 'Body Temperature', '8310-5', 99.1, '\u00b0F', '[degF]', now));
    resources.add(_bloodPressure('obs-krishna-bp', 'Patient/patient-krishna', 138, 88, now));
    resources.add(_vitalSign('obs-maya-spo2', 'Patient/patient-maya', 'Oxygen Saturation', '2708-6', 88, '%', '%', now));
    resources.add(_bloodPressure('obs-maya-bp', 'Patient/patient-maya', 128, 82, now));
    resources.add(_vitalSign('obs-priya-hr', 'Patient/patient-priya', 'Heart Rate', '8867-4', 82, 'bpm', '/min', now));

    // Lab Observations (6)
    resources.add(_labObservation('obs-krishna-hba1c', 'Patient/patient-krishna', 'Hemoglobin A1c', '4548-4', 7.2, '%', '%', now));
    resources.add(_labObservation('obs-arjun-chol', 'Patient/patient-arjun', 'Total Cholesterol', '2093-3', 245, 'mg/dL', 'mg/dL', now));
    resources.add(_labObservation('obs-sita-tsh', 'Patient/patient-sita', 'TSH', '3016-3', 4.5, 'mIU/L', 'm[IU]/L', now));
    resources.add(_labObservation('obs-sunita-alt', 'Patient/patient-sunita', 'Alanine Aminotransferase (ALT)', '1742-6', 28, 'U/L', 'U/L', now));
    resources.add(_labObservation('obs-maya-creat', 'Patient/patient-maya', 'Creatinine', '2160-0', 1.1, 'mg/dL', 'mg/dL', now));
    resources.add(_labObservation('obs-priya-hgb', 'Patient/patient-priya', 'Hemoglobin', '718-7', 11.2, 'g/dL', 'g/dL', now));

    // DiagnosticReports (4)
    resources.add(_diagnosticReport('diag-arjun-lipid', 'Patient/patient-arjun', 'Full Lipid Panel', '57698-3', 'LDL Cholesterol elevated at 142 mg/dL.', now));
    resources.add(_diagnosticReport('diag-maya-cxr', 'Patient/patient-maya', 'Chest X-ray', '36643-5', 'Hyperinflated lungs consistent with COPD. No acute infiltrates.', now));
    resources.add(_diagnosticReport('diag-sunita-ecg', 'Patient/patient-sunita', 'Electrocardiogram (ECG)', '11524-6', 'Normal sinus rhythm, left ventricular hypertrophy.', now));
    resources.add(_diagnosticReport('diag-priya-us', 'Patient/patient-priya', 'Obstetric Ultrasound', '11525-3', 'Single viable intrauterine pregnancy at 28 weeks. Normal fetal biometry.', now));

    // MedicationRequests (7)
    resources.add(_medicationRequest('medreq-arjun-amox', 'Patient/patient-arjun', 'Amoxicillin 500mg', '723', 'Practitioner/practitioner-arpan', '500mg orally three times daily for 7 days', now));
    resources.add(_medicationRequest('medreq-krishna-metformin', 'Patient/patient-krishna', 'Metformin 500mg', '861007', 'Practitioner/practitioner-elena', '500mg orally twice daily with meals', now));
    resources.add(_medicationRequest('medreq-sunita-amlodipine', 'Patient/patient-sunita', 'Amlodipine 5mg', '329528', 'Practitioner/practitioner-elena', '5mg once daily in the morning', now));
    resources.add(_medicationRequest('medreq-maya-salbutamol', 'Patient/patient-maya', 'Salbutamol inhaler', '435', 'Practitioner/practitioner-arpan', '2 puffs every 4-6 hours as needed', now));
    resources.add(_medicationRequest('medreq-priya-prenatal', 'Patient/patient-priya', 'Prenatal Vitamins', '904420', 'Practitioner/practitioner-nisha', '1 tablet daily', now));
    resources.add(_medicationRequest('medreq-deepak-sertraline', 'Patient/patient-deepak', 'Sertraline 50mg', '312938', 'Practitioner/practitioner-rajesh', '50mg once daily in the morning', now));
    resources.add(_medicationRequest('medreq-ram-ibuprofen', 'Patient/patient-ram', 'Ibuprofen 400mg', '5640', 'Practitioner/practitioner-bikesh', '400mg orally three times daily with food', now));

    // Immunizations (5)
    resources.add(_immunization('imm-arjun-flu', 'Patient/patient-arjun', 'Influenza Vaccine (Quadrivalent)', '140', 'FL2025-KTM-001', now));
    resources.add(_immunization('imm-arjun-covid', 'Patient/patient-arjun', 'COVID-19 Vaccine (Pfizer-BioNTech)', '208', 'CV2024-KTM-4521', now.subtract(const Duration(days: 180))));
    resources.add(_immunization('imm-priya-bcg', 'Patient/patient-priya', 'BCG Vaccine', '19', 'BCG1998-NPL-001', now.subtract(const Duration(days: 9125))));
    resources.add(_immunization('imm-ram-dpt', 'Patient/patient-ram', 'DPT Vaccine', '20', 'DPT1965-NPL-012', now.subtract(const Duration(days: 21900))));
    resources.add(_immunization('imm-deepak-hepb', 'Patient/patient-deepak', 'Hepatitis B Vaccine', '08', 'HB2025-KTM-789', now.subtract(const Duration(days: 365))));

    // Allergies (5)
    resources.add(_allergy('allergy-sunita-pen', 'Patient/patient-sunita', 'Penicillin', '764146007', 'medication', 'high', 'Practitioner/practitioner-elena', now));
    resources.add(_allergy('allergy-ram-sulfa', 'Patient/patient-ram', 'Sulfa drugs', '91936005', 'medication', 'high', 'Practitioner/practitioner-bikesh', now));
    resources.add(_allergy('allergy-priya-latex', 'Patient/patient-priya', 'Latex', '111088007', 'environment', 'low', 'Practitioner/practitioner-nisha', now));
    resources.add(_allergy('allergy-deepak-dust', 'Patient/patient-deepak', 'Dust mites', '260147004', 'environment', 'low', 'Practitioner/practitioner-rajesh', now));
    resources.add(_allergy('allergy-krishna-aspirin', 'Patient/patient-krishna', 'Aspirin', '387458008', 'medication', 'high', 'Practitioner/practitioner-elena', now));

    // Conditions (8 — as FHIR resources)
    resources.add(_condition('cond-krishna-diabetes', 'Patient/patient-krishna', 'E11.9', 'Type 2 diabetes mellitus without complications', 'active', 'confirmed', now.subtract(const Duration(days: 1825))));
    resources.add(_condition('cond-sunita-htn', 'Patient/patient-sunita', 'I10', 'Essential (primary) hypertension', 'active', 'confirmed', now.subtract(const Duration(days: 730))));
    resources.add(_condition('cond-maya-copd', 'Patient/patient-maya', 'J44.1', 'Chronic obstructive pulmonary disease with acute exacerbation', 'active', 'confirmed', now.subtract(const Duration(days: 3650))));
    resources.add(_condition('cond-priya-delivery', 'Patient/patient-priya', 'O80', 'Encounter for full-term uncomplicated delivery', 'resolved', 'confirmed', now.subtract(const Duration(days: 60))));
    resources.add(_condition('cond-deepak-depression', 'Patient/patient-deepak', 'F32.1', 'Major depressive disorder, single episode, moderate', 'active', 'provisional', now.subtract(const Duration(days: 90))));
    resources.add(_condition('cond-ram-backpain', 'Patient/patient-ram', 'M54.5', 'Low back pain', 'active', 'confirmed', now.subtract(const Duration(days: 180))));
    resources.add(_condition('cond-arjun-uri', 'Patient/patient-arjun', 'J06.9', 'Acute upper respiratory infection, unspecified', 'resolved', 'confirmed', now.subtract(const Duration(days: 30))));
    resources.add(_condition('cond-arjun-lipid', 'Patient/patient-arjun', 'E78.5', 'Hyperlipidemia, unspecified', 'active', 'confirmed', now.subtract(const Duration(days: 365))));

    // Consents (6)
    resources.add(_consent('consent-arjun-arpan', 'Patient/patient-arjun', 'Practitioner/practitioner-arpan', 'active', now));
    resources.add(_consent('consent-arjun-elena', 'Patient/patient-arjun', 'Practitioner/practitioner-elena', 'active', now));
    resources.add(_consent('consent-sunita-elena', 'Patient/patient-sunita', 'Practitioner/practitioner-elena', 'active', now));
    resources.add(_consent('consent-krishna-elena', 'Patient/patient-krishna', 'Practitioner/practitioner-elena', 'active', now));
    resources.add(_consent('consent-priya-nisha', 'Patient/patient-priya', 'Practitioner/practitioner-nisha', 'active', now));
    resources.add(_consent('consent-deepak-rajesh', 'Patient/patient-deepak', 'Practitioner/practitioner-rajesh', 'active', now));

    // Encounters (8 — as FHIR resources)
    resources.add(_encounter('enc-arjun-cardio-01', 'Patient/patient-arjun', 'Practitioner/practitioner-arpan', 'finished', 'AMB', 'ambulatory', '185349003', 'Encounter for check up', 'Organization/nepal-mediciti', now.subtract(const Duration(days: 14)), now.subtract(const Duration(days: 14)).add(const Duration(hours: 1))));
    resources.add(_encounter('enc-sunita-htn-01', 'Patient/patient-sunita', 'Practitioner/practitioner-elena', 'finished', 'AMB', 'ambulatory', '390906007', 'Follow-up encounter for hypertension', 'Organization/patan-hospital', now.subtract(const Duration(days: 10)), now.subtract(const Duration(days: 10)).add(const Duration(minutes: 45))));
    resources.add(_encounter('enc-ram-knee-01', 'Patient/patient-ram', 'Practitioner/practitioner-bikesh', 'finished', 'AMB', 'ambulatory', '30989003', 'Knee pain', 'Organization/bir-hospital', now.subtract(const Duration(days: 7)), now.subtract(const Duration(days: 7)).add(const Duration(minutes: 30))));
    resources.add(_encounter('enc-priya-prenatal-01', 'Patient/patient-priya', 'Practitioner/practitioner-nisha', 'finished', 'AMB', 'ambulatory', '424441002', 'Prenatal visit', 'Organization/grande-hospital', now.subtract(const Duration(days: 5)), now.subtract(const Duration(days: 5)).add(const Duration(minutes: 40))));
    resources.add(_encounter('enc-krishna-diabetes-01', 'Patient/patient-krishna', 'Practitioner/practitioner-elena', 'finished', 'AMB', 'ambulatory', '46635009', 'Diabetes mellitus type 2', 'Organization/nepal-mediciti', now.subtract(const Duration(days: 4)), now.subtract(const Duration(days: 4)).add(const Duration(minutes: 30))));
    resources.add(_encounter('enc-maya-copd-01', 'Patient/patient-maya', 'Practitioner/practitioner-arpan', 'finished', 'EMER', 'emergency', '195951007', 'Acute exacerbation of COPD', 'Organization/bir-hospital', now.subtract(const Duration(days: 2)), now.subtract(const Duration(days: 2)).add(const Duration(hours: 3))));
    resources.add(_encounter('enc-deepak-anxiety-01', 'Patient/patient-deepak', 'Practitioner/practitioner-rajesh', 'finished', 'AMB', 'ambulatory', '197480006', 'Anxiety disorder', 'Organization/patan-hospital', now.subtract(const Duration(days: 3)), now.subtract(const Duration(days: 3)).add(const Duration(minutes: 50))));
    resources.add(_encounter('enc-sita-physical-01', 'Patient/patient-sita', 'Practitioner/practitioner-elena', 'finished', 'AMB', 'ambulatory', '185349003', 'Annual physical examination', 'Organization/grande-hospital', now.subtract(const Duration(days: 6)), now.subtract(const Duration(days: 6)).add(const Duration(hours: 1))));

    for (final r in resources) {
      await resourceBox.add(r);
    }

    // -- Organizations (Hospitals & Pharmacies) --
    await _seedOrganizations(now);

    // -- Health Tips --
    await _seedHealthTips(now);

    // -- Schedule Slots for all practitioners --
    await _seedScheduleSlots(now);

    // -- Notifications --
    await _seedNotifications(now);

    // -- Appointments (15) --
    await _seedAppointments(now);

    // -- Insurance Claims (4) --
    await _seedInsuranceClaims(now);

    // -- Pharmacy Orders (4) --
    await _seedPharmacyOrders(now);

    // -- Lab Bookings (3) --
    await _seedLabBookings(now);

    // -- Clinical Data (Encounters, Conditions, Procedures, CarePlans, etc.) --
    await _seedEncounters(now);
    await _seedConditions(now);
    await _seedProcedures(now);
    await _seedCarePlans(now);
    await _seedServiceRequests(now);
    await _seedMedicationRequests(now);
    await _seedLocations(now);
    await _seedHealthcareServices(now);
    await _seedPractitionerRoles(now);
    await _seedSlots(now);
    await _seedTypedImmunizations(now);
    await _seedTypedAllergyIntolerances(now);
    await _seedAuditEvents(now);
    await _seedRbacPermissions(now);
    await _seedClinicalActionPermissions(now);
  }

  // ----------------------------------------------------------------
  // Seed: Organizations
  // ----------------------------------------------------------------

  static Future<void> _seedOrganizations(DateTime now) async {
    final box = DatabaseService.organizations;

    final hospitals = [
      OrganizationLocal()
        ..fhirId = 'org-bir-hospital'
        ..name = 'Bir Hospital'
        ..type = 'hospital'
        ..address = 'Mahaboudha, Kathmandu'
        ..phone = '+977-1-4221119'
        ..latitude = 27.7035
        ..longitude = 85.3141
        ..openHours = '24/7'
        ..rating = 4.2
        ..hasEmergency = true
        ..isOpen24Hours = true
        ..departmentsJson = '["Emergency","Cardiology","Orthopedics","General Medicine","Surgery","Pediatrics"]'
        ..servicesJson = '["ICU","X-Ray","MRI","Blood Bank","Pharmacy"]'
        ..createdAt = now
        ..syncStatus = 0,
      OrganizationLocal()
        ..fhirId = 'org-tuth'
        ..name = 'Tribhuvan University Teaching Hospital'
        ..type = 'hospital'
        ..address = 'Maharajgunj, Kathmandu'
        ..phone = '+977-1-4412303'
        ..latitude = 27.7362
        ..longitude = 85.3310
        ..openHours = '24/7'
        ..rating = 4.5
        ..hasEmergency = true
        ..isOpen24Hours = true
        ..departmentsJson = '["Emergency","Cardiology","Neurology","Oncology","Dermatology","ENT","Ophthalmology"]'
        ..servicesJson = '["ICU","NICU","CT Scan","MRI","Dialysis","Blood Bank"]'
        ..createdAt = now
        ..syncStatus = 0,
      OrganizationLocal()
        ..fhirId = 'org-patan-hospital'
        ..name = 'Patan Hospital'
        ..type = 'hospital'
        ..address = 'Lagankhel, Lalitpur'
        ..phone = '+977-1-5522266'
        ..latitude = 27.6686
        ..longitude = 85.3188
        ..openHours = '24/7'
        ..rating = 4.3
        ..hasEmergency = true
        ..isOpen24Hours = true
        ..departmentsJson = '["Emergency","Internal Medicine","Obstetrics","Pediatrics","Surgery"]'
        ..servicesJson = '["ICU","Lab","X-Ray","Ultrasound","Pharmacy"]'
        ..createdAt = now
        ..syncStatus = 0,
      OrganizationLocal()
        ..fhirId = 'org-grande-hospital'
        ..name = 'Grande International Hospital'
        ..type = 'hospital'
        ..address = 'Dhapasi, Kathmandu'
        ..phone = '+977-1-5159266'
        ..latitude = 27.7440
        ..longitude = 85.3380
        ..openHours = '24/7'
        ..rating = 4.6
        ..hasEmergency = true
        ..isOpen24Hours = true
        ..departmentsJson = '["Emergency","Cardiology","Neurosurgery","Orthopedics","Gastroenterology","Urology"]'
        ..servicesJson = '["ICU","Cath Lab","MRI","CT Scan","Dialysis","Pharmacy"]'
        ..createdAt = now
        ..syncStatus = 0,
      OrganizationLocal()
        ..fhirId = 'org-norvic'
        ..name = 'Norvic International Hospital'
        ..type = 'hospital'
        ..address = 'Thapathali, Kathmandu'
        ..phone = '+977-1-4258554'
        ..latitude = 27.6929
        ..longitude = 85.3184
        ..openHours = '24/7'
        ..rating = 4.4
        ..hasEmergency = true
        ..isOpen24Hours = true
        ..departmentsJson = '["Emergency","Cardiology","Nephrology","Oncology","Orthopedics"]'
        ..servicesJson = '["ICU","Cath Lab","Dialysis","CT Scan","Pharmacy"]'
        ..createdAt = now
        ..syncStatus = 0,
      OrganizationLocal()
        ..fhirId = 'org-nepal-mediciti'
        ..name = 'Nepal Mediciti'
        ..type = 'hospital'
        ..address = 'Bhaisepati, Lalitpur'
        ..phone = '+977-1-4217766'
        ..latitude = 27.6583
        ..longitude = 85.3013
        ..openHours = '24/7'
        ..rating = 4.5
        ..hasEmergency = true
        ..isOpen24Hours = true
        ..departmentsJson = '["Emergency","Cardiology","Neurosurgery","Oncology","IVF","Dialysis"]'
        ..servicesJson = '["ICU","Cath Lab","MRI","PET Scan","Pharmacy"]'
        ..createdAt = now
        ..syncStatus = 0,
    ];

    final pharmacies = [
      OrganizationLocal()
        ..fhirId = 'org-om-pharmacy'
        ..name = 'Om Pharmacy'
        ..type = 'pharmacy'
        ..address = 'New Road, Kathmandu'
        ..phone = '+977-1-4222456'
        ..latitude = 27.7040
        ..longitude = 85.3120
        ..openHours = '07:00-21:00'
        ..rating = 4.1
        ..hasEmergency = false
        ..isOpen24Hours = false
        ..createdAt = now
        ..syncStatus = 0,
      OrganizationLocal()
        ..fhirId = 'org-kathmandu-pharmacy'
        ..name = 'Kathmandu Pharmacy'
        ..type = 'pharmacy'
        ..address = 'Putalisadak, Kathmandu'
        ..phone = '+977-1-4411234'
        ..latitude = 27.7100
        ..longitude = 85.3220
        ..openHours = '08:00-20:00'
        ..rating = 4.3
        ..hasEmergency = false
        ..isOpen24Hours = false
        ..createdAt = now
        ..syncStatus = 0,
      OrganizationLocal()
        ..fhirId = 'org-life-care-pharmacy'
        ..name = 'Life Care Pharmacy'
        ..type = 'pharmacy'
        ..address = 'Baluwatar, Kathmandu'
        ..phone = '+977-1-4415678'
        ..latitude = 27.7280
        ..longitude = 85.3280
        ..openHours = '24/7'
        ..rating = 4.5
        ..hasEmergency = false
        ..isOpen24Hours = true
        ..createdAt = now
        ..syncStatus = 0,
      OrganizationLocal()
        ..fhirId = 'org-nepal-medicos'
        ..name = 'Nepal Medicos'
        ..type = 'pharmacy'
        ..address = 'Jamal, Kathmandu'
        ..phone = '+977-1-4225566'
        ..latitude = 27.7110
        ..longitude = 85.3170
        ..openHours = '07:00-22:00'
        ..rating = 4.0
        ..hasEmergency = false
        ..isOpen24Hours = false
        ..createdAt = now
        ..syncStatus = 0,
      OrganizationLocal()
        ..fhirId = 'org-city-pharmacy'
        ..name = 'City Pharmacy'
        ..type = 'pharmacy'
        ..address = 'Maharajgunj, Kathmandu'
        ..phone = '+977-1-4412900'
        ..latitude = 27.7350
        ..longitude = 85.3300
        ..openHours = '06:00-23:00'
        ..rating = 4.2
        ..hasEmergency = false
        ..isOpen24Hours = false
        ..createdAt = now
        ..syncStatus = 0,
    ];

    for (final o in [...hospitals, ...pharmacies]) {
      await box.add(o);
    }
  }

  // ----------------------------------------------------------------
  // Seed: Health Tips
  // ----------------------------------------------------------------

  static Future<void> _seedHealthTips(DateTime now) async {
    final box = DatabaseService.healthTips;

    final tips = [
      HealthTipLocal()
        ..title = 'Stay Hydrated at Altitude'
        ..summary = 'Drinking enough water is crucial, especially in Nepal\'s hilly regions.'
        ..content = 'At higher altitudes the air is drier and your body loses moisture faster through breathing. '
            'Aim for at least 3 liters of water per day when trekking or living above 2,000 meters. '
            'Dehydration can mimic altitude sickness, so keep a water bottle handy at all times.'
        ..category = 'wellness'
        ..author = 'Dr. Arpan K. Sharma'
        ..isActive = true
        ..publishedAt = now.subtract(const Duration(days: 2))
        ..createdAt = now
        ..syncStatus = 0,
      HealthTipLocal()
        ..title = 'Manage Blood Pressure Naturally'
        ..summary = 'Simple lifestyle changes can help keep your blood pressure in check.'
        ..content = 'Reduce sodium intake by cutting back on processed foods and pickles. '
            'Include potassium-rich foods like bananas and spinach in your diet. '
            'Regular brisk walking for 30 minutes daily can lower systolic blood pressure by 5-8 mmHg. '
            'Practice deep breathing or meditation for stress management.'
        ..category = 'cardiovascular'
        ..author = 'Dr. Elena Vance'
        ..isActive = true
        ..publishedAt = now.subtract(const Duration(days: 5))
        ..createdAt = now
        ..syncStatus = 0,
      HealthTipLocal()
        ..title = 'Monsoon Hygiene Tips'
        ..summary = 'Prevent waterborne diseases during Nepal\'s rainy season.'
        ..content = 'Always boil or filter drinking water during monsoon season. '
            'Wash hands thoroughly before meals and after using the restroom. '
            'Avoid street food that may have been exposed to contaminated water. '
            'Keep your surroundings clean to prevent mosquito breeding.'
        ..category = 'prevention'
        ..author = 'Dr. Arpan K. Sharma'
        ..isActive = true
        ..publishedAt = now.subtract(const Duration(days: 7))
        ..createdAt = now
        ..syncStatus = 0,
      HealthTipLocal()
        ..title = 'Understanding Diabetes in Nepal'
        ..summary = 'Type 2 diabetes is rising rapidly. Know the warning signs.'
        ..content = 'Nepal has seen a significant rise in Type 2 diabetes, especially in urban areas. '
            'Watch for symptoms like frequent urination, excessive thirst, unexplained weight loss, and fatigue. '
            'Limit sugary drinks and refined carbohydrates. '
            'Get your fasting blood sugar checked annually after age 35.'
        ..category = 'chronic-disease'
        ..author = 'Dr. Elena Vance'
        ..isActive = true
        ..publishedAt = now.subtract(const Duration(days: 10))
        ..createdAt = now
        ..syncStatus = 0,
      HealthTipLocal()
        ..title = 'Mental Health Matters'
        ..summary = 'Breaking the stigma around mental health in Nepal.'
        ..content = 'Mental health conditions affect 1 in 4 people globally and Nepal is no exception. '
            'Talking about your feelings is a sign of strength, not weakness. '
            'If you experience persistent sadness, anxiety, or difficulty sleeping for more than two weeks, '
            'consult a healthcare professional. Helpline: 1166 (Nepal Mental Health Helpline).'
        ..category = 'mental-health'
        ..author = 'Anjali Sharma'
        ..isActive = true
        ..publishedAt = now.subtract(const Duration(days: 14))
        ..createdAt = now
        ..syncStatus = 0,
    ];

    for (final t in tips) {
      await box.add(t);
    }
  }

  // ----------------------------------------------------------------
  // Seed: Schedule Slots for all 7 practitioners (5 days)
  // ----------------------------------------------------------------

  static Future<void> _seedScheduleSlots(DateTime now) async {
    final box = DatabaseService.scheduleSlots;
    final today = DateTime(now.year, now.month, now.day);

    final practitioners = [
      {'ref': 'Practitioner/practitioner-arpan', 'facility': 'Nepal Mediciti'},
      {'ref': 'Practitioner/practitioner-elena', 'facility': 'Grande International Hospital'},
      {'ref': 'Practitioner/practitioner-anjali', 'facility': 'Bir Hospital'},
      {'ref': 'Practitioner/practitioner-bikesh', 'facility': 'Patan Hospital'},
      {'ref': 'Practitioner/practitioner-suman', 'facility': 'Norvic International Hospital'},
      {'ref': 'Practitioner/practitioner-nisha', 'facility': 'Nepal Mediciti'},
      {'ref': 'Practitioner/practitioner-rajesh', 'facility': 'Grande International Hospital'},
    ];

    for (final prac in practitioners) {
      for (int day = 1; day <= 5; day++) {
        final slotDate = today.add(Duration(days: day));
        // Morning slot
        await box.add(ScheduleSlotLocal()
          ..practitionerRef = prac['ref']!
          ..date = slotDate
          ..startTime = '09:00'
          ..endTime = '12:00'
          ..slotDurationMinutes = 30
          ..maxPatients = 6
          ..bookedCount = day == 1 ? 2 : 0
          ..facilityName = prac['facility']!
          ..isEmergencyOverride = false
          ..isTelehealth = false
          ..status = 'available'
          ..createdAt = now
          ..syncStatus = 0);
        // Afternoon slot
        await box.add(ScheduleSlotLocal()
          ..practitionerRef = prac['ref']!
          ..date = slotDate
          ..startTime = '14:00'
          ..endTime = '17:00'
          ..slotDurationMinutes = 30
          ..maxPatients = 6
          ..bookedCount = 0
          ..facilityName = prac['facility']!
          ..isEmergencyOverride = false
          ..isTelehealth = day % 3 == 0
          ..status = 'available'
          ..createdAt = now
          ..syncStatus = 0);
      }
    }
  }

  // ----------------------------------------------------------------
  // Seed: Notifications (12)
  // ----------------------------------------------------------------

  static Future<void> _seedNotifications(DateTime now) async {
    final box = DatabaseService.notificationRecords;

    final notifications = [
      NotificationRecordLocal()
        ..userEmail = 'arjun@example.com'
        ..title = 'Appointment Reminder'
        ..body = 'You have an appointment with Dr. Arpan K. Sharma tomorrow at 09:00.'
        ..type = 'appointment'
        ..isRead = false
        ..relatedRoute = '/appointments'
        ..createdAt = now.subtract(const Duration(hours: 2))
        ..syncStatus = 0,
      NotificationRecordLocal()
        ..userEmail = 'arjun@example.com'
        ..title = 'Lab Results Ready'
        ..body = 'Your Full Lipid Panel results are now available. Tap to view.'
        ..type = 'lab_result'
        ..isRead = false
        ..relatedResourceId = 'diag-arjun-lipid'
        ..relatedRoute = '/medical-records'
        ..createdAt = now.subtract(const Duration(hours: 6))
        ..syncStatus = 0,
      NotificationRecordLocal()
        ..userEmail = 'arjun@example.com'
        ..title = 'Prescription Updated'
        ..body = 'Dr. Arpan K. Sharma has updated your Amoxicillin prescription.'
        ..type = 'prescription'
        ..isRead = true
        ..relatedResourceId = 'medreq-arjun-amox'
        ..relatedRoute = '/medical-records'
        ..createdAt = now.subtract(const Duration(days: 1))
        ..syncStatus = 0,
      NotificationRecordLocal()
        ..userEmail = 'arpan@example.com'
        ..title = 'New Patient Registration'
        ..body = 'Sunita Rajbhandari has granted you access to her medical records.'
        ..type = 'consent'
        ..isRead = true
        ..relatedResourceId = 'patient-sunita'
        ..relatedRoute = '/patients'
        ..createdAt = now.subtract(const Duration(days: 1))
        ..syncStatus = 0,
      NotificationRecordLocal()
        ..userEmail = 'arjun@example.com'
        ..title = 'Health Tip'
        ..body = 'New health tip: Stay Hydrated at Altitude. Tap to read more.'
        ..type = 'health_tip'
        ..isRead = true
        ..relatedRoute = '/health-tips'
        ..createdAt = now.subtract(const Duration(days: 2))
        ..syncStatus = 0,
      NotificationRecordLocal()
        ..userEmail = 'krishna@example.com'
        ..title = 'Lab Results Available'
        ..body = 'Your HbA1c test results are now available. Please review.'
        ..type = 'lab_result'
        ..isRead = false
        ..relatedResourceId = 'obs-krishna-hba1c'
        ..relatedRoute = '/medical-records'
        ..createdAt = now.subtract(const Duration(hours: 3))
        ..syncStatus = 0,
      NotificationRecordLocal()
        ..userEmail = 'krishna@example.com'
        ..title = 'Appointment Reminder'
        ..body = 'Virtual follow-up with Dr. Elena Vance in 5 days.'
        ..type = 'appointment'
        ..isRead = false
        ..relatedRoute = '/appointments'
        ..createdAt = now.subtract(const Duration(hours: 1))
        ..syncStatus = 0,
      NotificationRecordLocal()
        ..userEmail = 'priya@example.com'
        ..title = 'Upcoming Prenatal Visit'
        ..body = 'Your 32-week prenatal checkup with Dr. Nisha Poudel is in 3 days.'
        ..type = 'appointment'
        ..isRead = false
        ..relatedRoute = '/appointments'
        ..createdAt = now.subtract(const Duration(hours: 4))
        ..syncStatus = 0,
      NotificationRecordLocal()
        ..userEmail = 'maya@example.com'
        ..title = 'Prescription Refill Due'
        ..body = 'Your Salbutamol inhaler prescription is due for refill.'
        ..type = 'prescription'
        ..isRead = false
        ..relatedResourceId = 'medreq-maya-salbutamol'
        ..relatedRoute = '/medical-records'
        ..createdAt = now.subtract(const Duration(hours: 8))
        ..syncStatus = 0,
      NotificationRecordLocal()
        ..userEmail = 'deepak@example.com'
        ..title = 'Appointment Rescheduled'
        ..body = 'Your appointment with Dr. Rajesh Manandhar has been rescheduled to next week.'
        ..type = 'appointment'
        ..isRead = true
        ..relatedRoute = '/appointments'
        ..createdAt = now.subtract(const Duration(days: 2))
        ..syncStatus = 0,
      NotificationRecordLocal()
        ..userEmail = 'sunita@example.com'
        ..title = 'Blood Pressure Alert'
        ..body = 'Your recent BP reading (142/95) is elevated. Please follow up with your doctor.'
        ..type = 'alert'
        ..isRead = false
        ..relatedRoute = '/medical-records'
        ..createdAt = now.subtract(const Duration(hours: 12))
        ..syncStatus = 0,
      NotificationRecordLocal()
        ..userEmail = 'admin@example.com'
        ..title = 'New Verification Request'
        ..body = 'Dr. Bikesh Shrestha has submitted a practitioner verification request.'
        ..type = 'verification'
        ..isRead = false
        ..relatedResourceId = 'practitioner-bikesh'
        ..relatedRoute = '/admin'
        ..createdAt = now.subtract(const Duration(hours: 1))
        ..syncStatus = 0,
    ];

    for (final n in notifications) {
      await box.add(n);
    }
  }

  // ----------------------------------------------------------------
  // Seed: Appointments (15 total)
  // ----------------------------------------------------------------

  static Future<void> _seedAppointments(DateTime now) async {
    final box = DatabaseService.appointments;
    final today = DateTime(now.year, now.month, now.day);

    final appointments = [
      // -- Completed (past) --
      AppointmentLocal()
        ..patientRef = 'Patient/patient-arjun'
        ..practitionerRef = 'Practitioner/practitioner-arpan'
        ..practitionerName = 'Dr. Arpan K. Sharma'
        ..patientName = 'Arjun Maharjan'
        ..appointmentType = 'opd'
        ..status = 'completed'
        ..scheduledAt = today.subtract(const Duration(days: 14)).add(const Duration(hours: 9))
        ..durationMinutes = 30
        ..specialty = 'Cardiology'
        ..notes = 'Routine cardiology checkup, lipid panel review'
        ..createdAt = now
        ..syncStatus = 0,
      AppointmentLocal()
        ..patientRef = 'Patient/patient-sunita'
        ..practitionerRef = 'Practitioner/practitioner-elena'
        ..practitionerName = 'Dr. Elena Vance'
        ..patientName = 'Sunita Rajbhandari'
        ..appointmentType = 'opd'
        ..status = 'completed'
        ..scheduledAt = today.subtract(const Duration(days: 10)).add(const Duration(hours: 10))
        ..durationMinutes = 30
        ..specialty = 'Internal Medicine'
        ..notes = 'Hypertension follow-up, medication adjustment'
        ..createdAt = now
        ..syncStatus = 0,
      AppointmentLocal()
        ..patientRef = 'Patient/patient-krishna'
        ..practitionerRef = 'Practitioner/practitioner-elena'
        ..practitionerName = 'Dr. Elena Vance'
        ..patientName = 'Krishna Prasad Koirala'
        ..appointmentType = 'opd'
        ..status = 'completed'
        ..scheduledAt = today.subtract(const Duration(days: 4)).add(const Duration(hours: 9))
        ..durationMinutes = 30
        ..specialty = 'Internal Medicine'
        ..notes = 'Diabetes management review, HbA1c follow-up'
        ..createdAt = now
        ..syncStatus = 0,
      AppointmentLocal()
        ..patientRef = 'Patient/patient-maya'
        ..practitionerRef = 'Practitioner/practitioner-arpan'
        ..practitionerName = 'Dr. Arpan K. Sharma'
        ..patientName = 'Maya Rai'
        ..appointmentType = 'emergency'
        ..status = 'completed'
        ..scheduledAt = today.subtract(const Duration(days: 2)).add(const Duration(hours: 8))
        ..durationMinutes = 60
        ..specialty = 'Pulmonology'
        ..notes = 'COPD exacerbation emergency visit'
        ..createdAt = now
        ..syncStatus = 0,
      AppointmentLocal()
        ..patientRef = 'Patient/patient-sita'
        ..practitionerRef = 'Practitioner/practitioner-elena'
        ..practitionerName = 'Dr. Elena Vance'
        ..patientName = 'Sita Devi Gurung'
        ..appointmentType = 'opd'
        ..status = 'completed'
        ..scheduledAt = today.subtract(const Duration(days: 6)).add(const Duration(hours: 11))
        ..durationMinutes = 45
        ..specialty = 'Internal Medicine'
        ..notes = 'Annual physical examination'
        ..createdAt = now
        ..syncStatus = 0,
      // -- No-show --
      AppointmentLocal()
        ..patientRef = 'Patient/patient-deepak'
        ..practitionerRef = 'Practitioner/practitioner-rajesh'
        ..practitionerName = 'Dr. Rajesh Manandhar'
        ..patientName = 'Deepak Adhikari'
        ..appointmentType = 'opd'
        ..status = 'noshow'
        ..scheduledAt = today.subtract(const Duration(days: 7)).add(const Duration(hours: 14))
        ..durationMinutes = 50
        ..specialty = 'Psychiatry'
        ..notes = 'Initial psychiatric evaluation - patient did not attend'
        ..createdAt = now
        ..syncStatus = 0,
      // -- Cancelled --
      AppointmentLocal()
        ..patientRef = 'Patient/patient-ram'
        ..practitionerRef = 'Practitioner/practitioner-bikesh'
        ..practitionerName = 'Dr. Bikesh Shrestha'
        ..patientName = 'Ram Bahadur Thapa'
        ..appointmentType = 'opd'
        ..status = 'cancelled'
        ..scheduledAt = today.subtract(const Duration(days: 1)).add(const Duration(hours: 10))
        ..durationMinutes = 30
        ..specialty = 'Orthopedics'
        ..notes = 'Knee pain consultation - cancelled by patient'
        ..createdAt = now
        ..syncStatus = 0,
      // -- Booked (upcoming) --
      AppointmentLocal()
        ..patientRef = 'Patient/patient-arjun'
        ..practitionerRef = 'Practitioner/practitioner-arpan'
        ..practitionerName = 'Dr. Arpan K. Sharma'
        ..patientName = 'Arjun Maharjan'
        ..appointmentType = 'opd'
        ..status = 'booked'
        ..scheduledAt = today.add(const Duration(days: 1, hours: 9))
        ..durationMinutes = 30
        ..specialty = 'Cardiology'
        ..notes = 'Follow-up: medication review and ECG'
        ..createdAt = now
        ..syncStatus = 0,
      AppointmentLocal()
        ..patientRef = 'Patient/patient-sunita'
        ..practitionerRef = 'Practitioner/practitioner-elena'
        ..practitionerName = 'Dr. Elena Vance'
        ..patientName = 'Sunita Rajbhandari'
        ..appointmentType = 'opd'
        ..status = 'booked'
        ..scheduledAt = today.add(const Duration(days: 2, hours: 10))
        ..durationMinutes = 30
        ..specialty = 'Internal Medicine'
        ..notes = 'Blood pressure monitoring follow-up'
        ..createdAt = now
        ..syncStatus = 0,
      AppointmentLocal()
        ..patientRef = 'Patient/patient-priya'
        ..practitionerRef = 'Practitioner/practitioner-nisha'
        ..practitionerName = 'Dr. Nisha Poudel'
        ..patientName = 'Priya Tamang'
        ..appointmentType = 'opd'
        ..status = 'booked'
        ..scheduledAt = today.add(const Duration(days: 3, hours: 11))
        ..durationMinutes = 40
        ..specialty = 'OB/GYN'
        ..notes = '32-week prenatal checkup'
        ..createdAt = now
        ..syncStatus = 0,
      AppointmentLocal()
        ..patientRef = 'Patient/patient-krishna'
        ..practitionerRef = 'Practitioner/practitioner-elena'
        ..practitionerName = 'Dr. Elena Vance'
        ..patientName = 'Krishna Prasad Koirala'
        ..appointmentType = 'telemedicine'
        ..status = 'booked'
        ..scheduledAt = today.add(const Duration(days: 5, hours: 14))
        ..durationMinutes = 20
        ..specialty = 'Internal Medicine'
        ..notes = 'Virtual diabetes follow-up'
        ..createdAt = now
        ..syncStatus = 0,
      AppointmentLocal()
        ..patientRef = 'Patient/patient-deepak'
        ..practitionerRef = 'Practitioner/practitioner-rajesh'
        ..practitionerName = 'Dr. Rajesh Manandhar'
        ..patientName = 'Deepak Adhikari'
        ..appointmentType = 'opd'
        ..status = 'booked'
        ..scheduledAt = today.add(const Duration(days: 7, hours: 14))
        ..durationMinutes = 50
        ..specialty = 'Psychiatry'
        ..notes = 'Rescheduled initial psychiatric evaluation'
        ..createdAt = now
        ..syncStatus = 0,
      AppointmentLocal()
        ..patientRef = 'Patient/patient-ram'
        ..practitionerRef = 'Practitioner/practitioner-bikesh'
        ..practitionerName = 'Dr. Bikesh Shrestha'
        ..patientName = 'Ram Bahadur Thapa'
        ..appointmentType = 'opd'
        ..status = 'booked'
        ..scheduledAt = today.add(const Duration(days: 4, hours: 10))
        ..durationMinutes = 30
        ..specialty = 'Orthopedics'
        ..notes = 'Knee pain evaluation and X-ray review'
        ..createdAt = now
        ..syncStatus = 0,
      AppointmentLocal()
        ..patientRef = 'Patient/patient-maya'
        ..practitionerRef = 'Practitioner/practitioner-arpan'
        ..practitionerName = 'Dr. Arpan K. Sharma'
        ..patientName = 'Maya Rai'
        ..appointmentType = 'opd'
        ..status = 'booked'
        ..scheduledAt = today.add(const Duration(days: 10, hours: 9))
        ..durationMinutes = 30
        ..specialty = 'Pulmonology'
        ..notes = 'COPD post-exacerbation follow-up'
        ..createdAt = now
        ..syncStatus = 0,
      AppointmentLocal()
        ..patientRef = 'Patient/patient-sita'
        ..practitionerRef = 'Practitioner/practitioner-suman'
        ..practitionerName = 'Dr. Suman Karki'
        ..patientName = 'Sita Devi Gurung'
        ..appointmentType = 'opd'
        ..status = 'booked'
        ..scheduledAt = today.add(const Duration(days: 8, hours: 10))
        ..durationMinutes = 30
        ..specialty = 'Pediatrics'
        ..notes = 'Child vaccination consultation'
        ..createdAt = now
        ..syncStatus = 0,
    ];

    for (final a in appointments) {
      await box.add(a);
    }
  }

  // ----------------------------------------------------------------
  // Seed: Insurance Claims (4)
  // ----------------------------------------------------------------

  static Future<void> _seedInsuranceClaims(DateTime now) async {
    final box = DatabaseService.insuranceClaims;
    if (box.isNotEmpty) return;

    final claims = [
      InsuranceClaimLocal()
        ..patientRef = 'Patient/patient-maya'
        ..claimType = 'emergency'
        ..provider = 'Nepal Life Insurance'
        ..policyNumber = 'NLI-2024-8834'
        ..amount = 45000.0
        ..status = 'submitted'
        ..description = 'Emergency admission for COPD exacerbation'
        ..createdAt = now.subtract(const Duration(days: 1))
        ..syncStatus = 0,
      InsuranceClaimLocal()
        ..patientRef = 'Patient/patient-arjun'
        ..claimType = 'outpatient'
        ..provider = 'Sagarmatha Health Insurance'
        ..policyNumber = 'SHI-2024-1122'
        ..amount = 8500.0
        ..status = 'approved'
        ..description = 'Cardiology consultation and lipid panel'
        ..createdAt = now.subtract(const Duration(days: 10))
        ..syncStatus = 0,
      InsuranceClaimLocal()
        ..patientRef = 'Patient/patient-ram'
        ..claimType = 'outpatient'
        ..provider = 'Himalayan General Insurance'
        ..policyNumber = 'HGI-2024-5567'
        ..amount = 12000.0
        ..status = 'rejected'
        ..description = 'Orthopedic consultation - policy exclusion for pre-existing condition'
        ..createdAt = now.subtract(const Duration(days: 15))
        ..syncStatus = 0,
      InsuranceClaimLocal()
        ..patientRef = 'Patient/patient-priya'
        ..claimType = 'maternity'
        ..provider = 'Nepal Life Insurance'
        ..policyNumber = 'NLI-2024-9921'
        ..amount = 35000.0
        ..status = 'under-review'
        ..description = 'Prenatal care and obstetric ultrasound'
        ..createdAt = now.subtract(const Duration(days: 3))
        ..syncStatus = 0,
    ];

    for (final c in claims) {
      await box.add(c);
    }
  }

  // ----------------------------------------------------------------
  // Seed: Pharmacy Orders (4)
  // ----------------------------------------------------------------

  static Future<void> _seedPharmacyOrders(DateTime now) async {
    final box = DatabaseService.pharmacyOrders;
    if (box.isNotEmpty) return;

    final orders = [
      PharmacyOrderLocal()
        ..patientRef = 'Patient/patient-krishna'
        ..pharmacyName = 'Om Pharmacy'
        ..itemsJson = jsonEncode([
          {'name': 'Metformin 500mg', 'qty': 60, 'price': 120.0},
          {'name': 'Glucose test strips', 'qty': 50, 'price': 800.0},
        ])
        ..status = 'pending'
        ..totalPrice = 920.0
        ..deliveryAddress = 'Chitwan, Bharatpur-5'
        ..createdAt = now.subtract(const Duration(hours: 4))
        ..syncStatus = 0,
      PharmacyOrderLocal()
        ..patientRef = 'Patient/patient-sunita'
        ..pharmacyName = 'Kathmandu Pharmacy'
        ..itemsJson = jsonEncode([
          {'name': 'Amlodipine 5mg', 'qty': 30, 'price': 150.0},
        ])
        ..status = 'processing'
        ..totalPrice = 150.0
        ..createdAt = now.subtract(const Duration(hours: 8))
        ..syncStatus = 0,
      PharmacyOrderLocal()
        ..patientRef = 'Patient/patient-deepak'
        ..pharmacyName = 'Life Care Pharmacy'
        ..itemsJson = jsonEncode([
          {'name': 'Sertraline 50mg', 'qty': 30, 'price': 450.0},
        ])
        ..status = 'ready'
        ..totalPrice = 450.0
        ..createdAt = now.subtract(const Duration(days: 1))
        ..syncStatus = 0,
      PharmacyOrderLocal()
        ..patientRef = 'Patient/patient-maya'
        ..pharmacyName = 'Nepal Medicos'
        ..itemsJson = jsonEncode([
          {'name': 'Salbutamol inhaler', 'qty': 2, 'price': 600.0},
          {'name': 'Prednisolone 5mg', 'qty': 20, 'price': 80.0},
        ])
        ..status = 'delivered'
        ..totalPrice = 680.0
        ..deliveryAddress = 'Dharan-10, Sunsari'
        ..createdAt = now.subtract(const Duration(days: 2))
        ..syncStatus = 0,
    ];

    for (final o in orders) {
      await box.add(o);
    }
  }

  // ----------------------------------------------------------------
  // Seed: Lab Bookings (3)
  // ----------------------------------------------------------------

  static Future<void> _seedLabBookings(DateTime now) async {
    final box = DatabaseService.labBookings;
    if (box.isNotEmpty) return;

    final today = DateTime(now.year, now.month, now.day);

    final bookings = [
      LabBookingLocal()
        ..patientRef = 'Patient/patient-krishna'
        ..testsJson = jsonEncode([
          {'name': 'HbA1c', 'code': '4548-4'},
          {'name': 'Fasting Glucose', 'code': '1558-6'},
        ])
        ..status = 'scheduled'
        ..totalPrice = 1200.0
        ..scheduledAt = today.add(const Duration(days: 3, hours: 8))
        ..labName = 'Patan Hospital Lab'
        ..createdAt = now
        ..syncStatus = 0,
      LabBookingLocal()
        ..patientRef = 'Patient/patient-sita'
        ..testsJson = jsonEncode([
          {'name': 'Thyroid Panel', 'code': '3016-3'},
          {'name': 'CBC', 'code': '58410-2'},
        ])
        ..status = 'completed'
        ..totalPrice = 1800.0
        ..scheduledAt = today.subtract(const Duration(days: 2)).add(const Duration(hours: 7))
        ..labName = 'Grande Hospital Lab'
        ..createdAt = now.subtract(const Duration(days: 3))
        ..syncStatus = 0,
      LabBookingLocal()
        ..patientRef = 'Patient/patient-priya'
        ..testsJson = jsonEncode([
          {'name': 'Hemoglobin', 'code': '718-7'},
          {'name': 'Blood Group', 'code': '883-9'},
        ])
        ..status = 'scheduled'
        ..totalPrice = 600.0
        ..scheduledAt = today.add(const Duration(days: 2, hours: 9))
        ..labName = 'Nepal Mediciti Lab'
        ..createdAt = now
        ..syncStatus = 0,
    ];

    for (final b in bookings) {
      await box.add(b);
    }
  }

  // -- FHIR Resource Helpers --

  static FhirResource _patient(String id, List<String> given, String family, String gender, String birthDate, String healthId, String city) {
    final identifiers = <fhir.Identifier>[];
    if (healthId.isNotEmpty) {
      identifiers.add(fhir.Identifier(
        system: fhir.FhirUri('http://health.gov.np/fhir/sid/patient-id'),
        value: healthId,
      ));
    }
    final p = fhir.Patient(
      fhirId: id,
      name: [fhir.HumanName(given: given, family: family)],
      gender: fhir.FhirCode(gender),
      birthDate: fhir.FhirDate(birthDate),
      identifier: identifiers.isNotEmpty ? identifiers : null,
      address: [fhir.Address(city: city, country: 'Nepal')],
    );
    return FhirResource()
      ..fhirId = id
      ..resourceType = 'Patient'
      ..jsonData = jsonEncode(p.toJson())
      ..syncStatus = 0
      ..isDownloadedOffline = true
      ..lastUpdated = DateTime.now()
      ..createdAt = DateTime.now();
  }

  static FhirResource _practitioner(String id, List<String> prefix, List<String> given, String family, String qual, String nmc, String snomedCode) {
    final p = fhir.Practitioner(
      fhirId: id,
      active: fhir.FhirBoolean(true),
      name: [fhir.HumanName(prefix: prefix.isNotEmpty ? prefix : null, given: given, family: family)],
      identifier: [fhir.Identifier(system: fhir.FhirUri('http://nmc.org.np/fhir/sid/practitioner-license'), value: nmc)],
      qualification: [
        fhir.PractitionerQualification(
          code: fhir.CodeableConcept(
            coding: [fhir.Coding(system: fhir.FhirUri('http://snomed.info/sct'), code: fhir.FhirCode(snomedCode), display: qual)],
            text: qual,
          ),
        ),
      ],
    );
    return FhirResource()
      ..fhirId = id
      ..resourceType = 'Practitioner'
      ..jsonData = jsonEncode(p.toJson())
      ..syncStatus = 0
      ..isDownloadedOffline = true
      ..lastUpdated = DateTime.now()
      ..createdAt = DateTime.now();
  }

  static FhirResource _vitalSign(String id, String patientRef, String name, String loinc, num value, String unit, String unitCode, DateTime now) {
    final o = fhir.Observation(
      fhirId: id,
      status: fhir.FhirCode('final'),
      category: [fhir.CodeableConcept(coding: [fhir.Coding(system: fhir.FhirUri('http://terminology.hl7.org/CodeSystem/observation-category'), code: fhir.FhirCode('vital-signs'))])],
      code: fhir.CodeableConcept(coding: [fhir.Coding(system: fhir.FhirUri('http://loinc.org'), code: fhir.FhirCode(loinc), display: name)], text: name),
      subject: fhir.Reference(reference: patientRef),
      effectiveDateTime: fhir.FhirDateTime(now),
      valueQuantity: fhir.Quantity(value: fhir.FhirDecimal(value.toDouble()), unit: unit, system: fhir.FhirUri('http://unitsofmeasure.org'), code: fhir.FhirCode(unitCode)),
    );
    return FhirResource()
      ..fhirId = id
      ..resourceType = 'Observation'
      ..jsonData = jsonEncode(o.toJson())
      ..patientReference = patientRef
      ..category = 'vital-signs'
      ..syncStatus = 0
      ..isDownloadedOffline = true
      ..lastUpdated = now
      ..createdAt = now;
  }

  static FhirResource _bloodPressure(String id, String patientRef, int systolic, int diastolic, DateTime now) {
    final o = fhir.Observation(
      fhirId: id,
      status: fhir.FhirCode('final'),
      category: [fhir.CodeableConcept(coding: [fhir.Coding(system: fhir.FhirUri('http://terminology.hl7.org/CodeSystem/observation-category'), code: fhir.FhirCode('vital-signs'))])],
      code: fhir.CodeableConcept(coding: [fhir.Coding(system: fhir.FhirUri('http://loinc.org'), code: fhir.FhirCode('85354-9'), display: 'Blood Pressure')], text: 'Blood Pressure'),
      subject: fhir.Reference(reference: patientRef),
      effectiveDateTime: fhir.FhirDateTime(now),
      component: [
        fhir.ObservationComponent(
          code: fhir.CodeableConcept(coding: [fhir.Coding(system: fhir.FhirUri('http://loinc.org'), code: fhir.FhirCode('8480-6'), display: 'Systolic')]),
          valueQuantity: fhir.Quantity(value: fhir.FhirDecimal(systolic.toDouble()), unit: 'mmHg', system: fhir.FhirUri('http://unitsofmeasure.org'), code: fhir.FhirCode('mm[Hg]')),
        ),
        fhir.ObservationComponent(
          code: fhir.CodeableConcept(coding: [fhir.Coding(system: fhir.FhirUri('http://loinc.org'), code: fhir.FhirCode('8462-4'), display: 'Diastolic')]),
          valueQuantity: fhir.Quantity(value: fhir.FhirDecimal(diastolic.toDouble()), unit: 'mmHg', system: fhir.FhirUri('http://unitsofmeasure.org'), code: fhir.FhirCode('mm[Hg]')),
        ),
      ],
    );
    return FhirResource()
      ..fhirId = id
      ..resourceType = 'Observation'
      ..jsonData = jsonEncode(o.toJson())
      ..patientReference = patientRef
      ..category = 'vital-signs'
      ..syncStatus = 0
      ..isDownloadedOffline = true
      ..lastUpdated = now
      ..createdAt = now;
  }

  static FhirResource _labObservation(String id, String patientRef, String name, String loinc, num value, String unit, String unitCode, DateTime now) {
    final o = fhir.Observation(
      fhirId: id,
      status: fhir.FhirCode('final'),
      category: [fhir.CodeableConcept(coding: [fhir.Coding(system: fhir.FhirUri('http://terminology.hl7.org/CodeSystem/observation-category'), code: fhir.FhirCode('laboratory'))])],
      code: fhir.CodeableConcept(coding: [fhir.Coding(system: fhir.FhirUri('http://loinc.org'), code: fhir.FhirCode(loinc), display: name)], text: name),
      subject: fhir.Reference(reference: patientRef),
      effectiveDateTime: fhir.FhirDateTime(now.subtract(const Duration(days: 3))),
      issued: fhir.FhirInstant(now.subtract(const Duration(days: 2))),
      valueQuantity: fhir.Quantity(value: fhir.FhirDecimal(value.toDouble()), unit: unit, system: fhir.FhirUri('http://unitsofmeasure.org'), code: fhir.FhirCode(unitCode)),
    );
    return FhirResource()
      ..fhirId = id
      ..resourceType = 'Observation'
      ..jsonData = jsonEncode(o.toJson())
      ..patientReference = patientRef
      ..category = 'laboratory'
      ..syncStatus = 0
      ..isDownloadedOffline = true
      ..lastUpdated = now
      ..createdAt = now;
  }

  static FhirResource _diagnosticReport(String id, String patientRef, String title, String loinc, String conclusion, DateTime now) {
    final r = fhir.DiagnosticReport(
      fhirId: id,
      status: fhir.FhirCode('final'),
      code: fhir.CodeableConcept(coding: [fhir.Coding(system: fhir.FhirUri('http://loinc.org'), code: fhir.FhirCode(loinc), display: title)], text: title),
      subject: fhir.Reference(reference: patientRef),
      issued: fhir.FhirInstant(now.subtract(const Duration(days: 1))),
      effectiveDateTime: fhir.FhirDateTime(now.subtract(const Duration(days: 2))),
      conclusion: conclusion,
    );
    return FhirResource()
      ..fhirId = id
      ..resourceType = 'DiagnosticReport'
      ..jsonData = jsonEncode(r.toJson())
      ..patientReference = patientRef
      ..category = 'laboratory'
      ..syncStatus = 0
      ..isDownloadedOffline = true
      ..lastUpdated = now
      ..createdAt = now;
  }

  static FhirResource _medicationRequest(String id, String patientRef, String med, String rxnorm, String requesterRef, String dosageText, DateTime now) {
    final m = fhir.MedicationRequest(
      fhirId: id,
      status: fhir.FhirCode('active'),
      intent: fhir.FhirCode('order'),
      medicationCodeableConcept: fhir.CodeableConcept(
        coding: [fhir.Coding(system: fhir.FhirUri('http://www.nlm.nih.gov/research/umls/rxnorm'), code: fhir.FhirCode(rxnorm), display: med)],
        text: med,
      ),
      subject: fhir.Reference(reference: patientRef),
      requester: fhir.Reference(reference: requesterRef),
      authoredOn: fhir.FhirDateTime(now),
      dosageInstruction: [fhir.Dosage(text: dosageText)],
    );
    return FhirResource()
      ..fhirId = id
      ..resourceType = 'MedicationRequest'
      ..jsonData = jsonEncode(m.toJson())
      ..patientReference = patientRef
      ..practitionerReference = requesterRef
      ..syncStatus = 0
      ..isDownloadedOffline = true
      ..lastUpdated = now
      ..createdAt = now;
  }

  static FhirResource _immunization(String id, String patientRef, String vaccine, String cvx, String lotNumber, DateTime date) {
    final i = fhir.Immunization(
      fhirId: id,
      status: fhir.FhirCode('completed'),
      vaccineCode: fhir.CodeableConcept(
        coding: [fhir.Coding(system: fhir.FhirUri('http://hl7.org/fhir/sid/cvx'), code: fhir.FhirCode(cvx), display: vaccine)],
        text: vaccine,
      ),
      patient: fhir.Reference(reference: patientRef),
      occurrenceDateTime: fhir.FhirDateTime(date),
      lotNumber: lotNumber,
    );
    return FhirResource()
      ..fhirId = id
      ..resourceType = 'Immunization'
      ..jsonData = jsonEncode(i.toJson())
      ..patientReference = patientRef
      ..syncStatus = 0
      ..isDownloadedOffline = true
      ..lastUpdated = date
      ..createdAt = date;
  }

  static FhirResource _allergy(String id, String patientRef, String substance, String snomedCode, String category, String criticality, String recorderRef, DateTime now) {
    final a = fhir.AllergyIntolerance(
      fhirId: id,
      clinicalStatus: fhir.CodeableConcept(coding: [fhir.Coding(system: fhir.FhirUri('http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical'), code: fhir.FhirCode('active'))]),
      verificationStatus: fhir.CodeableConcept(coding: [fhir.Coding(system: fhir.FhirUri('http://terminology.hl7.org/CodeSystem/allergyintolerance-verification'), code: fhir.FhirCode('confirmed'))]),
      type: fhir.FhirCode('allergy'),
      category: [fhir.FhirCode(category)],
      criticality: fhir.FhirCode(criticality),
      code: fhir.CodeableConcept(
        coding: [fhir.Coding(system: fhir.FhirUri('http://snomed.info/sct'), code: fhir.FhirCode(snomedCode), display: substance)],
        text: substance,
      ),
      patient: fhir.Reference(reference: patientRef),
      recorder: fhir.Reference(reference: recorderRef),
      recordedDate: fhir.FhirDateTime(now),
    );
    return FhirResource()
      ..fhirId = id
      ..resourceType = 'AllergyIntolerance'
      ..jsonData = jsonEncode(a.toJson())
      ..patientReference = patientRef
      ..practitionerReference = recorderRef
      ..syncStatus = 0
      ..isDownloadedOffline = true
      ..lastUpdated = now
      ..createdAt = now;
  }

  static FhirResource _condition(String id, String patientRef, String icdCode, String display, String clinicalStatus, String verificationStatus, DateTime onset) {
    final json = {
      'resourceType': 'Condition',
      'id': id,
      'clinicalStatus': {'coding': [{'system': 'http://terminology.hl7.org/CodeSystem/condition-clinical', 'code': clinicalStatus}]},
      'verificationStatus': {'coding': [{'system': 'http://terminology.hl7.org/CodeSystem/condition-ver-status', 'code': verificationStatus}]},
      'code': {'coding': [{'system': 'http://hl7.org/fhir/sid/icd-10-cm', 'code': icdCode, 'display': display}], 'text': display},
      'subject': {'reference': patientRef},
      'onsetDateTime': onset.toIso8601String(),
      'recordedDate': onset.toIso8601String(),
    };
    return FhirResource()
      ..fhirId = id
      ..resourceType = 'Condition'
      ..jsonData = jsonEncode(json)
      ..patientReference = patientRef
      ..syncStatus = 0
      ..isDownloadedOffline = true
      ..lastUpdated = DateTime.now()
      ..createdAt = DateTime.now();
  }

  static FhirResource _encounter(String id, String patientRef, String practitionerRef, String status, String classCode, String classDisplay, String snomedCode, String snomedDisplay, String orgRef, DateTime start, DateTime end) {
    final json = {
      'resourceType': 'Encounter',
      'id': id,
      'status': status,
      'class': {'system': 'http://terminology.hl7.org/CodeSystem/v3-ActCode', 'code': classCode, 'display': classDisplay},
      'subject': {'reference': patientRef},
      'participant': [{'individual': {'reference': practitionerRef}}],
      'period': {'start': start.toIso8601String(), 'end': end.toIso8601String()},
      'reasonCode': [{'coding': [{'system': 'http://snomed.info/sct', 'code': snomedCode, 'display': snomedDisplay}]}],
      'serviceProvider': {'reference': orgRef},
    };
    return FhirResource()
      ..fhirId = id
      ..resourceType = 'Encounter'
      ..jsonData = jsonEncode(json)
      ..patientReference = patientRef
      ..practitionerReference = practitionerRef
      ..syncStatus = 0
      ..isDownloadedOffline = true
      ..lastUpdated = DateTime.now()
      ..createdAt = DateTime.now();
  }

  static FhirResource _consent(String id, String patientRef, String practitionerRef, String status, DateTime now) {
    final c = fhir.Consent(
      fhirId: id,
      status: fhir.FhirCode(status),
      scope: fhir.CodeableConcept(coding: [fhir.Coding(system: fhir.FhirUri('http://terminology.hl7.org/CodeSystem/consentscope'), code: fhir.FhirCode('patient-privacy'), display: 'Privacy Consent')]),
      category: [fhir.CodeableConcept(coding: [fhir.Coding(system: fhir.FhirUri('http://terminology.hl7.org/CodeSystem/consentcategorycodes'), code: fhir.FhirCode('59284-0'), display: 'Consent Document')])],
      patient: fhir.Reference(reference: patientRef),
      dateTime: fhir.FhirDateTime(now),
      performer: [fhir.Reference(reference: patientRef)],
      provision: fhir.ConsentProvision(
        type: fhir.FhirCode('permit'),
        actor: [
          fhir.ConsentActor(
            role: fhir.CodeableConcept(coding: [fhir.Coding(system: fhir.FhirUri('http://terminology.hl7.org/CodeSystem/v3-ParticipationType'), code: fhir.FhirCode('PRCP'), display: 'Primary information recipient')]),
            reference: fhir.Reference(reference: practitionerRef),
          ),
        ],
        action: [fhir.CodeableConcept(coding: [fhir.Coding(system: fhir.FhirUri('http://terminology.hl7.org/CodeSystem/consentaction'), code: fhir.FhirCode('access'))])],
      ),
    );
    return FhirResource()
      ..fhirId = id
      ..resourceType = 'Consent'
      ..jsonData = jsonEncode(c.toJson())
      ..patientReference = patientRef
      ..practitionerReference = practitionerRef
      ..syncStatus = 0
      ..isDownloadedOffline = true
      ..lastUpdated = now
      ..createdAt = now;
  }

  // ----------------------------------------------------------------
  // Seed: Encounters (typed collection)
  // ----------------------------------------------------------------

  static Future<void> _seedEncounters(DateTime now) async {
    final box = DatabaseService.encounters;
    if (box.isNotEmpty) return;

    final encounters = [
      EncounterLocal()
        ..fhirId = 'enc-arjun-cardio-01'
        ..patientRef = 'Patient/patient-arjun'
        ..practitionerRef = 'Practitioner/practitioner-arpan'
        ..status = 'finished'
        ..classCode = 'AMB'
        ..startDate = now.subtract(const Duration(days: 14))
        ..endDate = now.subtract(const Duration(days: 14)).add(const Duration(hours: 1))
        ..organizationRef = 'Organization/org-nepal-mediciti'
        ..reasonJson = jsonEncode(['Encounter for check up', 'Cardiology review'])
        ..serviceType = 'General'
        ..patientName = 'Arjun Maharjan'
        ..practitionerName = 'Dr. Arpan K. Sharma'
        ..createdAt = now.subtract(const Duration(days: 14))
        ..syncStatus = 0,
      EncounterLocal()
        ..fhirId = 'enc-sunita-htn-01'
        ..patientRef = 'Patient/patient-sunita'
        ..practitionerRef = 'Practitioner/practitioner-elena'
        ..status = 'finished'
        ..classCode = 'AMB'
        ..startDate = now.subtract(const Duration(days: 10))
        ..endDate = now.subtract(const Duration(days: 10)).add(const Duration(minutes: 45))
        ..organizationRef = 'Organization/org-patan-hospital'
        ..reasonJson = jsonEncode(['Hypertension follow-up', 'Medication review'])
        ..serviceType = 'Internal Medicine'
        ..patientName = 'Sunita Rajbhandari'
        ..practitionerName = 'Dr. Elena Vance'
        ..createdAt = now.subtract(const Duration(days: 10))
        ..syncStatus = 0,
      EncounterLocal()
        ..fhirId = 'enc-ram-knee-01'
        ..patientRef = 'Patient/patient-ram'
        ..practitionerRef = 'Practitioner/practitioner-bikesh'
        ..status = 'finished'
        ..classCode = 'AMB'
        ..startDate = now.subtract(const Duration(days: 7))
        ..endDate = now.subtract(const Duration(days: 7)).add(const Duration(minutes: 30))
        ..organizationRef = 'Organization/org-bir-hospital'
        ..reasonJson = jsonEncode(['Knee pain', 'Orthopedic evaluation'])
        ..serviceType = 'Orthopedics'
        ..patientName = 'Ram Bahadur Thapa'
        ..practitionerName = 'Dr. Bikesh Shrestha'
        ..createdAt = now.subtract(const Duration(days: 7))
        ..syncStatus = 0,
      EncounterLocal()
        ..fhirId = 'enc-priya-prenatal-01'
        ..patientRef = 'Patient/patient-priya'
        ..practitionerRef = 'Practitioner/practitioner-nisha'
        ..status = 'finished'
        ..classCode = 'AMB'
        ..startDate = now.subtract(const Duration(days: 5))
        ..endDate = now.subtract(const Duration(days: 5)).add(const Duration(minutes: 40))
        ..organizationRef = 'Organization/org-grande-hospital'
        ..reasonJson = jsonEncode(['Prenatal visit', '28-week checkup'])
        ..serviceType = 'OB/GYN'
        ..patientName = 'Priya Tamang'
        ..practitionerName = 'Dr. Nisha Poudel'
        ..createdAt = now.subtract(const Duration(days: 5))
        ..syncStatus = 0,
      EncounterLocal()
        ..fhirId = 'enc-krishna-diabetes-01'
        ..patientRef = 'Patient/patient-krishna'
        ..practitionerRef = 'Practitioner/practitioner-elena'
        ..status = 'finished'
        ..classCode = 'AMB'
        ..startDate = now.subtract(const Duration(days: 4))
        ..endDate = now.subtract(const Duration(days: 4)).add(const Duration(minutes: 30))
        ..organizationRef = 'Organization/org-nepal-mediciti'
        ..reasonJson = jsonEncode(['Diabetes management', 'HbA1c review'])
        ..serviceType = 'Internal Medicine'
        ..patientName = 'Krishna Prasad Koirala'
        ..practitionerName = 'Dr. Elena Vance'
        ..createdAt = now.subtract(const Duration(days: 4))
        ..syncStatus = 0,
      EncounterLocal()
        ..fhirId = 'enc-maya-copd-01'
        ..patientRef = 'Patient/patient-maya'
        ..practitionerRef = 'Practitioner/practitioner-arpan'
        ..status = 'finished'
        ..classCode = 'EMER'
        ..startDate = now.subtract(const Duration(days: 2))
        ..endDate = now.subtract(const Duration(days: 2)).add(const Duration(hours: 3))
        ..organizationRef = 'Organization/org-bir-hospital'
        ..reasonJson = jsonEncode(['COPD exacerbation', 'Acute respiratory distress'])
        ..serviceType = 'Emergency'
        ..patientName = 'Maya Rai'
        ..practitionerName = 'Dr. Arpan K. Sharma'
        ..createdAt = now.subtract(const Duration(days: 2))
        ..syncStatus = 0,
      EncounterLocal()
        ..fhirId = 'enc-deepak-anxiety-01'
        ..patientRef = 'Patient/patient-deepak'
        ..practitionerRef = 'Practitioner/practitioner-rajesh'
        ..status = 'finished'
        ..classCode = 'AMB'
        ..startDate = now.subtract(const Duration(days: 3))
        ..endDate = now.subtract(const Duration(days: 3)).add(const Duration(minutes: 50))
        ..organizationRef = 'Organization/org-patan-hospital'
        ..reasonJson = jsonEncode(['Anxiety disorder', 'Initial psychiatric evaluation'])
        ..serviceType = 'Psychiatry'
        ..patientName = 'Deepak Adhikari'
        ..practitionerName = 'Dr. Rajesh Manandhar'
        ..createdAt = now.subtract(const Duration(days: 3))
        ..syncStatus = 0,
      EncounterLocal()
        ..fhirId = 'enc-sita-physical-01'
        ..patientRef = 'Patient/patient-sita'
        ..practitionerRef = 'Practitioner/practitioner-elena'
        ..status = 'finished'
        ..classCode = 'AMB'
        ..startDate = now.subtract(const Duration(days: 6))
        ..endDate = now.subtract(const Duration(days: 6)).add(const Duration(hours: 1))
        ..organizationRef = 'Organization/org-grande-hospital'
        ..reasonJson = jsonEncode(['Annual physical examination', 'Thyroid screening'])
        ..serviceType = 'Internal Medicine'
        ..patientName = 'Sita Devi Gurung'
        ..practitionerName = 'Dr. Elena Vance'
        ..createdAt = now.subtract(const Duration(days: 6))
        ..syncStatus = 0,
    ];

    for (final e in encounters) {
      await box.add(e);
    }
  }

  // ----------------------------------------------------------------
  // Seed: Conditions (typed collection)
  // ----------------------------------------------------------------

  static Future<void> _seedConditions(DateTime now) async {
    final box = DatabaseService.conditions;
    if (box.isNotEmpty) return;

    final conditions = [
      ConditionLocal()
        ..fhirId = 'cond-krishna-diabetes'
        ..patientRef = 'Patient/patient-krishna'
        ..code = 'E11.9'
        ..displayName = 'Type 2 diabetes mellitus without complications'
        ..clinicalStatus = 'active'
        ..verificationStatus = 'confirmed'
        ..onsetDate = now.subtract(const Duration(days: 1825))
        ..recordedDate = now.subtract(const Duration(days: 1825))
        ..severity = 'moderate'
        ..recorderRef = 'Practitioner/practitioner-elena'
        ..createdAt = now.subtract(const Duration(days: 1825))
        ..syncStatus = 0,
      ConditionLocal()
        ..fhirId = 'cond-sunita-htn'
        ..patientRef = 'Patient/patient-sunita'
        ..code = 'I10'
        ..displayName = 'Essential (primary) hypertension'
        ..clinicalStatus = 'active'
        ..verificationStatus = 'confirmed'
        ..onsetDate = now.subtract(const Duration(days: 730))
        ..recordedDate = now.subtract(const Duration(days: 730))
        ..severity = 'moderate'
        ..recorderRef = 'Practitioner/practitioner-elena'
        ..createdAt = now.subtract(const Duration(days: 730))
        ..syncStatus = 0,
      ConditionLocal()
        ..fhirId = 'cond-maya-copd'
        ..patientRef = 'Patient/patient-maya'
        ..code = 'J44.1'
        ..displayName = 'Chronic obstructive pulmonary disease with acute exacerbation'
        ..clinicalStatus = 'active'
        ..verificationStatus = 'confirmed'
        ..onsetDate = now.subtract(const Duration(days: 3650))
        ..recordedDate = now.subtract(const Duration(days: 3650))
        ..severity = 'severe'
        ..recorderRef = 'Practitioner/practitioner-arpan'
        ..createdAt = now.subtract(const Duration(days: 3650))
        ..syncStatus = 0,
      ConditionLocal()
        ..fhirId = 'cond-priya-delivery'
        ..patientRef = 'Patient/patient-priya'
        ..code = 'O80'
        ..displayName = 'Encounter for full-term uncomplicated delivery'
        ..clinicalStatus = 'resolved'
        ..verificationStatus = 'confirmed'
        ..onsetDate = now.subtract(const Duration(days: 60))
        ..abatementDate = now.subtract(const Duration(days: 55))
        ..recordedDate = now.subtract(const Duration(days: 60))
        ..severity = 'moderate'
        ..recorderRef = 'Practitioner/practitioner-nisha'
        ..createdAt = now.subtract(const Duration(days: 60))
        ..syncStatus = 0,
      ConditionLocal()
        ..fhirId = 'cond-deepak-depression'
        ..patientRef = 'Patient/patient-deepak'
        ..code = 'F32.1'
        ..displayName = 'Major depressive disorder, single episode, moderate'
        ..clinicalStatus = 'active'
        ..verificationStatus = 'provisional'
        ..onsetDate = now.subtract(const Duration(days: 90))
        ..recordedDate = now.subtract(const Duration(days: 90))
        ..severity = 'moderate'
        ..recorderRef = 'Practitioner/practitioner-rajesh'
        ..createdAt = now.subtract(const Duration(days: 90))
        ..syncStatus = 0,
      ConditionLocal()
        ..fhirId = 'cond-ram-backpain'
        ..patientRef = 'Patient/patient-ram'
        ..code = 'M54.5'
        ..displayName = 'Low back pain'
        ..clinicalStatus = 'active'
        ..verificationStatus = 'confirmed'
        ..onsetDate = now.subtract(const Duration(days: 180))
        ..recordedDate = now.subtract(const Duration(days: 180))
        ..severity = 'moderate'
        ..bodySite = 'Lumbar spine'
        ..recorderRef = 'Practitioner/practitioner-bikesh'
        ..createdAt = now.subtract(const Duration(days: 180))
        ..syncStatus = 0,
      ConditionLocal()
        ..fhirId = 'cond-arjun-uri'
        ..patientRef = 'Patient/patient-arjun'
        ..code = 'J06.9'
        ..displayName = 'Acute upper respiratory infection, unspecified'
        ..clinicalStatus = 'resolved'
        ..verificationStatus = 'confirmed'
        ..onsetDate = now.subtract(const Duration(days: 30))
        ..abatementDate = now.subtract(const Duration(days: 20))
        ..recordedDate = now.subtract(const Duration(days: 30))
        ..severity = 'mild'
        ..recorderRef = 'Practitioner/practitioner-arpan'
        ..createdAt = now.subtract(const Duration(days: 30))
        ..syncStatus = 0,
      ConditionLocal()
        ..fhirId = 'cond-arjun-lipid'
        ..patientRef = 'Patient/patient-arjun'
        ..code = 'E78.5'
        ..displayName = 'Hyperlipidemia, unspecified'
        ..clinicalStatus = 'active'
        ..verificationStatus = 'confirmed'
        ..onsetDate = now.subtract(const Duration(days: 365))
        ..recordedDate = now.subtract(const Duration(days: 365))
        ..severity = 'moderate'
        ..recorderRef = 'Practitioner/practitioner-arpan'
        ..createdAt = now.subtract(const Duration(days: 365))
        ..syncStatus = 0,
    ];

    for (final c in conditions) {
      await box.add(c);
    }
  }

  // ----------------------------------------------------------------
  // Seed: Procedures
  // ----------------------------------------------------------------

  static Future<void> _seedProcedures(DateTime now) async {
    final box = DatabaseService.procedures;
    if (box.isNotEmpty) return;

    final procedures = [
      ProcedureLocal()
        ..fhirId = 'proc-arjun-blood-draw'
        ..patientRef = 'Patient/patient-arjun'
        ..encounterRef = 'Encounter/enc-arjun-cardio-01'
        ..code = '82078001'
        ..displayName = 'Venous blood draw'
        ..status = 'completed'
        ..performedDate = now.subtract(const Duration(days: 14))
        ..performerRef = 'Practitioner/practitioner-anjali'
        ..performerName = 'Anjali Sharma'
        ..bodySite = 'Left arm'
        ..createdAt = now.subtract(const Duration(days: 14))
        ..syncStatus = 0,
      ProcedureLocal()
        ..fhirId = 'proc-sunita-ecg'
        ..patientRef = 'Patient/patient-sunita'
        ..encounterRef = 'Encounter/enc-sunita-htn-01'
        ..code = '29303009'
        ..displayName = 'Electrocardiogram (ECG)'
        ..status = 'completed'
        ..performedDate = now.subtract(const Duration(days: 10))
        ..performerRef = 'Practitioner/practitioner-elena'
        ..performerName = 'Dr. Elena Vance'
        ..bodySite = 'Chest'
        ..createdAt = now.subtract(const Duration(days: 10))
        ..syncStatus = 0,
      ProcedureLocal()
        ..fhirId = 'proc-maya-nebulizer'
        ..patientRef = 'Patient/patient-maya'
        ..encounterRef = 'Encounter/enc-maya-copd-01'
        ..code = '44738004'
        ..displayName = 'Nebulizer therapy'
        ..status = 'completed'
        ..performedDate = now.subtract(const Duration(days: 2))
        ..performerRef = 'Practitioner/practitioner-anjali'
        ..performerName = 'Anjali Sharma'
        ..bodySite = 'Respiratory'
        ..createdAt = now.subtract(const Duration(days: 2))
        ..syncStatus = 0,
    ];

    for (final p in procedures) {
      await box.add(p);
    }
  }

  // ----------------------------------------------------------------
  // Seed: Care Plans
  // ----------------------------------------------------------------

  static Future<void> _seedCarePlans(DateTime now) async {
    final box = DatabaseService.carePlans;
    if (box.isNotEmpty) return;

    final carePlans = [
      CarePlanLocal()
        ..fhirId = 'cp-krishna-diabetes'
        ..patientRef = 'Patient/patient-krishna'
        ..status = 'active'
        ..intent = 'plan'
        ..title = 'Diabetes Management Plan'
        ..category = 'disease-management'
        ..periodStart = now.subtract(const Duration(days: 90))
        ..periodEnd = now.add(const Duration(days: 275))
        ..activitiesJson = jsonEncode([
            {'description': 'Daily blood glucose monitoring', 'status': 'in-progress'},
            {'description': 'HbA1c test every 3 months', 'status': 'scheduled'},
            {'description': 'Dietary consultation monthly', 'status': 'in-progress'},
          ])
        ..goalsJson = jsonEncode([
            {'description': 'HbA1c below 7%', 'target': '< 7%', 'dueDate': now.add(const Duration(days: 90)).toIso8601String()},
            {'description': 'Fasting glucose 80-130 mg/dL', 'target': '80-130 mg/dL'},
          ])
        ..authorRef = 'Practitioner/practitioner-elena'
        ..notes = 'Patient has been compliant with medication. Needs dietary improvement.'
        ..createdAt = now.subtract(const Duration(days: 90))
        ..syncStatus = 0,
      CarePlanLocal()
        ..fhirId = 'cp-maya-copd'
        ..patientRef = 'Patient/patient-maya'
        ..status = 'active'
        ..intent = 'plan'
        ..title = 'COPD Management Plan'
        ..category = 'disease-management'
        ..periodStart = now.subtract(const Duration(days: 2))
        ..periodEnd = now.add(const Duration(days: 180))
        ..activitiesJson = jsonEncode([
            {'description': 'Daily inhaler use (Salbutamol)', 'status': 'in-progress'},
            {'description': 'Pulmonary rehab exercises', 'status': 'scheduled'},
            {'description': 'Follow-up in 2 weeks', 'status': 'scheduled'},
          ])
        ..goalsJson = jsonEncode([
            {'description': 'SpO2 above 92%', 'target': '> 92%'},
            {'description': 'Reduce exacerbations to < 2/year', 'target': '< 2 per year'},
          ])
        ..authorRef = 'Practitioner/practitioner-arpan'
        ..notes = 'Post-exacerbation plan. Patient to avoid cold and polluted environments.'
        ..createdAt = now.subtract(const Duration(days: 2))
        ..syncStatus = 0,
    ];

    for (final cp in carePlans) {
      await box.add(cp);
    }
  }

  // ----------------------------------------------------------------
  // Seed: Service Requests
  // ----------------------------------------------------------------

  static Future<void> _seedServiceRequests(DateTime now) async {
    final box = DatabaseService.serviceRequests;
    if (box.isNotEmpty) return;

    final requests = [
      ServiceRequestLocal()
        ..fhirId = 'sr-krishna-hba1c'
        ..patientRef = 'Patient/patient-krishna'
        ..requesterRef = 'Practitioner/practitioner-elena'
        ..requesterName = 'Dr. Elena Vance'
        ..code = '4548-4'
        ..displayName = 'Hemoglobin A1c (HbA1c)'
        ..status = 'active'
        ..intent = 'order'
        ..priority = 'routine'
        ..category = 'laboratory'
        ..encounterRef = 'Encounter/enc-krishna-diabetes-01'
        ..occurrenceDate = now.add(const Duration(days: 3))
        ..createdAt = now
        ..syncStatus = 0,
      ServiceRequestLocal()
        ..fhirId = 'sr-maya-xray'
        ..patientRef = 'Patient/patient-maya'
        ..requesterRef = 'Practitioner/practitioner-arpan'
        ..requesterName = 'Dr. Arpan K. Sharma'
        ..code = '36643-5'
        ..displayName = 'Chest X-Ray PA and Lateral'
        ..status = 'completed'
        ..intent = 'order'
        ..priority = 'urgent'
        ..category = 'imaging'
        ..encounterRef = 'Encounter/enc-maya-copd-01'
        ..occurrenceDate = now.subtract(const Duration(days: 2))
        ..createdAt = now.subtract(const Duration(days: 2))
        ..syncStatus = 0,
      ServiceRequestLocal()
        ..fhirId = 'sr-priya-hgb'
        ..patientRef = 'Patient/patient-priya'
        ..requesterRef = 'Practitioner/practitioner-nisha'
        ..requesterName = 'Dr. Nisha Poudel'
        ..code = '718-7'
        ..displayName = 'Hemoglobin'
        ..status = 'active'
        ..intent = 'order'
        ..priority = 'routine'
        ..category = 'laboratory'
        ..encounterRef = 'Encounter/enc-priya-prenatal-01'
        ..occurrenceDate = now.add(const Duration(days: 2))
        ..createdAt = now
        ..syncStatus = 0,
    ];

    for (final sr in requests) {
      await box.add(sr);
    }
  }

  // ----------------------------------------------------------------
  // Seed: Medication Requests (typed)
  // ----------------------------------------------------------------

  static Future<void> _seedMedicationRequests(DateTime now) async {
    final box = DatabaseService.medicationRequests;
    if (box.isNotEmpty) return;

    final meds = [
      MedicationRequestLocal()
        ..fhirId = 'medreq-krishna-metformin-typed'
        ..patientRef = 'Patient/patient-krishna'
        ..requesterRef = 'Practitioner/practitioner-elena'
        ..requesterName = 'Dr. Elena Vance'
        ..medicationCode = '861007'
        ..medicationName = 'Metformin 500mg'
        ..status = 'active'
        ..dosageJson = jsonEncode({'text': '500mg orally twice daily with meals', 'frequency': 'BID'})
        ..dispenseJson = jsonEncode({'quantity': 60, 'unit': 'tablets', 'refills': 5})
        ..encounterRef = 'Encounter/enc-krishna-diabetes-01'
        ..createdAt = now.subtract(const Duration(days: 4))
        ..syncStatus = 0,
      MedicationRequestLocal()
        ..fhirId = 'medreq-sunita-amlodipine-typed'
        ..patientRef = 'Patient/patient-sunita'
        ..requesterRef = 'Practitioner/practitioner-elena'
        ..requesterName = 'Dr. Elena Vance'
        ..medicationCode = '329528'
        ..medicationName = 'Amlodipine 5mg'
        ..status = 'active'
        ..dosageJson = jsonEncode({'text': '5mg once daily in the morning', 'frequency': 'QD'})
        ..dispenseJson = jsonEncode({'quantity': 30, 'unit': 'tablets', 'refills': 3})
        ..encounterRef = 'Encounter/enc-sunita-htn-01'
        ..createdAt = now.subtract(const Duration(days: 10))
        ..syncStatus = 0,
      MedicationRequestLocal()
        ..fhirId = 'medreq-maya-salbutamol-typed'
        ..patientRef = 'Patient/patient-maya'
        ..requesterRef = 'Practitioner/practitioner-arpan'
        ..requesterName = 'Dr. Arpan K. Sharma'
        ..medicationCode = '435'
        ..medicationName = 'Salbutamol inhaler'
        ..status = 'active'
        ..dosageJson = jsonEncode({'text': '2 puffs every 4-6 hours as needed', 'frequency': 'PRN'})
        ..dispenseJson = jsonEncode({'quantity': 1, 'unit': 'inhaler', 'refills': 2})
        ..encounterRef = 'Encounter/enc-maya-copd-01'
        ..createdAt = now.subtract(const Duration(days: 2))
        ..syncStatus = 0,
      MedicationRequestLocal()
        ..fhirId = 'medreq-deepak-sertraline-typed'
        ..patientRef = 'Patient/patient-deepak'
        ..requesterRef = 'Practitioner/practitioner-rajesh'
        ..requesterName = 'Dr. Rajesh Manandhar'
        ..medicationCode = '312938'
        ..medicationName = 'Sertraline 50mg'
        ..status = 'active'
        ..dosageJson = jsonEncode({'text': '50mg once daily in the morning', 'frequency': 'QD'})
        ..dispenseJson = jsonEncode({'quantity': 30, 'unit': 'tablets', 'refills': 2})
        ..encounterRef = 'Encounter/enc-deepak-anxiety-01'
        ..createdAt = now.subtract(const Duration(days: 3))
        ..syncStatus = 0,
      MedicationRequestLocal()
        ..fhirId = 'medreq-ram-ibuprofen-typed'
        ..patientRef = 'Patient/patient-ram'
        ..requesterRef = 'Practitioner/practitioner-bikesh'
        ..requesterName = 'Dr. Bikesh Shrestha'
        ..medicationCode = '5640'
        ..medicationName = 'Ibuprofen 400mg'
        ..status = 'active'
        ..dosageJson = jsonEncode({'text': '400mg orally three times daily with food', 'frequency': 'TID'})
        ..dispenseJson = jsonEncode({'quantity': 30, 'unit': 'tablets', 'refills': 1})
        ..encounterRef = 'Encounter/enc-ram-knee-01'
        ..createdAt = now.subtract(const Duration(days: 7))
        ..syncStatus = 0,
      MedicationRequestLocal()
        ..fhirId = 'medreq-priya-prenatal-typed'
        ..patientRef = 'Patient/patient-priya'
        ..requesterRef = 'Practitioner/practitioner-nisha'
        ..requesterName = 'Dr. Nisha Poudel'
        ..medicationCode = '904420'
        ..medicationName = 'Prenatal Vitamins'
        ..status = 'active'
        ..dosageJson = jsonEncode({'text': '1 tablet daily', 'frequency': 'QD'})
        ..dispenseJson = jsonEncode({'quantity': 30, 'unit': 'tablets', 'refills': 6})
        ..encounterRef = 'Encounter/enc-priya-prenatal-01'
        ..createdAt = now.subtract(const Duration(days: 5))
        ..syncStatus = 0,
    ];

    for (final m in meds) {
      await box.add(m);
    }
  }

  // ----------------------------------------------------------------
  // Seed: Locations
  // ----------------------------------------------------------------

  static Future<void> _seedLocations(DateTime now) async {
    final box = DatabaseService.locations;
    if (box.isNotEmpty) return;

    final locations = [
      LocationLocal()
        ..fhirId = 'loc-bir-er'
        ..name = 'Emergency Room'
        ..type = 'wing'
        ..description = 'Bir Hospital Emergency Department'
        ..organizationRef = 'Organization/org-bir-hospital'
        ..status = 'active'
        ..physicalType = 'wing'
        ..createdAt = now
        ..syncStatus = 0,
      LocationLocal()
        ..fhirId = 'loc-bir-icu'
        ..name = 'Intensive Care Unit'
        ..type = 'wing'
        ..description = 'Bir Hospital ICU \u2014 12 beds'
        ..organizationRef = 'Organization/org-bir-hospital'
        ..status = 'active'
        ..physicalType = 'wing'
        ..createdAt = now
        ..syncStatus = 0,
      LocationLocal()
        ..fhirId = 'loc-bir-opd'
        ..name = 'Outpatient Department'
        ..type = 'wing'
        ..description = 'Bir Hospital OPD \u2014 Ground Floor'
        ..organizationRef = 'Organization/org-bir-hospital'
        ..status = 'active'
        ..physicalType = 'wing'
        ..createdAt = now
        ..syncStatus = 0,
      LocationLocal()
        ..fhirId = 'loc-patan-er'
        ..name = 'Emergency Room'
        ..type = 'wing'
        ..description = 'Patan Hospital Emergency Department'
        ..organizationRef = 'Organization/org-patan-hospital'
        ..status = 'active'
        ..physicalType = 'wing'
        ..createdAt = now
        ..syncStatus = 0,
      LocationLocal()
        ..fhirId = 'loc-patan-lab'
        ..name = 'Pathology Laboratory'
        ..type = 'area'
        ..description = 'Patan Hospital Laboratory \u2014 2nd Floor'
        ..organizationRef = 'Organization/org-patan-hospital'
        ..status = 'active'
        ..physicalType = 'area'
        ..createdAt = now
        ..syncStatus = 0,
      LocationLocal()
        ..fhirId = 'loc-grande-radiology'
        ..name = 'Radiology Department'
        ..type = 'area'
        ..description = 'Grande International Hospital \u2014 CT, MRI, X-Ray'
        ..organizationRef = 'Organization/org-grande-hospital'
        ..status = 'active'
        ..physicalType = 'area'
        ..createdAt = now
        ..syncStatus = 0,
    ];

    for (final l in locations) {
      await box.add(l);
    }
  }

  // ----------------------------------------------------------------
  // Seed: Healthcare Services
  // ----------------------------------------------------------------

  static Future<void> _seedHealthcareServices(DateTime now) async {
    final box = DatabaseService.healthcareServices;
    if (box.isNotEmpty) return;

    final services = [
      HealthcareServiceLocal()
        ..fhirId = 'hs-bir-emergency'
        ..organizationRef = 'Organization/org-bir-hospital'
        ..name = 'Emergency Services'
        ..type = 'emergency'
        ..specialty = 'Emergency Medicine'
        ..locationRef = 'Location/loc-bir-er'
        ..active = true
        ..comment = '24/7 emergency care'
        ..createdAt = now
        ..syncStatus = 0,
      HealthcareServiceLocal()
        ..fhirId = 'hs-bir-cardiology'
        ..organizationRef = 'Organization/org-bir-hospital'
        ..name = 'Cardiology OPD'
        ..type = 'cardiology-opd'
        ..specialty = 'Cardiology'
        ..locationRef = 'Location/loc-bir-opd'
        ..active = true
        ..comment = 'Sun-Fri 09:00-16:00'
        ..createdAt = now
        ..syncStatus = 0,
      HealthcareServiceLocal()
        ..fhirId = 'hs-patan-lab'
        ..organizationRef = 'Organization/org-patan-hospital'
        ..name = 'Pathology & Lab Services'
        ..type = 'laboratory'
        ..specialty = 'Pathology'
        ..locationRef = 'Location/loc-patan-lab'
        ..active = true
        ..comment = 'Sun-Fri 07:00-18:00, Sat 07:00-12:00'
        ..createdAt = now
        ..syncStatus = 0,
      HealthcareServiceLocal()
        ..fhirId = 'hs-grande-radiology'
        ..organizationRef = 'Organization/org-grande-hospital'
        ..name = 'Radiology & Imaging'
        ..type = 'radiology'
        ..specialty = 'Radiology'
        ..locationRef = 'Location/loc-grande-radiology'
        ..active = true
        ..comment = 'CT, MRI, X-Ray, Ultrasound \u2014 24/7'
        ..createdAt = now
        ..syncStatus = 0,
    ];

    for (final s in services) {
      await box.add(s);
    }
  }

  // ----------------------------------------------------------------
  // Seed: Practitioner Roles
  // ----------------------------------------------------------------

  static Future<void> _seedPractitionerRoles(DateTime now) async {
    final box = DatabaseService.practitionerRoles;
    if (box.isNotEmpty) return;

    final roles = [
      PractitionerRoleLocal()
        ..fhirId = 'pr-arpan-mediciti'
        ..practitionerRef = 'Practitioner/practitioner-arpan'
        ..organizationRef = 'Organization/org-nepal-mediciti'
        ..code = 'doctor'
        ..specialty = 'Cardiology'
        ..active = true
        ..practitionerName = 'Dr. Arpan K. Sharma'
        ..organizationName = 'Nepal Mediciti'
        ..createdAt = now
        ..syncStatus = 0,
      PractitionerRoleLocal()
        ..fhirId = 'pr-arpan-bir'
        ..practitionerRef = 'Practitioner/practitioner-arpan'
        ..organizationRef = 'Organization/org-bir-hospital'
        ..code = 'doctor'
        ..specialty = 'Cardiology'
        ..active = true
        ..practitionerName = 'Dr. Arpan K. Sharma'
        ..organizationName = 'Bir Hospital'
        ..createdAt = now
        ..syncStatus = 0,
      PractitionerRoleLocal()
        ..fhirId = 'pr-elena-grande'
        ..practitionerRef = 'Practitioner/practitioner-elena'
        ..organizationRef = 'Organization/org-grande-hospital'
        ..code = 'doctor'
        ..specialty = 'Internal Medicine'
        ..active = true
        ..practitionerName = 'Dr. Elena Vance'
        ..organizationName = 'Grande International Hospital'
        ..createdAt = now
        ..syncStatus = 0,
      PractitionerRoleLocal()
        ..fhirId = 'pr-elena-patan'
        ..practitionerRef = 'Practitioner/practitioner-elena'
        ..organizationRef = 'Organization/org-patan-hospital'
        ..code = 'doctor'
        ..specialty = 'Internal Medicine'
        ..active = true
        ..practitionerName = 'Dr. Elena Vance'
        ..organizationName = 'Patan Hospital'
        ..createdAt = now
        ..syncStatus = 0,
      PractitionerRoleLocal()
        ..fhirId = 'pr-anjali-bir'
        ..practitionerRef = 'Practitioner/practitioner-anjali'
        ..organizationRef = 'Organization/org-bir-hospital'
        ..code = 'nurse'
        ..specialty = 'General Nursing'
        ..active = true
        ..practitionerName = 'Anjali Sharma'
        ..organizationName = 'Bir Hospital'
        ..createdAt = now
        ..syncStatus = 0,
      PractitionerRoleLocal()
        ..fhirId = 'pr-bikesh-patan'
        ..practitionerRef = 'Practitioner/practitioner-bikesh'
        ..organizationRef = 'Organization/org-patan-hospital'
        ..code = 'doctor'
        ..specialty = 'Orthopedics'
        ..active = true
        ..practitionerName = 'Dr. Bikesh Shrestha'
        ..organizationName = 'Patan Hospital'
        ..createdAt = now
        ..syncStatus = 0,
      PractitionerRoleLocal()
        ..fhirId = 'pr-suman-norvic'
        ..practitionerRef = 'Practitioner/practitioner-suman'
        ..organizationRef = 'Organization/org-norvic'
        ..code = 'doctor'
        ..specialty = 'Pediatrics'
        ..active = true
        ..practitionerName = 'Dr. Suman Karki'
        ..organizationName = 'Norvic International Hospital'
        ..createdAt = now
        ..syncStatus = 0,
      PractitionerRoleLocal()
        ..fhirId = 'pr-nisha-mediciti'
        ..practitionerRef = 'Practitioner/practitioner-nisha'
        ..organizationRef = 'Organization/org-nepal-mediciti'
        ..code = 'doctor'
        ..specialty = 'OB/GYN'
        ..active = true
        ..practitionerName = 'Dr. Nisha Poudel'
        ..organizationName = 'Nepal Mediciti'
        ..createdAt = now
        ..syncStatus = 0,
      PractitionerRoleLocal()
        ..fhirId = 'pr-rajesh-grande'
        ..practitionerRef = 'Practitioner/practitioner-rajesh'
        ..organizationRef = 'Organization/org-grande-hospital'
        ..code = 'doctor'
        ..specialty = 'Psychiatry'
        ..active = true
        ..practitionerName = 'Dr. Rajesh Manandhar'
        ..organizationName = 'Grande International Hospital'
        ..createdAt = now
        ..syncStatus = 0,
    ];

    for (final r in roles) {
      await box.add(r);
    }
  }

  // ----------------------------------------------------------------
  // Seed: Slots
  // ----------------------------------------------------------------

  static Future<void> _seedSlots(DateTime now) async {
    final box = DatabaseService.slots;
    if (box.isNotEmpty) return;

    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final dayAfter = DateTime(now.year, now.month, now.day + 2);

    final slots = [
      // Dr. Arpan morning slots at Nepal Mediciti
      for (int i = 0; i < 9; i++)
        SlotLocal()
          ..fhirId = 'slot-arpan-mediciti-am-$i'
          ..scheduleRef = 'Schedule/sched-arpan-mediciti'
          ..status = i < 3 ? 'busy' : 'free'
          ..startTime = tomorrow.add(Duration(hours: 9, minutes: i * 20))
          ..endTime = tomorrow.add(Duration(hours: 9, minutes: (i + 1) * 20))
          ..serviceType = 'General'
          ..practitionerRef = 'Practitioner/practitioner-arpan'
          ..organizationRef = 'Organization/org-nepal-mediciti'
          ..maxPatients = 1
          ..bookedCount = i < 3 ? 1 : 0
          ..createdAt = now
          ..syncStatus = 0,
      // Dr. Elena afternoon slots at Grande Hospital
      for (int i = 0; i < 6; i++)
        SlotLocal()
          ..fhirId = 'slot-elena-grande-pm-$i'
          ..scheduleRef = 'Schedule/sched-elena-grande'
          ..status = i < 1 ? 'busy' : 'free'
          ..startTime = tomorrow.add(Duration(hours: 14, minutes: i * 30))
          ..endTime = tomorrow.add(Duration(hours: 14, minutes: (i + 1) * 30))
          ..serviceType = 'General'
          ..practitionerRef = 'Practitioner/practitioner-elena'
          ..organizationRef = 'Organization/org-grande-hospital'
          ..maxPatients = 1
          ..bookedCount = i < 1 ? 1 : 0
          ..createdAt = now
          ..syncStatus = 0,
      // Dr. Arpan telehealth slots at Bir Hospital
      for (int i = 0; i < 6; i++)
        SlotLocal()
          ..fhirId = 'slot-arpan-bir-tele-$i'
          ..scheduleRef = 'Schedule/sched-arpan-bir'
          ..status = 'free'
          ..startTime = dayAfter.add(Duration(hours: 10, minutes: i * 30))
          ..endTime = dayAfter.add(Duration(hours: 10, minutes: (i + 1) * 30))
          ..serviceType = 'Telehealth'
          ..practitionerRef = 'Practitioner/practitioner-arpan'
          ..organizationRef = 'Organization/org-bir-hospital'
          ..maxPatients = 1
          ..bookedCount = 0
          ..createdAt = now
          ..syncStatus = 0,
      // Dr. Nisha slots at Nepal Mediciti
      for (int i = 0; i < 6; i++)
        SlotLocal()
          ..fhirId = 'slot-nisha-mediciti-am-$i'
          ..scheduleRef = 'Schedule/sched-nisha-mediciti'
          ..status = i < 2 ? 'busy' : 'free'
          ..startTime = tomorrow.add(Duration(hours: 9, minutes: i * 30))
          ..endTime = tomorrow.add(Duration(hours: 9, minutes: (i + 1) * 30))
          ..serviceType = 'General'
          ..practitionerRef = 'Practitioner/practitioner-nisha'
          ..organizationRef = 'Organization/org-nepal-mediciti'
          ..maxPatients = 1
          ..bookedCount = i < 2 ? 1 : 0
          ..createdAt = now
          ..syncStatus = 0,
      // Dr. Rajesh slots at Grande Hospital
      for (int i = 0; i < 4; i++)
        SlotLocal()
          ..fhirId = 'slot-rajesh-grande-pm-$i'
          ..scheduleRef = 'Schedule/sched-rajesh-grande'
          ..status = 'free'
          ..startTime = tomorrow.add(Duration(hours: 14, minutes: i * 50))
          ..endTime = tomorrow.add(Duration(hours: 14, minutes: (i + 1) * 50))
          ..serviceType = 'General'
          ..practitionerRef = 'Practitioner/practitioner-rajesh'
          ..organizationRef = 'Organization/org-grande-hospital'
          ..maxPatients = 1
          ..bookedCount = 0
          ..createdAt = now
          ..syncStatus = 0,
    ];

    for (final s in slots) {
      await box.add(s);
    }
  }

  // ----------------------------------------------------------------
  // Seed: Immunizations (typed collection)
  // ----------------------------------------------------------------

  static Future<void> _seedTypedImmunizations(DateTime now) async {
    final box = DatabaseService.immunizations;
    if (box.isNotEmpty) return;

    final immunizations = [
      ImmunizationLocal()
        ..fhirId = 'imm-arjun-covid-typed'
        ..patientRef = 'Patient/patient-arjun'
        ..vaccineCode = '208'
        ..vaccineName = 'COVID-19 Vaccine (Pfizer-BioNTech)'
        ..occurrenceDate = now.subtract(const Duration(days: 180))
        ..status = 'completed'
        ..lotNumber = 'CV2024-KTM-4521'
        ..site = 'Left deltoid'
        ..routeOfAdmin = 'Intramuscular'
        ..doseQuantity = '0.3 mL'
        ..performerRef = 'Practitioner/practitioner-anjali'
        ..createdAt = now.subtract(const Duration(days: 180))
        ..syncStatus = 0,
      ImmunizationLocal()
        ..fhirId = 'imm-arjun-flu-typed'
        ..patientRef = 'Patient/patient-arjun'
        ..vaccineCode = '140'
        ..vaccineName = 'Influenza Vaccine (Quadrivalent)'
        ..occurrenceDate = now.subtract(const Duration(days: 60))
        ..status = 'completed'
        ..lotNumber = 'FL2025-KTM-001'
        ..site = 'Left deltoid'
        ..routeOfAdmin = 'Intramuscular'
        ..doseQuantity = '0.5 mL'
        ..performerRef = 'Practitioner/practitioner-anjali'
        ..createdAt = now.subtract(const Duration(days: 60))
        ..syncStatus = 0,
      ImmunizationLocal()
        ..fhirId = 'imm-priya-bcg-typed'
        ..patientRef = 'Patient/patient-priya'
        ..vaccineCode = '19'
        ..vaccineName = 'BCG Vaccine'
        ..occurrenceDate = now.subtract(const Duration(days: 9125))
        ..status = 'completed'
        ..lotNumber = 'BCG1998-NPL-001'
        ..site = 'Left deltoid'
        ..routeOfAdmin = 'Intradermal'
        ..doseQuantity = '0.1 mL'
        ..createdAt = now.subtract(const Duration(days: 9125))
        ..syncStatus = 0,
      ImmunizationLocal()
        ..fhirId = 'imm-deepak-hepb-typed'
        ..patientRef = 'Patient/patient-deepak'
        ..vaccineCode = '08'
        ..vaccineName = 'Hepatitis B Vaccine'
        ..occurrenceDate = now.subtract(const Duration(days: 365))
        ..status = 'completed'
        ..lotNumber = 'HB2025-KTM-789'
        ..site = 'Right deltoid'
        ..routeOfAdmin = 'Intramuscular'
        ..doseQuantity = '1.0 mL'
        ..performerRef = 'Practitioner/practitioner-elena'
        ..createdAt = now.subtract(const Duration(days: 365))
        ..syncStatus = 0,
      ImmunizationLocal()
        ..fhirId = 'imm-ram-dpt-typed'
        ..patientRef = 'Patient/patient-ram'
        ..vaccineCode = '20'
        ..vaccineName = 'DPT Vaccine'
        ..occurrenceDate = now.subtract(const Duration(days: 21900))
        ..status = 'completed'
        ..lotNumber = 'DPT1965-NPL-012'
        ..site = 'Left thigh'
        ..routeOfAdmin = 'Intramuscular'
        ..doseQuantity = '0.5 mL'
        ..createdAt = now.subtract(const Duration(days: 21900))
        ..syncStatus = 0,
    ];

    for (final i in immunizations) {
      await box.add(i);
    }
  }

  // ----------------------------------------------------------------
  // Seed: Allergy Intolerances (typed collection)
  // ----------------------------------------------------------------

  static Future<void> _seedTypedAllergyIntolerances(DateTime now) async {
    final box = DatabaseService.allergyIntolerances;
    if (box.isNotEmpty) return;

    final allergies = [
      AllergyIntoleranceLocal()
        ..fhirId = 'allergy-sunita-pen-typed'
        ..patientRef = 'Patient/patient-sunita'
        ..code = '764146007'
        ..displayName = 'Penicillin'
        ..clinicalStatus = 'active'
        ..verificationStatus = 'confirmed'
        ..type = 'allergy'
        ..category = 'medication'
        ..criticality = 'high'
        ..onsetDate = now.subtract(const Duration(days: 3650))
        ..reactionJson = jsonEncode([{'manifestation': 'Anaphylaxis', 'severity': 'severe'}])
        ..recorderRef = 'Practitioner/practitioner-elena'
        ..createdAt = now.subtract(const Duration(days: 3650))
        ..syncStatus = 0,
      AllergyIntoleranceLocal()
        ..fhirId = 'allergy-ram-sulfa-typed'
        ..patientRef = 'Patient/patient-ram'
        ..code = '91936005'
        ..displayName = 'Sulfa drugs'
        ..clinicalStatus = 'active'
        ..verificationStatus = 'confirmed'
        ..type = 'allergy'
        ..category = 'medication'
        ..criticality = 'high'
        ..onsetDate = now.subtract(const Duration(days: 7300))
        ..reactionJson = jsonEncode([{'manifestation': 'Rash', 'severity': 'moderate'}, {'manifestation': 'Nausea', 'severity': 'mild'}])
        ..recorderRef = 'Practitioner/practitioner-bikesh'
        ..createdAt = now.subtract(const Duration(days: 7300))
        ..syncStatus = 0,
      AllergyIntoleranceLocal()
        ..fhirId = 'allergy-priya-latex-typed'
        ..patientRef = 'Patient/patient-priya'
        ..code = '111088007'
        ..displayName = 'Latex'
        ..clinicalStatus = 'active'
        ..verificationStatus = 'confirmed'
        ..type = 'allergy'
        ..category = 'environment'
        ..criticality = 'low'
        ..onsetDate = now.subtract(const Duration(days: 730))
        ..reactionJson = jsonEncode([{'manifestation': 'Contact dermatitis', 'severity': 'mild'}])
        ..recorderRef = 'Practitioner/practitioner-nisha'
        ..createdAt = now.subtract(const Duration(days: 730))
        ..syncStatus = 0,
      AllergyIntoleranceLocal()
        ..fhirId = 'allergy-deepak-dust-typed'
        ..patientRef = 'Patient/patient-deepak'
        ..code = '260147004'
        ..displayName = 'Dust mites'
        ..clinicalStatus = 'active'
        ..verificationStatus = 'confirmed'
        ..type = 'allergy'
        ..category = 'environment'
        ..criticality = 'low'
        ..onsetDate = now.subtract(const Duration(days: 1825))
        ..reactionJson = jsonEncode([{'manifestation': 'Rhinitis', 'severity': 'mild'}, {'manifestation': 'Sneezing', 'severity': 'mild'}])
        ..recorderRef = 'Practitioner/practitioner-rajesh'
        ..createdAt = now.subtract(const Duration(days: 1825))
        ..syncStatus = 0,
      AllergyIntoleranceLocal()
        ..fhirId = 'allergy-krishna-aspirin-typed'
        ..patientRef = 'Patient/patient-krishna'
        ..code = '387458008'
        ..displayName = 'Aspirin'
        ..clinicalStatus = 'active'
        ..verificationStatus = 'confirmed'
        ..type = 'allergy'
        ..category = 'medication'
        ..criticality = 'high'
        ..onsetDate = now.subtract(const Duration(days: 3650))
        ..reactionJson = jsonEncode([{'manifestation': 'Bronchospasm', 'severity': 'severe'}, {'manifestation': 'Urticaria', 'severity': 'moderate'}])
        ..recorderRef = 'Practitioner/practitioner-elena'
        ..createdAt = now.subtract(const Duration(days: 3650))
        ..syncStatus = 0,
    ];

    for (final a in allergies) {
      await box.add(a);
    }
  }

  // ----------------------------------------------------------------
  // Seed: Audit Events
  // ----------------------------------------------------------------

  static Future<void> _seedAuditEvents(DateTime now) async {
    final box = DatabaseService.auditEvents;
    if (box.isNotEmpty) return;

    final events = [
      AuditEventLocal()
        ..fhirId = 'audit-login-arpan'
        ..type = 'user-auth'
        ..action = 'login'
        ..recorded = now.subtract(const Duration(hours: 2))
        ..agentRef = 'practitioner-arpan'
        ..agentName = 'Dr. Arpan K. Sharma'
        ..outcome = 'success'
        ..detail = 'Login from mobile app'
        ..createdAt = now.subtract(const Duration(hours: 2))
        ..syncStatus = 0,
      AuditEventLocal()
        ..fhirId = 'audit-access-arjun-records'
        ..type = 'data-access'
        ..action = 'read'
        ..recorded = now.subtract(const Duration(hours: 1))
        ..agentRef = 'practitioner-arpan'
        ..agentName = 'Dr. Arpan K. Sharma'
        ..entityRef = 'Patient/patient-arjun'
        ..entityType = 'Patient'
        ..outcome = 'success'
        ..detail = 'Viewed patient medical records'
        ..createdAt = now.subtract(const Duration(hours: 1))
        ..syncStatus = 0,
      AuditEventLocal()
        ..fhirId = 'audit-create-encounter'
        ..type = 'rest'
        ..action = 'create'
        ..recorded = now
        ..agentRef = 'practitioner-arpan'
        ..agentName = 'Dr. Arpan K. Sharma'
        ..entityRef = 'Encounter/enc-arjun-cardio-01'
        ..entityType = 'Encounter'
        ..outcome = 'success'
        ..detail = 'Started cardiology encounter for Arjun Maharjan'
        ..createdAt = now
        ..syncStatus = 0,
      AuditEventLocal()
        ..fhirId = 'audit-verify-bikesh'
        ..type = 'admin'
        ..action = 'update'
        ..recorded = now.subtract(const Duration(days: 1))
        ..agentRef = 'admin'
        ..agentName = 'System Admin'
        ..entityRef = 'Practitioner/practitioner-bikesh'
        ..entityType = 'Practitioner'
        ..outcome = 'success'
        ..detail = 'Approved practitioner verification for Dr. Bikesh Shrestha'
        ..createdAt = now.subtract(const Duration(days: 1))
        ..syncStatus = 0,
      AuditEventLocal()
        ..fhirId = 'audit-consent-krishna'
        ..type = 'data-access'
        ..action = 'create'
        ..recorded = now.subtract(const Duration(hours: 4))
        ..agentRef = 'patient-krishna'
        ..agentName = 'Krishna Prasad Koirala'
        ..entityRef = 'Consent/consent-krishna-elena'
        ..entityType = 'Consent'
        ..outcome = 'success'
        ..detail = 'Granted data access consent to Dr. Elena Vance'
        ..createdAt = now.subtract(const Duration(hours: 4))
        ..syncStatus = 0,
    ];

    for (final e in events) {
      await box.add(e);
    }
  }

  // ----------------------------------------------------------------
  // Seed: RBAC Permissions
  // ----------------------------------------------------------------

  static Future<void> _seedRbacPermissions(DateTime now) async {
    final box = DatabaseService.rbacPermissions;
    if (box.isNotEmpty) return;

    const resources = ['patients', 'encounters', 'appointments', 'organizations', 'users', 'audit_log', 'settings', 'reports'];
    const actions = ['read', 'create', 'update', 'delete', 'export'];

    const rolePermissions = {
      'patient': {
        'patients': ['read'],
        'encounters': ['read'],
        'appointments': ['read', 'create', 'update'],
        'organizations': ['read'],
        'reports': ['read', 'export'],
      },
      'doctor': {
        'patients': ['read', 'create', 'update'],
        'encounters': ['read', 'create', 'update'],
        'appointments': ['read', 'create', 'update', 'delete'],
        'organizations': ['read'],
        'reports': ['read', 'create', 'export'],
      },
      'nurse': {
        'patients': ['read', 'update'],
        'encounters': ['read', 'create', 'update'],
        'appointments': ['read', 'update'],
        'organizations': ['read'],
        'reports': ['read'],
      },
      'admin': {
        'patients': ['read', 'create', 'update', 'delete', 'export'],
        'encounters': ['read', 'create', 'update', 'delete', 'export'],
        'appointments': ['read', 'create', 'update', 'delete', 'export'],
        'organizations': ['read', 'create', 'update', 'delete'],
        'users': ['read', 'create', 'update', 'delete'],
        'audit_log': ['read', 'export'],
        'settings': ['read', 'update'],
        'reports': ['read', 'create', 'update', 'delete', 'export'],
      },
    };

    for (final role in rolePermissions.entries) {
      final roleId = role.key;
      final roleName = roleId[0].toUpperCase() + roleId.substring(1);
      final allowed = role.value;

      for (final resource in resources) {
        for (final action in actions) {
          final isAllowed = allowed[resource]?.contains(action) ?? false;
          final perm = RbacPermissionLocal()
            ..roleId = roleId
            ..roleName = roleName
            ..resource = resource
            ..action = action
            ..isAllowed = isAllowed
            ..createdAt = now;
          await box.add(perm);
        }
      }
    }
  }

  // ----------------------------------------------------------------
  // Seed: Clinical action permissions (consumed by Can / canProvider)
  // ----------------------------------------------------------------

  /// Idempotent — seeds doctor/nurse rows for the clinical CTAs gated by
  /// the `Can` widget. Safe to call alongside `_seedRbacPermissions`; only
  /// inserts rows whose `(roleId, resource, action)` triple is missing.
  static Future<void> _seedClinicalActionPermissions(DateTime now) async {
    final box = DatabaseService.rbacPermissions;

    // resource.action → {roleCode: allowed}
    const matrix = <String, Map<String, bool>>{
      'encounter.sign':      {'doctor': true,  'nurse': false},
      'encounter.finalize':  {'doctor': true,  'nurse': false},
      'prescription.issue':  {'doctor': true,  'nurse': false},
      'order.lab':           {'doctor': true,  'nurse': false},
      'order.imaging':       {'doctor': true,  'nurse': false},
      'vitals.record':       {'doctor': true,  'nurse': true},
      'triage.update':       {'doctor': true,  'nurse': true},
    };

    bool exists(String roleId, String resource, String action) {
      return box.values.any((p) =>
          p.roleId == roleId &&
          p.resource == resource &&
          p.action == action);
    }

    for (final entry in matrix.entries) {
      final parts = entry.key.split('.');
      final resource = parts[0];
      final action = parts[1];
      for (final role in entry.value.entries) {
        if (exists(role.key, resource, action)) continue;
        final perm = RbacPermissionLocal()
          ..roleId = role.key
          ..roleName = role.key[0].toUpperCase() + role.key.substring(1)
          ..resource = resource
          ..action = action
          ..isAllowed = role.value
          ..createdAt = now;
        await box.add(perm);
      }
    }
  }
}
