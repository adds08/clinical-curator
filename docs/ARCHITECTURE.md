# Clinical Curator — Architecture

## 1. Project Structure (Monorepo)

Clinical Curator is a **Melos monorepo** containing two Flutter apps, a Serverpod backend, an auto-generated client SDK, and 4 shared packages.

```
clinical-curator/
├── apps/
│   ├── clinical/           # Main patient + clinician Flutter app
│   │   ├── lib/
│   │   │   ├── app.dart          # ShadcnApp.router + theme setup
│   │   │   ├── main.dart         # Hive init, env load, seed
│   │   │   ├── core/
│   │   │   │   ├── network/
│   │   │   │   │   └── sync_service.dart    # FHIR _since REST sync client
│   │   │   │   └── router/
│   │   │   │       └── app_router.dart      # GoRouter with role-based shells
│   │   │   ├── domain/
│   │   │   │   ├── models/       # UserRole, AppUser, RoleState, EncounterStatus
│   │   │   │   └── providers/    # Auth, role, theme, connectivity, patient data, FHIR data
│   │   │   └── features/         # 26 feature directories
│   │   │       ├── auth/         # Login, signup, practitioner registration
│   │   │       ├── patient_home/ # Patient home with health summary
│   │   │       ├── doctor_dashboard/ # Doctor dashboard with stats + queue
│   │   │       ├── medical_records/ # Records bento grid + cardiovascular detail
│   │   │       ├── patient_detail/  # Patient profile, vitals chart, timeline
│   │   │       ├── patient_management/ # Patient directory + add patient
│   │   │       ├── doctor_schedule/   # Timesheet + schedule entry
│   │   │       ├── ambulance/     # Request form, confirmation, tracking
│   │   │       ├── health_tips/   # Article library
│   │   │       ├── telemedicine/  # Specialist search + video call (WebRTC skeleton)
│   │   │       ├── profile/       # Settings with role toggle + clinician settings
│   │   │       ├── consent/       # FHIR Consent management
│   │   │       ├── admin/         # Admin routes (to be populated)
│   │   │       ├── booking/       # Appointment booking, AI triage placeholder
│   │   │       ├── clinical/      # Encounter workspace
│   │   │       ├── hospitals/     # Hospital directory
│   │   │       ├── insurance/     # Insurance claim screen
│   │   │       ├── lab_booking/   # Lab booking screen
│   │   │       ├── notifications/ # Notifications screen
│   │   │       ├── onboarding/    # Onboarding wizard
│   │   │       ├── pharmacy/      # Pharmacy order screen
│   │   │       └── shared/        # Scaffold, bottom nav, services hub, shared widgets
│   │   ├── test/
│   │   ├── android/
│   │   └── ios/
│   │
│   └── admin/              # Admin Flutter app (verification, audit, RBAC, orgs)
│       └── lib/
│           ├── main.dart
│           ├── router.dart
│           ├── domain/providers/  # Admin auth, serverpod client, repo providers
│           └── features/
│               ├── admin/         # Dashboard, panel, audit log, health tips, orgs, RBAC, users
│               └── auth/          # Admin login screen
│
├── clinical_curator_server/  # Serverpod 3.4.5 backend
│   ├── bin/
│   │   ├── main.dart         # Server entry point
│   │   └── seed.dart         # Database seed runner
│   ├── config/               # Environment configs (dev, staging, prod, test)
│   ├── lib/src/
│   │   ├── auth/             # JWT auth + key management
│   │   ├── endpoints/        # 16 endpoint groups
│   │   │   ├── admin_endpoint.dart
│   │   │   ├── auth_endpoint.dart
│   │   │   ├── fhir_sync_endpoint.dart
│   │   │   └── ... (appointment, ambulance, audit, health tip, insurance,
│   │   │        lab booking, notification, organization, pharmacy, rbac,
│   │   │        schedule, webrtc signaling)
│   │   ├── errors/           # AppException classes
│   │   ├── generated/        # Serverpod-generated protocol code
│   │   ├── models/           # Server-side model helpers
│   │   ├── services/         # Business logic services
│   │   ├── utils/            # Helper utilities
│   │   └── web/              # Web server static files
│   ├── migrations/           # 3 database migrations
│   ├── test/                 # Integration tests
│   └── web/                  # Static web assets
│
├── clinical_curator_client/  # Auto-generated Serverpod client SDK
│   └── lib/src/protocol/     # 28 model classes + endpoint refs
│
├── packages/
│   ├── core/ (cc_core)       # Design tokens, theme, config, auth primitives, utils
│   ├── data/ (cc_data)       # Hive DB service, mock/reference seed, network layer,
│   │                         # 17 repositories, 5 providers, audit logger
│   ├── fhir_models/ (cc_fhir_models)  # 27+ Hive TypeAdapter collections + domain models
│   └── rbac/ (cc_rbac)       # Role-based access control (Can widget, canProvider)
│
├── docs/
│   ├── ARCHITECTURE.md       # This file
│   ├── FEATURE_TRACKER.md    # Living feature/status tracker
│   ├── ADMIN_GUIDE.md        # Admin user guide
│   ├── USER_GUIDE.md         # Patient/clinician user guide
│   ├── manual/               # Clinician + patient manuals
│   └── plan/                 # 12 implementation plan docs
│
├── docker-compose.yaml       # PostgreSQL + Redis services
├── Makefile                  # Convenience targets
└── melos.yaml                # Melos workspace config
```

