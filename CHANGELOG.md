# Changelog

All notable changes to this project are documented here. Keep newest at top.
Format: `YYYY-MM-DD` — scope — summary. Dates are absolute (no "yesterday").

---

## 2026-04-15

### Added (evening)
- **Shared `.env` config system** — new [app_config.dart](packages/core/lib/config/app_config.dart) in `cc_core` reads runtime config from the repo-root `.env` via [flutter_dotenv ^5.2.1] with a fallback to `--dart-define`. Root [.env.example](.env.example) documents `ENV`, `SERVERPOD_URL`, `SERVERPOD_HOST`, `SERVERPOD_PORT`, `GOOGLE_CLIENT_ID`, `KHALTI_PUBLIC_KEY`, `ESEWA_PUBLIC_KEY`. Both apps bundle the root `.env` as an asset (`../../.env` in [apps/clinical/pubspec.yaml](apps/clinical/pubspec.yaml) + [apps/admin/pubspec.yaml](apps/admin/pubspec.yaml)) and call `await dotenv.load()` before `runApp` in their respective `main.dart`. `.env` stays gitignored; `.env.example` is tracked.
- **Admin Serverpod provider** — new [apps/admin/lib/domain/providers/serverpod_provider.dart](apps/admin/lib/domain/providers/serverpod_provider.dart) exposes a shared `Client` driven by `AppConfig.serverpodUrl`. Removes the hardcoded `http://localhost:8080/` from [admin_dashboard_screen.dart](apps/admin/lib/features/admin/screens/admin_dashboard_screen.dart) and replaces the `--dart-define=ENV` read with `AppConfig.env`.
- **`AppEnvironment` delegates to `AppConfig`** — [app_environment.dart](packages/core/lib/config/app_environment.dart) now pulls `apiBaseUrl` from `AppConfig.serverpodUrl` so the clinical Serverpod client, debug banner, and FHIR URL all resolve against the same `.env` source of truth.

### Fixed
- **Admin approval never reached clinical app backend** — root cause: [verification_detail_screen.dart](apps/admin/lib/features/admin/screens/verification_detail_screen.dart) `_approveAccount` / `_rejectAccount` wrote ONLY to the local Hive box. When the clinical app ran in a different session/process the server row stayed stale. Both handlers now call a new `_syncApprovalToServer(approve: ...)` which looks up the server account via `client.auth.getByEmail(email)` and then calls `client.admin.approvePractitioner(id)` / `rejectPractitioner(id)`. Best-effort: Hive write still stands when offline.
- **VerificationWatcher was Hive-only** — [verification_watcher.dart](apps/clinical/lib/domain/services/verification_watcher.dart) `check(...)` now first pulls the signed-in practitioner's `UserAccount` from Serverpod (`auth.getByEmail`) and upserts it into Hive before the transition check. This is what makes a fresh admin approval visible on a separate clinical-app process/machine. Added a first-time-seed branch that refreshes `authProvider` when the user lands already-verified so `canToggleRole` is correct.

