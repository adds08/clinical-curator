# Clinical Curator

A FHIR R4-compliant clinical health application for Nepal's healthcare ecosystem. Built with Flutter, supporting mobile, web, and desktop platforms.

## Test Credentials

| Email | Password | Role | Description |
|-------|----------|------|-------------|
| `arjun@example.com` | `password123` | Patient | Regular patient with vitals, lab reports, prescriptions, immunizations |
| `sunita@example.com` | `password123` | Patient | Patient with critical vitals and penicillin allergy |
| `arpan@example.com` | `password123` | Doctor (verified) | Can toggle between Doctor View and Patient View |
| `elena@example.com` | `password123` | Doctor (verified) | Internal Medicine specialist |
| `anjali@example.com` | `password123` | Nurse (verified) | ICU nurse, can toggle to practitioner view |
| `bikesh@example.com` | `password123` | Doctor (pending) | Submitted for admin verification, NOT yet approved |
| `admin@example.com` | `admin123` | Admin | Dedicated admin account for practitioner verification |

## Configuration (`.env`)

Runtime config for both Flutter apps (clinical + admin) and docker-compose lives in a single `.env` at the repo root. Copy the template on first checkout:

```bash
cp .env.example .env
```

The Flutter apps bundle `../../.env` as an asset (see `apps/clinical/pubspec.yaml` + `apps/admin/pubspec.yaml`) and load it via `flutter_dotenv` in `main.dart` before `runApp`. Both apps read the SAME file — this is what keeps admin approvals flowing to the clinical app's backend.

Keys consumed by the Flutter apps (via `package:cc_core/config/app_config.dart`):

| Key | Default | Used by |
| --- | ------- | ------- |
| `ENV` | `dev` | Seed picker + debug banner (mock/dev/staging/prod) |
| `SERVERPOD_URL` | `http://localhost:8080/` | Clinical + admin Serverpod `Client(...)` — must match! |
| `SERVERPOD_HOST` / `SERVERPOD_PORT` | `localhost` / `8080` | Reserved for tooling |
| `GOOGLE_CLIENT_ID` | (empty) | Drive backup (feature disabled when blank) |
| `KHALTI_PUBLIC_KEY`, `ESEWA_PUBLIC_KEY` | (empty) | Payment gateways |

`.env` is gitignored; `.env.example` is committed. `AppConfig.<key>` falls back to `--dart-define=<KEY>=...` when `.env` is missing, so CI pipelines without a `.env` still work.

## Quick Start

All day-to-day commands run through the top-level `Makefile`. Run `make help` for the full list.

### ENV values (`--dart-define=ENV=<value>`)

| Value | Client seed | Server seed | Typical use |
| ----- | ----------- | ----------- | ----------- |
| `mock` | Full `MockSeed` — Arjun, Sunita, 60+ FHIR resources | `--mode mock` via `make seed-mock` | Demos / screenshots |
| `dev` *(default)* | `ReferenceSeed` — admin + RBAC + 5 hospitals only | `--mode reference` via `make seed` | Local dev |
| `staging` | `ReferenceSeed` | `--mode reference` | Pre-prod QA |
| `prod` | `ReferenceSeed` | `--mode reference` | Production |

`dev`, `staging`, and `prod` never create phantom patients / practitioners / observations.

```bash
# First-time setup: install deps across the workspace
make setup

# Start PostgreSQL + Redis
make db-up

# Generate Serverpod + Hive adapters
make codegen

# Start the Serverpod backend (applies migrations)
make server

# Run the clinical app in Chrome (dev env)
make app-web

# Run on a connected device
make app                # ENV=dev by default
make app ENV=mock       # full demo data (Arjun, Sunita, fake FHIR)
make app ENV=staging    # staging
make app ENV=prod       # production
make app DEVICE=chrome  # pick a device

# Admin app
make admin-web

# Seed reference data only (admin + RBAC + 5 hospitals)
make server-stop && make seed

# Seed the full mock/demo dataset
make server-stop && make seed-mock

# One-shot: install, start DB, seed, start server
make all
```

### Serverpod migrations

When you change a protocol YAML, create a migration before restarting the server:

