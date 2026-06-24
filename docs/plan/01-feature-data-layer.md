⚠️ DEPRECATED — Superseded by docs/plan/12-18
This describes the legacy mock-data architecture. See 18-nepal-complete-system.md for current FHIR-native design.
---
# Feature 01 — Data Layer Foundations

## Overview

Establish the remaining 15 Hive CE collections (TypeIds 11–25), extend `DatabaseService` to register and open them, create matching Serverpod `.spy.yaml` models, and add corresponding server endpoints. This is the foundational layer that all other features depend on.

## Dependencies

None — this is the base layer.

## What Already Exists

### Hive Collections (11 of 26)

| TypeId | Class | File |
|--------|-------|------|
| 0 | `UserAccount` | `lib/data/collections/user_account_collection.dart` |
| 1 | `FhirResource` | `lib/data/collections/fhir_resource_collection.dart` |
| 2 | `AmbulanceRequestLocal` | `lib/data/collections/ambulance_request_collection.dart` |
| 3 | `AppointmentLocal` | `lib/data/collections/appointment_collection.dart` |
| 4 | `ScheduleSlotLocal` | `lib/data/collections/schedule_slot_collection.dart` |
| 5 | `PharmacyOrderLocal` | `lib/data/collections/pharmacy_order_collection.dart` |
| 6 | `InsuranceClaimLocal` | `lib/data/collections/insurance_claim_collection.dart` |
| 7 | `NotificationRecordLocal` | `lib/data/collections/notification_record_collection.dart` |
| 8 | `HealthTipLocal` | `lib/data/collections/health_tip_collection.dart` |
| 9 | `OrganizationLocal` | `lib/data/collections/organization_collection.dart` |
| 10 | `LabBookingLocal` | `lib/data/collections/lab_booking_collection.dart` |

### Database Service
- `lib/core/database/isar_service.dart` — registers 11 adapters, opens 11 boxes, provides static getters

### Serverpod Models (11 of 26)
- `clinical_curator_server/lib/src/models/` — 11 `.spy.yaml` files matching the Hive collections above

### Pattern Reference
Every existing collection follows: `@HiveType(typeId: N)`, `@HiveField(M)` for each field, `part 'filename.g.dart'`, `extends HiveObject`, `late` for required fields, nullable for optional. All syncable collections include `late int syncStatus`.

## What Needs to Be Built

### 15 New Hive Collections — `lib/data/collections/`

| TypeId | Class | File | Key Fields |
|--------|-------|------|------------|
| 11 | `EncounterLocal` | `encounter_collection.dart` | fhirId, patientRef, practitionerRef, status, classCode, startDate, endDate, organizationRef, reasonJson, syncStatus |
| 12 | `ConditionLocal` | `condition_collection.dart` | fhirId, patientRef, code, displayName, clinicalStatus, verificationStatus, onsetDate, abatementDate, recordedDate, syncStatus |
| 13 | `ProcedureLocal` | `procedure_collection.dart` | fhirId, patientRef, encounterRef, code, displayName, status, performedDate, performerRef, syncStatus |
| 14 | `CarePlanLocal` | `care_plan_collection.dart` | fhirId, patientRef, status, intent, title, periodStart, periodEnd, activitiesJson, goalsJson, syncStatus |
| 15 | `ServiceRequestLocal` | `service_request_collection.dart` | fhirId, patientRef, requesterRef, code, displayName, status, priority, encounterRef, occurrenceDate, syncStatus |
| 16 | `MedicationRequestLocal` | `medication_request_collection.dart` | fhirId, patientRef, requesterRef, medicationCode, medicationName, status, dosageJson, dispenseJson, syncStatus |
| 17 | `LocationLocal` | `location_collection.dart` | fhirId, name, type, address, latitude, longitude, organizationRef, status, syncStatus |
| 18 | `HealthcareServiceLocal` | `healthcare_service_collection.dart` | fhirId, organizationRef, name, type, specialty, availableTimeJson, locationRef, active, syncStatus |
| 19 | `PractitionerRoleLocal` | `practitioner_role_collection.dart` | fhirId, practitionerRef, organizationRef, code, specialty, locationRefsJson, availableTimeJson, active, syncStatus |
| 20 | `SlotLocal` | `slot_collection.dart` | fhirId, scheduleRef, status, startTime, endTime, serviceType, practitionerRef, syncStatus |
| 21 | `ImmunizationLocal` | `immunization_collection.dart` | fhirId, patientRef, vaccineCode, vaccineName, occurrenceDate, status, lotNumber, site, route, doseQuantity, syncStatus |
| 22 | `AllergyIntoleranceLocal` | `allergy_intolerance_collection.dart` | fhirId, patientRef, code, displayName, clinicalStatus, verificationStatus, type, category, criticality, onsetDate, syncStatus |
| 23 | `AuditEventLocal` | `audit_event_collection.dart` | fhirId, type, action, recorded, agentRef, agentName, entityRef, entityType, outcome, detail, syncStatus |
| 24 | `RbacPermissionLocal` | `rbac_permission_collection.dart` | roleId, roleName, resource, action, isAllowed, createdAt |
| 25 | `PaymentLocal` | `payment_collection.dart` | fhirId, patientRef, amount, currency, status, method, gateway, transactionId, appointmentRef, description, createdAt, syncStatus |

