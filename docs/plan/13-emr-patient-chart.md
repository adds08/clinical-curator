# Phase 2: EMR Core — Patient Chart + Order Entry

**Status:** 🔴 Not started  
**Priority:** P1 — Core clinician workflow  
**Effort:** ~4 weeks  
**Depends on:** Phase 1 (FHIR storage layer)

## Objective

Build a full patient chart with SOAP notes, order entry (labs, prescriptions, imaging), and clinical decision support. This is the EMR side of the application — where clinicians do their work.

## 2A: Patient Chart Layout

### Wireframe

```
┌───────────────────────────────────────────────────────────────┐
│  Patient Banner                                               │
│  ┌──────────────────────────────────────────────────────────┐│
│  │ [Avatar] Ram Bahadur, 45M  • MRN: PT-2026-0001            ││
│  │ DOB: 1981-03-15  • Phone: 9841-XXXXXX  • A+ Blood        ││
│  │ ⚠ Penicillin Allergy  • ⚠ Hypertension                   ││
│  └──────────────────────────────────────────────────────────┘│
├─────────────┬────────────────────────────────────────────────┤
│ Chart Tabs  │ Content Area                                   │
│             │                                                │
│  📋 Summary │ ┌─────────────────┬──────────────────────────┐ │
│             │ │ Active Problems │  Active Medications      │ │
│  🏥 Encount.│ │ • Hypertension  │  • Amlodipine 5mg daily │ │
│             │ │ • T2DM          │  • Metformin 500mg BID   │ │
│  📋 Orders  │ └─────────────────┴──────────────────────────┘ │
│             │ ┌─────────────────┬──────────────────────────┐ │
│  🧪 Results │ │ Allergies       │  Vitals Snapshot         │ │
│             │ │ ⚠ Penicillin    │  BP: 142/88 (2026-06-20) │ │
│  💊 Meds    │ │ ⚠ Sulfa        │  HR: 82  (2026-06-20)    │ │
│             │ └─────────────────┴──────────────────────────┘ │
│  📊 Vitals  │ ┌───────────────────────────────────────────┐  │
│             │ │ Vitals Trend (fl_chart LineChart)         │  │
│  💉 Immuniz.│ │ BP over last 6 months                     │  │
│             │ │ 📈📉📈📉📈📉                               │  │
│  📄 Docs    │ └───────────────────────────────────────────┘  │
│             │                                                │
│  📋 Admin   │                                                │
└─────────────┴────────────────────────────────────────────────┘
```

### Patient Banner Pseudocode

```dart
// apps/clinical/lib/features/patient_chart/widgets/patient_banner.dart

class PatientBanner extends ConsumerWidget {
  final String patientFhirId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientAsync = ref.watch(patientProvider(patientFhirId));
    final allergiesAsync = ref.watch(allergiesProvider(patientFhirId));

    return patientAsync.when(
      data: (patient) => Card(
        child: Row(
          children: [
            // Avatar + demographics
            Avatar(initials: _initials(patient), size: 48),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _fullName(patient),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Text('MRN: ${_mrn(patient)} • ${_age(patient)}${_gender(patient)}'),
                  Text('DOB: ${_dob(patient)} • ${_bloodType(patient)}'),
                ],
              ),
            ),
            // Allergy alerts
            allergiesAsync.when(
              data: (allergies) => Row(
                children: allergies.map((a) => DestructiveBadge(
                  child: Text('⚠ ${a['code']['coding'][0]['display']}'),
                )).toList(),
              ),
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),
          ],
        ),
      ),
      loading: () => const PatientBannerSkeleton(),
      error: (e, _) => ErrorBanner(message: e.toString()),
    );
  }
}
```

### Chart Tab Navigation

