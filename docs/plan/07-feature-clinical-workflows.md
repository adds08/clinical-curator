# Feature 07 — Clinical Workflows

## Overview

Implement the core clinical documentation flow that is the heart of the platform: encounter creation, clinical observation recording, condition/diagnosis management, procedure documentation, care plan creation, and service request ordering. This feature enables doctors to document patient visits as structured FHIR resources.

## Dependencies

- Feature 03 (FHIR Resources) — repositories for Encounter, Condition, Procedure, CarePlan, ServiceRequest
- Feature 04 (Offline Sync) — clinical data must persist to server

## What Already Exists

### Patient Data Views
- `lib/features/patient_detail/screens/patient_detail_screen.dart` — shows patient vitals, labs, medications, immunizations, allergies (read-only)
- `lib/features/medical_records/screens/medical_records_screen.dart` — patient-facing records with bento grid and tabs
- `lib/features/medical_records/screens/cardiovascular_detail_screen.dart` — specialized detail view

### Data Providers
- `lib/domain/providers/patient_data_provider.dart` — typed providers for vitals, labs, medications, immunizations, allergies (read from `FhirResource` Hive box)
- `lib/domain/providers/practitioner_data_provider.dart` — all patients, patient count, appointments

### FHIR Infrastructure
- `lib/data/repositories/base_repository.dart` — generic CRUD with sync status
- `lib/data/repositories/observation_repository.dart` — `ObservationRepository`
- `lib/data/repositories/medication_repository.dart` — `MedicationRepository`
- `lib/core/constants/fhir_constants.dart` — LOINC codes for vitals, SNOMED codes
- `lib/core/utils/fhir_helpers.dart` — FHIR utility functions

### Existing Screens (Doctor View)
- `lib/features/doctor_dashboard/screens/doctor_dashboard_screen.dart` — stats, schedule, patient queue
- `lib/features/patient_management/screens/patient_management_screen.dart` — patient directory
- `lib/features/patient_management/screens/add_patient_screen.dart` — patient registration form

## What Needs to Be Built

### 1. Encounter List Screen — `lib/features/clinical/screens/encounter_list_screen.dart` (new)

Doctor's encounter history:
- Tab filters: Today, This Week, All
- Each encounter card: patient name, encounter class (ambulatory/emergency/inpatient), status, date/time, duration
- Status badges: planned, in-progress, finished, cancelled
- FAB to start new encounter
- Search by patient name

### 2. Start Encounter Screen — `lib/features/clinical/screens/start_encounter_screen.dart` (new)

Begin a new clinical encounter:
- **Patient selection:** Search/select from patient list (reuse patient search from `patient_management_screen.dart`)
- **Encounter class:** Ambulatory (AMB), Emergency (EMER), Inpatient (IMP)
- **Reason for visit:** Free text + common reason chips (checkup, follow-up, acute illness, injury, referral)
- **Service type:** General, Specialist, Emergency
- **Organization:** Auto-fill from practitioner's assigned facility
- Creates `fhir.Encounter` with status `in-progress` via `EncounterRepository`

### 3. Encounter Workspace Screen — `lib/features/clinical/screens/encounter_workspace_screen.dart` (new)

The main clinical workspace — a tabbed interface during an active encounter:

**Tab 1 — Vitals:**
- Record vital signs: BP, heart rate, temperature, SpO2, respiratory rate, weight, height
- Each vital creates a `fhir.Observation` linked to this encounter
- Quick-entry form with numeric inputs and unit selectors
- Recent vitals history for comparison

**Tab 2 — Conditions:**
- View patient's active problem list
- Add new condition: SNOMED/ICD-10 code search, clinical status, verification status, onset date, severity
- Each creates a `fhir.Condition` linked to this encounter
- Mark existing conditions as resolved

**Tab 3 — Procedures:**
- Document procedures performed: code, status, performed date, notes
- Each creates a `fhir.Procedure` linked to encounter and patient
- Common procedure quick-select chips

**Tab 4 — Orders:**
- Create service requests: lab orders, imaging orders, referrals
- Each creates a `fhir.ServiceRequest` with priority and encounter reference
- Prescribe medications: drug name, dosage, frequency, duration, quantity
- Each creates a `fhir.MedicationRequest` linked to encounter

**Tab 5 — Notes:**
- Free-text clinical notes
- Stored as `Encounter.text` narrative or as a `DocumentReference`
- Auto-generated summary from recorded data (vitals, conditions, procedures, orders)

**Tab 6 — Summary:**
- Read-only overview of everything recorded in this encounter
- Confirm and finalize button → sets encounter status to `finished`

### 4. Encounter Summary Screen — `lib/features/clinical/screens/encounter_summary_screen.dart` (new)

Post-encounter summary:
- All recorded data in a printable/exportable format
- PDF generation option (using `pdf` package)
- Option to create follow-up appointment
- Link back to patient detail

### 5. Condition Management Screens — `lib/features/clinical/screens/`

**`condition_list_screen.dart`** (new):
- Patient's problem list: active conditions, resolved conditions
- Severity indicators, onset dates
- Tap to view/edit condition detail

**`add_condition_screen.dart`** (new):
- Code search: search SNOMED CT or ICD-10 codes (local list or API)
- Fields: code, display name, clinical status, verification status, onset date, severity, body site, notes
- Creates `fhir.Condition` resource