### Added (afternoon)
- **FHIR `_since` sync (P3-B)** — new server endpoint [fhir_sync_endpoint.dart](clinical_curator_server/lib/src/endpoints/fhir_sync_endpoint.dart) exposes `since(resourceType, since, limit)` returning a generated `FhirSyncBatchDto { resources, nextSince, hasMore }` and `push(List<FhirResourceRecord>)` with last-write-wins on `meta.lastUpdated`. Supports Patient, Observation, MedicationRequest, AllergyIntolerance, Immunization, Encounter, Condition, DiagnosticReport. Client service [fhir_sync_service.dart](apps/clinical/lib/domain/services/fhir_sync_service.dart) persists per-type `lastSyncTimestamp_<type>` in SharedPreferences, pulls in 500-row batches, pushes local rows with `syncStatus != 0`, debounces 30s, reruns every 5 min + on `AppLifecycleState.resumed` + on online-transition (`connectivity_plus`). Conflicts (local newer than server) log to `AuditLogger.dataConflict`. New [sync_chip.dart](apps/clinical/lib/features/shared/widgets/sync_chip.dart) shadcn pill mounted in [doctor_dashboard_screen.dart](apps/clinical/lib/features/doctor_dashboard/screens/doctor_dashboard_screen.dart): renders "Offline" / "Syncing…" / "Synced Xm ago"; tap opens drawer with per-type counts + "Sync now".
- **Backup service (P-Backup)** — new [backup_service.dart](apps/clinical/lib/domain/services/backup_service.dart) with `exportLocal()` (JSON envelope under app-documents + `share_plus` share sheet), `importLocal(File)` with conflict counts + schema check, and Google Drive skeleton: `exportToDrive()`, `listDriveBackups()`, `importFromDrive(id)` using app-data scope. Disabled when `GOOGLE_CLIENT_ID` is not defined at build time. Wired in [profile_settings_screen.dart](apps/clinical/lib/features/profile/screens/profile_settings_screen.dart) as a new "Backup & Restore" section — four shadcn settings rows (export local, import local, Drive export, Drive restore). Added deps: `share_plus: ^10.1.4`, `file_picker: ^8.1.7`, `googleapis: ^13.2.0`, `googleapis_auth: ^1.5.1`, `google_sign_in: ^6.2.1`, `http: ^1.2.2`.
- **Admin Clear Demo Data (P2-B)** — [admin_dashboard_screen.dart](apps/admin/lib/features/admin/screens/admin_dashboard_screen.dart) gains a `DestructiveButton` "Clear Demo Data" visible only when `--dart-define=ENV=mock`. Shadcn `AlertDialog` confirm → purges Hive `FhirResource` rows whose `patientReference` matches any of the 8 demo patient ids + calls new `fhirSyncEndpoint.purgeDemoData(adminEmail: ...)` server-side (rejects non-admin account types). Writes an `AuditEvent` with the purge counts. Admin now depends on `clinical_curator_client` + `serverpod_flutter`.
- **AuditLogger helpers** — added `dataExported`, `dataImported`, `dataDeleted`, `dataConflict` to [audit_logger.dart](apps/clinical/lib/domain/services/audit_logger.dart).
- **P2-A Audit call-sites (remainder)** — `AuditLogger.encounterCreated` now fires from `EncounterWorkflowNotifier.startEncounter` after the Hive add; `AuditLogger.consentGranted` fires from `createConsent(...)` and the activate branch of `toggleConsentStatus(...)`; `AuditLogger.consentRevoked` fires from the deactivate branch. Consent UI forwards the current user's email/displayName.

### Fixed
- **BUG-1 Vitals not persisting** — drawer submit handlers in [patient_detail_screen.dart](apps/clinical/lib/features/patient_detail/screens/patient_detail_screen.dart) now accept `WidgetRef` and call `ref.invalidate(patientVitalsProvider|patientLabsProvider|patientMedicationsProvider|patientRecordsProvider)` after each Hive write. Prior `Provider.family` providers cached first-read results; invalidations force a re-scan of the `fhirResources` box so Save → reopen → visible round-trips correctly. Applies to all 5 drawers (Lab, Diagnosis, Prescription, Vitals, Clinical Note).
- **BUG-2 Noto fonts missing-characters warning** — [app_theme.dart](packages/core/lib/theme/app_theme.dart) now passes a shadcn `Typography.geist(sans: TextStyle(fontFamilyFallback: ['Noto Sans Devanagari','Noto Sans','Noto Color Emoji','Apple Color Emoji']))` to both light and dark themes. Nepali input + emoji now render without the GSub warning.
- **P1-A Admin auto-login** — [apps/admin/lib/main.dart](apps/admin/lib/main.dart) is now a `ConsumerStatefulWidget` that awaits `themeProvider.loadTheme()` + `adminAuthProvider.restore()` before mounting the router. [router.dart](apps/admin/lib/router.dart) gains a redirect guard (unauthenticated → `/admin/login`; authed on `/admin/login` → `/admin/dashboard`) bound to `adminAuthProvider` via a `ChangeNotifier` wrapper. Admin now starts at login unless a valid session exists.

### Added
- **P1-B Admin theme toggle + logout** — [admin_dashboard_screen.dart](apps/admin/lib/features/admin/screens/admin_dashboard_screen.dart) header row now mounts [ThemeToggleButton](apps/admin/lib/features/admin/widgets/theme_toggle_button.dart) (cycles light → dark → system via `themeProvider`) and an `IconButton.ghost(LucideIcons.logOut)` that calls `adminAuthProvider.logout()` — redirect guard bounces to `/admin/login`.
- **P1-C Practitioner verification propagation** — new [verification_watcher.dart](apps/clinical/lib/domain/services/verification_watcher.dart) re-reads the signed-in practitioner's `UserAccount` row on every app resume + login, compares against `lastSeenVerificationStatus:<email>` in SharedPreferences, and on unverified → verified transition: fires a one-time shadcn `AlertDialog` ("Your practitioner account has been verified…"), calls `authProvider.checkAuthStatus()` so `canToggleRole` flips true, and writes `AuditLogger.practitionerVerified(...)`. Wired via `WidgetsBindingObserver` in [app.dart](apps/clinical/lib/app.dart).
- **AuditLogger helpers** — added `practitionerVerified(...)` + `dataAccessed(...)` to [audit_logger.dart](apps/clinical/lib/domain/services/audit_logger.dart).
- **P2-A Audit call-sites (partial)** — `AuditLogger.dataAccessed` fires once per session when a clinician opens a patient detail screen; `AuditLogger.prescriptionIssued` fires from `_openPrescriptionDrawer` after a MedicationRequest is persisted.

