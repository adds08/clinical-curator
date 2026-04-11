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

## Quick Start

```bash
# Install dependencies
flutter pub get

# Generate Hive adapters
dart run build_runner build --delete-conflicting-outputs

# Run on Chrome
flutter run -d chrome

# Run on iOS/Android
flutter run

# Build for web
flutter build web
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

All data is stored locally in Hive CE. The app works fully offline. FHIR resources are cached as JSON and can be downloaded for offline access. Sync with a remote server (HAPI FHIR, etc.) is architecturally planned but not yet implemented.

## License

Private project. All rights reserved.