```bash
make server-migrate   # serverpod create-migration
make server           # applies on startup
make server-repair    # dev escape hatch — forces DB to match target
```

## Tech Stack

| Layer | Technology |
|-------|-----------|
| UI Framework | Flutter + shadcn_flutter v0.0.52 |
| State Management | flutter_riverpod |
| Local Database | Hive CE (works on mobile, desktop, web) |
| FHIR Standard | fhir ^0.12.1 (R4) |
| Routing | go_router with role-based redirects |
| Charts | fl_chart |
| Maps | flutter_map + latlong2 |
| Persistence | shared_preferences (role/theme) |

## Architecture

```
lib/
  main.dart                    -- App entry, Hive init, mock seed
  app.dart                     -- ShadcnApp.router with theme

  core/
    constants/                 -- Colors, typography, spacing, radius, FHIR URIs
    theme/                     -- Light/dark themes, surface hierarchy, glassmorphism
    router/                    -- GoRouter with auth guard, role-based shells
    database/                  -- Hive CE database service
    utils/                     -- Responsive, FHIR helpers, validators, formatters

  data/
    collections/               -- Hive TypeAdapters (UserAccount, FhirResource)
    mock/                      -- Mock seed data (7 users, 20+ FHIR resources)

  domain/
    models/                    -- UserRole, AppUser, RoleState
    providers/                 -- Auth, role, theme, connectivity, FHIR data providers

  features/
    auth/                      -- Login, signup, practitioner registration
    patient_home/              -- Patient dashboard with health summary
    doctor_dashboard/          -- Doctor dashboard with stats, queue, tools
    medical_records/           -- Records bento grid + cardiovascular detail
    patient_detail/            -- Patient profile, vitals chart, labs, timeline
    patient_management/        -- Patient directory + add patient form
    doctor_schedule/           -- Timesheet + schedule entry
    ambulance/                 -- Request form, confirmation, tracking
    health_tips/               -- Article library with search
    telemedicine/              -- Specialist search + video call shell
    profile/                   -- Settings with role toggle + clinician settings
    consent/                   -- FHIR Consent management + QR sharing
    admin/                     -- Verification queue + detail review
    shared/                    -- Scaffold, bottom nav, services hub
```

## Screens (24 total)

### Auth (3)
- **Login** -- Email/password with HIPAA notice
- **Signup** -- Patient account creation
- **Practitioner Registration** -- License upload, specialization, admin review

### Patient View (4 tabs: Home, Records, Services, Profile)
- **Patient Home** -- Health summary (HR/BP from FHIR), profile completion, public health alerts, 8 medical services
- **Medical Records** -- Bento grid with filter tabs (All/Prescriptions/Labs/Imaging/Immunizations), reads from FHIR providers
- **Cardiovascular Detail** -- Glassmorphic bottom sheet with HRV/BPM metrics
- **Services Hub** -- Grid of Ambulance, Telemedicine, Health Tips, Lab Booking, Pharmacy, Insurance

### Doctor View (5 tabs: Dashboard, Patients, Schedule, Services, Profile)
- **Doctor Dashboard** -- Stats, schedule timeline, patient queue, pending consults, quick tools
- **Patient Management** -- Directory with search/filter, vitals snapshots, ward stats
- **Add Patient** -- Registration form that creates FHIR Patient resource in Hive
- **Patient Detail** -- Profile, allergy alerts, vitals trendline chart, labs, medications, visit timeline
- **Schedule Timesheet** -- Date picker, hours summary, agenda blocks
- **Schedule Entry** -- Availability form with slot duration, buffer time, live preview

### Shared Services
- **Ambulance Request Form** -- Pickup location, emergency type
- **Ambulance Confirmation** -- ETA, driver details, instructions
- **Ambulance Tracking** -- Map view with route, driver info
- **Health Tips Library** -- Articles, alerts, newsletter signup
- **Telemedicine Search** -- Specialist cards with booking
- **Video Call** -- UI shell with controls

### Profile & Settings
- **Profile Settings** -- Role toggle (Doctor/Patient), theme, language, security, notifications, logout
- **Clinician Settings** -- License management, facilities, notification toggles, audit log
- **Consent Management** -- FHIR Consent list, grant/revoke access, QR sharing

