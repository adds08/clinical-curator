# Clinical Curator -- Architecture

## 1. Project Structure

Clinical Curator follows a **feature-based** project structure. Each feature is self-contained with its own screens, widgets, and providers.

```
lib/
  main.dart                       # App entry, Hive init, mock seed
  app.dart                        # ShadcnApp.router + theme setup

  core/
    constants/                    # Design tokens
      app_colors.dart             # Full color token system (light + dark)
      app_typography.dart         # Plus Jakarta Sans type scale
      app_spacing.dart            # Spacing tokens (4-40px)
      app_radius.dart             # Border radius tokens (4-20px)
      fhir_constants.dart         # FHIR system URIs, LOINC codes
    database/
      isar_service.dart           # Hive CE database service (DatabaseService)
    router/
      app_router.dart             # GoRouter with role-based redirects
      route_names.dart            # All route path constants
    theme/
      app_theme.dart              # shadcn_flutter ThemeData (light + dark)
      surface_theme.dart          # Surface-level tonal layering
      glassmorphism.dart          # Glassmorphic decoration builder
    utils/
      responsive.dart             # Mobile/tablet/desktop breakpoints
      fhir_helpers.dart           # FHIR model extraction utilities
      validators.dart             # Form validation (email, password, phone, license)
      date_formatters.dart        # Clinical date formatting
      id_generator.dart           # Health ID, Patient ID generation

  data/
    collections/
      user_account_collection.dart    # Hive TypeAdapter for user accounts
      fhir_resource_collection.dart   # Hive TypeAdapter for FHIR resources
    mock/
      mock_seed.dart              # Seeds 7 users + 20+ FHIR resources on first run

  domain/
    models/
      user_role.dart              # UserRole enum (patient, doctor, nurse, admin)
      app_user.dart               # AppUser domain model (Equatable)
      role_state.dart             # RoleState for toggle management
    providers/
      auth_provider.dart          # AuthNotifier (login, signup, logout, session restore)
      role_provider.dart          # RoleNotifier (SharedPreferences persistence)
      theme_provider.dart         # ThemeNotifier (dark/light toggle)
      connectivity_provider.dart  # Network status stream
      database_provider.dart      # Hive box providers
      patient_data_provider.dart  # FHIR Observation, DiagnosticReport, etc. per patient
      practitioner_data_provider.dart  # All patients, pending verifications
      user_provider.dart          # Current user's FHIR Patient/Practitioner

  features/
    auth/                         # Login, signup, practitioner registration
    patient_home/                 # Patient home with health summary
    doctor_dashboard/             # Doctor dashboard with stats and queue
    medical_records/              # Records bento grid + cardiovascular detail
    patient_detail/               # Patient profile, vitals chart, timeline
    patient_management/           # Patient directory + add patient
    doctor_schedule/              # Timesheet + schedule entry
    ambulance/                    # Request form, confirmation, tracking
    health_tips/                  # Article library
    telemedicine/                 # Specialist search + video call
    profile/                      # Settings with role toggle + clinician settings
    consent/                      # FHIR Consent management
    admin/                        # Verification queue + detail
    shared/                       # Scaffold, bottom nav, services hub
```

## 2. State Management

**Riverpod** (`flutter_riverpod`) is used for all state management.

- `ProviderScope` wraps the app at root level in `main.dart`
- Core providers in `domain/providers/`:
  - `authProvider` — `StateNotifierProvider<AuthNotifier, AuthState>` for login/signup/logout
  - `roleProvider` — `StateNotifierProvider<RoleNotifier, UserRole>` persisted via SharedPreferences
  - `themeProvider` — `StateNotifierProvider<ThemeNotifier, ThemeMode>` for dark/light toggle
  - `connectivityProvider` — `StreamProvider` from connectivity_plus
- FHIR data providers in `domain/providers/`:
  - `patientVitalsProvider(patientRef)` — vital signs from Hive
  - `latestHeartRateProvider(patientRef)` / `latestBloodPressureProvider(patientRef)` — latest readings
  - `patientLabsProvider`, `patientMedicationsProvider`, `patientImmunizationsProvider`, `patientAllergiesProvider`
  - `allPatientsProvider`, `patientCountProvider`, `pendingVerificationsProvider`
  - `currentUserFhirPatientProvider`, `currentUserFhirPractitionerProvider`