### Known Gaps (still 🔴 / 🟡 — next pass)
- **P2-A remainder** — encounter create + consent grant/revoke call-sites NOT wired (helpers ready).
- **P2-B Admin Clear Demo Data** — NOT built this pass.
- **P2-C Payment gateway call-sites** — adapter exists; booking-confirmation + insurance-claim NOT wired.
- **P3-A WebRTC client** — signaling endpoint exists; `flutter_webrtc` dep + real `RTCPeerConnection` / `MediaStream` plumbing NOT added.
- **P3-B FHIR `_since` REST sync** — NOT started. No `fhir_sync_endpoint.dart` server-side, no `FhirSyncService` client-side, no last-synced AppBar badge.

---

## 2026-04-14

### Added
- **Reference seed + ENV split** — new [reference_seed.dart](packages/data/lib/mock/reference_seed.dart) seeds only admin account + RBAC permissions + five flagship hospitals (Bir, TUTH, Patan, Grande, Norvic) + `kNepalSpecialties` constant. ENV gate rewired: `ENV=mock` → `MockSeed.seedIfEmpty()`, `ENV=dev|staging|prod` → `ReferenceSeed.seedIfEmpty()`. Server [seed.dart](clinical_curator_server/bin/seed.dart) accepts `--mode reference|mock` (default `reference`); `make seed` seeds reference only, new `make seed-mock` for the full demo dataset.
- **AuditLogger service** — [audit_logger.dart](apps/clinical/lib/domain/services/audit_logger.dart) persists FHIR-shaped AuditEvent rows to Hive for login success/failure (wired in `auth_provider.dart`), encounter create, prescription issue, consent grant/revoke. Fire-and-forget (errors swallowed). Hook points for encounter/prescription/consent sites defined but not yet wired at every call site — helper ready for drop-in.
- **Sparse vitals empty state** — [patient_detail_screen.dart](apps/clinical/lib/features/patient_detail/screens/patient_detail_screen.dart) vitals trendline now detects when every series has <2 points and renders a centered shadcn empty card ("Add at least 2 vitals to see a trend", `LucideIcons.trendingUp`) instead of a misleading lone dot.
- **AI Triage placeholder screen** — new [ai_triage_screen.dart](apps/clinical/lib/features/booking/screens/ai_triage_screen.dart) replaces the no-op "Coming Soon" tap on `booking_hub_screen.dart`. Shadcn informational card explains the feature is planned (v2) and offers PrimaryButton → `/service/telemedicine` plus OutlineButton → `/booking/doctor-search`. Route `/booking/ai-triage` registered. `isComingSoon` param removed from `_BookingPathCard`.
- **Payment gateway adapter** — [payment_gateway.dart](apps/clinical/lib/domain/payments/payment_gateway.dart) ships `PaymentGateway` abstract, `MockGateway` (auto-succeeds, 400ms delay), `KhaltiGateway` and `EsewaGateway` (fail-fast when public key missing). `paymentGatewayProvider` returns `MockGateway` for `ENV=mock|dev`, `KhaltiGateway(KHALTI_PUBLIC_KEY)` for staging/prod. Real SDK integration marked with `TODO(payments)` — call-site wiring deferred.
- **WebRTC signaling endpoint skeleton** — new [webrtc_signaling_endpoint.dart](clinical_curator_server/lib/src/endpoints/webrtc_signaling_endpoint.dart) in-memory room-based relay for offer/answer/ice messages, broadcast-to-peers (excluding sender) via `subscribe()` stream + `send()` call. `flutter_webrtc` client wiring + real `RTCPeerConnection`/`MediaStream` plumbing in `video_call_screen.dart` NOT yet done — tracked in FEATURE_TRACKER.md.

### Fixed
- **Drawer context bug (7 files)** — `openDrawer(builder: (_) => ...)` was discarding the drawer's own context, causing `closeDrawer(context)` inside it to assert `No DrawerEntryWidget found in the widget tree`. Renamed builder param `_` → `ctx` and routed inner `closeDrawer` calls through it in: `health_tips_screen.dart`, `doctor_dashboard_screen.dart` (3 drawers), `hospitals_screen.dart`, `lab_booking_screen.dart`, `profile_settings_screen.dart` (4 drawers), `patient_home_screen.dart`, `insurance_screen.dart`.