## 2. State Management

**Riverpod** (`flutter_riverpod`) is used for all state management.

- `ProviderScope` wraps the app at root level in both apps
- Core providers follow the `StateNotifierProvider<*, *>` pattern
- FHIR data providers use `FutureProvider.autoDispose` for async server calls
- The admin app uses Serverpod client directly via providers in `repository_providers.dart`

## 3. Local Database (Clinical App Only)

**Hive CE** (Community Edition) — works on mobile, desktop, AND web.

- Database service: `DatabaseService` in `packages/data/lib/database/isar_service.dart`
- Two Hive boxes: `user_accounts` and `fhir_resources`
- 27+ Hive TypeAdapter collections in `packages/fhir_models/lib/collections/`
- Mock data seeded automatically if boxes are empty (via `MockSeed` or `ReferenceSeed`)

The admin app does NOT use Hive — it communicates with the Serverpod backend exclusively.

## 4. FHIR R4 Standard

All clinical data follows **HL7 FHIR R4** using the `fhir: ^0.12.1` Dart package.

| Resource | Usage | LOINC/SNOMED Codes |
|----------|-------|-------------------|
| Patient | User health profiles, demographics | — |
| Practitioner | Doctor/nurse credentials, qualifications | NMC registration |
| Observation | Vital signs (HR, BP, SpO2, temp) | 8867-4, 85354-9, 2708-6, 8310-5 |
| DiagnosticReport | Lab results (lipid panel) | 57698-3 |
| MedicationRequest | Prescriptions (Amoxicillin) | RxNorm 723 |
| Immunization | Vaccines (influenza) | CVX 158 |
| AllergyIntolerance | Drug allergies (penicillin) | SNOMED 764146007 |
| Consent | Record sharing permissions | — |

## 5. Routing

**go_router** with `StatefulShellRoute.indexedStack` for bottom navigation shells.

Three navigation contexts:
- **Patient** (4 tabs): Home, Records, Services, Profile
- **Doctor/Nurse** (5 tabs): Dashboard, Patients, Schedule, Services, Profile
- **Admin** (1 tab): Verifications (in admin app)

Auth guard: unauthenticated → `/login`. Authenticated on auth page → role-appropriate home.

## 6. Design System — Clinical Precision Framework

**shadcn_flutter v0.0.52** — provides Card, Button, Badge, Avatar, Progress, Alert, etc.

### Core Principles
- **No-Line Rule** — tonal background shifts define boundaries, NOT borders
- **Surface Hierarchy** — 5 levels from `#ffffff` (lowest) to `#e0e3e5` (highest)
- **Sharp Geometry** — 8-12px border radius, no pills
- **Glassmorphism** — `BackdropFilter` blur for floating/premium elements

Design tokens in `packages/core/lib/constants/`: colors, typography, spacing, radius, FHIR constants.

## 7. Offline-First Architecture (Clinical App)

Designed for low-connectivity environments in Nepal.

```
[UI] ↔ [Riverpod Provider] ↔ [Hive Box (local)] ↔ [Serverpod API (sync)]
```

- All reads come from Hive first (synchronous, instant)
- FHIR resources stored as JSON with indexed fields for filtering
- `syncStatus` field tracks: 0=synced, 1=pendingUpload, 2=pendingDelete
- `_since` REST sync via `FhirSyncService` with 5-min periodic timer
- Backup/restore via local JSON files and Google Drive

## 8. Data Flow

```
┌─────────────────────┐     ┌─────────────────────┐
│  apps/clinical       │     │  apps/admin          │
│  (Flutter App)       │     │  (Flutter App)       │
│                      │     │                      │
│  Reads/Writes → Hive │     │  Calls API directly  │
│  (offline-first)     │     │  (online-only)       │
└───────┬─────────────┘     └──────────┬───────────┘
        │                              │
        │  uses packages:              │  uses packages:
        │  - cc_core                   │  - cc_core
        │  - cc_data                   │  - clinical_curator_client
        │  - cc_fhir_models            │
        │  - cc_rbac                   │
        │  - clinical_curator_client   │
        ▼                              ▼
┌─────────────────────────────────────────────────┐
│           clinical_curator_client               │
│         (auto-generated Serverpod SDK)           │
└────────────────────┬────────────────────────────┘
                     │  HTTP/WebSocket
                     ▼
┌─────────────────────────────────────────────────┐
│           clinical_curator_server               │
│           (Serverpod Backend)                    │
│                                                  │
│   ┌──────────┐  ┌──────────┐  ┌──────────────┐ │
│   │ PostgreSQL│  │  Redis   │  │  Web Server   │ │
│   │ (pgvector)│  │ (cache)  │  │ (Flutter web) │ │
│   └──────────┘  └──────────┘  └──────────────┘ │
└─────────────────────────────────────────────────┘
```

## 9. Removed Packages (Historical)

The following packages were removed from the workspace:
- **`cc_repositories`** — Abstract repository layer. Had zero consumers. Admin rewritten to use `clinical_curator_client` directly.
- **`cc_ui_kit`** — Contained only `SubPageScaffold`. Moved to `cc_core` for sharing across apps.