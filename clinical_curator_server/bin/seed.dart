import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:serverpod/serverpod.dart';

import 'package:clinical_curator_server/src/generated/endpoints.dart';
import 'package:clinical_curator_server/src/generated/protocol.dart';

/// Seeds the PostgreSQL database with rich FHIR R4-compliant clinical data
/// for development and testing.
///
/// Seed version: 2.0 — expanded with 16 users, 60+ FHIR resources,
/// encounters, conditions, medications, labs, immunizations, allergies,
/// diagnostic reports, appointments, notifications, insurance claims,
/// pharmacy orders, and schedule slots for all practitioners.
void main(List<String> args) async {
  final pod = Serverpod(['--mode', 'development', '--apply-migrations'],
      Protocol(), Endpoints());
  await pod.start();

  final session = await pod.createSession();

  try {
    // Check seed version for incremental updates
    final existingUsers = await UserAccount.db.count(session);
    if (existingUsers > 0) {
      print('Database already seeded ($existingUsers users found). Skipping.');
      await session.close();
      await pod.shutdown();
      return;
    }

    print('Seeding database...');
    final now = DateTime.now();

    // ── Hashed Passwords ───────────────────────────────────────────────────
    final patientPassword = BCrypt.hashpw('password123', BCrypt.gensalt());
    final adminPassword = BCrypt.hashpw('admin123', BCrypt.gensalt());

    // ── User Accounts (16 total) ───────────────────────────────────────────
    final accounts = [
      // -- Existing patients --
      UserAccount(
        email: 'arjun@example.com',
        passwordHash: patientPassword,
        displayName: 'Arjun Maharjan',
        isPractitioner: false,
        isVerified: false,
        healthId: 'NEP-2024-8842-19',
        accountType: 'patient',
        fhirPatientId: 'patient-arjun',
        createdAt: now,
      ),
      UserAccount(
        email: 'sunita@example.com',
        passwordHash: patientPassword,
        displayName: 'Sunita Rajbhandari',
        isPractitioner: false,
        isVerified: false,
        healthId: 'NEP-2024-7731-05',
        accountType: 'patient',
        fhirPatientId: 'patient-sunita',
        createdAt: now,
      ),
      // -- New patients --
      UserAccount(
        email: 'ram@example.com',
        passwordHash: patientPassword,
        displayName: 'Ram Bahadur Thapa',
        isPractitioner: false,
        isVerified: false,
        healthId: 'NEP-2024-3341-07',
        accountType: 'patient',
        fhirPatientId: 'patient-ram',
        createdAt: now,
      ),
      UserAccount(
        email: 'sita@example.com',
        passwordHash: patientPassword,
        displayName: 'Sita Devi Gurung',
        isPractitioner: false,
        isVerified: false,
        healthId: 'NEP-2024-4452-11',
        accountType: 'patient',
        fhirPatientId: 'patient-sita',
        createdAt: now,
      ),
      UserAccount(
        email: 'deepak@example.com',
        passwordHash: patientPassword,
        displayName: 'Deepak Adhikari',
        isPractitioner: false,
        isVerified: false,
        healthId: 'NEP-2024-5563-23',
        accountType: 'patient',
        fhirPatientId: 'patient-deepak',
        createdAt: now,
      ),
      UserAccount(
        email: 'priya@example.com',
        passwordHash: patientPassword,
        displayName: 'Priya Tamang',
        isPractitioner: false,
        isVerified: false,
        healthId: 'NEP-2024-6674-35',
        accountType: 'patient',
        fhirPatientId: 'patient-priya',
        createdAt: now,
      ),
      UserAccount(
        email: 'krishna@example.com',
        passwordHash: patientPassword,
        displayName: 'Krishna Prasad Koirala',
        isPractitioner: false,
        isVerified: false,
        healthId: 'NEP-2024-7785-47',
        accountType: 'patient',
        fhirPatientId: 'patient-krishna',
        createdAt: now,
      ),
      UserAccount(
        email: 'maya@example.com',
        passwordHash: patientPassword,
        displayName: 'Maya Rai',
        isPractitioner: false,
        isVerified: false,
        healthId: 'NEP-2024-8896-59',
        accountType: 'patient',
        fhirPatientId: 'patient-maya',
        createdAt: now,
      ),
      // -- Existing practitioners --
      UserAccount(
        email: 'arpan@example.com',
        passwordHash: patientPassword,
        displayName: 'Dr. Arpan K. Sharma',
        isPractitioner: true,
        isVerified: true,
        practitionerType: 'doctor',
        accountType: 'practitioner',
        fhirPatientId: 'patient-arpan',
        fhirPractitionerId: 'practitioner-arpan',
        createdAt: now,
      ),
      UserAccount(
        email: 'elena@example.com',
        passwordHash: patientPassword,
        displayName: 'Dr. Elena Vance',
        isPractitioner: true,
        isVerified: true,
        practitionerType: 'doctor',
        accountType: 'practitioner',
        fhirPatientId: 'patient-elena',
        fhirPractitionerId: 'practitioner-elena',
        createdAt: now,
      ),
      UserAccount(
        email: 'anjali@example.com',
        passwordHash: patientPassword,
        displayName: 'Anjali Sharma',
        isPractitioner: true,
        isVerified: true,
        practitionerType: 'nurse',
        accountType: 'practitioner',
        fhirPatientId: 'patient-anjali',
        fhirPractitionerId: 'practitioner-anjali',
        createdAt: now,
      ),
      UserAccount(
        email: 'bikesh@example.com',
        passwordHash: patientPassword,
        displayName: 'Dr. Bikesh Shrestha',
        isPractitioner: true,
        isVerified: false,
        practitionerType: 'doctor',
        accountType: 'practitioner',
        fhirPatientId: 'patient-bikesh',
        fhirPractitionerId: 'practitioner-bikesh',
        createdAt: now,
      ),
      // -- New practitioners --
      UserAccount(
        email: 'suman@example.com',
        passwordHash: patientPassword,
        displayName: 'Dr. Suman Karki',
        isPractitioner: true,
        isVerified: true,
        practitionerType: 'doctor',
        accountType: 'practitioner',
        fhirPatientId: 'patient-suman',
        fhirPractitionerId: 'practitioner-suman',
        createdAt: now,
      ),
      UserAccount(
        email: 'nisha@example.com',
        passwordHash: patientPassword,
        displayName: 'Dr. Nisha Poudel',
        isPractitioner: true,
        isVerified: true,
        practitionerType: 'doctor',
        accountType: 'practitioner',
        fhirPatientId: 'patient-nisha',
        fhirPractitionerId: 'practitioner-nisha',
        createdAt: now,
      ),
      UserAccount(
        email: 'rajesh@example.com',
        passwordHash: patientPassword,
        displayName: 'Dr. Rajesh Manandhar',
        isPractitioner: true,
        isVerified: true,
        practitionerType: 'doctor',
        accountType: 'practitioner',
        fhirPatientId: 'patient-rajesh',
        fhirPractitionerId: 'practitioner-rajesh',
        createdAt: now,
      ),
      // -- Admin --
      UserAccount(
        email: 'admin@example.com',
        passwordHash: adminPassword,
        displayName: 'Admin User',
        isPractitioner: false,
        isVerified: true,
        accountType: 'admin',
        createdAt: now,
      ),
    ];

    for (final a in accounts) {
      await UserAccount.db.insertRow(session, a);
    }
    print('  \u2713 ${accounts.length} user accounts');

    // ── FHIR Patient Resources ─────────────────────────────────────────────
    final patientData = [
      {'id': 'patient-arjun', 'given': 'Arjun', 'family': 'Maharjan', 'gender': 'male', 'birthDate': '1990-05-15', 'healthId': 'NEP-2024-8842-19', 'address': 'Kathmandu'},
      {'id': 'patient-sunita', 'given': 'Sunita', 'family': 'Rajbhandari', 'gender': 'female', 'birthDate': '1985-11-22', 'healthId': 'NEP-2024-7731-05', 'address': 'Kathmandu'},
      {'id': 'patient-arpan', 'given': 'Arpan', 'family': 'Sharma', 'gender': 'male', 'birthDate': '1978-03-10', 'healthId': '', 'address': 'Kathmandu'},
      {'id': 'patient-elena', 'given': 'Elena', 'family': 'Vance', 'gender': 'female', 'birthDate': '1982-07-04', 'healthId': '', 'address': 'Kathmandu'},
      {'id': 'patient-anjali', 'given': 'Anjali', 'family': 'Sharma', 'gender': 'female', 'birthDate': '1993-01-28', 'healthId': '', 'address': 'Kathmandu'},
      {'id': 'patient-bikesh', 'given': 'Bikesh', 'family': 'Shrestha', 'gender': 'male', 'birthDate': '1988-09-14', 'healthId': '', 'address': 'Kathmandu'},
      {'id': 'patient-ram', 'given': 'Ram Bahadur', 'family': 'Thapa', 'gender': 'male', 'birthDate': '1961-03-20', 'healthId': 'NEP-2024-3341-07', 'address': 'Pokhara'},
      {'id': 'patient-sita', 'given': 'Sita Devi', 'family': 'Gurung', 'gender': 'female', 'birthDate': '1981-08-12', 'healthId': 'NEP-2024-4452-11', 'address': 'Bhaktapur'},
      {'id': 'patient-deepak', 'given': 'Deepak', 'family': 'Adhikari', 'gender': 'male', 'birthDate': '1994-01-05', 'healthId': 'NEP-2024-5563-23', 'address': 'Kathmandu'},
      {'id': 'patient-priya', 'given': 'Priya', 'family': 'Tamang', 'gender': 'female', 'birthDate': '1998-06-18', 'healthId': 'NEP-2024-6674-35', 'address': 'Lalitpur'},
      {'id': 'patient-krishna', 'given': 'Krishna Prasad', 'family': 'Koirala', 'gender': 'male', 'birthDate': '1971-11-30', 'healthId': 'NEP-2024-7785-47', 'address': 'Chitwan'},
      {'id': 'patient-maya', 'given': 'Maya', 'family': 'Rai', 'gender': 'female', 'birthDate': '1954-04-08', 'healthId': 'NEP-2024-8896-59', 'address': 'Dharan'},
    ];

    for (final p in patientData) {
      final json = <String, dynamic>{
        'resourceType': 'Patient',
        'id': p['id'],
        'name': [{'given': [p['given']], 'family': p['family']}],
        'gender': p['gender'],
        'birthDate': p['birthDate'],
        'address': [{'city': p['address'], 'country': 'Nepal'}],
      };
      if ((p['healthId'] as String).isNotEmpty) {
        json['identifier'] = [
          {'system': 'http://health.gov.np/fhir/sid/patient-id', 'value': p['healthId']},
        ];
      }
      await FhirResourceRecord.db.insertRow(session, FhirResourceRecord(
        fhirId: p['id']!,
        resourceType: 'Patient',
        jsonData: jsonEncode(json),
        syncVersion: 0,
        lastUpdated: now,
        createdAt: now,
      ));
    }
    print('  \u2713 ${patientData.length} Patient resources');

    // ── FHIR Practitioner Resources ────────────────────────────────────────
    final practitionerData = [
      {'id': 'practitioner-arpan', 'prefix': 'Dr.', 'given': 'Arpan K.', 'family': 'Sharma', 'specialty': 'Cardiology', 'license': 'NMC-12345', 'snomedCode': '394579002'},
      {'id': 'practitioner-elena', 'prefix': 'Dr.', 'given': 'Elena', 'family': 'Vance', 'specialty': 'Internal Medicine', 'license': 'NMC-67890', 'snomedCode': '394802001'},
      {'id': 'practitioner-anjali', 'prefix': '', 'given': 'Anjali', 'family': 'Sharma', 'specialty': 'ICU Nursing', 'license': 'NNC-44321', 'snomedCode': '394618009'},
      {'id': 'practitioner-bikesh', 'prefix': 'Dr.', 'given': 'Bikesh', 'family': 'Shrestha', 'specialty': 'Orthopedics', 'license': 'NMC-99887', 'snomedCode': '394801008'},
      {'id': 'practitioner-suman', 'prefix': 'Dr.', 'given': 'Suman', 'family': 'Karki', 'specialty': 'Pediatrics', 'license': 'NMC-55431', 'snomedCode': '394537008'},
      {'id': 'practitioner-nisha', 'prefix': 'Dr.', 'given': 'Nisha', 'family': 'Poudel', 'specialty': 'OB/GYN', 'license': 'NMC-66789', 'snomedCode': '394586005'},
      {'id': 'practitioner-rajesh', 'prefix': 'Dr.', 'given': 'Rajesh', 'family': 'Manandhar', 'specialty': 'Psychiatry', 'license': 'NMC-77234', 'snomedCode': '394587001'},
    ];

    for (final p in practitionerData) {
      final json = {
        'resourceType': 'Practitioner',
        'id': p['id'],
        'active': true,
        'name': [{'prefix': p['prefix']!.isNotEmpty ? [p['prefix']] : null, 'given': [p['given']], 'family': p['family']}],
        'identifier': [{'system': 'http://nmc.org.np/fhir/sid/practitioner-license', 'value': p['license']}],
        'qualification': [
          {
            'code': {
              'coding': [{'system': 'http://snomed.info/sct', 'code': p['snomedCode'], 'display': p['specialty']}],
              'text': p['specialty'],
            },
          },
        ],
      };
      await FhirResourceRecord.db.insertRow(session, FhirResourceRecord(
        fhirId: p['id']!,
        resourceType: 'Practitioner',
        jsonData: jsonEncode(json),
        practitionerReference: 'Practitioner/${p['id']}',
        syncVersion: 0,
        lastUpdated: now,
        createdAt: now,
      ));
    }
    print('  \u2713 ${practitionerData.length} Practitioner resources');

    // ── Vital-Sign Observations ────────────────────────────────────────────
    final vitals = [
      {'id': 'obs-arjun-hr', 'patient': 'Patient/patient-arjun', 'name': 'Heart Rate', 'loinc': '8867-4', 'value': 95, 'unit': 'bpm', 'code': '/min'},
      {'id': 'obs-arjun-temp', 'patient': 'Patient/patient-arjun', 'name': 'Body Temperature', 'loinc': '8310-5', 'value': 98.6, 'unit': '\u00b0F', 'code': '[degF]'},
      {'id': 'obs-arjun-spo2', 'patient': 'Patient/patient-arjun', 'name': 'Oxygen Saturation', 'loinc': '2708-6', 'value': 98, 'unit': '%', 'code': '%'},
      {'id': 'obs-sunita-hr', 'patient': 'Patient/patient-sunita', 'name': 'Heart Rate', 'loinc': '8867-4', 'value': 112, 'unit': 'bpm', 'code': '/min'},
      {'id': 'obs-sunita-spo2', 'patient': 'Patient/patient-sunita', 'name': 'Oxygen Saturation', 'loinc': '2708-6', 'value': 91, 'unit': '%', 'code': '%'},
      {'id': 'obs-ram-hr', 'patient': 'Patient/patient-ram', 'name': 'Heart Rate', 'loinc': '8867-4', 'value': 78, 'unit': 'bpm', 'code': '/min'},
      {'id': 'obs-krishna-temp', 'patient': 'Patient/patient-krishna', 'name': 'Body Temperature', 'loinc': '8310-5', 'value': 99.1, 'unit': '\u00b0F', 'code': '[degF]'},
      {'id': 'obs-maya-spo2', 'patient': 'Patient/patient-maya', 'name': 'Oxygen Saturation', 'loinc': '2708-6', 'value': 88, 'unit': '%', 'code': '%'},
      {'id': 'obs-priya-hr', 'patient': 'Patient/patient-priya', 'name': 'Heart Rate', 'loinc': '8867-4', 'value': 82, 'unit': 'bpm', 'code': '/min'},
    ];

    for (final v in vitals) {
      final json = {
        'resourceType': 'Observation',
        'id': v['id'],
        'status': 'final',
        'category': [{'coding': [{'system': 'http://terminology.hl7.org/CodeSystem/observation-category', 'code': 'vital-signs'}]}],
        'code': {'coding': [{'system': 'http://loinc.org', 'code': v['loinc'], 'display': v['name']}], 'text': v['name']},
        'subject': {'reference': v['patient']},
        'effectiveDateTime': now.toIso8601String(),
        'valueQuantity': {'value': v['value'], 'unit': v['unit'], 'system': 'http://unitsofmeasure.org', 'code': v['code']},
      };
      await FhirResourceRecord.db.insertRow(session, FhirResourceRecord(
        fhirId: v['id'] as String,
        resourceType: 'Observation',
        jsonData: jsonEncode(json),
        patientReference: v['patient'] as String,
        category: 'vital-signs',
        syncVersion: 0,
        lastUpdated: now,
        createdAt: now,
      ));
    }

    // Blood pressure observations
    final bpData = [
      {'id': 'obs-arjun-bp', 'patient': 'Patient/patient-arjun', 'systolic': 120, 'diastolic': 80},
      {'id': 'obs-sunita-bp', 'patient': 'Patient/patient-sunita', 'systolic': 142, 'diastolic': 95},
      {'id': 'obs-krishna-bp', 'patient': 'Patient/patient-krishna', 'systolic': 138, 'diastolic': 88},
      {'id': 'obs-maya-bp', 'patient': 'Patient/patient-maya', 'systolic': 128, 'diastolic': 82},
    ];

    for (final bp in bpData) {
      final json = {
        'resourceType': 'Observation',
        'id': bp['id'],
        'status': 'final',
        'category': [{'coding': [{'system': 'http://terminology.hl7.org/CodeSystem/observation-category', 'code': 'vital-signs'}]}],
        'code': {'coding': [{'system': 'http://loinc.org', 'code': '85354-9', 'display': 'Blood Pressure'}], 'text': 'Blood Pressure'},
        'subject': {'reference': bp['patient']},
        'effectiveDateTime': now.toIso8601String(),
        'component': [
          {
            'code': {'coding': [{'system': 'http://loinc.org', 'code': '8480-6', 'display': 'Systolic'}]},
            'valueQuantity': {'value': bp['systolic'], 'unit': 'mmHg', 'system': 'http://unitsofmeasure.org', 'code': 'mm[Hg]'},
          },
          {
            'code': {'coding': [{'system': 'http://loinc.org', 'code': '8462-4', 'display': 'Diastolic'}]},
            'valueQuantity': {'value': bp['diastolic'], 'unit': 'mmHg', 'system': 'http://unitsofmeasure.org', 'code': 'mm[Hg]'},
          },
        ],
      };
      await FhirResourceRecord.db.insertRow(session, FhirResourceRecord(
        fhirId: bp['id'] as String,
        resourceType: 'Observation',
        jsonData: jsonEncode(json),
        patientReference: bp['patient'] as String,
        category: 'vital-signs',
        syncVersion: 0,
        lastUpdated: now,
        createdAt: now,
      ));
    }
    print('  \u2713 ${vitals.length + bpData.length} Vital-sign Observations');

    // ── Laboratory Observations ────────────────────────────────────────────
    final labObs = [
      {'id': 'obs-krishna-hba1c', 'patient': 'Patient/patient-krishna', 'name': 'Hemoglobin A1c', 'loinc': '4548-4', 'value': 7.2, 'unit': '%', 'code': '%'},
      {'id': 'obs-arjun-chol', 'patient': 'Patient/patient-arjun', 'name': 'Total Cholesterol', 'loinc': '2093-3', 'value': 245, 'unit': 'mg/dL', 'code': 'mg/dL'},
      {'id': 'obs-sita-tsh', 'patient': 'Patient/patient-sita', 'name': 'TSH', 'loinc': '3016-3', 'value': 4.5, 'unit': 'mIU/L', 'code': 'm[IU]/L'},
      {'id': 'obs-sunita-alt', 'patient': 'Patient/patient-sunita', 'name': 'Alanine Aminotransferase (ALT)', 'loinc': '1742-6', 'value': 28, 'unit': 'U/L', 'code': 'U/L'},
      {'id': 'obs-maya-creat', 'patient': 'Patient/patient-maya', 'name': 'Creatinine', 'loinc': '2160-0', 'value': 1.1, 'unit': 'mg/dL', 'code': 'mg/dL'},
      {'id': 'obs-priya-hgb', 'patient': 'Patient/patient-priya', 'name': 'Hemoglobin', 'loinc': '718-7', 'value': 11.2, 'unit': 'g/dL', 'code': 'g/dL'},
    ];

    for (final l in labObs) {
      final json = {
        'resourceType': 'Observation',
        'id': l['id'],
        'status': 'final',
        'category': [{'coding': [{'system': 'http://terminology.hl7.org/CodeSystem/observation-category', 'code': 'laboratory'}]}],
        'code': {'coding': [{'system': 'http://loinc.org', 'code': l['loinc'], 'display': l['name']}], 'text': l['name']},
        'subject': {'reference': l['patient']},
        'effectiveDateTime': now.subtract(const Duration(days: 3)).toIso8601String(),
        'issued': now.subtract(const Duration(days: 2)).toIso8601String(),
        'valueQuantity': {'value': l['value'], 'unit': l['unit'], 'system': 'http://unitsofmeasure.org', 'code': l['code']},
      };
      await FhirResourceRecord.db.insertRow(session, FhirResourceRecord(
        fhirId: l['id'] as String,
        resourceType: 'Observation',
        jsonData: jsonEncode(json),
        patientReference: l['patient'] as String,
        category: 'laboratory',
        syncVersion: 0,
        lastUpdated: now,
        createdAt: now,
      ));
    }
    print('  \u2713 ${labObs.length} Laboratory Observations');

    // ── Encounters ─────────────────────────────────────────────────────────
    final encounters = [
      {
        'id': 'enc-arjun-cardio-01',
        'status': 'finished',
        'classCode': 'AMB', 'classDisplay': 'ambulatory',
        'patient': 'Patient/patient-arjun',
        'practitioner': 'Practitioner/practitioner-arpan',
        'start': now.subtract(const Duration(days: 14)).toIso8601String(),
        'end': now.subtract(const Duration(days: 14)).add(const Duration(hours: 1)).toIso8601String(),
        'snomedCode': '185349003', 'snomedDisplay': 'Encounter for check up',
        'org': 'Organization/nepal-mediciti',
      },
      {
        'id': 'enc-sunita-htn-01',
        'status': 'finished',
        'classCode': 'AMB', 'classDisplay': 'ambulatory',
        'patient': 'Patient/patient-sunita',
        'practitioner': 'Practitioner/practitioner-elena',
        'start': now.subtract(const Duration(days: 10)).toIso8601String(),
        'end': now.subtract(const Duration(days: 10)).add(const Duration(minutes: 45)).toIso8601String(),
        'snomedCode': '390906007', 'snomedDisplay': 'Follow-up encounter for hypertension',
        'org': 'Organization/patan-hospital',
      },
      {
        'id': 'enc-ram-knee-01',
        'status': 'finished',
        'classCode': 'AMB', 'classDisplay': 'ambulatory',
        'patient': 'Patient/patient-ram',
        'practitioner': 'Practitioner/practitioner-bikesh',
        'start': now.subtract(const Duration(days: 7)).toIso8601String(),
        'end': now.subtract(const Duration(days: 7)).add(const Duration(minutes: 30)).toIso8601String(),
        'snomedCode': '30989003', 'snomedDisplay': 'Knee pain',
        'org': 'Organization/bir-hospital',
      },
      {
        'id': 'enc-priya-prenatal-01',
        'status': 'finished',
        'classCode': 'AMB', 'classDisplay': 'ambulatory',
        'patient': 'Patient/patient-priya',
        'practitioner': 'Practitioner/practitioner-nisha',
        'start': now.subtract(const Duration(days: 5)).toIso8601String(),
        'end': now.subtract(const Duration(days: 5)).add(const Duration(minutes: 40)).toIso8601String(),
        'snomedCode': '424441002', 'snomedDisplay': 'Prenatal visit',
        'org': 'Organization/grande-hospital',
      },
      {
        'id': 'enc-krishna-diabetes-01',
        'status': 'finished',
        'classCode': 'AMB', 'classDisplay': 'ambulatory',
        'patient': 'Patient/patient-krishna',
        'practitioner': 'Practitioner/practitioner-elena',
        'start': now.subtract(const Duration(days: 4)).toIso8601String(),
        'end': now.subtract(const Duration(days: 4)).add(const Duration(minutes: 30)).toIso8601String(),
        'snomedCode': '46635009', 'snomedDisplay': 'Diabetes mellitus type 2',
        'org': 'Organization/nepal-mediciti',
      },
      {
        'id': 'enc-maya-copd-01',
        'status': 'finished',
        'classCode': 'EMER', 'classDisplay': 'emergency',
        'patient': 'Patient/patient-maya',
        'practitioner': 'Practitioner/practitioner-arpan',
        'start': now.subtract(const Duration(days: 2)).toIso8601String(),
        'end': now.subtract(const Duration(days: 2)).add(const Duration(hours: 3)).toIso8601String(),
        'snomedCode': '195951007', 'snomedDisplay': 'Acute exacerbation of COPD',
        'org': 'Organization/bir-hospital',
      },
      {
        'id': 'enc-deepak-anxiety-01',
        'status': 'finished',
        'classCode': 'AMB', 'classDisplay': 'ambulatory',
        'patient': 'Patient/patient-deepak',
        'practitioner': 'Practitioner/practitioner-rajesh',
        'start': now.subtract(const Duration(days: 3)).toIso8601String(),
        'end': now.subtract(const Duration(days: 3)).add(const Duration(minutes: 50)).toIso8601String(),
        'snomedCode': '197480006', 'snomedDisplay': 'Anxiety disorder',
        'org': 'Organization/patan-hospital',
      },
      {
        'id': 'enc-sita-physical-01',
        'status': 'finished',
        'classCode': 'AMB', 'classDisplay': 'ambulatory',
        'patient': 'Patient/patient-sita',
        'practitioner': 'Practitioner/practitioner-elena',
        'start': now.subtract(const Duration(days: 6)).toIso8601String(),
        'end': now.subtract(const Duration(days: 6)).add(const Duration(hours: 1)).toIso8601String(),
        'snomedCode': '185349003', 'snomedDisplay': 'Annual physical examination',
        'org': 'Organization/grande-hospital',
      },
    ];

    for (final e in encounters) {
      final json = {
        'resourceType': 'Encounter',
        'id': e['id'],
        'status': e['status'],
        'class': {'system': 'http://terminology.hl7.org/CodeSystem/v3-ActCode', 'code': e['classCode'], 'display': e['classDisplay']},
        'subject': {'reference': e['patient']},
        'participant': [{'individual': {'reference': e['practitioner']}}],
        'period': {'start': e['start'], 'end': e['end']},
        'reasonCode': [{'coding': [{'system': 'http://snomed.info/sct', 'code': e['snomedCode'], 'display': e['snomedDisplay']}]}],
        'serviceProvider': {'reference': e['org']},
      };
      await FhirResourceRecord.db.insertRow(session, FhirResourceRecord(
        fhirId: e['id']!,
        resourceType: 'Encounter',
        jsonData: jsonEncode(json),
        patientReference: e['patient']!,
        practitionerReference: e['practitioner']!,
        syncVersion: 0,
        lastUpdated: now,
        createdAt: now,
      ));
    }
    print('  \u2713 ${encounters.length} Encounter resources');

    // ── Conditions (ICD-10) ────────────────────────────────────────────────
    final conditions = [
      {'id': 'cond-krishna-diabetes', 'patient': 'Patient/patient-krishna', 'icd': 'E11.9', 'display': 'Type 2 diabetes mellitus without complications', 'clinical': 'active', 'verification': 'confirmed', 'onset': now.subtract(const Duration(days: 1825)).toIso8601String()},
      {'id': 'cond-sunita-htn', 'patient': 'Patient/patient-sunita', 'icd': 'I10', 'display': 'Essential (primary) hypertension', 'clinical': 'active', 'verification': 'confirmed', 'onset': now.subtract(const Duration(days: 730)).toIso8601String()},
      {'id': 'cond-maya-copd', 'patient': 'Patient/patient-maya', 'icd': 'J44.1', 'display': 'Chronic obstructive pulmonary disease with acute exacerbation', 'clinical': 'active', 'verification': 'confirmed', 'onset': now.subtract(const Duration(days: 3650)).toIso8601String()},
      {'id': 'cond-priya-delivery', 'patient': 'Patient/patient-priya', 'icd': 'O80', 'display': 'Encounter for full-term uncomplicated delivery', 'clinical': 'resolved', 'verification': 'confirmed', 'onset': now.subtract(const Duration(days: 60)).toIso8601String()},
      {'id': 'cond-deepak-depression', 'patient': 'Patient/patient-deepak', 'icd': 'F32.1', 'display': 'Major depressive disorder, single episode, moderate', 'clinical': 'active', 'verification': 'provisional', 'onset': now.subtract(const Duration(days: 90)).toIso8601String()},
      {'id': 'cond-ram-backpain', 'patient': 'Patient/patient-ram', 'icd': 'M54.5', 'display': 'Low back pain', 'clinical': 'active', 'verification': 'confirmed', 'onset': now.subtract(const Duration(days: 180)).toIso8601String()},
      {'id': 'cond-arjun-uri', 'patient': 'Patient/patient-arjun', 'icd': 'J06.9', 'display': 'Acute upper respiratory infection, unspecified', 'clinical': 'resolved', 'verification': 'confirmed', 'onset': now.subtract(const Duration(days: 30)).toIso8601String()},
      {'id': 'cond-arjun-lipid', 'patient': 'Patient/patient-arjun', 'icd': 'E78.5', 'display': 'Hyperlipidemia, unspecified', 'clinical': 'active', 'verification': 'confirmed', 'onset': now.subtract(const Duration(days: 365)).toIso8601String()},
    ];

    for (final c in conditions) {
      final json = {
        'resourceType': 'Condition',
        'id': c['id'],
        'clinicalStatus': {'coding': [{'system': 'http://terminology.hl7.org/CodeSystem/condition-clinical', 'code': c['clinical']}]},
        'verificationStatus': {'coding': [{'system': 'http://terminology.hl7.org/CodeSystem/condition-ver-status', 'code': c['verification']}]},
        'code': {'coding': [{'system': 'http://hl7.org/fhir/sid/icd-10-cm', 'code': c['icd'], 'display': c['display']}], 'text': c['display']},
        'subject': {'reference': c['patient']},
        'onsetDateTime': c['onset'],
        'recordedDate': c['onset'],
      };
      await FhirResourceRecord.db.insertRow(session, FhirResourceRecord(
        fhirId: c['id']!,
        resourceType: 'Condition',
        jsonData: jsonEncode(json),
        patientReference: c['patient']!,
        syncVersion: 0,
        lastUpdated: now,
        createdAt: now,
      ));
    }
    print('  \u2713 ${conditions.length} Condition resources');

    // ── MedicationRequests (RxNorm) ────────────────────────────────────────
    final medications = [
      {'id': 'medreq-krishna-metformin', 'patient': 'Patient/patient-krishna', 'practitioner': 'Practitioner/practitioner-elena', 'rxnorm': '861007', 'name': 'Metformin 500mg', 'dosage': '500mg orally twice daily with meals'},
      {'id': 'medreq-sunita-amlodipine', 'patient': 'Patient/patient-sunita', 'practitioner': 'Practitioner/practitioner-elena', 'rxnorm': '329528', 'name': 'Amlodipine 5mg', 'dosage': '5mg once daily in the morning'},
      {'id': 'medreq-maya-salbutamol', 'patient': 'Patient/patient-maya', 'practitioner': 'Practitioner/practitioner-arpan', 'rxnorm': '435', 'name': 'Salbutamol inhaler', 'dosage': '2 puffs every 4-6 hours as needed'},
      {'id': 'medreq-priya-prenatal', 'patient': 'Patient/patient-priya', 'practitioner': 'Practitioner/practitioner-nisha', 'rxnorm': '904420', 'name': 'Prenatal Vitamins', 'dosage': '1 tablet daily'},
      {'id': 'medreq-deepak-sertraline', 'patient': 'Patient/patient-deepak', 'practitioner': 'Practitioner/practitioner-rajesh', 'rxnorm': '312938', 'name': 'Sertraline 50mg', 'dosage': '50mg once daily in the morning'},
      {'id': 'medreq-ram-ibuprofen', 'patient': 'Patient/patient-ram', 'practitioner': 'Practitioner/practitioner-bikesh', 'rxnorm': '5640', 'name': 'Ibuprofen 400mg', 'dosage': '400mg orally three times daily with food'},
      // Keep original Arjun medication
      {'id': 'medreq-arjun-amox', 'patient': 'Patient/patient-arjun', 'practitioner': 'Practitioner/practitioner-arpan', 'rxnorm': '723', 'name': 'Amoxicillin 500mg', 'dosage': '500mg orally three times daily for 7 days'},
    ];

    for (final m in medications) {
      final json = {
        'resourceType': 'MedicationRequest',
        'id': m['id'],
        'status': 'active',
        'intent': 'order',
        'medicationCodeableConcept': {
          'coding': [{'system': 'http://www.nlm.nih.gov/research/umls/rxnorm', 'code': m['rxnorm'], 'display': m['name']}],
          'text': m['name'],
        },
        'subject': {'reference': m['patient']},
        'requester': {'reference': m['practitioner']},
        'authoredOn': now.toIso8601String(),
        'dosageInstruction': [{'text': m['dosage']}],
      };
      await FhirResourceRecord.db.insertRow(session, FhirResourceRecord(
        fhirId: m['id']!,
        resourceType: 'MedicationRequest',
        jsonData: jsonEncode(json),
        patientReference: m['patient']!,
        practitionerReference: m['practitioner']!,
        syncVersion: 0,
        lastUpdated: now,
        createdAt: now,
      ));
    }
    print('  \u2713 ${medications.length} MedicationRequest resources');

    // ── Immunizations (CVX) ────────────────────────────────────────────────
    final immunizations = [
      {'id': 'imm-arjun-covid', 'patient': 'Patient/patient-arjun', 'cvx': '208', 'name': 'COVID-19 Vaccine (Pfizer-BioNTech)', 'date': now.subtract(const Duration(days: 180)).toIso8601String(), 'lot': 'CV2024-KTM-4521'},
      {'id': 'imm-priya-bcg', 'patient': 'Patient/patient-priya', 'cvx': '19', 'name': 'BCG Vaccine', 'date': now.subtract(const Duration(days: 9125)).toIso8601String(), 'lot': 'BCG1998-NPL-001'},
      {'id': 'imm-ram-dpt', 'patient': 'Patient/patient-ram', 'cvx': '20', 'name': 'DPT Vaccine', 'date': now.subtract(const Duration(days: 21900)).toIso8601String(), 'lot': 'DPT1965-NPL-012'},
      {'id': 'imm-deepak-hepb', 'patient': 'Patient/patient-deepak', 'cvx': '08', 'name': 'Hepatitis B Vaccine', 'date': now.subtract(const Duration(days: 365)).toIso8601String(), 'lot': 'HB2025-KTM-789'},
      // Keep original
      {'id': 'imm-arjun-flu', 'patient': 'Patient/patient-arjun', 'cvx': '140', 'name': 'Influenza Vaccine (Quadrivalent)', 'date': now.toIso8601String(), 'lot': 'FL2025-KTM-001'},
    ];

    for (final i in immunizations) {
      final json = {
        'resourceType': 'Immunization',
        'id': i['id'],
        'status': 'completed',
        'vaccineCode': {
          'coding': [{'system': 'http://hl7.org/fhir/sid/cvx', 'code': i['cvx'], 'display': i['name']}],
          'text': i['name'],
        },
        'patient': {'reference': i['patient']},
        'occurrenceDateTime': i['date'],
        'lotNumber': i['lot'],
      };
      await FhirResourceRecord.db.insertRow(session, FhirResourceRecord(
        fhirId: i['id']!,
        resourceType: 'Immunization',
        jsonData: jsonEncode(json),
        patientReference: i['patient']!,
        syncVersion: 0,
        lastUpdated: now,
        createdAt: now,
      ));
    }
    print('  \u2713 ${immunizations.length} Immunization resources');

    // ── AllergyIntolerances (SNOMED) ───────────────────────────────────────
    final allergies = [
      // Keep original
      {'id': 'allergy-sunita-pen', 'patient': 'Patient/patient-sunita', 'snomed': '764146007', 'name': 'Penicillin', 'category': 'medication', 'criticality': 'high', 'recorder': 'Practitioner/practitioner-elena'},
      // New
      {'id': 'allergy-ram-sulfa', 'patient': 'Patient/patient-ram', 'snomed': '91936005', 'name': 'Sulfa drugs', 'category': 'medication', 'criticality': 'high', 'recorder': 'Practitioner/practitioner-bikesh'},
      {'id': 'allergy-priya-latex', 'patient': 'Patient/patient-priya', 'snomed': '111088007', 'name': 'Latex', 'category': 'environment', 'criticality': 'low', 'recorder': 'Practitioner/practitioner-nisha'},
      {'id': 'allergy-deepak-dust', 'patient': 'Patient/patient-deepak', 'snomed': '260147004', 'name': 'Dust mites', 'category': 'environment', 'criticality': 'low', 'recorder': 'Practitioner/practitioner-rajesh'},
      {'id': 'allergy-krishna-aspirin', 'patient': 'Patient/patient-krishna', 'snomed': '387458008', 'name': 'Aspirin', 'category': 'medication', 'criticality': 'high', 'recorder': 'Practitioner/practitioner-elena'},
    ];

    for (final a in allergies) {
      final json = {
        'resourceType': 'AllergyIntolerance',
        'id': a['id'],
        'clinicalStatus': {'coding': [{'system': 'http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical', 'code': 'active'}]},
        'verificationStatus': {'coding': [{'system': 'http://terminology.hl7.org/CodeSystem/allergyintolerance-verification', 'code': 'confirmed'}]},
        'type': 'allergy',
        'category': [a['category']],
        'criticality': a['criticality'],
        'code': {
          'coding': [{'system': 'http://snomed.info/sct', 'code': a['snomed'], 'display': a['name']}],
          'text': a['name'],
        },
        'patient': {'reference': a['patient']},
        'recorder': {'reference': a['recorder']},
        'recordedDate': now.toIso8601String(),
      };
      await FhirResourceRecord.db.insertRow(session, FhirResourceRecord(
        fhirId: a['id']!,
        resourceType: 'AllergyIntolerance',
        jsonData: jsonEncode(json),
        patientReference: a['patient']!,
        practitionerReference: a['recorder']!,
        syncVersion: 0,
        lastUpdated: now,
        createdAt: now,
      ));
    }
    print('  \u2713 ${allergies.length} AllergyIntolerance resources');

    // ── DiagnosticReports ──────────────────────────────────────────────────
    final diagReports = [
      // Keep original
      {
        'id': 'diag-arjun-lipid',
        'patient': 'Patient/patient-arjun',
        'loinc': '57698-3', 'name': 'Full Lipid Panel',
        'conclusion': 'LDL Cholesterol elevated at 142 mg/dL.',
      },
      // New
      {
        'id': 'diag-maya-cxr',
        'patient': 'Patient/patient-maya',
        'loinc': '36643-5', 'name': 'Chest X-ray',
        'conclusion': 'Hyperinflated lungs consistent with COPD. No acute infiltrates.',
      },
      {
        'id': 'diag-sunita-ecg',
        'patient': 'Patient/patient-sunita',
        'loinc': '11524-6', 'name': 'Electrocardiogram (ECG)',
        'conclusion': 'Normal sinus rhythm, left ventricular hypertrophy.',
      },
      {
        'id': 'diag-priya-us',
        'patient': 'Patient/patient-priya',
        'loinc': '11525-3', 'name': 'Obstetric Ultrasound',
        'conclusion': 'Single viable intrauterine pregnancy at 28 weeks. Normal fetal biometry.',
      },
    ];

    for (final d in diagReports) {
      final json = {
        'resourceType': 'DiagnosticReport',
        'id': d['id'],
        'status': 'final',
        'code': {'coding': [{'system': 'http://loinc.org', 'code': d['loinc'], 'display': d['name']}], 'text': d['name']},
        'subject': {'reference': d['patient']},
        'issued': now.subtract(const Duration(days: 1)).toIso8601String(),
        'effectiveDateTime': now.subtract(const Duration(days: 2)).toIso8601String(),
        'conclusion': d['conclusion'],
      };
      await FhirResourceRecord.db.insertRow(session, FhirResourceRecord(
        fhirId: d['id']!,
        resourceType: 'DiagnosticReport',
        jsonData: jsonEncode(json),
        patientReference: d['patient']!,
        category: 'laboratory',
        syncVersion: 0,
        lastUpdated: now,
        createdAt: now,
      ));
    }
    print('  \u2713 ${diagReports.length} DiagnosticReport resources');

    // ── Consent Resources ──────────────────────────────────────────────────
    final consents = [
      {'id': 'consent-arjun-arpan', 'patient': 'Patient/patient-arjun', 'practitioner': 'Practitioner/practitioner-arpan'},
      {'id': 'consent-arjun-elena', 'patient': 'Patient/patient-arjun', 'practitioner': 'Practitioner/practitioner-elena'},
      {'id': 'consent-sunita-elena', 'patient': 'Patient/patient-sunita', 'practitioner': 'Practitioner/practitioner-elena'},
      {'id': 'consent-krishna-elena', 'patient': 'Patient/patient-krishna', 'practitioner': 'Practitioner/practitioner-elena'},
      {'id': 'consent-priya-nisha', 'patient': 'Patient/patient-priya', 'practitioner': 'Practitioner/practitioner-nisha'},
      {'id': 'consent-deepak-rajesh', 'patient': 'Patient/patient-deepak', 'practitioner': 'Practitioner/practitioner-rajesh'},
    ];

    for (final c in consents) {
      await FhirResourceRecord.db.insertRow(session, FhirResourceRecord(
        fhirId: c['id']!,
        resourceType: 'Consent',
        jsonData: jsonEncode({
          'resourceType': 'Consent',
          'id': c['id'],
          'status': 'active',
          'scope': {'coding': [{'system': 'http://terminology.hl7.org/CodeSystem/consentscope', 'code': 'patient-privacy'}]},
          'category': [{'coding': [{'system': 'http://terminology.hl7.org/CodeSystem/consentcategorycodes', 'code': '59284-0'}]}],
          'patient': {'reference': c['patient']},
          'dateTime': now.toIso8601String(),
          'provision': {
            'type': 'permit',
            'actor': [{'role': {'coding': [{'system': 'http://terminology.hl7.org/CodeSystem/v3-ParticipationType', 'code': 'PRCP'}]}, 'reference': {'reference': c['practitioner']}}],
          },
        }),
        patientReference: c['patient']!,
        practitionerReference: c['practitioner']!,
        syncVersion: 0,
        lastUpdated: now,
        createdAt: now,
      ));
    }
    print('  \u2713 ${consents.length} Consent resources');

    // ── Organizations (Hospitals & Pharmacies) ─────────────────────────────
    final hospitals = [
      Organization(name: 'Tribhuvan University Teaching Hospital', type: 'government', address: 'Maharajgunj, Kathmandu', phone: '01-4412303', latitude: 27.7382, longitude: 85.3345, hasEmergency: true, isOpen24Hours: true, rating: 4.2, openHours: '24/7', departmentsJson: '["Emergency","Surgery","Internal Medicine","Pediatrics","OB/GYN","Cardiology","Neurology"]', createdAt: now),
      Organization(name: 'Bir Hospital', type: 'government', address: 'Mahaboudha, Kathmandu', phone: '01-4221119', latitude: 27.7050, longitude: 85.3139, hasEmergency: true, isOpen24Hours: true, rating: 3.8, openHours: '24/7', departmentsJson: '["Emergency","General Medicine","Surgery","Orthopedics"]', createdAt: now),
      Organization(name: 'Nepal Mediciti', type: 'private', address: 'Bhaisepati, Lalitpur', phone: '01-4217766', latitude: 27.6583, longitude: 85.3013, hasEmergency: true, isOpen24Hours: true, rating: 4.5, openHours: '24/7', departmentsJson: '["Emergency","Cardiology","Neurosurgery","Oncology","IVF","Dialysis"]', createdAt: now),
      Organization(name: 'Grande International Hospital', type: 'private', address: 'Tokha, Kathmandu', phone: '01-5159266', latitude: 27.7456, longitude: 85.3117, hasEmergency: true, isOpen24Hours: true, rating: 4.4, openHours: '24/7', departmentsJson: '["Emergency","Cardiology","Neurology","Orthopedics","Gastro"]', createdAt: now),
      Organization(name: 'Patan Hospital', type: 'government', address: 'Lagankhel, Lalitpur', phone: '01-5522266', latitude: 27.6696, longitude: 85.3244, hasEmergency: true, isOpen24Hours: true, rating: 4.0, openHours: '24/7', departmentsJson: '["Emergency","Pediatrics","Internal Medicine","Surgery"]', createdAt: now),
      Organization(name: 'Norvic International Hospital', type: 'private', address: 'Thapathali, Kathmandu', phone: '01-4258554', latitude: 27.6942, longitude: 85.3168, hasEmergency: true, isOpen24Hours: true, rating: 4.3, openHours: '24/7', departmentsJson: '["Emergency","Cardiology","Neurology","Oncology"]', createdAt: now),
    ];

    for (final h in hospitals) {
      await Organization.db.insertRow(session, h);
    }
    print('  \u2713 ${hospitals.length} Hospital organizations');

    final pharmacies = [
      Organization(name: 'Nepal Pharmacy', type: 'pharmacy', address: 'New Road, Kathmandu', phone: '01-4223456', latitude: 27.7049, longitude: 85.3131, hasEmergency: false, isOpen24Hours: false, rating: 4.1, openHours: '8:00 AM - 9:00 PM', servicesJson: '["Prescription","OTC","Delivery"]', createdAt: now),
      Organization(name: 'Healthy Life Pharmacy', type: 'pharmacy', address: 'Pulchowk, Lalitpur', phone: '01-5541234', latitude: 27.6810, longitude: 85.3186, hasEmergency: false, isOpen24Hours: false, rating: 4.3, openHours: '7:00 AM - 10:00 PM', servicesJson: '["Prescription","OTC","Health Supplements","Delivery"]', createdAt: now),
      Organization(name: 'City Care Pharmacy', type: 'pharmacy', address: 'Baneshwor, Kathmandu', phone: '01-4468990', latitude: 27.6918, longitude: 85.3421, hasEmergency: false, isOpen24Hours: true, rating: 4.0, openHours: '24/7', servicesJson: '["Prescription","OTC","Emergency","Delivery"]', createdAt: now),
      Organization(name: 'Green Valley Pharmacy', type: 'pharmacy', address: 'Thamel, Kathmandu', phone: '01-4257890', latitude: 27.7153, longitude: 85.3123, hasEmergency: false, isOpen24Hours: false, rating: 3.9, openHours: '9:00 AM - 8:00 PM', servicesJson: '["Prescription","OTC","Ayurvedic"]', createdAt: now),
      Organization(name: 'MedPlus Pharmacy', type: 'pharmacy', address: 'Kalanki, Kathmandu', phone: '01-4276543', latitude: 27.6942, longitude: 85.2810, hasEmergency: false, isOpen24Hours: false, rating: 4.2, openHours: '7:30 AM - 9:30 PM', servicesJson: '["Prescription","OTC","Lab Supplies","Delivery"]', createdAt: now),
    ];

    for (final p in pharmacies) {
      await Organization.db.insertRow(session, p);
    }
    print('  \u2713 ${pharmacies.length} Pharmacy organizations');

    // ── Health Tips ─────────────────────────────────────────────────────────
    final tips = [
      HealthTip(title: 'Managing Diabetes in Nepal', summary: 'Practical tips for blood sugar management with locally available foods.', content: 'Nepal has seen a significant rise in diabetes cases. Here are evidence-based strategies using locally available foods and lifestyle changes to manage blood sugar levels effectively...', category: 'Diabetes', author: 'Dr. Arpan K. Sharma', isActive: true, publishedAt: now.subtract(const Duration(days: 2)), createdAt: now),
      HealthTip(title: 'Heart Health: Warning Signs', summary: 'Know the early warning signs of cardiovascular problems.', content: 'Cardiovascular disease is the leading cause of death globally. Recognizing early warning signs can save lives. Key symptoms include chest pain, shortness of breath, unusual fatigue...', category: 'Cardiology', author: 'Dr. Elena Vance', isActive: true, publishedAt: now.subtract(const Duration(days: 5)), createdAt: now),
      HealthTip(title: 'Monsoon Health Precautions', summary: 'Stay safe during Nepal\'s monsoon season with these health tips.', content: 'The monsoon season brings unique health challenges including waterborne diseases, dengue, and respiratory infections. Boil drinking water, use mosquito nets, and maintain hygiene...', category: 'Seasonal Health', author: 'Ministry of Health', isActive: true, publishedAt: now.subtract(const Duration(days: 10)), createdAt: now),
      HealthTip(title: 'Mental Health Awareness', summary: 'Breaking the stigma around mental health in Nepali communities.', content: 'Mental health conditions affect 1 in 4 people worldwide. In Nepal, stigma often prevents people from seeking help. Common conditions include depression, anxiety, and PTSD...', category: 'Mental Health', author: 'WHO Nepal', isActive: true, publishedAt: now.subtract(const Duration(days: 15)), createdAt: now),
      HealthTip(title: 'Nutrition for Children', summary: 'Essential nutrition guide for children under 5 in Nepal.', content: 'Proper nutrition in the first 1000 days of life is crucial. Include dal, green vegetables, eggs, and fortified flour in your child\'s diet. Breastfeeding exclusively for 6 months...', category: 'Nutrition', author: 'UNICEF Nepal', isActive: true, publishedAt: now.subtract(const Duration(days: 20)), createdAt: now),
    ];

    for (final t in tips) {
      await HealthTip.db.insertRow(session, t);
    }
    print('  \u2713 ${tips.length} Health tips');

    // ── Appointments (15 total) ────────────────────────────────────────────
    final today = DateTime(now.year, now.month, now.day);
    final appointments = [
      // -- Completed (past) --
      Appointment(patientRef: 'Patient/patient-arjun', practitionerRef: 'Practitioner/practitioner-arpan', practitionerName: 'Dr. Arpan K. Sharma', patientName: 'Arjun Maharjan', appointmentType: 'opd', status: 'completed', scheduledAt: today.subtract(const Duration(days: 14, hours: -9)), durationMinutes: 30, specialty: 'Cardiology', notes: 'Routine cardiology checkup, lipid panel review', createdAt: now),
      Appointment(patientRef: 'Patient/patient-sunita', practitionerRef: 'Practitioner/practitioner-elena', practitionerName: 'Dr. Elena Vance', patientName: 'Sunita Rajbhandari', appointmentType: 'opd', status: 'completed', scheduledAt: today.subtract(const Duration(days: 10, hours: -10)), durationMinutes: 30, specialty: 'Internal Medicine', notes: 'Hypertension follow-up, medication adjustment', createdAt: now),
      Appointment(patientRef: 'Patient/patient-krishna', practitionerRef: 'Practitioner/practitioner-elena', practitionerName: 'Dr. Elena Vance', patientName: 'Krishna Prasad Koirala', appointmentType: 'opd', status: 'completed', scheduledAt: today.subtract(const Duration(days: 4, hours: -9)), durationMinutes: 30, specialty: 'Internal Medicine', notes: 'Diabetes management review, HbA1c follow-up', createdAt: now),
      Appointment(patientRef: 'Patient/patient-maya', practitionerRef: 'Practitioner/practitioner-arpan', practitionerName: 'Dr. Arpan K. Sharma', patientName: 'Maya Rai', appointmentType: 'emergency', status: 'completed', scheduledAt: today.subtract(const Duration(days: 2, hours: -8)), durationMinutes: 60, specialty: 'Pulmonology', notes: 'COPD exacerbation emergency visit', createdAt: now),
      Appointment(patientRef: 'Patient/patient-sita', practitionerRef: 'Practitioner/practitioner-elena', practitionerName: 'Dr. Elena Vance', patientName: 'Sita Devi Gurung', appointmentType: 'opd', status: 'completed', scheduledAt: today.subtract(const Duration(days: 6, hours: -11)), durationMinutes: 45, specialty: 'Internal Medicine', notes: 'Annual physical examination', createdAt: now),
      // -- No-show --
      Appointment(patientRef: 'Patient/patient-deepak', practitionerRef: 'Practitioner/practitioner-rajesh', practitionerName: 'Dr. Rajesh Manandhar', patientName: 'Deepak Adhikari', appointmentType: 'opd', status: 'noshow', scheduledAt: today.subtract(const Duration(days: 7, hours: -14)), durationMinutes: 50, specialty: 'Psychiatry', notes: 'Initial psychiatric evaluation - patient did not attend', createdAt: now),
      // -- Cancelled --
      Appointment(patientRef: 'Patient/patient-ram', practitionerRef: 'Practitioner/practitioner-bikesh', practitionerName: 'Dr. Bikesh Shrestha', patientName: 'Ram Bahadur Thapa', appointmentType: 'opd', status: 'cancelled', scheduledAt: today.subtract(const Duration(days: 1, hours: -10)), durationMinutes: 30, specialty: 'Orthopedics', notes: 'Knee pain consultation - cancelled by patient', createdAt: now),
      // -- Booked (upcoming) --
      Appointment(patientRef: 'Patient/patient-arjun', practitionerRef: 'Practitioner/practitioner-arpan', practitionerName: 'Dr. Arpan K. Sharma', patientName: 'Arjun Maharjan', appointmentType: 'opd', status: 'booked', scheduledAt: today.add(const Duration(days: 1, hours: 9)), durationMinutes: 30, specialty: 'Cardiology', notes: 'Follow-up: medication review and ECG', createdAt: now),
      Appointment(patientRef: 'Patient/patient-sunita', practitionerRef: 'Practitioner/practitioner-elena', practitionerName: 'Dr. Elena Vance', patientName: 'Sunita Rajbhandari', appointmentType: 'opd', status: 'booked', scheduledAt: today.add(const Duration(days: 2, hours: 10)), durationMinutes: 30, specialty: 'Internal Medicine', notes: 'Blood pressure monitoring follow-up', createdAt: now),
      Appointment(patientRef: 'Patient/patient-priya', practitionerRef: 'Practitioner/practitioner-nisha', practitionerName: 'Dr. Nisha Poudel', patientName: 'Priya Tamang', appointmentType: 'opd', status: 'booked', scheduledAt: today.add(const Duration(days: 3, hours: 11)), durationMinutes: 40, specialty: 'OB/GYN', notes: '32-week prenatal checkup', createdAt: now),
      Appointment(patientRef: 'Patient/patient-krishna', practitionerRef: 'Practitioner/practitioner-elena', practitionerName: 'Dr. Elena Vance', patientName: 'Krishna Prasad Koirala', appointmentType: 'telemedicine', status: 'booked', scheduledAt: today.add(const Duration(days: 5, hours: 14)), durationMinutes: 20, specialty: 'Internal Medicine', notes: 'Virtual diabetes follow-up', createdAt: now),
      Appointment(patientRef: 'Patient/patient-deepak', practitionerRef: 'Practitioner/practitioner-rajesh', practitionerName: 'Dr. Rajesh Manandhar', patientName: 'Deepak Adhikari', appointmentType: 'opd', status: 'booked', scheduledAt: today.add(const Duration(days: 7, hours: 14)), durationMinutes: 50, specialty: 'Psychiatry', notes: 'Rescheduled initial psychiatric evaluation', createdAt: now),
      Appointment(patientRef: 'Patient/patient-ram', practitionerRef: 'Practitioner/practitioner-bikesh', practitionerName: 'Dr. Bikesh Shrestha', patientName: 'Ram Bahadur Thapa', appointmentType: 'opd', status: 'booked', scheduledAt: today.add(const Duration(days: 4, hours: 10)), durationMinutes: 30, specialty: 'Orthopedics', notes: 'Knee pain evaluation and X-ray review', createdAt: now),
      Appointment(patientRef: 'Patient/patient-maya', practitionerRef: 'Practitioner/practitioner-arpan', practitionerName: 'Dr. Arpan K. Sharma', patientName: 'Maya Rai', appointmentType: 'opd', status: 'booked', scheduledAt: today.add(const Duration(days: 10, hours: 9)), durationMinutes: 30, specialty: 'Pulmonology', notes: 'COPD post-exacerbation follow-up', createdAt: now),
      Appointment(patientRef: 'Patient/patient-sita', practitionerRef: 'Practitioner/practitioner-suman', practitionerName: 'Dr. Suman Karki', patientName: 'Sita Devi Gurung', appointmentType: 'opd', status: 'booked', scheduledAt: today.add(const Duration(days: 8, hours: 10)), durationMinutes: 30, specialty: 'Pediatrics', notes: 'Child vaccination consultation', createdAt: now),
    ];

    for (final a in appointments) {
      await Appointment.db.insertRow(session, a);
    }
    print('  \u2713 ${appointments.length} Appointments');

    // ── Schedule Slots (all 7 practitioners, 5 days) ───────────────────────
    final practitioners = [
      {'ref': 'Practitioner/practitioner-arpan', 'facility': 'Nepal Mediciti'},
      {'ref': 'Practitioner/practitioner-elena', 'facility': 'Grande International Hospital'},
      {'ref': 'Practitioner/practitioner-anjali', 'facility': 'Bir Hospital'},
      {'ref': 'Practitioner/practitioner-bikesh', 'facility': 'Patan Hospital'},
      {'ref': 'Practitioner/practitioner-suman', 'facility': 'Norvic International Hospital'},
      {'ref': 'Practitioner/practitioner-nisha', 'facility': 'Nepal Mediciti'},
      {'ref': 'Practitioner/practitioner-rajesh', 'facility': 'Grande International Hospital'},
    ];

    int slotCount = 0;
    for (final prac in practitioners) {
      for (int day = 1; day <= 5; day++) {
        final slotDate = DateTime(now.year, now.month, now.day + day);
        // Morning slot
        await ScheduleSlot.db.insertRow(session, ScheduleSlot(
          practitionerRef: prac['ref']!,
          date: slotDate,
          startTime: '09:00',
          endTime: '12:00',
          slotDurationMinutes: 30,
          maxPatients: 6,
          bookedCount: day == 1 ? 2 : 0,
          facilityName: prac['facility']!,
          isEmergencyOverride: false,
          isTelehealth: false,
          status: 'available',
          createdAt: now,
        ));
        // Afternoon slot
        await ScheduleSlot.db.insertRow(session, ScheduleSlot(
          practitionerRef: prac['ref']!,
          date: slotDate,
          startTime: '14:00',
          endTime: '17:00',
          slotDurationMinutes: 30,
          maxPatients: 6,
          bookedCount: 0,
          facilityName: prac['facility']!,
          isEmergencyOverride: false,
          isTelehealth: day % 3 == 0,
          status: 'available',
          createdAt: now,
        ));
        slotCount += 2;
      }
    }
    print('  \u2713 $slotCount Schedule slots');

    // ── Notifications (12) ─────────────────────────────────────────────────
    final notifications = [
      NotificationRecord(userEmail: 'arjun@example.com', title: 'Lab Results Available', body: 'Your Full Lipid Panel results are now available.', type: 'lab_result', isRead: false, relatedResourceId: 'diag-arjun-lipid', relatedRoute: '/records', createdAt: now.subtract(const Duration(hours: 2))),
      NotificationRecord(userEmail: 'arjun@example.com', title: 'Prescription Updated', body: 'Dr. Arpan K. Sharma has updated your Amoxicillin prescription.', type: 'prescription', isRead: true, relatedResourceId: 'medreq-arjun-amox', relatedRoute: '/records', createdAt: now.subtract(const Duration(days: 1))),
      NotificationRecord(userEmail: 'arjun@example.com', title: 'Appointment Reminder', body: 'You have an appointment with Dr. Arpan K. Sharma tomorrow at 09:00.', type: 'appointment', isRead: false, relatedRoute: '/appointments', createdAt: now.subtract(const Duration(hours: 6))),
      NotificationRecord(userEmail: 'arpan@example.com', title: 'New Patient Assigned', body: 'Arjun Maharjan has been assigned to your care.', type: 'patient_assignment', isRead: false, relatedResourceId: 'patient-arjun', relatedRoute: '/patients', createdAt: now.subtract(const Duration(hours: 5))),
      NotificationRecord(userEmail: 'admin@example.com', title: 'New Verification Request', body: 'Dr. Bikesh Shrestha has submitted a practitioner verification request.', type: 'verification', isRead: false, relatedResourceId: 'practitioner-bikesh', relatedRoute: '/admin', createdAt: now.subtract(const Duration(hours: 1))),
      NotificationRecord(userEmail: 'krishna@example.com', title: 'Lab Results Available', body: 'Your HbA1c test results are now available. Please review.', type: 'lab_result', isRead: false, relatedResourceId: 'obs-krishna-hba1c', relatedRoute: '/records', createdAt: now.subtract(const Duration(hours: 3))),
      NotificationRecord(userEmail: 'krishna@example.com', title: 'Appointment Reminder', body: 'Virtual follow-up with Dr. Elena Vance in 5 days.', type: 'appointment', isRead: false, relatedRoute: '/appointments', createdAt: now.subtract(const Duration(hours: 1))),
      NotificationRecord(userEmail: 'priya@example.com', title: 'Upcoming Prenatal Visit', body: 'Your 32-week prenatal checkup with Dr. Nisha Poudel is in 3 days.', type: 'appointment', isRead: false, relatedRoute: '/appointments', createdAt: now.subtract(const Duration(hours: 4))),
      NotificationRecord(userEmail: 'maya@example.com', title: 'Prescription Refill Due', body: 'Your Salbutamol inhaler prescription is due for refill.', type: 'prescription', isRead: false, relatedResourceId: 'medreq-maya-salbutamol', relatedRoute: '/records', createdAt: now.subtract(const Duration(hours: 8))),
      NotificationRecord(userEmail: 'deepak@example.com', title: 'Appointment Rescheduled', body: 'Your appointment with Dr. Rajesh Manandhar has been rescheduled to next week.', type: 'appointment', isRead: true, relatedRoute: '/appointments', createdAt: now.subtract(const Duration(days: 2))),
      NotificationRecord(userEmail: 'sunita@example.com', title: 'Blood Pressure Alert', body: 'Your recent BP reading (142/95) is elevated. Please follow up with your doctor.', type: 'alert', isRead: false, relatedRoute: '/records', createdAt: now.subtract(const Duration(hours: 12))),
      NotificationRecord(userEmail: 'admin@example.com', title: 'System Update', body: 'FHIR R4 compliance update applied. All resources now include UCUM codes.', type: 'system', isRead: true, createdAt: now.subtract(const Duration(days: 3))),
    ];

    for (final n in notifications) {
      await NotificationRecord.db.insertRow(session, n);
    }
    print('  \u2713 ${notifications.length} Notifications');

    // ── Insurance Claims (4) ───────────────────────────────────────────────
    final claims = [
      InsuranceClaim(patientRef: 'Patient/patient-maya', claimType: 'emergency', provider: 'Nepal Life Insurance', policyNumber: 'NLI-2024-8834', amount: 45000.0, status: 'submitted', description: 'Emergency admission for COPD exacerbation', createdAt: now.subtract(const Duration(days: 1))),
      InsuranceClaim(patientRef: 'Patient/patient-arjun', claimType: 'outpatient', provider: 'Sagarmatha Health Insurance', policyNumber: 'SHI-2024-1122', amount: 8500.0, status: 'approved', description: 'Cardiology consultation and lipid panel', createdAt: now.subtract(const Duration(days: 10))),
      InsuranceClaim(patientRef: 'Patient/patient-ram', claimType: 'outpatient', provider: 'Himalayan General Insurance', policyNumber: 'HGI-2024-5567', amount: 12000.0, status: 'rejected', description: 'Orthopedic consultation - policy exclusion for pre-existing condition', createdAt: now.subtract(const Duration(days: 15))),
      InsuranceClaim(patientRef: 'Patient/patient-priya', claimType: 'maternity', provider: 'Nepal Life Insurance', policyNumber: 'NLI-2024-9921', amount: 35000.0, status: 'under-review', description: 'Prenatal care and obstetric ultrasound', createdAt: now.subtract(const Duration(days: 3))),
    ];

    for (final c in claims) {
      await InsuranceClaim.db.insertRow(session, c);
    }
    print('  \u2713 ${claims.length} Insurance claims');

    // ── Pharmacy Orders (4) ────────────────────────────────────────────────
    final pharmacyOrders = [
      PharmacyOrder(patientRef: 'Patient/patient-krishna', pharmacyName: 'Nepal Pharmacy', itemsJson: jsonEncode([{'name': 'Metformin 500mg', 'qty': 60, 'price': 120.0}, {'name': 'Glucose test strips', 'qty': 50, 'price': 800.0}]), status: 'pending', totalPrice: 920.0, deliveryAddress: 'Chitwan, Bharatpur-5', createdAt: now.subtract(const Duration(hours: 4))),
      PharmacyOrder(patientRef: 'Patient/patient-sunita', pharmacyName: 'Healthy Life Pharmacy', itemsJson: jsonEncode([{'name': 'Amlodipine 5mg', 'qty': 30, 'price': 150.0}]), status: 'processing', totalPrice: 150.0, createdAt: now.subtract(const Duration(hours: 8))),
      PharmacyOrder(patientRef: 'Patient/patient-deepak', pharmacyName: 'City Care Pharmacy', itemsJson: jsonEncode([{'name': 'Sertraline 50mg', 'qty': 30, 'price': 450.0}]), status: 'ready', totalPrice: 450.0, createdAt: now.subtract(const Duration(days: 1))),
      PharmacyOrder(patientRef: 'Patient/patient-maya', pharmacyName: 'MedPlus Pharmacy', itemsJson: jsonEncode([{'name': 'Salbutamol inhaler', 'qty': 2, 'price': 600.0}, {'name': 'Prednisolone 5mg', 'qty': 20, 'price': 80.0}]), status: 'delivered', totalPrice: 680.0, deliveryAddress: 'Dharan-10, Sunsari', createdAt: now.subtract(const Duration(days: 2))),
    ];

    for (final po in pharmacyOrders) {
      await PharmacyOrder.db.insertRow(session, po);
    }
    print('  \u2713 ${pharmacyOrders.length} Pharmacy orders');

    // ── Lab Bookings (3) ───────────────────────────────────────────────────
    final labBookings = [
      LabBooking(patientRef: 'Patient/patient-krishna', testsJson: jsonEncode([{'name': 'HbA1c', 'code': '4548-4'}, {'name': 'Fasting Glucose', 'code': '1558-6'}]), status: 'scheduled', totalPrice: 1200.0, scheduledAt: today.add(const Duration(days: 3, hours: 8)), labName: 'Patan Hospital Lab', createdAt: now),
      LabBooking(patientRef: 'Patient/patient-sita', testsJson: jsonEncode([{'name': 'Thyroid Panel', 'code': '3016-3'}, {'name': 'CBC', 'code': '58410-2'}]), status: 'completed', totalPrice: 1800.0, scheduledAt: today.subtract(const Duration(days: 2, hours: -7)), labName: 'Grande Hospital Lab', createdAt: now.subtract(const Duration(days: 3))),
      LabBooking(patientRef: 'Patient/patient-priya', testsJson: jsonEncode([{'name': 'Hemoglobin', 'code': '718-7'}, {'name': 'Blood Group', 'code': '883-9'}]), status: 'scheduled', totalPrice: 600.0, scheduledAt: today.add(const Duration(days: 2, hours: 9)), labName: 'Nepal Mediciti Lab', createdAt: now),
    ];

    for (final lb in labBookings) {
      await LabBooking.db.insertRow(session, lb);
    }
    print('  \u2713 ${labBookings.length} Lab bookings');

    print('\n\u2705 Database seeded successfully!');
    print('   ${accounts.length} users, ${patientData.length} patients, ${practitionerData.length} practitioners');
    print('   ${vitals.length + bpData.length + labObs.length} observations, ${encounters.length} encounters');
    print('   ${conditions.length} conditions, ${medications.length} medications');
    print('   ${immunizations.length} immunizations, ${allergies.length} allergies');
    print('   ${diagReports.length} diagnostic reports, ${consents.length} consents');
    print('   ${hospitals.length} hospitals, ${pharmacies.length} pharmacies');
    print('   ${appointments.length} appointments, $slotCount schedule slots');
    print('   ${notifications.length} notifications, ${claims.length} insurance claims');
    print('   ${pharmacyOrders.length} pharmacy orders, ${labBookings.length} lab bookings');
  } catch (e, st) {
    print('\u274c Seed failed: $e');
    print(st);
  } finally {
    await session.close();
    await pod.shutdown();
  }
}
