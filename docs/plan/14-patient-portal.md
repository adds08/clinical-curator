# Phase 3: Patient Portal (PHR/PMR)

**Status:** 🔴 Not started
**Priority:** P1 — Patient self-service
**Effort:** ~3 weeks
**Depends on:** Phase 1 (FHIR storage), Phase 2 (patient data exists in system)

## Objective

Build a patient portal allowing patients to view their health records, book appointments, request medication refills, message their care team, and enter self-reported data. This is the Patient Health Record (PHR) / Personal Medical Record (PMR) side.

## 3A: My Health Record

### Screen: Patient Home → My Record

```dart
// apps/clinical/lib/features/patient_portal/screens/my_health_record_screen.dart

class MyHealthRecordScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientFhirId = ref.watch(currentUserProvider).fhirPatientId;

    return SubPageScaffold(
      title: 'My Health Record',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active Problems
            _SectionCard(
              title: 'Active Problems',
              icon: Icons.fact_check,
              emptyMessage: 'No active problems recorded.',
              provider: problemsProvider(patientFhirId),
              builder: (conditions) => Column(
                children: conditions.map((c) => _ProblemRow(
                  name: c['code']['coding'][0]['display'],
                  onsetDate: c['onsetDateTime'],
                  status: c['clinicalStatus']['coding'][0]['code'],
                )).toList(),
              ),
            ),

            // Medications
            _SectionCard(
              title: 'Current Medications',
              icon: Icons.medication,
              emptyMessage: 'No active medications.',
              provider: medicationsProvider(patientFhirId),
              builder: (meds) => Column(
                children: meds.map((m) => _MedicationRow(
                  name: m['medicationCodeableConcept']['coding'][0]['display'],
                  dosage: m['dosageInstruction']?[0]?['text'] ?? 'As directed',
                  status: m['status'],
                )).toList(),
              ),
            ),

            // Allergies
            _SectionCard(
              title: 'Allergies',
              icon: Icons.warning_amber,
              emptyMessage: 'No allergies recorded.',
              provider: allergiesProvider(patientFhirId),
              builder: (allergies) => Wrap(
                spacing: 8,
                children: allergies.map((a) => Chip(
                  child: Text(a['code']['coding'][0]['display']),
                )).toList(),
              ),
            ),

            // Lab Results
            _SectionCard(
              title: 'Recent Lab Results',
              icon: Icons.biotech,
              emptyMessage: 'No lab results available.',
              provider: recentLabsProvider(patientFhirId),
              builder: (results) => _LabResultsTable(results: results), // → ultimate_grid
            ),

            // Immunizations
            _SectionCard(
              title: 'Immunizations',
              icon: Icons.vaccines,
              emptyMessage: 'No immunizations recorded.',
              provider: immunizationsProvider(patientFhirId),
              builder: (immunizations) => Column(
                children: immunizations.map((i) => _ImmunizationRow(
                  name: i['vaccineCode']['coding'][0]['display'],
                  date: i['occurrenceDateTime'],
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 3B: Appointment Booking (Patient Self-Service)

### Screen: My Appointments → Book Appointment

```dart
// apps/clinical/lib/features/patient_portal/screens/book_appointment_screen.dart

class BookAppointmentScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends ConsumerState<BookAppointmentScreen> {
  String? _selectedPractitionerId;
  DateTime? _selectedDate;
  String? _selectedSlotId;
  String _reason = '';