```dart
// apps/clinical/lib/features/patient_chart/screens/patient_chart_screen.dart

class PatientChartScreen extends ConsumerStatefulWidget {
  final String patientFhirId;
  const PatientChartScreen({required this.patientFhirId});

  @override
  ConsumerState<PatientChartScreen> createState() => _PatientChartScreenState();
}

class _PatientChartScreenState extends ConsumerState<PatientChartScreen> {
  int _selectedTab = 0;
  static const _tabs = [
    TabData(icon: Icons.dashboard, label: 'Summary'),
    TabData(icon: Icons.local_hospital, label: 'Encounters'),
    TabData(icon: Icons.receipt_long, label: 'Orders'),
    TabData(icon: Icons.biotech, label: 'Results'),
    TabData(icon: Icons.medication, label: 'Meds'),
    TabData(icon: Icons.monitor_heart, label: 'Vitals'),
    TabData(icon: Icons.vaccines, label: 'Immuniz.'),
    TabData(icon: Icons.description, label: 'Docs'),
    TabData(icon: Icons.settings, label: 'Admin'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Sticky patient banner
          PatientBanner(patientFhirId: widget.patientFhirId),
          // Scrollable tab bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _tabs.asMap().entries.map((e) => _TabChip(
                selected: _selectedTab == e.key,
                icon: e.value.icon,
                label: e.value.label,
                onTap: () => setState(() => _selectedTab = e.key),
              )).toList(),
            ),
          ),
          // Tab content
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return switch (_selectedTab) {
      0 => PatientSummaryTab(patientFhirId: widget.patientFhirId),
      1 => EncounterListTab(patientFhirId: widget.patientFhirId),
      2 => OrderListTab(patientFhirId: widget.patientFhirId),
      3 => ResultsTab(patientFhirId: widget.patientFhirId),
      4 => MedicationTab(patientFhirId: widget.patientFhirId),
      5 => VitalsTab(patientFhirId: widget.patientFhirId),
      6 => ImmunizationTab(patientFhirId: widget.patientFhirId),
      7 => DocumentsTab(patientFhirId: widget.patientFhirId),
      8 => AdminTab(patientFhirId: widget.patientFhirId),
      _ => const Center(child: Text('Not implemented')),
    };
  }
}
```

## 2B: SOAP Note Editor (Encounter Workspace)

### SOAP Note Structure

```dart
// apps/clinical/lib/features/patient_chart/models/soap_note.dart

class SoapNote {
  final String subjective;   // Chief complaint, HPI, ROS
  final String objective;    // Physical exam, vitals, labs
  final String assessment;   // Diagnosis, differential
  final String plan;         // Orders, medications, follow-up

  // FHIR → SOAP mapping
  factory SoapNote.fromEncounter(Map<String, dynamic> fhirEncounter) {
    // Encounter.extension contains SOAP sections
    final extensions = fhirEncounter['extension'] as List? ?? [];
    return SoapNote(
      subjective: _findExtensionValue(extensions, 'soap-subjective') ?? '',
      objective: _findExtensionValue(extensions, 'soap-objective') ?? '',
      assessment: _findExtensionValue(extensions, 'soap-assessment') ?? '',
      plan: _findExtensionValue(extensions, 'soap-plan') ?? '',
    );
  }

  // SOAP → FHIR
  Map<String, dynamic> toFhirExtension() => {
    'extension': [
      {'url': 'soap-subjective', 'valueString': subjective},
      {'url': 'soap-objective', 'valueString': objective},
      {'url': 'soap-assessment', 'valueString': assessment},
      {'url': 'soap-plan', 'valueString': plan},
    ],
  };
}
```

## 2C: Order Entry Flow

### Lab Order (FHIR ServiceRequest)

