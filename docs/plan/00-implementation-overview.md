# Clinical Curator — Implementation Overview

## Vision

A FHIR R4-compliant clinical health platform for Nepal with offline-first architecture, dual-role support (patient/doctor), granular admin RBAC, and full clinical documentation workflows.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter 3.11+ / shadcn_flutter |
| State | flutter_riverpod 2.6.1 |
| Routing | go_router 17.1.0 |
| Local DB | Hive CE 2.7.0 (26 typed collections) |
| Backend | Serverpod 3.4.5 |
| Server DB | PostgreSQL 16 + Redis |
| FHIR | fhir ^0.12.1 (R4) |
| Auth | Serverpod Auth module |
| Charts | fl_chart 0.70.2 |
| Maps | flutter_map 7.0.2 |
| Video | flutter_webrtc |
| Notifications | firebase_messaging |

## Feature Files

| # | Feature | File | Depends On |
|---|---------|------|-----------|
| 01 | Data Layer Foundations | [01-feature-data-layer.md](01-feature-data-layer.md) | — |
| 02 | Auth & RBAC | [02-feature-auth-rbac.md](02-feature-auth-rbac.md) | 01 |
| 03 | FHIR Resources | [03-feature-fhir-resources.md](03-feature-fhir-resources.md) | 01 |
| 04 | Offline Sync | [04-feature-offline-sync.md](04-feature-offline-sync.md) | 01, 03 |
| 05 | Admin Dashboard | [05-feature-admin-dashboard.md](05-feature-admin-dashboard.md) | 01, 02 |
| 06 | Hospital Management | [06-feature-hospital-management.md](06-feature-hospital-management.md) | 03, 05 |
| 07 | Clinical Workflows | [07-feature-clinical-workflows.md](07-feature-clinical-workflows.md) | 03, 04 |
| 08 | Appointment Booking | [08-feature-appointment-booking.md](08-feature-appointment-booking.md) | 06, 07 |
| 09 | Integrations | [09-feature-integrations.md](09-feature-integrations.md) | 04, 08 |
| 10 | AI Triage Placeholder | [10-feature-ai-triage.md](10-feature-ai-triage.md) | 08 |
| 11 | Testing & Deployment | [11-feature-testing-deployment.md](11-feature-testing-deployment.md) | All |

## Dependency Graph

```
01 Data Layer
 ├──> 02 Auth & RBAC
 │     └──> 05 Admin Dashboard
 │           └──> 06 Hospital Management
 ├──> 03 FHIR Resources
 │     ├──> 04 Offline Sync
 │     │     ├──> 07 Clinical Workflows
 │     │     └──> 09 Integrations
 │     └──> 06 Hospital Management
 │           └──> 08 Appointment Booking
 │                 ├──> 09 Integrations
 │                 └──> 10 AI Triage
 └──> 11 Testing & Deployment (after all)
```

## Key Decisions

| Decision | Choice |
|----------|--------|
| Admin roles | Granular RBAC with fine-grained permissions |
| Hospital data | Full profile (departments, capacity, equipment, staff) |
| Practitioner assignment | Multi-hospital via FHIR PractitionerRole |
| FHIR storage | Typed Hive collections per resource type |
| FHIR scope | All clinical resources (12+ resource types) |
| Offline | Everything except admin operations |
| Sync conflicts | Last-write-wins by timestamp |
| Auth | Serverpod Auth module (email, Google, Apple) |
| Audit | Full trail with admin UI screen |
| Clinical workflows | Full documentation (encounters, conditions, orders, care plans) |
| Integrations | WebRTC + GPS + FCM + payment UI (mock gateway) |
| Analytics | Charts, trends, CSV/PDF export |
| Booking | Flexible 3-path flow + future AI triage |
| AI triage | Placeholder UI + architecture for Claude API |
| Nepal Health ID | Mock but realistic format |
| Payments | eSewa/Khalti mock gateway ready |

## Hive TypeId Registry

| TypeId | Collection | Status |
|--------|-----------|--------|
| 0 | UserAccount | Existing |
| 1 | FhirResource | Existing (keep for backward compat) |
| 2 | AmbulanceRequestLocal | Existing |
| 3 | AppointmentLocal | Existing |
| 4 | ScheduleSlotLocal | Existing |
| 5 | PharmacyOrderLocal | Existing |
| 6 | InsuranceClaimLocal | Existing |
| 7 | NotificationRecordLocal | Existing |
| 8 | HealthTipLocal | Existing |
| 9 | OrganizationLocal | Existing (to be extended) |
| 10 | LabBookingLocal | Existing |
| 11 | EncounterLocal | **New** |
| 12 | ConditionLocal | **New** |
| 13 | ProcedureLocal | **New** |
| 14 | CarePlanLocal | **New** |
| 15 | ServiceRequestLocal | **New** |
| 16 | MedicationRequestLocal | **New** |
| 17 | LocationLocal | **New** |
| 18 | HealthcareServiceLocal | **New** |
| 19 | PractitionerRoleLocal | **New** |
| 20 | SlotLocal | **New** |
| 21 | ImmunizationLocal | **New** |
| 22 | AllergyIntoleranceLocal | **New** |
| 23 | AuditEventLocal | **New** |
| 24 | RbacPermissionLocal | **New** |
| 25 | PaymentLocal | **New** |