### Changed
- **Telemedicine uses real providers** — [telemedicine_screen.dart](apps/clinical/lib/features/telemedicine/screens/telemedicine_screen.dart) now reads doctors from `allPractitionerRolesProvider` (filtered by specialty + search) and next slots from `availableSlotsProvider`. Deleted `_DoctorMock` class and its 4 hardcoded entries. Shows "No specialists available" empty state when no Practitioners exist. "Rating" field dropped (no FHIR source).
- **Video call partner no longer hardcoded** — [video_call_screen.dart](apps/clinical/lib/features/telemedicine/screens/video_call_screen.dart) accepts `practitionerName` / `specialty` constructor params; router forwards them via query params (`?name=...&specialty=...`). Falls back to "Call in progress" when absent. Removed "Dr. Arpan K. Sharma" / "Cardiology" hardcoded strings.
- **Mock seed gated behind ENV=dev** — [main.dart](apps/clinical/lib/main.dart) only runs `MockSeed.seedIfEmpty()` when `--dart-define=ENV=dev` (default). Staging/prod builds start with empty Hive.

### Removed
- **Medical records mock fallback** — deleted `_mockEntries()` (Dr. Elena Vance, Dr. Marcus Thorne, CVS Pharmacy, LDL 142 etc.) from [medical_records_screen.dart](apps/clinical/lib/features/medical_records/screens/medical_records_screen.dart). Empty state now uses `LucideIcons.fileText` + "No medical records yet" when providers return nothing. Unused `subItems` field on `_TimelineEntry` also removed.

### Added
- **Immunizations section on Patient Detail** — [patient_detail_screen.dart](apps/clinical/lib/features/patient_detail/screens/patient_detail_screen.dart) now renders a shadcn Card list backed by `patientImmunizationsProvider`, showing vaccine name (`vaccineCode`), `occurrenceDateTime`, and status. Empty state: "No immunizations on record". Placed between Active Medications and Visit Timeline.

### Fixed
- **New patient phantom data** — [patient_detail_screen.dart](apps/clinical/lib/features/patient_detail/screens/patient_detail_screen.dart) rendered hardcoded vitals, a "Penicillin" allergy banner, fake lab results, and fake medications for every patient. All sections now read from FHIR providers (`patientVitalsProvider`, `patientAllergiesProvider`, `patientLabsProvider`, `patientMedicationsProvider`) filtered by `Patient/<fhirId>`. Added empty states for each section. Removed `'0922-A'` default patientId.

### Changed
- **Makefile minimized** (30 → 22 targets). Merged env/device-specific variants into parametric targets:
  - `app-run`/`app-run-dev/staging/prod` → `make app ENV=... DEVICE=...`
  - `app-build*` → `make app-build ENV=...`
  - `server-start*` → `make server MODE=...`
  - `admin-run*` → `make admin` / `make admin-web`
  - Dropped: `server-generate` (use `codegen`), `ws-format-check`, `ws-codegen`.
- Added `server-migrate` (`serverpod create-migration`) and `server-repair` (`--apply-repair-migration`).
- Updated README Quick Start and docs/plan/{04,11} to use new targets.

### Added
- **Serverpod migration `20260414161004581`** — creates `allergy_intolerances`, `audit_events`, `care_plans`, `conditions`, `encounters`, `healthcare_services`, `immunizations`, `locations`, `medication_requests`, `payments`, `practitioner_roles`, `procedures`, `rbac_permissions`, `service_requests`, `slots`, plus missing indexes on `schedule_slots`.

### Refactored
- **Pure shadcn_flutter UI** — removed every `package:flutter/material.dart` import from [apps/clinical/lib/](apps/clinical/lib/).
  - 12 files migrated off Material widgets (Scaffold/AppBar/Card/Button/TextField/etc.).
  - 434 `Icons.xyz` references across 44 files → `LucideIcons.xyz` equivalents.
  - 10 files cleaned up duplicate `as shadcn` prefix imports.
  - `MaterialPageRoute` → `PageRouteBuilder` (fade) in [ambulance_request_form_screen.dart:51](apps/clinical/lib/features/ambulance/screens/ambulance_request_form_screen.dart#L51).
  - Removed `uses-material-design: true` from pubspec.
  - `shadcn_flutter` itself still transitively re-exports a handful of Material symbols (`Icons`, `MaterialPageRoute`, `SliverAppBar`, `FlutterLogo`) — this is inside the package, not in app code.
  - Final `flutter analyze lib/` → No issues found.