  @override
  Widget build(BuildContext context) {
    return SubPageScaffold(
      title: 'Book Appointment',
      child: Stepper(
        currentStep: _currentStep,
        steps: [
          // Step 1: Select specialty + practitioner
          Step(
            title: const Text('Choose Doctor'),
            content: _buildDoctorSearch(),
          ),
          // Step 2: Select date + slot
          Step(
            title: const Text('Pick Date & Time'),
            content: _buildSlotPicker(),
          ),
          // Step 3: Reason + confirm
          Step(
            title: const Text('Reason & Confirm'),
            content: _buildConfirmation(),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorSearch() {
    return Column(
      children: [
        // Specialty filter chips
        Wrap(
          spacing: 8,
          children: ['All', 'Cardiology', 'Orthopedics', 'OB/GYN', 'Pediatrics', 'General'].map((s) =>
            ChoiceChip(
              label: Text(s),
              selected: _specialty == s,
              onSelected: (_) => setState(() => _specialty = s),
            ),
          ).toList(),
        ),
        const SizedBox(height: 16),
        // Practitioner list
        Expanded(
          child: ref.watch(practitionersProvider).when(
            data: (practitioners) => ListView.builder(
              itemCount: practitioners.length,
              itemBuilder: (_, i) => _PractitionerCard(
                practitioner: practitioners[i],
                selected: _selectedPractitionerId == practitioners[i]['id'],
                onTap: () => setState(() => _selectedPractitionerId = practitioners[i]['id']),
              ),
            ),
            loading: () => const LoadingSpinner(),
          ),
        ),
      ],
    );
  }

  Widget _buildSlotPicker() {
    return Column(
      children: [
        // Date selector (horizontal calendar strip)
        DateStrip(
          selectedDate: _selectedDate,
          onDateSelected: (date) => setState(() => _selectedDate = date),
        ),
        const SizedBox(height: 16),
        // Available slots grid
        ref.watch(availableSlotsProvider(_selectedPractitionerId!, _selectedDate!)).when(
          data: (slots) => Wrap(
            spacing: 8,
            children: slots.map((slot) => _SlotChip(
              time: slot['start'],
              available: slot['status'] == 'free',
              selected: _selectedSlotId == slot['id'],
              onTap: () => setState(() => _selectedSlotId = slot['id']),
            )).toList(),
          ),
          loading: () => const LoadingSpinner(),
        ),
      ],
    );
  }

  Future<void> _confirmBooking() async {
    // Create FHIR Appointment
    final appointment = {
      'resourceType': 'Appointment',
      'status': 'booked',
      'start': _selectedDate!.toIso8601String(),
      'participant': [
        {
          'actor': {'reference': 'Patient/${_patientFhirId}'},
          'status': 'accepted',
        },
        {
          'actor': {'reference': 'Practitioner/$_selectedPractitionerId'},
          'status': 'accepted',
        },
      ],
      'reasonCode': [{'text': _reason}],
    };

    await ref.read(fhirApiProvider).create('Appointment', appointment);
    showToast(context: context, message: 'Appointment booked!');
    context.pop();
  }
}
```

## 3C: Medication Refill Request

```dart
// apps/clinical/lib/features/patient_portal/screens/request_refill_screen.dart

class RequestRefillScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SubPageScaffold(
      title: 'Request Refill',
      child: ref.watch(activeMedicationsProvider).when(
        data: (meds) => ListView.builder(
          itemCount: meds.length,
          itemBuilder: (_, i) => _RefillCard(
            medication: meds[i],
            onRequest: () => _sendRefillRequest(ref, meds[i]),
          ),
        ),
        loading: () => const LoadingSpinner(),
      ),
    );
  }

  Future<void> _sendRefillRequest(WidgetRef ref, Map<String, dynamic> medication) async {
    // Create FHIR MedicationRequest for refill
    final refillRequest = {
      'resourceType': 'MedicationRequest',
      'status': 'active',
      'intent': 'order',
      'subject': {'reference': 'Patient/${_patientFhirId}'},
      'medicationReference': {'reference': 'Medication/${medication['id']}'},
      'dosageInstruction': medication['dosageInstruction'],
      'note': [{'text': 'Patient requested refill via portal'}],
    };

    await ref.read(fhirApiProvider).create('MedicationRequest', refillRequest);
    showToast(context: context, message: 'Refill request sent to your doctor!');
  }
}
```

## 3D: Secure Messaging

```dart
// FHIR Communication resource for patient-provider messaging

Future<void> sendMessage(WidgetRef ref, String toPractitionerFhirId, String body) async {
  final message = {
    'resourceType': 'Communication',
    'status': 'unknown',
    'subject': {'reference': 'Patient/${_patientFhirId}'},
    'recipient': [{'reference': 'Practitioner/$toPractitionerFhirId'}],
    'sender': {'reference': 'Patient/${_patientFhirId}'},
    'sent': DateTime.now().toUtc().toIso8601String(),
    'payload': [
      {'contentString': body},
    ],
  };

  await ref.read(fhirApiProvider).create('Communication', message);
}

// Fetch message thread
Future<List<Map<String, dynamic>>> getMessages(WidgetRef ref, String participantFhirId) async {
  final result = await ref.read(fhirApiProvider).search('Communication', {
    'patient': 'Patient/${_patientFhirId}',
  });
  return result.entries
      .where((m) => m['recipient'].any((r) => r['reference'].contains(participantFhirId)))
      .toList()
    ..sort((a, b) => b['sent'].compareTo(a['sent']));
}
```

## 3E: Self-Reported Data Entry

### Vital Signs Entry by Patient

```dart
// apps/clinical/lib/features/patient_portal/screens/log_vitals_screen.dart

Future<void> logBloodPressure(WidgetRef ref, int systolic, int diastolic) async {
  final observation = {
    'resourceType': 'Observation',
    'status': 'final',
    'category': [{
      'coding': [{'system': 'http://terminology.hl7.org/CodeSystem/observation-category', 'code': 'vital-signs'}]
    }],
    'code': {'coding': [{'system': 'http://loinc.org', 'code': '85354-9', 'display': 'Blood Pressure'}]},
    'subject': {'reference': 'Patient/${_patientFhirId}'},
    'effectiveDateTime': DateTime.now().toUtc().toIso8601String(),
    'component': [
      {
        'code': {'coding': [{'system': 'http://loinc.org', 'code': '8480-6'}]},
        'valueQuantity': {'value': systolic, 'unit': 'mmHg', 'system': 'http://unitsofmeasure.org', 'code': 'mm[Hg]'},
      },
      {
        'code': {'coding': [{'system': 'http://loinc.org', 'code': '8462-4'}]},
        'valueQuantity': {'value': diastolic, 'unit': 'mmHg', 'system': 'http://unitsofmeasure.org', 'code': 'mm[Hg]'},
      },
    ],
  };

  await ref.read(fhirApiProvider).create('Observation', observation);
}
```

## Files to Create

| File | Purpose |
|------|---------|
| `apps/clinical/lib/features/patient_portal/screens/my_health_record_screen.dart` | Full health record view |
| `apps/clinical/lib/features/patient_portal/screens/book_appointment_screen.dart` | Appointment booking wizard |
| `apps/clinical/lib/features/patient_portal/screens/my_appointments_screen.dart` | Appointment list + cancel/reschedule |
| `apps/clinical/lib/features/patient_portal/screens/request_refill_screen.dart` | Medication refill request |
| `apps/clinical/lib/features/patient_portal/screens/messages_screen.dart` | Secure messaging with care team |
| `apps/clinical/lib/features/patient_portal/screens/log_vitals_screen.dart` | Self-reported vitals entry |
| `apps/clinical/lib/features/patient_portal/screens/lab_results_screen.dart` | Lab results detail view |
| `apps/clinical/lib/features/patient_portal/providers/patient_portal_providers.dart` | Riverpod providers for portal |