### DatabaseService Updates — `lib/core/database/isar_service.dart`

1. Add 15 new import statements for the new collection files
2. Add 15 new box name constants (e.g., `static const String encountersBox = 'encounters'`)
3. Register 15 new adapters in `initialize()` with `isAdapterRegistered` guard
4. Open 15 new boxes in `initialize()`
5. Add 15 new static getters (e.g., `static Box<EncounterLocal> get encounters => ...`)

### Serverpod Models — `clinical_curator_server/lib/src/models/`

15 new `.spy.yaml` files mirroring each Hive collection:
- `encounter.spy.yaml`
- `condition.spy.yaml`
- `procedure.spy.yaml`
- `care_plan.spy.yaml`
- `service_request.spy.yaml`
- `medication_request.spy.yaml`
- `location.spy.yaml`
- `healthcare_service.spy.yaml`
- `practitioner_role.spy.yaml`
- `slot.spy.yaml`
- `immunization.spy.yaml`
- `allergy_intolerance.spy.yaml`
- `audit_event.spy.yaml`
- `rbac_permission.spy.yaml`
- `payment.spy.yaml`

### Mock Seed Extension — `lib/data/mock/mock_seed.dart`

Add sample data for at least:
- 3 encounters (ambulatory, emergency, inpatient)
- 4 conditions (2 active, 2 resolved)
- 2 procedures
- 1 care plan with activities
- 2 service requests (lab order, imaging)
- 3 locations (hospital wings)
- 2 healthcare services
- 2 practitioner roles
- Sample slots for existing schedules
- 2 audit events

## Implementation Order

1. Create all 15 collection `.dart` files (follow `appointment_collection.dart` as template)
2. Run `dart run build_runner build` to generate `.g.dart` adapter files
3. Update `DatabaseService` with imports, constants, adapter registrations, box openings, getters
4. Create 15 Serverpod `.spy.yaml` model files
5. Run `serverpod generate` in the server package
6. Extend mock seed with sample data
7. Verify app starts and opens all 26 boxes without errors

## Acceptance Criteria

- [ ] All 15 new Hive collections compile with `build_runner`
- [ ] `DatabaseService.initialize()` registers all 26 adapters and opens all 26 boxes
- [ ] Each collection class follows the established pattern (`@HiveType`, `@HiveField`, `extends HiveObject`)
- [ ] All 15 Serverpod models generate via `serverpod generate`
- [ ] Mock seed creates sample data for clinical collections
- [ ] Existing functionality is unbroken (all 11 original boxes still work)
- [ ] `hive_registrar.g.dart` regenerated successfully
- [ ] App launches on all targets (mobile, web, desktop) without Hive registration errors

## FHIR Compliance Notes

New collections map to these FHIR R4 resource types:
- Encounter, Condition, Procedure, CarePlan, ServiceRequest, MedicationRequest — core clinical
- Location, HealthcareService, PractitionerRole, Slot — facility & scheduling
- Immunization, AllergyIntolerance — patient history
- AuditEvent — security & compliance

`RbacPermissionLocal` and `PaymentLocal` are app-domain models, not direct FHIR resources.

## Mock Data Requirements

Extend `lib/data/mock/mock_seed.dart` to seed:
- Clinical data tied to existing demo patients (Dr. Sharma, Ram Thapa, etc.)
- Encounters with realistic Nepal clinical scenarios
- Conditions using ICD-10/SNOMED codes from `lib/core/constants/fhir_constants.dart`
- Locations within the seeded organizations

## Complexity Estimate

**High** — 15 collection files + 15 generated files + 15 server models + DatabaseService rewrite + mock seed extension. Approximately 45+ new files. However, each follows an established, repetitive pattern.