- Router uses a `_RouterRefreshNotifier` that listens to auth and role providers, triggering redirect re-evaluation

## 3. Local Database

**Hive CE** (Community Edition) — works on mobile, desktop, AND web.

- Database service: `lib/core/database/isar_service.dart` (`DatabaseService` class)
- Two Hive boxes:
  - `user_accounts` — `Box<UserAccount>` for auth accounts
  - `fhir_resources` — `Box<FhirResource>` for all FHIR data
- TypeAdapters generated via `hive_ce_generator` + `build_runner`
- `FhirResource` stores: `fhirId`, `resourceType`, `jsonData` (full FHIR JSON), `patientReference`, `practitionerReference`, `category`, `syncStatus`, `isDownloadedOffline`, `lastUpdated`
- Initialized in `main.dart` before `runApp()`
- Mock data seeded automatically if boxes are empty

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

Resources are stored as JSON strings in Hive and deserialized via `fhir.Resource.fromJson()` when needed by providers.

## 5. Routing

**go_router** with `StatefulShellRoute.indexedStack` for bottom navigation shells.

Three navigation contexts:
- **Patient** (4 tabs): Home, Records, Services, Profile
- **Doctor/Nurse** (5 tabs): Dashboard, Patients, Schedule, Services, Profile
- **Admin** (1 tab): Verifications

Auth guard: unauthenticated → `/login`. Authenticated on auth page → role-appropriate home.
Role guard: wrong role prefix → redirect to correct home.

Each shell branch has its own `GlobalKey<NavigatorState>` for independent navigation stacks.

## 6. Design System — Clinical Precision Framework

### UI Library
**shadcn_flutter v0.0.52** — provides `Card`, `Button.primary/secondary/outline/ghost/destructive/link`, `Badge`, `Avatar`, `Progress`, `Alert`, `Chip`, `Switch`, `Checkbox`, `TextField`, `showToast`, `Tabs`, and more.

### Core Principles
- **No-Line Rule** — tonal background shifts define boundaries, NOT borders
- **Surface Hierarchy** — 5 levels from `#ffffff` (lowest) to `#e0e3e5` (highest)
- **Sharp Geometry** — 8-12px border radius, no pills
- **Glassmorphism** — `BackdropFilter` blur for floating/premium elements
- **Ambient Shadows** — 24px blur at 4% opacity, no traditional drop shadows

### Design Tokens
- Colors: `core/constants/app_colors.dart` — primary #004ac6, surface #f7f9fb, 5-level surface hierarchy, dark theme
- Typography: `core/constants/app_typography.dart` — Plus Jakarta Sans, full Material type scale
- Spacing: `core/constants/app_spacing.dart` — 4px to 40px scale
- Radius: `core/constants/app_radius.dart` — card 12px, button 6px, chip 4px, input 8px

## 7. Offline-First Architecture

Designed for low-connectivity environments in Nepal.

```
[UI] ↔ [Riverpod Provider] ↔ [Hive Box (local)] ↔ [API (future)]
```

- All reads come from Hive first (synchronous, instant)
- FHIR resources stored as JSON with indexed fields for filtering
- `syncStatus` field tracks: 0=synced, 1=pendingUpload, 2=pendingDelete
- `isDownloadedOffline` flag for explicitly cached records
- Backend sync (HAPI FHIR, Dio HTTP client) is architecturally planned, not yet implemented

## 8. Mock Data Seeding

`lib/data/mock/mock_seed.dart` seeds on first run:

**7 user accounts:**
- 2 patients (Arjun Maharjan, Sunita Rajbhandari)
- 2 verified doctors (Dr. Arpan K. Sharma, Dr. Elena Vance)
- 1 verified nurse (Anjali Sharma)
- 1 pending doctor (Dr. Bikesh Shrestha — awaiting admin verification)
- 1 admin (Admin User)

**20+ FHIR resources:**
- 6 Patient resources, 4 Practitioner resources
- Arjun: 4 vital signs (HR 95, BP 120/80, temp 98.6, SpO2 98%), 1 lipid panel, 1 Amoxicillin prescription, 1 influenza vaccine
- Sunita: 3 critical vitals (HR 112, BP 142/95, SpO2 91%), 1 penicillin allergy

All resources use proper FHIR R4 coding systems (LOINC, SNOMED, RxNorm, CVX).