### 6. Care Plan Screens — `lib/features/clinical/screens/`

**`care_plan_list_screen.dart`** (new):
- Active care plans for a patient
- Status badges: draft, active, on-hold, completed, revoked
- Progress indicators per plan

**`care_plan_detail_screen.dart`** (new):
- View/edit care plan: title, period, status
- Activities list with completion status
- Goals with target values and progress
- Add/remove activities and goals

**`create_care_plan_screen.dart`** (new):
- Title, category, period (start/end dates)
- Add activities: description, status, reference to service request
- Add goals: description, target, due date
- Creates `fhir.CarePlan` resource

### 7. Clinical Order Entry — `lib/features/clinical/screens/`

**`create_service_request_screen.dart`** (new):
- Order type: Laboratory, Imaging, Referral, Procedure
- Code search (LOINC for labs, SNOMED for procedures)
- Priority: routine, urgent, stat
- Clinical notes / reason
- Creates `fhir.ServiceRequest`

**`medication_prescribe_screen.dart`** (new):
- Drug search (by name or RxNorm code)
- Dosage: amount, unit, frequency (BID, TID, QID, PRN, etc.)
- Duration, quantity, refills
- Instructions / special notes
- Creates `fhir.MedicationRequest`

### 8. Clinical Providers — `lib/domain/providers/`

| File | Purpose |
|------|---------|
| `encounter_workflow_provider.dart` (new) | Active encounter state, encounter lifecycle (start → workspace → finalize) |
| `problem_list_provider.dart` (new) | Aggregated active conditions for a patient across all encounters |
| `clinical_order_provider.dart` (new) | Pending and completed service requests/medication requests |

Reuse from Feature 03:
- `encounter_provider.dart`
- `condition_provider.dart`
- `procedure_provider.dart`
- `care_plan_provider.dart`
- `service_request_provider.dart`

### 9. Navigation Updates — `lib/core/router/app_router.dart`

Add routes within doctor shell:
- `/doctor/encounters` — encounter list
- `/doctor/encounters/new` — start encounter
- `/doctor/encounters/:id/workspace` — encounter workspace
- `/doctor/encounters/:id/summary` — encounter summary
- `/doctor/patients/:id/conditions` — condition list
- `/doctor/patients/:id/conditions/new` — add condition
- `/doctor/patients/:id/care-plans` — care plan list
- `/doctor/patients/:id/care-plans/new` — create care plan

Link from:
- Doctor dashboard → encounter list
- Patient detail → start encounter for this patient
- Patient detail → view conditions, care plans

## Implementation Order

1. Create `encounter_workflow_provider.dart` (active encounter state)
2. Create `encounter_list_screen.dart`
3. Create `start_encounter_screen.dart`
4. Create `encounter_workspace_screen.dart` with all 6 tabs
5. Create `encounter_summary_screen.dart`
6. Create `condition_list_screen.dart` and `add_condition_screen.dart`
7. Create care plan screens (list, detail, create)
8. Create order entry screens (service request, medication prescribe)
9. Create `problem_list_provider.dart` and `clinical_order_provider.dart`
10. Update router with clinical workflow routes
11. Link from doctor dashboard and patient detail screens

## Acceptance Criteria

- [ ] Doctor can start a new encounter for a patient
- [ ] Encounter workspace allows recording vitals, conditions, procedures, orders, notes
- [ ] Each recorded item creates the correct FHIR resource type linked to the encounter
- [ ] Vitals create `Observation` resources with proper LOINC codes
- [ ] Conditions create `Condition` resources with clinical/verification status
- [ ] Procedures create `Procedure` resources linked to encounter
- [ ] Service requests create `ServiceRequest` resources with priority
- [ ] Medications create `MedicationRequest` resources with dosage
- [ ] Encounter can be finalized (status → `finished`) with summary
- [ ] Care plans can be created, edited, and tracked with activities and goals
- [ ] Patient can view their encounters, conditions, and care plans in medical records
- [ ] All clinical data is stored as FHIR R4 compliant resources
- [ ] Problem list aggregates active conditions across encounters

## FHIR Compliance Notes

Core FHIR R4 resources used:
- **Encounter** — clinical visit documentation (class, status, reason, participant, period)
- **Observation** — vital signs with LOINC codes (8867-4 HR, 85354-9 BP, 2708-6 SpO2, 8310-5 Temp)
- **Condition** — diagnoses/problems with SNOMED CT / ICD-10 codes
- **Procedure** — procedures performed with SNOMED CT codes
- **CarePlan** — treatment plans with activities and goals
- **ServiceRequest** — lab/imaging/referral orders with LOINC codes
- **MedicationRequest** — prescriptions with RxNorm codes and dosage instructions

## Mock Data Requirements

- Extend mock seed with:
  - 2 completed encounters for demo patients with full clinical data
  - 1 in-progress encounter for workspace testing
  - Conditions with proper SNOMED codes (hypertension: 38341003, diabetes: 73211009)
  - A care plan for diabetes management
- Ensure encounter workspace can be tested with seeded patient data

## Complexity Estimate

**Very High** — the core clinical feature with multiple interconnected screens and complex state management. The encounter workspace alone has 6 tabs, each creating different FHIR resources. Requires careful attention to FHIR resource linking (encounter references in all child resources).
