⚠️ DEPRECATED — Superseded by docs/plan/12-18
This describes the legacy mock-data architecture. See 18-nepal-complete-system.md for current FHIR-native design.
---
# Feature 03 — FHIR Resources

## Overview

Extend FHIR resource coverage from the current 8 resource types to the full clinical set (14+ types). Add typed repositories for each new resource, create providers for accessing them, and extend the mock seed with realistic clinical data.

## Dependencies

- Feature 01 (Data Layer) — new Hive collections for typed local storage

## What Already Exists

### Repositories — `lib/data/repositories/`

| File | Extends | Resource Type |
|------|---------|--------------|
| `base_repository.dart` | — | Generic `FhirResource` CRUD via Hive box |
| `patient_repository.dart` | `BaseRepository<fhir.Patient>` | Patient |
| `observation_repository.dart` | `BaseRepository<fhir.Observation>` | Observation |
| `diagnostic_report_repository.dart` | `BaseRepository<fhir.DiagnosticReport>` | DiagnosticReport |
| `medication_repository.dart` | `BaseRepository<fhir.MedicationRequest>` | MedicationRequest |
| `consent_repository.dart` | `BaseRepository<fhir.Consent>` | Consent |

### Providers — `lib/domain/providers/`

| File | Provides |
|------|----------|
| `patient_data_provider.dart` | Vitals, labs, medications, immunizations, allergies (family providers) |
| `practitioner_data_provider.dart` | All patients, patient count, appointments, slots, pending verifications |
| `consent_provider.dart` | Consent list, grant/revoke |

### FHIR Infrastructure

| File | Purpose |
|------|---------|
| `lib/core/network/fhir_api_service.dart` | Dio-based FHIR REST client with typed search helpers |
| `lib/core/constants/fhir_constants.dart` | LOINC codes, SNOMED, Nepal health ID system URIs |
| `lib/core/utils/fhir_helpers.dart` | Utility functions for FHIR resource manipulation |

### Mock Data — `lib/data/mock/mock_seed.dart`

Currently seeds: Patient, Practitioner, Observation (vitals), DiagnosticReport, MedicationRequest, Immunization, AllergyIntolerance, Consent

### BaseRepository Pattern

All repositories extend `BaseRepository<T extends fhir.Resource>` which:
- Stores resources in the generic `FhirResource` Hive box as JSON
- Filters by `resourceType` string
- Supports `syncStatus` tracking (0=synced, 1=pending, 2=delete)
- Provides: `getLocalResources()`, `parseLocalResources()`, `saveLocally()`, `deleteLocally()`, `findByFhirId()`

## What Needs to Be Built

### New Typed Repositories — `lib/data/repositories/`

| File | Class | Resource Type | Key Methods Beyond Base |
|------|-------|--------------|------------------------|
| `encounter_repository.dart` | `EncounterRepository` | `fhir.Encounter` | `getByPatient()`, `getByPractitioner()`, `getByDateRange()`, `getActive()` |
| `condition_repository.dart` | `ConditionRepository` | `fhir.Condition` | `getActiveByPatient()`, `getResolvedByPatient()`, `getProblemList()` |
| `procedure_repository.dart` | `ProcedureRepository` | `fhir.Procedure` | `getByEncounter()`, `getByPatient()` |
| `care_plan_repository.dart` | `CarePlanRepository` | `fhir.CarePlan` | `getActiveByPatient()`, `getByStatus()` |
| `service_request_repository.dart` | `ServiceRequestRepository` | `fhir.ServiceRequest` | `getPendingByPatient()`, `getByRequester()`, `getByEncounter()` |
| `immunization_repository.dart` | `ImmunizationRepository` | `fhir.Immunization` | `getByPatient()`, `getByVaccineCode()` |
| `allergy_intolerance_repository.dart` | `AllergyIntoleranceRepository` | `fhir.AllergyIntolerance` | `getActiveByPatient()`, `getByCriticality()` |
| `location_repository.dart` | `LocationRepository` | `fhir.Location` | `getByOrganization()`, `getByType()` |
| `healthcare_service_repository.dart` | `HealthcareServiceRepository` | `fhir.HealthcareService` | `getByOrganization()`, `getBySpecialty()` |
| `practitioner_role_repository.dart` | `PractitionerRoleRepository` | `fhir.PractitionerRole` | `getByPractitioner()`, `getByOrganization()`, `getBySpecialty()` |
| `practitioner_repository.dart` | `PractitionerRepository` | `fhir.Practitioner` | `getBySpecialty()`, `getVerified()` |

### New Providers — `lib/domain/providers/`