```dart
// apps/clinical/lib/features/patient_chart/widgets/order_lab_sheet.dart

class OrderLabSheet extends ConsumerStatefulWidget {
  final String patientFhirId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomSheet(
      title: 'Order Lab Test',
      child: Column(
        children: [
          // Test search
          TextField(placeholder: 'Search LOINC tests...', onChanged: (v) => _searchTests(v)),
          Expanded(
            child: _testsAsync.when(
              data: (tests) => ListView.builder(
                itemCount: tests.length,
                itemBuilder: (_, i) => RadioListTile<String>(
                  title: Text(tests[i].display),
                  subtitle: Text('LOINC: ${tests[i].code}'),
                  value: tests[i].code,
                  groupValue: _selectedTest,
                  onChanged: (v) => setState(() => _selectedTest = v),
                ),
              ),
              loading: () => const LoadingSpinner(),
            ),
          ),
          // Priority, collection date, notes
          Row(children: [
            Dropdown<String>(label: 'Priority', items: ['routine', 'urgent', 'stat']),
            DatePicker(label: 'Collection Date'),
          ]),
          TextField(placeholder: 'Clinical notes...', maxLines: 2),
          // Submit
          Button.primary(
            onPressed: () => _submitOrder(ref),
            child: const Text('Place Lab Order'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitOrder(WidgetRef ref) async {
    // Build FHIR ServiceRequest for lab order
    final serviceRequest = {
      'resourceType': 'ServiceRequest',
      'status': 'active',
      'intent': 'order',
      'subject': {'reference': 'Patient/${widget.patientFhirId}'},
      'code': {
        'coding': [
          {'system': 'http://loinc.org', 'code': _selectedTest, 'display': _selectedTestDisplay}
        ],
      },
      'priority': _priority,
      'occurrenceDateTime': _collectionDate?.toIso8601String(),
      'note': [{'text': _notes}],
      'requester': {'reference': 'Practitioner/${ref.read(authProvider).practitionerFhirId}'},
    };

    await ref.read(fhirApiProvider).create('ServiceRequest', serviceRequest);
    showToast(context: context, message: 'Lab order placed');
  }
}
```

## 2D: Clinical Decision Support

### Drug-Allergy Check

```dart
// apps/clinical/lib/features/patient_chart/services/cds_service.dart

class CdsService {
  /// Check if prescribed medication conflicts with patient allergies.
  Future<List<CdsAlert>> checkDrugAllergy(
    String patientFhirId,
    String medicationCode, // RxNorm code
  ) async {
    final allergies = await _fhirApi.search('AllergyIntolerance', {
      'patient': 'Patient/$patientFhirId',
      'clinical-status': 'active',
    });

    final alerts = <CdsAlert>[];

    // Simple code-level matching (production would use RxNorm relationships)
    for (final allergy in allergies) {
      final allergenCode = allergy['code']?['coding']?[0]?['code'];
      if (allergenCode == medicationCode) {
        alerts.add(CdsAlert(
          severity: 'error',
          title: 'DRUG-ALLERGY: ${allergy['code']['coding'][0]['display']}',
          message: 'Patient has documented allergy to this medication.',
        ));
      }
    }

    return alerts;
  }
}
```

## Files to Create

| File | Purpose |
|------|---------|
| `apps/clinical/lib/features/patient_chart/screens/patient_chart_screen.dart` | Main chart screen with tabs |
| `apps/clinical/lib/features/patient_chart/widgets/patient_banner.dart` | Demographics + alerts header |
| `apps/clinical/lib/features/patient_chart/tabs/patient_summary_tab.dart` | Problem list, meds, allergies summary |
| `apps/clinical/lib/features/patient_chart/tabs/encounter_list_tab.dart` | Encounter history |
| `apps/clinical/lib/features/patient_chart/screens/encounter_workspace_screen.dart` | SOAP note editor |
| `apps/clinical/lib/features/patient_chart/tabs/order_list_tab.dart` | Orders list + new order entry |
| `apps/clinical/lib/features/patient_chart/tabs/results_tab.dart` | Lab results table (ultimate_grid) |
| `apps/clinical/lib/features/patient_chart/tabs/medication_tab.dart` | Medication list + interactions |
| `apps/clinical/lib/features/patient_chart/tabs/vitals_tab.dart` | Vitals trending (fl_chart) |
| `apps/clinical/lib/features/patient_chart/services/cds_service.dart` | Clinical decision support alerts |