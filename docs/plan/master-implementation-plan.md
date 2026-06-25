# Clinical Curator — Master Implementation Plan

> **Audience**: AI coding agents, developers, and architects building the Nepal EMR Platform
>
> **Scope**: Multi-tenant FHIR-native EMR + PHR + Admin with offline-first capability
>
> **Version**: 1.0 — June 2026

---

## Table of Contents

1. [Current System State](#1-current-system-state)
2. [Design Audit (HTML Designs)](#2-design-audit-html-designs)
3. [Nepal EMR Plan Gap Analysis](#3-nepal-emr-plan-gap-analysis)
4. [FHIR Interoperability Status](#4-fhir-interoperability-status)
5. [Multi-Tenancy Architecture](#5-multi-tenancy-architecture)
6. [EMR Implementation Plan](#6-emr-implementation-plan)
7. [PHR Integration Strategy](#7-phr-integration-strategy)
8. [Admin & Superadmin Controls](#8-admin--superadmin-controls)
9. [FHIR Interoperability Baseline](#9-fhir-interoperability-baseline)
10. [Development Roadmap](#10-development-roadmap)
11. [AI Coding Guide](#11-ai-coding-guide)
12. [Design-to-Code Mapping](#12-design-to-code-mapping)
13. [Implementation Priority & Effort](#13-implementation-priority--effort)
14. [Reference Index](#14-reference-index)

---

## 1. Current System State

### 1.1 Technology Stack

| Layer | Technology | Version |
|---|---|---|
| Frontend (Clinical + PHR) | Flutter + shadcn_flutter | 3.x / 0.0.52 |
| State Management | flutter_riverpod | — |
| Local Storage | Hive CE | — |
| Backend | Serverpod | 3.4.5 |
| Database | PostgreSQL 16 + pgvector | 16 |
| Cache | Redis | 6.2.6 |
| Client SDK | serverpod_client | auto-generated |
| Auth | Serverpod auth + JWT + bcrypt | 3.4.5 |
| Health Data | FHIR R4 | R4 |
| Containerization | Docker + Docker Compose | — |

### 1.2 Monorepo Structure

```
clinical-curator/
├── apps/
│   ├── clinical/          # Patient + Clinician Flutter app (26 feature dirs)
│   └── admin/             # Admin Flutter app (verification, RBAC, audit, orgs)
├── clinical_curator_server/ # Serverpod backend (16 endpoint groups)
├── clinical_curator_client/  # Auto-generated Serverpod client SDK
├── packages/
│   ├── core/ (cc_core)    # Design tokens, theme, config, auth primitives
│   ├── data/ (cc_data)    # Hive DB service, mock/reference seed, providers
│   ├── fhir_models/ (cc_fhir_models) # Hive TypeAdapter collections + domain models
│   └── rbac/ (cc_rbac)    # Role-based access control
├── designs/               # HTML design files from Claude design agent
├── docs/
│   ├── plan/              # Existing implementation plan docs (21 files)
│   ├── plan/design-specification.md  # UI/UX design spec (1,457 lines)
│   └── plan/master-implementation-plan.md # This file
└── docker-compose.yaml    # PostgreSQL + Redis services
```

### 1.3 Backend Endpoints (Protocol.yaml)

| Endpoint Group | Methods | Status |
|---|---|---|
| `admin` | listPendingVerifications, approvePractitioner, rejectPractitioner, getDashboardStats, listVerifiedPractitioners, listAllUsers, setUserVerified, getAnalytics | ✅ Existing |
| `ambulance` | request, updateStatus, cancelWithReason, completeWithRating, getById, listForPatient, listActive | ✅ Existing |
| `appointment` | book, cancel, complete, listForPatient, listForPractitioner, listTodayForPractitioner, getById | ✅ Existing |
| `audit` | list, recent, record | ✅ Existing |
| `auth` | login, signup, registerPractitioner, getByEmail, getById, updateProfile, changePassword | ✅ Existing |
| `emailIdp` | login, startRegistration, verifyRegistrationCode, finishRegistration, startPasswordReset, verifyPasswordResetCode, finishPasswordReset, hasAccount | ✅ Existing |
| `fhirResource` | create, read, update, deleteById, searchByType, searchByPatient, searchByPractitioner, getChangesSince | ✅ Existing |
| `fhirSync` | since, push, purgeDemoData | ✅ Existing |
| `healthTip` | listAll, listAllAdmin, listByCategory, getById, create, update, delete | ✅ Existing |
| `insurance` | submitClaim, listClaims, updateStatus, getById | ✅ Existing |
| `labBooking` | create, listForPatient, updateStatus, getById | ✅ Existing |
| `notification` | create, listForUser, markAsRead, markAllAsRead, getUnreadCount | ✅ Existing |
| `organization` | listAll, listHospitals, listPharmacies, search, getById, create, update, delete | ✅ Existing |
| `pharmacy` | createOrder, listOrders, updateStatus, getById | ✅ Existing |
| `rbac` | listAll, listForRole, setPermission, deletePermission | ✅ Existing |
| `schedule` | createSlot, updateSlot, deleteSlot, listSlots, listAvailableSlots, bookSlot | ✅ Existing |
| `webrtcSignaling` | subscribe, send | ✅ Existing |
| `greeting` | hello | ✅ Existing |

### 1.4 FHIR Tables in PostgreSQL

| Table | Status |
|---|---|
| `user_accounts` | ✅ Seeded (admin + 3 auth accounts) |
| `fhir_resources` | ✅ Seeded (60+ resources) |
| `serverpod_auth_idp_email_account` | ✅ Seeded (3 accounts) |
| `serverpod_auth_core_user` | ✅ Seeded |
| `appointments` | ✅ Seeded (15 appointments) |
| `schedule_slots` | ✅ Seeded (70 slots) |
| `organizations` | ✅ Seeded (11 orgs) |
| `health_tips` | ✅ Seeded (5 tips) |
| `notification_records` | ✅ Seeded (12 notifications) |
| `insurance_claims` | ✅ Seeded (4 claims) |
| `pharmacy_orders` | ✅ Seeded (4 orders) |
| `lab_bookings` | ✅ Seeded (3 bookings) |
| `rbac_permissions` | ✅ Table exists |

### 1.5 Frontend Screens (Clinical App)

| Screen | Route | Status |
|---|---|---|
| Login | `/login` | ✅ Complete |
| Signup / Practitioner Registration | `/signup` | ✅ Complete |
| Patient Home | `/patient-home` | 🟡 Needs refinement |
| Doctor Dashboard | `/doctor-dashboard` | ✅ Complete (needs EMR integration) |
| Doctor Schedule (Timesheet) | `/doctor-schedule` | ✅ Complete (all features) |
| Add Schedule Entry | `/schedule-entry` | ✅ Complete |
| Patient Detail | `/patient-detail/:id` | 🟡 Partial (vitals + timeline) |
| Patient Management (list) | `/patient-management` | 🟡 Partial |
| Medical Records | `/medical-records` | 🟡 Needs refinement |
| Booking / Reschedule | `/bookings` | 🟡 Partial |
| Hospitals | `/hospitals` | 🟡 Basic |
| Pharmacy | `/pharmacy` | 🟡 Basic |
| Lab Booking | `/lab-booking` | 🟡 Basic |
| Insurance | `/insurance` | 🟡 Basic |
| Notifications | `/notifications` | 🟡 Basic |
| Ambulance | `/ambulance` | 🟡 Basic |
| Health Tips | `/health-tips` | ✅ Complete |
| Telemedicine | `/telemedicine` | 🟡 Basic (WebRTC skeleton) |
| Profile & Settings | `/profile` | 🟡 Partial |
| Onboarding | `/onboarding/**` | 🟡 Basic |
| Consent | `/consent` | 🟡 Basic |
| Encounter Workspace | `/encounter/:id` | 🔴 **Missing** |
| Patient Chart (EMR) | `/patient-chart/:id` | 🔴 **Missing** |

### 1.6 Sync Service Status

| Feature | Status |
|---|---|
| FHIR resource sync (push + pull) | ✅ Complete |
| Schedule slot sync (push) | ✅ Complete |
| Offline detection | ✅ Complete |
| Sync toggle in settings | ✅ Complete (SharedPreferences) |
| Pending count tracking | ✅ Complete |
| Conflict resolution (try-create → fallback to update) | ✅ Complete |

### 1.7 Auth Accounts (Functional)

| Role | Email | Password |
|---|---|---|
| Admin | `admin@example.com` | `admin123` |
| Patient | `arjun@example.com` | `password123` |
| Practitioner | `arpan@example.com` | `password123` |
| Practitioner | `elena@example.com` | `password123` |

---

## 2. Design Audit (HTML Designs)

Claude generated 3 HTML design files in `designs/PHR and EMR app design/`:

### 2.1 EMR Design File
**File**: `designs/PHR and EMR app design/Clinical Curator EMR.dc.html`

**Design system**: Desktop-focused with sidebar navigation (not bottom nav like current mobile app):
- Sidebar: Dashboard, Schedule, Patients, Health Tips, Profile, Logout
- Top-left logo + "Clinical Curator — Clinician Portal"
- Uses: #004AC6 primary blue, #F8FAFC background, card-based layout

**Screens in design**:

| # | Screen Name | Key Elements |
|---|---|---|
| 1 | **Doctor Dashboard** | 3 stat cards (Total Patients, In Queue, Today), Today's Schedule (3 cards), Find Patient bar, New Referral button, OPD Queue with checked-in/vitals buttons, Quick Actions |
| 2 | **EMR Patient Chart** | Patient header with name/age/gender/ID, Start Encounter button, Allergies/Active Conditions chips, Tabs: Overview, Encounters, Vitals, Labs, Medications, Immunizations; Vitals Summary cards, Active Medications list, Recent Encounters list |
| 3 | **Encounter Workspace (SOAP)** | Encounter header (Patient, Type, Status), Tab: Subjective (CC + HPI), Tab: Objective (Vitals + PE), Tab: Assessment (ICD-10 search + diagnoses), Tab: Plan (Orders + prescriptions + follow-up), Save Draft + Complete Encounter buttons |
| 4 | **Schedule** | Sidebar Schedule active, week view with time grid, slots displayed as colored blocks on grid, patient names on booked slots |

**Design notes**: The designs use a **sidebar layout** not bottom nav. For mobile responsiveness we may want to adapt to bottom nav on phones but sidebar on tablets/desktop.

### 2.2 PHR Design File
**File**: `designs/PHR and EMR app design/Clinical Curator PHR.dc.html`

**Screens**:
- Patient home dashboard (health summary, upcoming appointments, quick actions)
- Appointments view (upcoming + past)
- Medical records (lab results, medications, immunizations)
- Profile

### 2.3 Admin Design File
**File**: `designs/PHR and EMR app design/Clinical Curator Admin.dc.html`

**Screens**:
- Admin dashboard with stats
- Practitioner verification queue
- User management
- Organization management
- Audit log

### 2.4 Generated App Code in Designs Folder

The `designs/PHR and EMR app design/apps/` folder contains **partial Flutter file stubs** that Claude generated:

| File | Content |
|---|---|
| `apps/admin/lib/features/admin/screens/admin_dashboard_screen.dart` | Admin dashboard stub |
| `apps/clinical/lib/features/auth/screens/login_screen.dart` | Login stub |
| `apps/clinical/lib/features/doctor_dashboard/screens/doctor_dashboard_screen.dart` | Dashboard stub with stats + queue |
| `apps/clinical/lib/features/doctor_schedule/screens/schedule_timesheet_screen.dart` | Schedule stub |
| `apps/clinical/lib/features/patient_home/screens/patient_home_screen.dart` | Patient home stub |
| `packages/core/lib/constants/app_colors.dart` | Color constants |
| `packages/core/lib/constants/app_radius.dart` | Radius constants |
| `packages/core/lib/constants/app_spacing.dart` | Spacing constants |
| `packages/core/lib/constants/app_typography.dart` | Typography constants |
| `packages/core/lib/theme/app_theme.dart` | Theme definition |
| `packages/core/lib/theme/clinical_colors.dart` | Clinical color tokens |
| `apps/clinical/lib/main.dart` | App entry point stub |

**Note**: These generated files are **simplified stubs** and need to be merged with the existing production code. The existing codebase has working versions of many of these files in the actual package locations under `packages/core/lib/`. Use the designs folder for **layout reference** but use the `packages/` source as the real codebase.

---

## 3. Nepal EMR Plan Gap Analysis

### 3.1 Completion by Module

| Module | Completion | Status |
|---|---|---|
| **Patient Registry** | 50% (3/6 done) | 🟡 |
| **Appointment System** | 67% (4/6 done) | 🟡 |
| **OPD Module (Encounters)** | 33% (3/9 done) | 🔴 |
| **Vitals Module** | 50% (2/4 done) | 🟡 |
| **Pharmacy** | 17% (1/6 done) | 🔴 |
| **Laboratory** | 20% (1/5 done) | 🔴 |
| **Immunization** | 25% (1/4 done) | 🔴 |
| **Maternal Health** | 0% (0/4 done) | 🔴 |
| **Child Health** | 0% (0/3 done) | 🔴 |
| **NCD Module** | 50% (2/4 done) | 🟡 |
| **Referral Module** | 0% (0/3 done) | 🔴 |
| **Analytics Engine** | 0% (0/4 done) | 🔴 |
| **DHIS2 Integration** | 0% (0/2 done) | 🔴 |
| **Terminology Service** | 0% (0/5 done) | 🔴 |
| **Multi-Tenancy** | 0% (0/5 done) | 🔴 |
| **Security Baseline** | 50% (3/6 done) | 🟡 |

### 3.2 Module-Specific Gap Details

#### Patient Registry (50%)
**Missing**: QR Code, National ID / Citizenship verification, Family linkage (RelatedPerson), Emergency contact
**Existing**: Registration form, FHIR Patient CRUD, healthId field, seed data (12 patients)

#### Appointment System (67%)
**Missing**: Walk-in flow, follow-up scheduling from encounter, patient-facing slot booking (practitioner slots exist but patient booking UI doesn't consume them)
**Existing**: Booking, queue management, FHIR Appointment/Schedule/Slot

#### OPD Module / Encounters (33%) — HIGHEST PRIORITY
**Missing**: Chief complaint input, History of Present Illness, Physical exam, ICD-10/SNOMED diagnosis search, Treatment plan / CarePlan surfacing, Follow-up scheduling
**Existing**: Encounter FHIR CRUD, Condition FHIR CRUD, CarePlan table exists

#### Vitals (50%)
**Missing**: Vitals capture during encounter, time-series charts
**Existing**: FHIR Observation CRUD, seed data (9 vitals + 4 BP + 6 labs)

#### Pharmacy (17%)
**Missing**: Full dispensing workflow, inventory tracking, stock tracking, expiry/batch tracking, MedicationDispense FHIR
**Existing**: PharmacyOrder creation, list, status update

#### Laboratory (20%)
**Missing**: Clinician ordering (ServiceRequest), sample collection workflow, results entry, verification workflow
**Existing**: Patient lab booking, DiagnosticReport display

#### Immunization (25%)
**Missing**: Vaccine schedules, coverage reports, reminder alerts
**Existing**: FHIR Immunization CRUD, seed data (5 immunizations)

---

## 4. FHIR Interoperability Status

### 4.1 Live FHIR Resources

| Resource | FHIR Endpoint | Codes Used |
|---|---|---|
| Patient | ✅ CRUD | NEP Health ID |
| Encounter | ✅ via fhirResource | SNOMED for reason |
| Observation (Vitals + Labs) | ✅ via fhirResource | LOINC, UCUM |
| Condition | ✅ via fhirResource | ICD-10 |
| MedicationRequest | ✅ via fhirResource | RxNorm |
| AllergyIntolerance | ✅ via fhirResource | SNOMED |
| Immunization | ✅ via fhirResource | CVX |
| DiagnosticReport | ✅ via fhirResource | LOINC |
| Appointment | ✅ via fhirResource | — |
| Organization | ✅ dedicated endpoint | — |
| Practitioner | ✅ via Organization | NMC license |
| Consent | ✅ via fhirResource | HL7 consent codes |
| Schedule/Slot | ✅ dedicated endpoint | — |

### 4.2 Measurable Interoperability Score

| Metric | Value |
|---|---|
| FHIR version | R4 (current) |
| Resources implemented | 13 |
| Terminology systems used | ICD-10, SNOMED CT, LOINC, RxNorm, CVX, UCUM |
| International Patient Summary (IPS) | **Passes** (Patient + Conditions + Meds + Allergies present) |
| FHIR Bundle endpoint | ❌ Missing |
| CapabilityStatement | ❌ Missing |
| OperationOutcome | ❌ Missing |
| _include / _revinclude | ❌ Missing |

### 4.3 Interoperability Gaps to Close

| Gap | Effort | Priority |
|---|---|---|
| FHIR Bundle wrapper for all list endpoints | 1 day | High |
| CapabilityStatement endpoint (`GET /fhir/metadata`) | 0.5 day | High |
| OperationOutcome for errors | 0.5 day | High |
| _include / _revinclude for Patient → linked resources | 1 day | Medium |
| DocumentReference for attachments | 1 day | Medium |
| PractitionerRole linking Practitioner ↔ Organization | 0.5 day | Medium |
| Provenance for audit trail in FHIR format | 1 day | Low |

---

## 5. Multi-Tenancy Architecture

### 5.1 Architecture Decision: Database-Per-Tenant

```
┌─────────────────────────────────────────────────────┐
│                  Admin Database                      │
│  ┌───────────────────────────────────────────────┐  │
│  │  organizations                                │  │
│  │  organization_databases (connection strings)   │  │
│  │  user_accounts (global, with facility_id)      │  │
│  │  serverpod_auth_core_user (global)             │  │
│  │  rbac_permissions (global — roles + scopes)    │  │
│  │  system_config                                 │  │
│  └───────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────┘
         │                    │                    │
         ▼                    ▼                    ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ Facility A  │    │ Facility B  │    │ Facility C  │
│ Database    │    │ Database    │    │ Database    │
│             │    │             │    │             │
│ All clinical│    │ All clinical│    │ All clinical│
│ tables:     │    │ tables:     │    │ tables:     │
│ patients    │    │ patients    │    │ patients    │
│ encounters  │    │ encounters  │    │ encounters  │
│ fhir_*     │    │ fhir_*     │    │ fhir_*     │
│ appointments│    │ appointments│    │ appointments│
│ schedule    │    │ schedule    │    │ schedule    │
│ ...all FHIR │    │ ...all FHIR │    │ ...all FHIR │
│ tables      │    │ tables      │    │ tables      │
│             │    │             │    │             │
│ Named:      │    │ Named:      │    │ Named:      │
│ clin_cur_fa │    │ clin_cur_fb │    │ clin_cur_fc │
└─────────────┘    └─────────────┘    └─────────────┘
```

### 5.2 Multi-Tenancy Implementation Plan

#### Step 1: Create `organization_databases` table (Migration)
```sql
CREATE TABLE organization_databases (
  id SERIAL PRIMARY KEY,
  organization_id INT NOT NULL REFERENCES organizations(id),
  db_host TEXT NOT NULL DEFAULT 'localhost',
  db_port INT NOT NULL DEFAULT 5432,
  db_name TEXT NOT NULL UNIQUE,
  db_user TEXT NOT NULL,
  db_password_encrypted TEXT NOT NULL,
  facility_slug TEXT NOT NULL UNIQUE,
  is_active BOOLEAN DEFAULT TRUE,
  module_mask INT DEFAULT 0,        -- bitmask: 1=OPD, 2=Pharmacy, 4=Lab, 8=Immunization...
  created_at TIMESTAMP DEFAULT NOW()
);
```

#### Step 2: TenantDatabaseManager Service
```dart
// clinical_curator_server/lib/src/services/tenant_db_manager.dart
class TenantDatabaseManager {
  final Map<int, DatabasePool> _pools = {};
  final DatabasePool _adminPool;

  Future<DatabasePool> forFacility(int facilityId) async { ... }
  Future<void> createFacilityDatabase(int facilityId, String slug) async { ... }
  Future<void> runMigrations(String dbName) async { ... }
}
```

#### Step 3: Add facility_id to JWT Claims
```dart
// In auth/ endpoint — when user logs in, include facility_id in JWT claims
final token = jwt.encode(
  subject: user.id.toString(),
  claims: {
    'facility_id': user.facilityId,
    'role': user.accountType,
  },
);
```

#### Step 4: Middleware or Endpoint-Local DB Routing
Each endpoint method checks the user's facility_id and routes to the appropriate database pool.

#### Step 5: Migration Runner for Tenant Databases
```dart
// bin/migrate_tenants.dart
// 1. Query all active organization_databases
// 2. For each, check tenant_migration_history for applied migrations
// 3. Apply any pending migrations from Serverpod's migration_registry.txt
// 4. Log completion
```

### 5.3 Decentralization Option

For hospitals that want on-premise data:
1. Export facility DB → send to hospital
2. Deploy Serverpod instance at hospital
3. Import DB
4. Configure central server to route API calls to hospital server for that facility
5. Central server becomes auth + routing + DHIS2 export, hospital keeps clinical data

---

## 6. EMR Implementation Plan

### 6.1 Patient Chart (Tabbed EMR Screen)

**Design reference**: `designs/Clinical Curator EMR.dc.html` → Screen 2

**File to create**: `apps/clinical/lib/features/patient_chart/screens/patient_chart_screen.dart`

**Layout** (matching the HTML design):

```
┌─────────────────────────────────────────────────────────────┐
│  ← Back to Patient List                                     │
│                                                             │
│  ┌── Patient Header ──────────────────────────────────────┐ │
│  │  Avatar(48px)  Name, Age · Gender · Health ID         │ │
│  │  Allergy Badges: ⚠ Penicillin                          │ │
│  │  Active Conditions: HTN · DM2 · COPD                   │ │
│  │  [Start Encounter] [New Order] [View All Details]      │ │
│  └─────────────────────────────────────────────────────────┘ │
│                                                             │
│  ┌── Tabs ───────────────────────────────────────────────┐ │
│  │  [Overview] [Encounters] [Vitals] [Labs] [Meds] [Imm.]│ │
│  └─────────────────────────────────────────────────────────┘ │
│                                                             │
│  ─── Tab: Overview ──────────────────────────────────────────│
│  ┌── Vitals Summary (3 cards) ────────────────────────────┐ │
│  │  [BP 120/80] [HR 72] [SpO2 98%]                       │ │
│  │  [Temp 98.6°F] [Weight] [BMI]                         │ │
│  └─────────────────────────────────────────────────────────┘ │
│  ┌── Active Medications ──────────────────────────────────┐ │
│  │  Med card: name, dose, frequency, prescriber          │ │
│  └─────────────────────────────────────────────────────────┘ │
│  ┌── Recent Encounters (last 3) ──────────────────────────┐ │
│  │  Card: date, type, practitioner, diagnosis            │ │
│  │  "View All" link                                        │ │
│  └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

**Tab implementations**:

| Tab | Content | Data Source |
|---|---|---|
| Overview | Vitals cards + Active Medications + Recent Encounters | FHIR resources filtered by patientRef |
| Encounters | List of all encounters, tap → SOAP workspace | Query fhir_resources WHERE resourceType=Encounter |
| Vitals | Time-series chart + table | Query fhir_resources WHERE category=vital-signs |
| Labs | Lab results with flags | Query fhir_resources WHERE category=laboratory |
| Medications | Active medications with [Stop]/[Renew] | Query fhir_resources WHERE resourceType=MedicationRequest |
| Immunizations | Vaccine history | Query fhir_resources WHERE resourceType=Immunization |

### 6.2 Encounter Workspace (SOAP Note)

**Design reference**: `designs/Clinical Curator EMR.dc.html` → Screen 3

**File to create**: `apps/clinical/lib/features/clinical/screens/soap_encounter_screen.dart`

**Layout**:
```
┌── Encounter Header ───────────────────────────────────────┐
│  Patient: Name  Type: [OPD/Emerg/IP]  Status: In Progress │
│  Attending: Dr. Name  Date: June 25, 2026                 │
└──────────────────────────────────────────────────────────┘

┌── Sections (vertically scrollable) ──────────────────────┐
│                                                          │
│  S — Subjective:                                         │
│  ┌── Chief Complaint ─────────────────────────────────┐ │
│  │  TextField("What brings the patient today?")        │ │
│  └────────────────────────────────────────────────────┘ │
│  ┌── History of Present Illness ───────────────────────┐ │
│  │  TextArea(4 lines, "Onset, course, severity...")    │ │
│  └────────────────────────────────────────────────────┘ │
│                                                          │
│  O — Objective:                                          │
│  ┌── Vitals Input ────────────────────────────────────┐ │
│  │  BP [___/___]  HR [___]  SpO2 [___]  Temp [___]   │ │
│  │  Weight [___]  Height [___]                        │ │
│  └────────────────────────────────────────────────────┘ │
│  ┌── Physical Exam ───────────────────────────────────┐ │
│  │  System [chips: CVS ✓  Resp  GI  Neuro  MSK  ...] │ │
│  │  (selected chip opens text field for notes)        │ │
│  └────────────────────────────────────────────────────┘ │
│                                                          │
│  A — Assessment:                                         │
│  ┌── Diagnoses ───────────────────────────────────────┐ │
│  │  [+ Add Diagnosis] → search ICD-10 / SNOMED        │ │
│  │  Each chip: "E11.9 - Type 2 diabetes" [remove]     │ │
│  │  Type: Primary / Secondary                          │ │
│  └────────────────────────────────────────────────────┘ │
│                                                          │
│  P — Plan:                                               │
│  ┌── Orders ──────────────────────────────────────────┐ │
│  │  [+ Medication Order]                               │ │
│  │  [+ Lab Order]                                      │ │
│  │  [+ Imaging Order]                                  │ │
│  │  [+ Referral]                                       │ │
│  └────────────────────────────────────────────────────┘ │
│  ┌── Follow-up ───────────────────────────────────────┐ │
│  │  DatePicker + notes TextField                       │ │
│  └────────────────────────────────────────────────────┘ │
│                                                          │
│  [Save Draft] [Complete Encounter]                       │
└──────────────────────────────────────────────────────────┘
```

### 6.3 Pseudo-Code for Key EMR Components

#### Patient Chart Provider
```dart
// packages/data/lib/providers/emr_providers.dart

/// All FHIR resources for a given patient, grouped by resource type.
final patientChartProvider = Provider.family<PatientChartData, String>((ref, patientId) {
  final box = DatabaseService.fhirResources;
  final resources = box.values.where((r) =>
    r.patientReference == 'Patient/$patientId'
  ).toList();

  return PatientChartData(
    vitals: resources.where((r) => r.category == 'vital-signs').toList(),
    conditions: resources.where((r) => r.resourceType == 'Condition').toList(),
    medications: resources.where((r) => r.resourceType == 'MedicationRequest').toList(),
    encounters: resources.where((r) => r.resourceType == 'Encounter').toList(),
    labs: resources.where((r) => r.category == 'laboratory').toList(),
    immunizations: resources.where((r) => r.resourceType == 'Immunization').toList(),
    allergies: resources.where((r) => r.resourceType == 'AllergyIntolerance').toList(),
    reports: resources.where((r) => r.resourceType == 'DiagnosticReport').toList(),
  );
});
```

#### Encounter Save Logic
```dart
/// Save a SOAP encounter
Future<void> _saveEncounter() async {
  // 1. Create/update Encounter FHIR resource
  final encounterJson = {
    'resourceType': 'Encounter',
    'id': encounterId,
    'status': 'finished',
    'class': {'code': 'AMB', 'display': 'ambulatory'},
    'subject': {'reference': 'Patient/$patientId'},
    'period': {'start': startTime, 'end': endTime},
    'diagnosis': diagnoses.map((d) => {
      'condition': {'reference': 'Condition/${d.conditionId}'},
      'use': {'coding': [{'code': d.type == 'primary' ? 'DD' : 'SEC'}]},
    }).toList(),
  };

  // 2. Create Condition resources for each diagnosis
  for (final d in diagnoses) {
    await _createCondition(d);
  }

  // 3. Create MedicationRequest resources for each prescription
  for (final m in medications) {
    await _createMedicationRequest(m);
  }

  // 4. Update vitals Observations
  await _updateVitals(vitals);

  // 5. All saved to Hive with syncStatus=1
  // 6. Bump refresh providers
}
```

#### ICD-10 Diagnosis Search
```dart
// Apps can either:
// A) Query from seeded FHIR Condition resources
// B) Load from a downloaded ICD-10 JSON bundle (recommended for scale)

final icd10Bundle = await rootBundle.loadString('assets/terminology/icd10-bundle.json');
final icd10Codes = jsonDecode(icd10Bundle)['entry'] as List;

// Search UI:
TextField(
  placeholder: const Text('Search diagnosis (ICD-10)'),
  onChanged: (query) {
    setState(() {
      results = icd10Codes.where((c) =>
        c['code'].toString().contains(query.toUpperCase()) ||
        c['display'].toLowerCase().contains(query.toLowerCase())
      ).take(20).toList();
    });
  },
);
```

---

## 7. PHR Integration Strategy

### 7.1 PHR Architecture

```
┌─────────────────────────────────────────────┐
│           PHR (Patient Portal)                │
│  ┌───────────────────────────────────────┐  │
│  │  Same Flutter app with Patient shell   │  │
│  │  (already exists: bottom nav:          │  │
│  │   Home, Appointments, Records,         │  │
│  │   Pharmacy, Profile)                   │  │
│  └───────────────┬───────────────────────┘  │
│                  │                           │
│  ┌───────────────▼───────────────────────┐  │
│  │  PHR Endpoints (NEW: phr/ endpoint)   │  │
│  │  - GET /phr/summary/:patientId        │  │
│  │  - GET /phr/vitals/:patientId         │  │
│  │  - GET /phr/records/:patientId        │  │
│  └───────────────┬───────────────────────┘  │
│                  │                           │
│  ┌───────────────▼───────────────────────┐  │
│  │  Facility EMR Database(s)              │  │
│  │  (multi-tenant, aggregated for PHR)    │  │
│  └───────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

### 7.2 PHR Endpoints to Create

```yaml
# protocol.yaml additions
phr:
  - getSummary:      # Combined health summary for patient
  - getVitals:       # All vitals across encounters
  - getRecords:      # All records, optionally filtered by type
  - getConsents:     # View own consent grants
  - grantConsent:    # Grant new consent
  - revokeConsent:   # Revoke consent
```

### 7.3 PHR Screens to Build

| Screen | Data | Existing? |
|---|---|---|
| Health Summary | Latest vitals, upcoming appts, active meds | 🟡 Partial (patient_home) |
| My Appointments | Upcoming + past + book new | 🟡 Partial (booking) |
| My Records | All FHIR resources, filterable | 🟡 Partial (medical_records) |
| My Pharmacy | Active prescriptions + order history | 🟡 Partial |
| My Lab Bookings | Lab orders + results | 🟡 Partial |
| My Profile | Account, sync toggle, preferences | 🟡 Partial |
| Consents | Grant/revoke data sharing | 🟡 Partial |

---

## 8. Admin & Superadmin Controls

### 8.1 Admin App Structure

```
apps/admin/lib/
├── main.dart
├── router.dart
├── domain/
│   └── providers/
└── features/
    ├── auth/
    │   └── screens/auth_screen.dart       # Admin login
    └── admin/
        └── screens/
            ├── admin_dashboard_screen.dart  # Design reference exists
            ├── facility_crud_screen.dart    # NEW: Facility CRUD
            ├── practitioner_verification_screen.dart  # Existing
            ├── user_management_screen.dart  # NEW: Global user management
            ├── organization_crud_screen.dart # Existing (partial)
            ├── rbac_screen.dart             # Existing (partial)
            └── audit_log_screen.dart        # Existing (partial)
```

### 8.2 Admin API Endpoints to Add

```yaml
admin:
  # -- Existing --
  - listPendingVerifications:
  - approvePractitioner:
  - rejectPractitioner:
  - getDashboardStats:
  - listVerifiedPractitioners:
  - listAllUsers:
  - setUserVerified:
  - getAnalytics:

  # -- NEW: Facility Management --
  - createFacility:           # Creates org + provisions DB
  - updateFacility:
  - deleteFacility:
  - listFacilities:
  - toggleFacilityModule:     # Enable/disable OPD, Pharmacy, Lab, etc.
  - getFacilityHealth:        # DB connection status, pending sync count, last backup

  # -- NEW: System --
  - exportToDHIS2:            # Generate DHIS2-compatible CSV/JSON
  - getSyncStatus:            # Cross-facility sync dashboard
  - runTenantMigrations:      # Re-run migrations on all tenants
  - getSystemLogs:            # Cross-facility audit log
```

### 8.3 Superadmin vs Facility-Admin

| Capability | Superadmin | Facility Admin |
|---|---|---|
| Create/edit facilities | ✅ | ❌ |
| Provision databases | ✅ | ❌ |
| View all facility data | ✅ aggregated | ❌ |
| Manage global RBAC | ✅ | ❌ |
| Approve practitioners | ❌ delegates | ✅ |
| Manage facility users | ❌ | ✅ |
| View facility audit log | ❌ | ✅ |
| Manage facility orgs | ❌ | ✅ |
| Export DHIS2 (facility) | ✅ national | ✅ facility |

### 8.4 Module Toggle Per Facility

Use a bitmask on `organization_databases.module_mask`:

```dart
enum FacilityModule {
  opd(1),
  pharmacy(2),
  lab(4),
  immunization(8),
  maternalHealth(16),
  ncd(32),
  referral(64),
  telemedicine(128),
  ambulance(256),
  insurance(512);

  final int bit;
  const FacilityModule(this.bit);
}

bool isModuleEnabled(int mask, FacilityModule module) {
  return (mask & module.bit) != 0;
}
```

---

## 9. FHIR Interoperability Baseline

### 9.1 FHIR Bundle Endpoint

```dart
// Add to fhirResource endpoint group
Future<Map<String, dynamic>> searchAsBundle(
  Session session,
  String resourceType, {
  String? patientRef,
  String? practitionerRef,
  int? limit,
  int? offset,
}) async {
  // 1. Query resources (existing logic)
  // 2. Wrap in FHIR Bundle format
  return {
    'resourceType': 'Bundle',
    'type': 'searchset',
    'total': totalCount,
    'entry': resources.map((r) => {
      'fullUrl': '/fhir/$resourceType/${r.fhirId}',
      'resource': jsonDecode(r.jsonData),
    }).toList(),
  };
}
```

### 9.2 CapabilityStatement Endpoint

```dart
// New endpoint: GET /fhir/metadata
Future<Map<String, dynamic>> getCapabilityStatement(Session session) async {
  return {
    'resourceType': 'CapabilityStatement',
    'status': 'active',
    'date': DateTime.now().toIso8601String(),
    'publisher': 'Clinical Curator',
    'kind': 'instance',
    'software': {'name': 'Clinical Curator', 'version': '1.0.0'},
    'fhirVersion': '4.0.1',
    'format': ['application/fhir+json'],
    'rest': [{
      'mode': 'server',
      'resource': [
        {'type': 'Patient', 'interaction': [{'code': 'read'}, {'code': 'create'}, {'code': 'update'}, {'code': 'search-type'}]},
        {'type': 'Encounter', 'interaction': [{'code': 'read'}, {'code': 'create'}, {'code': 'update'}]},
        {'type': 'Observation', 'interaction': [{'code': 'read'}, {'code': 'create'}]},
        {'type': 'Condition', 'interaction': [{'code': 'read'}, {'code': 'create'}]},
        {'type': 'MedicationRequest', 'interaction': [{'code': 'read'}, {'code': 'create'}]},
        {'type': 'AllergyIntolerance', 'interaction': [{'code': 'read'}, {'code': 'create'}]},
        {'type': 'Immunization', 'interaction': [{'code': 'read'}, {'code': 'create'}]},
        {'type': 'DiagnosticReport', 'interaction': [{'code': 'read'}, {'code': 'create'}]},
        {'type': 'Appointment', 'interaction': [{'code': 'read'}, {'code': 'create'}, {'code': 'update'}]},
      ],
    }],
  };
}
```

### 9.3 Client-Side FHIR Display

For rendering FHIR resources on the patient chart:
```dart
Widget _renderFhirResource(Map<String, dynamic> resource) {
  switch (resource['resourceType']) {
    case 'Patient': return PatientCard(resource);
    case 'Observation': return ObservationCard(resource);
    case 'Condition': return ConditionCard(resource);
    case 'MedicationRequest': return MedicationCard(resource);
    case 'Encounter': return EncounterCard(resource);
    case 'Immunization': return ImmunizationCard(resource);
    case 'AllergyIntolerance': return AllergCard(resource);
    case 'DiagnosticReport': return ReportCard(resource);
    default: return GenericFhirCard(resource);
  }
}
```

---

## 10. Development Roadmap

### Phase 0: Foundation (1-2 weeks)
```
Priority Items:
[1] Multi-tenancy — organization_databases table + TenantDatabaseManager
[2] Multi-tenancy — migration runner for tenant DBs
[3] FHIR Interoperability — Bundle endpoint + CapabilityStatement
[4] Create master data plan (this document)
```

### Phase 1: EMR Core (2-3 weeks)
```
Priority Items:
[1] Patient Chart — tabbed EMR screen with overview tab
[2] Patient Chart — vitals tab (chart + table)
[3] Patient Chart — medications tab
[4] Encounter Workspace — SOAP note (Subjective + Objective)
[5] Encounter Workspace — Assessment (ICD-10 search)
[6] Encounter Workspace — Plan (orders + follow-up)
```

### Phase 2: EMR Full (2-3 weeks)
```
Priority Items:
[1] Patient Chart — encounters tab
[2] Patient Chart — labs tab
[3] Patient Chart — immunizations tab
[4] Doctor Dashboard — Refactor to match HTML design
[5] Doctor Dashboard — OPD Queue with vitals button
[6] Dashboard — Find Patient + New Referral
```

### Phase 3: PHR + Admin (2 weeks)
```
Priority Items:
[1] PHR — phr/ endpoint group
[2] PHR — Patient health summary screen
[3] Admin — Facility CRUD + DB provisioning UI
[4] Admin — Module toggle per facility
[5] Admin — Superadmin dashboard
```

### Phase 4: Specialized Modules (3-4 weeks)
```
Priority Items:
[1] Pharmacy — Full dispensing workflow + MedicationDispense FHIR
[2] Laboratory — Clinician ordering + results entry + verification
[3] Immunization — Schedules + coverage reports
[4] NCD — Longitudinal tracking (Diabetes, HTN, COPD, Asthma)
[5] Maternal Health — ANC + Delivery + PNC templates
[6] Child Health — Growth charts + nutrition tracking
```

### Phase 5: Analytics + Scale (3-4 weeks)
```
Priority Items:
[1] Event-driven architecture (encounter created, lab finalized, etc.)
[2] Analytics engine — facility dashboards
[3] DHIS2 export layer
[4] Terminology download service (ICD-10, LOINC, ATC bundles)
[5] Performance optimization for scale
```

---

## 11. AI Coding Guide

### 11.1 General Rules for Code Generation

1. **Always use shadcn_flutter components** — never Material Design widgets
2. **Always use `Theme.of(context).colorScheme`** for colors — never hardcode hex
3. **Always use `ref.watch()` / `ref.read()`** via flutter_riverpod — never setState for data
4. **Always write local data first** (Hive), then sync — never skip local storage
5. **Always bump refreshProvider** after create/update/delete
6. **Always use `Practitioner/` prefix** for practitionerRef matching
7. **Always import from package paths** (e.g. `package:cc_core/...`) — never relative imports beyond the current directory

### 11.2 Screen Template

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_core/theme/clinical_colors.dart';
// ... other imports

class MyScreen extends ConsumerStatefulWidget {
  const MyScreen({super.key});

  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      color: colors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text('Screen Title',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: colors.foreground)),
              const SizedBox(height: AppSpacing.xl),

              // Content sections...
            ],
          ),
        ),
      ),
    );
  }
}
```

### 11.3 Provider Template

```dart
// Read provider
final myListProvider = Provider.family<List<MyModel>, String>((ref, filter) {
  ref.watch(myRefreshProvider);
  final box = DatabaseService.myBox;
  return box.values.where((item) => item.field == filter).toList()..sort(...);
});

// State provider for refresh
final myRefreshProvider = StateProvider<int>((ref) => 0);

// StateNotifier provider for complex logic
class MyNotifier extends StateNotifier<MyState> {
  MyNotifier() : super(const MyState());

  Future<void> doSomething() async {
    state = state.copyWith(isLoading: true);
    // ... business logic
    ref.read(myRefreshProvider.notifier).state++;
    state = state.copyWith(isLoading: false);
  }
}
```

### 11.4 Save-to-Hive Pattern

```dart
// 1. Create object
final item = MyModel()
  ..field1 = value1
  ..field2 = value2
  ..syncStatus = 1;

// 2. Save locally
await DatabaseService.myBox.add(item);

// 3. Bump refresh
ref.read(myRefreshProvider.notifier).state++;

// 4. Show toast
if (!mounted) return;
showToast(
  context: context,
  builder: (ctx, overlay) => SurfaceCard(
    child: Basic(
      leading: Icon(LucideIcons.circleCheck, color: colors.success),
      title: const Text('Saved successfully'),
    ),
  ),
);

// 5. Navigate back (optional)
Future.delayed(const Duration(milliseconds: 600), () {
  if (mounted) context.pop();
});
```

### 11.5 Tabbed Screen Pattern

```dart
// Use Flutter's TabBar + TabBarView
DefaultTabController(
  length: 6, // Number of tabs
  child: Column(
    children: [
      Container(
        color: colors.card,
        child: TabBar(
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Encounters'),
            Tab(text: 'Vitals'),
            Tab(text: 'Labs'),
            Tab(text: 'Medications'),
            Tab(text: 'Immunizations'),
          ],
        ),
      ),
      Expanded(
        child: TabBarView(
          children: [
            OverviewTab(/* ... */),
            EncountersTab(/* ... */),
            VitalsTab(/* ... */),
            LabsTab(/* ... */),
            MedicationsTab(/* ... */),
            ImmunizationsTab(/* ... */),
          ],
        ),
      ),
    ],
  ),
);
```

### 11.6 FHIR Resource Card Template

```dart
Widget _buildFhirCard(Map<String, dynamic> resource) {
  final type = resource['resourceType'] as String;
  final id = resource['id'] as String;

  return Card(
    padding: const EdgeInsets.all(AppSpacing.lg),
    fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Badge(text: type, color: _colorForType(type)),
            const SizedBox(width: AppSpacing.sm),
            Text(id, style: TextStyle(fontSize: 11, color: colors.mutedForeground)),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        // Render type-specific fields...
      ],
    ),
  );
}
```

---

## 12. Design-to-Code Mapping

| HTML Design File | Screen Name | Flutter File to Create/Update |
|---|---|---|
| EMR Screen 1 — Doctor Dashboard | Doctor Dashboard | `apps/clinical/lib/features/doctor_dashboard/screens/doctor_dashboard_screen.dart` |
| EMR Screen 2 — Patient Chart (tabbed) | Patient Chart (EMR) | `apps/clinical/lib/features/patient_chart/screens/patient_chart_screen.dart` |
| EMR Screen 2 — Patient Header | Patient Header widget | `apps/clinical/lib/features/patient_chart/widgets/emr_header.dart` |
| EMR Screen 2 — Overview Tab | Overview Tab | `apps/clinical/lib/features/patient_chart/screens/emr_overview_tab.dart` |
| EMR Screen 2 — Vitals Tab | Vitals Tab | `apps/clinical/lib/features/patient_chart/screens/emr_vitals_tab.dart` |
| EMR Screen 2 — Labs Tab | Labs Tab | `apps/clinical/lib/features/patient_chart/screens/emr_labs_tab.dart` |
| EMR Screen 2 — Medications Tab | Medications Tab | `apps/clinical/lib/features/patient_chart/screens/emr_medications_tab.dart` |
| EMR Screen 2 — Encounters Tab | Encounters Tab | `apps/clinical/lib/features/patient_chart/screens/emr_encounters_tab.dart` |
| EMR Screen 2 — Immunizations Tab | Immunizations Tab | `apps/clinical/lib/features/patient_chart/screens/emr_immunizations_tab.dart` |
| EMR Screen 3 — Encounter Workspace | SOAP Encounter | `apps/clinical/lib/features/clinical/screens/soap_encounter_screen.dart` |
| EMR Screen 3 — Diagnosis Search | ICD-10 Search | `apps/clinical/lib/features/shared/widgets/diagnosis_search.dart` |
| EMR Screen 4 — Schedule | Already exists | ✅ Already implemented |
| PHR Design — All screens | Already exists (patient shell) | 🟡 Refine existing |
| Admin Design — All screens | Admin App screens | `apps/admin/lib/features/admin/screens/*` |

---

## 13. Implementation Priority & Effort

### Ranked Implementation List

| Rank | Task | Effort | Dependencies | Value |
|---|---|---|---|---|
| 1 | Multi-tenancy: `organization_databases` table + migration | 0.5 day | None | Foundation |
| 2 | Multi-tenancy: `TenantDatabaseManager` service | 1 day | Rank 1 | Foundation |
| 3 | FHIR: Bundle endpoint for list APIs | 1 day | None | Interop |
| 4 | FHIR: CapabilityStatement endpoint | 0.5 day | None | Interop |
| 5 | Patient Chart: Tabbed screen shell + header | 2 days | Provider refactoring | Highest |
| 6 | Patient Chart: Overview tab (vitals, meds, encounters) | 1 day | Rank 5 | High |
| 7 | Patient Chart: Vitals tab (chart + table) | 1.5 days | Rank 5 | High |
| 8 | Patient Chart: Medications tab | 1 day | Rank 5 | High |
| 9 | Encounter Workspace: SOAP Subjective + Objective | 2 days | Rank 5 | High |
| 10 | Encounter Workspace: Assessment (ICD-10 search) | 1 day | Terminology data | High |
| 11 | Encounter Workspace: Plan (orders) | 1.5 days | Rank 9 | High |
| 12 | Patient Chart: Encounters tab | 0.5 day | Rank 5 | Medium |
| 13 | Patient Chart: Labs tab | 1 day | Rank 5 | Medium |
| 14 | Patient Chart: Immunizations tab | 0.5 day | Rank 5 | Medium |
| 15 | Doctor Dashboard: Refactor to match design | 1.5 days | — | Medium |
| 16 | Admin: Facility CRUD + DB provisioning | 2 days | Ranks 1-2 | Medium |
| 17 | Admin: Module toggle UI | 1 day | Rank 16 | Medium |
| 18 | PHR: Endpoint group + patient summary | 2 days | — | Medium |
| 19 | Admin: Superadmin dashboard | 1.5 days | Rank 16 | Medium |
| 20 | Pharmacy: Full dispensing workflow | 3 days | — | Lower |
| 21 | Terminology: ICD-10/LOINC download bundles | 1 day | — | Lower |
| 22 | Analytics: Event architecture | 3 days | Ranks 9-11 | Lower |
| 23 | DHIS2 export layer | 2 days | Rank 22 | Lower |
| 24-27 | Maternal Health, Child Health, NCD, Immunization modules | 3+ days each | Various | Later |

**Total effort (Phase 0-2)**: ~18-22 days to reach EMR baseline
**Total effort (Phase 0-5)**: ~50-60 days for full Nepal EMR plan

---

## 14. Reference Index

### Key Files

| File | Purpose |
|---|---|
| `apps/clinical/lib/features/doctor_schedule/screens/schedule_timesheet_screen.dart` | ✅ Complete schedule UI (reference) |
| `apps/clinical/lib/features/doctor_schedule/screens/schedule_entry_screen.dart` | ✅ Complete slot entry form (reference) |
| `apps/clinical/lib/core/network/sync_service.dart` | ✅ Offline sync with toggle |
| `packages/data/lib/providers/practitioner_data_provider.dart` | ✅ Refresh provider pattern (reference) |
| `clinical_curator_server/lib/src/endpoints/` | All 16 endpoint groups |
| `clinical_curator_server/lib/src/generated/protocol.yaml` | All API endpoints |
| `docs/plan/design-specification.md` | UI/UX specification (1,457 lines) |
| `designs/PHR and EMR app design/Clinical Curator EMR.dc.html` | EMR design screens |
| `designs/PHR and EMR app design/Clinical Curator PHR.dc.html` | PHR design screens |
| `designs/PHR and EMR app design/Clinical Curator Admin.dc.html` | Admin design screens |

### Design Token Files (in designs folder — for reference)

| File | Content |
|---|---|
| `designs/.../packages/core/lib/constants/app_colors.dart` | Color hex constants |
| `designs/.../packages/core/lib/theme/clinical_colors.dart` | Clinical color tokens |
| `designs/.../packages/core/lib/theme/app_theme.dart` | Theme definition |
| `designs/.../packages/core/lib/constants/app_typography.dart` | Typography scale |
| `designs/.../packages/core/lib/constants/app_radius.dart` | Border radius |
| `designs/.../packages/core/lib/constants/app_spacing.dart` | Spacing scale |

### Existing Plans

| File | Purpose |
|---|---|
| `docs/plan/00-implementation-overview.md` | High-level overview |
| `docs/plan/01-feature-data-layer.md` through `docs/plan/21-sync-auth-safety.md` | Detailed implementation plans |
| `docs/plan/13-emr-patient-chart.md` | EMR patient chart plan |
| `docs/plan/14-patient-portal.md` | Patient portal plan |
| `docs/plan/16-ui-modernization.md` | UI modernization plan |
| `docs/plan/20-local-development.md` | Local dev setup |
| `docs/ARCHITECTURE.md` | System architecture |

### Key Commands

```bash
# Start server
cd clinical_curator_server && dart bin/main.dart --mode development

# Start Flutter clinical app
make app-web

# Analyze code
cd apps/clinical && flutter analyze lib/features/doctor_schedule/ lib/core/network/sync_service.dart

# Run tests
cd apps/clinical && flutter test
```

---

*End of Master Implementation Plan. Last updated: June 25, 2026.*