| File | Key Providers |
|------|---------------|
| `encounter_provider.dart` | `encountersByPatientProvider(patientRef)`, `encountersByPractitionerProvider(practRef)`, `activeEncounterProvider`, `encountersByDateRangeProvider` |
| `condition_provider.dart` | `activeConditionsProvider(patientRef)`, `problemListProvider(patientRef)`, `resolvedConditionsProvider(patientRef)` |
| `procedure_provider.dart` | `proceduresByEncounterProvider(encounterRef)`, `proceduresByPatientProvider(patientRef)` |
| `care_plan_provider.dart` | `activeCarePlansProvider(patientRef)`, `carePlanDetailProvider(fhirId)` |
| `service_request_provider.dart` | `pendingOrdersProvider(patientRef)`, `completedOrdersProvider(patientRef)`, `ordersByRequesterProvider(practRef)` |
| `location_provider.dart` | `locationsByOrgProvider(orgRef)`, `locationsByTypeProvider(type)` |
| `healthcare_service_provider.dart` | `servicesByOrgProvider(orgRef)`, `servicesBySpecialtyProvider(specialty)` |
| `practitioner_role_provider.dart` | `rolesByPractitionerProvider(practRef)`, `rolesByOrgProvider(orgRef)`, `practitionersBySpecialtyProvider(specialty)` |

### FhirApiService Extensions — `lib/core/network/fhir_api_service.dart`

Add search helpers for:
- `searchEncounters({patientRef, practitionerRef, dateRange, status})`
- `searchConditions({patientRef, clinicalStatus})`
- `searchProcedures({patientRef, encounterRef})`
- `searchCarePlans({patientRef, status})`
- `searchServiceRequests({patientRef, requesterRef, status})`
- `searchLocations({organizationRef, type})`
- `searchHealthcareServices({organizationRef, specialty})`
- `searchPractitionerRoles({practitionerRef, organizationRef})`

### FHIR Constants Extensions — `lib/core/constants/fhir_constants.dart`

Add:
- Encounter class codes (AMB, EMER, IMP, OBSENC)
- Encounter status codes (planned, arrived, triaged, in-progress, finished, cancelled)
- Condition clinical status codes (active, recurrence, relapse, inactive, remission, resolved)
- Condition verification status codes (unconfirmed, provisional, differential, confirmed)
- Procedure status codes (preparation, in-progress, not-done, on-hold, stopped, completed)
- ServiceRequest status/priority codes
- CarePlan status codes (draft, active, on-hold, revoked, completed)

### Mock Seed Extension — `lib/data/mock/mock_seed.dart`

Add realistic clinical data:
- 3 encounters for demo patients (1 ambulatory checkup, 1 emergency visit, 1 follow-up)
- 4 conditions (hypertension active, diabetes active, fracture resolved, URI resolved)
- 2 procedures (blood draw, wound dressing)
- 1 care plan (diabetes management with 3 activities)
- 2 service requests (HbA1c lab order, chest X-ray)
- 2 practitioner roles linking Dr. Sharma to organizations

## Implementation Order

1. Create all 11 new repository files (extend `BaseRepository`)
2. Create all 8 new provider files
3. Add search helpers to `FhirApiService`
4. Extend `fhir_constants.dart` with new code systems
5. Extend mock seed with clinical data
6. Verify all providers return correctly parsed FHIR resources

## Acceptance Criteria

- [ ] All 11 new repositories extend `BaseRepository` with typed CRUD
- [ ] All 8 new providers return properly parsed FHIR R4 resources
- [ ] Repository filtering methods work correctly (by patient, practitioner, status, date)
- [ ] `FhirApiService` supports search for all new resource types
- [ ] Mock seed includes realistic clinical data (encounters, conditions, procedures, care plans)
- [ ] Existing 5 repositories and providers continue to work unchanged
- [ ] FHIR constants include all necessary code systems for clinical workflows

## FHIR Compliance Notes

All repositories use the `fhir ^0.12.1` package for proper R4 resource parsing. Resources are stored as JSON in the `FhirResource` Hive box and parsed via `fhir.Resource.fromJson()`. Each repository enforces proper `resourceType` filtering.

New FHIR R4 resource types: Encounter, Condition, Procedure, CarePlan, ServiceRequest, Location, HealthcareService, PractitionerRole, Immunization (typed repo), AllergyIntolerance (typed repo), Practitioner (typed repo).

## Mock Data Requirements

All mock clinical data should:
- Reference existing demo patients (Ram Thapa, Sita Gurung, etc.)
- Reference existing demo practitioners (Dr. Sharma, Nurse Poudel)
- Use proper LOINC/SNOMED/ICD-10 codes from `fhir_constants.dart`
- Have realistic Nepal clinical scenarios (altitude sickness, tropical diseases, etc.)

## Complexity Estimate

**Medium-High** — 11 repositories + 8 providers + API service extension + constants + mock data. Follows the established `BaseRepository` pattern closely, making individual files straightforward but volume is significant.