### Admin Panel
- **Admin Dashboard** -- Stats, verification queue with Pending/Approved/Rejected tabs
- **Verification Detail** -- License review, checklist, approve/reject/request info

## Role System

- **All doctors are users, but not all users are doctors**
- Practitioner type field: `doctor` or `nurse` (expandable)
- Role toggle only visible for verified practitioners
- Toggle persists across app restarts (SharedPreferences)
- Admin accounts are separate dedicated accounts

## FHIR Resources Used

| Resource | Usage |
|----------|-------|
| Patient | User health profiles |
| Practitioner | Doctor/nurse credentials |
| Observation | Vital signs (HR, BP, SpO2, temp) |
| DiagnosticReport | Lab results (lipid panel) |
| MedicationRequest | Prescriptions (Amoxicillin) |
| Immunization | Vaccines (influenza) |
| AllergyIntolerance | Drug allergies (penicillin) |
| Consent | Record sharing permissions |

## Design System

- **Primary:** #004ac6 | **Secondary:** #545f73 | **Error:** #ba1a1a
- **Font:** Plus Jakarta Sans
- **"No-Line" Rule:** Tonal surface shifts instead of borders
- **Radius:** 8-12px sharp geometry
- **Glassmorphism** for floating/premium elements
- **Dark mode** supported via theme toggle

## Documentation

- [User Guide](docs/USER_GUIDE.md) -- Patient and doctor workflows
- [Admin Guide](docs/ADMIN_GUIDE.md) -- Practitioner verification
- [Architecture](docs/ARCHITECTURE.md) -- Technical deep dive

## Offline Support

All data is stored locally in Hive CE. The app works fully offline. FHIR resources are cached as JSON and can be downloaded for offline access.

### Offline sync

The clinical app ships a **FHIR `_since` sync service** (`apps/clinical/lib/domain/services/fhir_sync_service.dart`):
- **Per-resource watermarks** — `lastSyncTimestamp_<ResourceType>` lives in `SharedPreferences`. On each tick the client pulls resources with `lastUpdated > since` from `FhirSyncEndpoint.since(...)` in 500-row batches (`hasMore`/`nextSince`) and pushes any local rows where `syncStatus != 0` via `FhirSyncEndpoint.push(...)`.
- **Conflict resolution** — `meta.lastUpdated` wins. Server keeps the newer copy; if the local row is newer it is kept and a `dataConflict` AuditEvent is written.
- **Triggers** — 5-minute timer, `AppLifecycleState.resumed`, online-transition via `connectivity_plus`. 30-second debounce prevents thrashing.
- **Status UI** — shadcn `SyncChip` (AppBar pill) shows `Offline` / `Syncing…` / `Synced Xm ago`; tap → drawer with per-type counts and a "Sync now" button.
- **Supported types** — `Patient`, `Observation`, `MedicationRequest`, `AllergyIntolerance`, `Immunization`, `Encounter`, `Condition`, `DiagnosticReport`.

### Backups

Profile → **Backup & Restore** gives the patient four paths, all backed by `BackupService` (`apps/clinical/lib/domain/services/backup_service.dart`):

| Path | Scope | Notes |
| --- | --- | --- |
| Export backup (local) | every Hive `FhirResource` | Writes `clinical_curator_backup_<ts>.json` to app-documents then triggers the system share sheet via `share_plus`. |
| Import backup (local) | same | `file_picker` → shadcn confirm → upsert into Hive (last-write-wins on `lastUpdated`). |
| Back up to Google Drive | same | Uploads the JSON to the Drive **app-data** folder (`drive.appdata` scope) via `google_sign_in` + `googleapis`. |
| Restore from Google Drive | same | Lists timestamped backups and downloads + imports the chosen one. |

Google Drive backup requires an OAuth Client ID at build time. If `GOOGLE_CLIENT_ID` is not defined, the Drive rows stay visible but disabled with a shadcn info toast.

```
flutter run -d macos \
  --dart-define=ENV=mock \
  --dart-define=GOOGLE_CLIENT_ID=123-abc.apps.googleusercontent.com
```

Every backup/restore writes an `AuditEvent` (`dataExported` / `dataImported`).

## License

Private project. All rights reserved.
