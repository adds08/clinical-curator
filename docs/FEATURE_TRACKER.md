# Feature Tracker

Living index of mocked data, UI shells, deferred integrations, and TODOs.
**Read this file before scanning the codebase.** It points directly at file:line locations so you don't have to grep blindly.

## Done 2026-04-15

- 🟢 **P1-A Admin auto-login** — admin app no longer auto-boots the dashboard. Awaits `adminAuthProvider.restore()` then go_router redirect guard sends unauthenticated users to `/admin/login`.
- 🟢 **P1-B Admin theme toggle + logout** — dashboard header mounts shadcn `ThemeToggleButton` (light/dark/system) + `IconButton.ghost(LucideIcons.logOut)`.
- 🟢 **P1-C Practitioner verification propagation** — `VerificationWatcher` fires one-time shadcn `AlertDialog` on unverified → verified transition, refreshes `authProvider` so `canToggleRole` flips, persists `lastSeenVerificationStatus:<email>` in SharedPreferences, writes `AuditLogger.practitionerVerified`.
- 🟢 **BUG-1 Clinical drawer saves not persisting** — all 5 drawer handlers now receive `WidgetRef` and `ref.invalidate(patient*Provider)` after each Hive write. Round-trip verified: Save → reopen → visible.
- 🟢 **BUG-2 Noto fonts warning** — shadcn `Typography.geist` overrides `sans` with `fontFamilyFallback: ['Noto Sans Devanagari', 'Noto Sans', emoji]`.
- 🟢 **P2-A Audit call-sites** — `encounterCreated` fires in `EncounterWorkflowNotifier.startEncounter`; `consentGranted` fires in `createConsent` + the activate branch of `toggleConsentStatus`; `consentRevoked` fires in the deactivate branch; `prescriptionIssued` + `dataAccessed(Patient)` already wired; new `dataExported` / `dataImported` / `dataDeleted` / `dataConflict` helpers fire from backup, sync, and admin-purge paths.
- 🟢 **P2-B Admin Clear Demo Data** — `DestructiveButton` in `admin_dashboard_screen.dart` visible only on `ENV=mock`; shadcn `AlertDialog` confirm; purges Hive + Postgres via new `fhirSyncEndpoint.purgeDemoData(adminEmail: ...)` (server rejects non-admin); writes a local `AuditEvent` row.
- 🟢 **P3-B FHIR `_since` REST sync** — `FhirSyncEndpoint.since/push/purgeDemoData` server-side; `FhirSyncService` client-side with per-type `lastSyncTimestamp_<T>` in SharedPreferences, 5-min periodic timer, `AppLifecycleState.resumed` + online-transition hooks, 30s debounce, 500-row batched pulls with `hasMore`/`nextSince`, `meta.lastUpdated` last-write-wins conflict resolution. Shadcn `SyncChip` pill mounted in the clinician dashboard AppBar.
- 🟢 **P-Backup local + Drive** — `BackupService.exportLocal` (JSON envelope + `share_plus`), `importLocal` (file_picker + schema check + shadcn confirm), `exportToDrive`/`importFromDrive` (googleapis + google_sign_in, app-data scope). Drive UI disabled when `GOOGLE_CLIENT_ID` is missing at build time.
- 🔴 **P2-C Payment gateway call-sites** — adapter exists; booking/insurance UI not wired.
- 🔴 **P3-A WebRTC client** — signaling endpoint exists; `flutter_webrtc` dep + `RTCPeerConnection`/`MediaStream` plumbing NOT added.

Status: 🔴 not started · 🟡 partial · 🟢 done · 🧪 mock/placeholder · ⏭ deferred post-V1

Last scan: 2026-04-14

---

## A. Mocked data / hardcoded values (by feature area)

### Telemedicine
- 🟢 2026-04-14 `_DoctorMock` replaced with real `allPractitionerRolesProvider` + `availableSlotsProvider` in telemedicine_screen.dart; `_DoctorMock` class removed.
- 🟢 2026-04-14 video_call_screen.dart accepts `practitionerName`/`specialty` constructor params; router forwards them as query params; falls back to "Call in progress" when absent.

### Medical Records
- 🟢 2026-04-14 `_mockEntries()` fallback removed in medical_records_screen.dart; empty state shows "No medical records yet" with `LucideIcons.fileText`.

### Vitals input (placeholders only — not rendered data)
- [doctor_dashboard_screen.dart:688,703,720,735,752,767](apps/clinical/lib/features/doctor_dashboard/screens/doctor_dashboard_screen.dart#L688) — default TextField hints: 120 / 80 / 72 / 98.6 / 98 / 16. These are input placeholders (`hintText`), not pre-filled values — safe, but double-check they aren't being submitted blindly.
- [patient_detail_screen.dart:1473-1613](apps/clinical/lib/features/patient_detail/screens/patient_detail_screen.dart#L1473) — same pattern for vitals/tests/diagnoses/medications/encounter notes.

## B. UI shells & "coming soon"

- 🟢 2026-04-14 AI Triage card now navigates to new `AiTriageScreen` (informational placeholder pointing at telemedicine/doctor-search). `isComingSoon` param + "Coming Soon" badge removed from `_BookingPathCard`.
- 🟡 [video_call_screen.dart:1-371](apps/clinical/lib/features/telemedicine/screens/video_call_screen.dart) — server signaling endpoint landed ([webrtc_signaling_endpoint.dart](clinical_curator_server/lib/src/endpoints/webrtc_signaling_endpoint.dart)) but client `flutter_webrtc` dep + `RTCPeerConnection`/`MediaStream` plumbing + roomId route param still TODO. Mic/Camera/Chat toggles still flip local state only.

## Done 2026-04-14 (new)
- 🟢 Reference vs mock seeding split — `ReferenceSeed` (admin + RBAC + 5 hospitals + `kNepalSpecialties`) for `ENV=dev|staging|prod`; `MockSeed` only for `ENV=mock`. Server `seed.dart --mode reference|mock`. `make seed` / `make seed-mock`.
- 🟢 `AuditLogger` service + login success/failure wiring in `auth_provider.dart`.
- 🟢 Sparse vitals empty state (<2 data points → shadcn info card).
- 🟢 AI Triage placeholder screen + route `/booking/ai-triage`.
- 🟢 `PaymentGateway` adapter (`MockGateway` + Khalti/eSewa fail-fast skeletons) + `paymentGatewayProvider` ENV-routed.
- 🟢 WebRTC signaling endpoint skeleton (in-memory room relay).

## New TODOs discovered (2026-04-14)
- 🔴 **Audit hook wiring** — `AuditLogger.encounterCreated` / `prescriptionIssued` / `consentGranted` / `consentRevoked` helpers exist but aren't called from the encounter workspace, `_openPrescriptionDrawer` submit, or `consent_provider.dart` yet. Pure wiring task.
- 🔴 **FHIR REST `_since` sync** — Serverpod endpoints for `/fhir/Patient/_history/_since=` (plus Observation, MedicationRequest, AllergyIntolerance, Immunization, Encounter, Condition, DiagnosticReport) and client-side `FhirSyncService` with conflict resolution (`meta.lastUpdated` wins) + per-resource `lastSyncTimestamp` in SharedPreferences. Not started.
- 🔴 **WebRTC client plumbing** — add `flutter_webrtc` to `apps/clinical/pubspec.yaml`, wire real `RTCPeerConnection` + `MediaStream` in `video_call_screen.dart`, consume signaling endpoint via streaming subscription, roomId = `practitionerId-patientId-ts` via route param, permission guards → shadcn toast fallback. iOS/Android/web platform config (Info.plist, manifest) also needed.
- 🔴 **Payment UI call site** — `paymentGatewayProvider` exists but insurance/booking flows haven't been updated to call `.charge(...)`. Mock confirmation AlertDialog still TODO.
- 🔴 **Admin "Clear Demo Data"** — not yet built. Only-visible-when-`ENV=mock` button in admin dashboard, shadcn `AlertDialog`, purges Hive+server `FhirResource` rows whose `patientRef` matches the mock seed's known patient ids, shows `showToast` count.
- 🔴 **Real Khalti / eSewa SDK integration** — requires API keys + native platform channel config; marked `TODO(payments)` in `payment_gateway.dart`.

## C. Deferred integrations (no implementation)

| Integration | Location | Status |
|---|---|---|
| WebRTC peer connection / media streams | [video_call_screen.dart](apps/clinical/lib/features/telemedicine/screens/video_call_screen.dart); routes [app_router.dart:155-160](apps/clinical/lib/core/router/app_router.dart#L155) | ⏭ |
| Firebase Cloud Messaging / push | (no FCM import anywhere) | ⏭ |
| Payment gateway (Khalti/eSewa/Stripe) | `PaymentCollection` exists in [hive_registrar.g.dart:24](apps/clinical/lib/hive_registrar.g.dart#L24), no processor wired | ⏭ |
| External lab systems | [lab_booking_endpoint.dart](clinical_curator_server/lib/src/endpoints/lab_booking_endpoint.dart) — stores bookings locally only | 🔴 |
| Pharmacy fulfillment | [pharmacy_endpoint.dart](clinical_curator_server/lib/src/endpoints/pharmacy_endpoint.dart) — local-only | 🔴 |
| Insurance provider APIs | [insurance_endpoint.dart](clinical_curator_server/lib/src/endpoints/insurance_endpoint.dart) — claim status manual | 🔴 |
| Runtime audit logging | `AuditEvent` collection exists but only seeded, never written during user actions (encounters/prescriptions/consent changes) | 🔴 |
| AI triage | [docs/plan/10-feature-ai-triage.md](docs/plan/10-feature-ai-triage.md) | ⏭ |
| FHIR REST sync (`_history`/`_since`) | [docs/plan/04-feature-offline-sync.md](docs/plan/04-feature-offline-sync.md) | 🟡 |

## D. Mock seed inventory

Auto-loads at startup via [main.dart:14](apps/clinical/lib/main.dart#L14) → [packages/data/lib/mock/mock_seed.dart](packages/data/lib/mock/mock_seed.dart).

**Users (16):**
- Patients (8): `patient-arjun`, `patient-sunita`, `patient-ram`, `patient-sita`, `patient-deepak`, `patient-priya`, `patient-krishna`, `patient-maya`
- Practitioners (7): `practitioner-arpan` (Cardiology), `practitioner-elena` (Internal Medicine), `practitioner-anjali` (Nursing), `practitioner-bikesh` (Orthopedics), `practitioner-suman` (Pediatrics), `practitioner-nisha` (OB/GYN), `practitioner-rajesh` (Psychiatry)
- Admin (1)

**FHIR resources:** 12 Patients · 7 Practitioners · 8 Vital Observations · 6 Lab Observations · 4 DiagnosticReports · 7 MedicationRequests · 5 Immunizations · 5 Allergies · 8 Conditions · 6 Consents · 8 Encounters · 5 Organizations (Bir, TUTH, Patan, Grande, Norvic, Mediciti)

**Operational data:** 15 Appointments · 4 Insurance Claims · 4 Pharmacy Orders · 3 Lab Bookings · 5 Audit Events · schedule slots for all practitioners · HealthTips · RBAC permissions for doctor/nurse/patient/admin

**Seed file hotspots:**
- [mock_seed.dart:30-40](packages/data/lib/mock/mock_seed.dart#L30) — entry class
- [mock_seed.dart:250-363](packages/data/lib/mock/mock_seed.dart#L250) — patient FHIR resources
- [mock_seed.dart:414-520](packages/data/lib/mock/mock_seed.dart#L414) — hardcoded hospitals with fake addresses, phone numbers, coordinates, ratings

## E. Server-side stubs

All endpoints functional against local Postgres; no external integrations.

- [health_tip_endpoint.dart](clinical_curator_server/lib/src/endpoints/health_tip_endpoint.dart) — CRUD only, no external content source
- [insurance_endpoint.dart](clinical_curator_server/lib/src/endpoints/insurance_endpoint.dart) — local claim storage
- [pharmacy_endpoint.dart](clinical_curator_server/lib/src/endpoints/pharmacy_endpoint.dart) — local order storage
- [lab_booking_endpoint.dart](clinical_curator_server/lib/src/endpoints/lab_booking_endpoint.dart) — local booking storage

No `UnimplementedError` found — every endpoint returns real data, but the "real" is just the local DB (seeded or user-entered).

## F. Provider behaviour (expected nulls — not bugs)

- [care_plan_provider.dart:36](apps/clinical/lib/domain/providers/care_plan_provider.dart#L36) — `carePlanDetailProvider` returns null when not found
- [encounter_provider.dart:34](apps/clinical/lib/domain/providers/encounter_provider.dart#L34) — `encounterDetailProvider` returns null when not found

## G. Not found (scan was clean)

- No `kDebugMode` / `assert()` / `ENV` gates hiding features
- No placeholder asset files (`placeholder*`, `avatar_stub*`, `sample*`)
- No "under construction" router stubs
- No `UnimplementedError` in server endpoints
- No `// TODO` / `// FIXME` comments surfaced in the scan (the codebase is clean of those markers)

---

## Done 2026-04-14

- Drawer context bug fixed in 7 files (`health_tips`, `doctor_dashboard`, `hospitals`, `lab_booking`, `profile_settings`, `patient_home`, `insurance`) — `builder: (_)` → `builder: (ctx)`, inner `closeDrawer(context)` → `closeDrawer(ctx)`.
- `_mockEntries()` fallback removed from medical_records_screen.dart; proper empty state added.
- `_DoctorMock` replaced in telemedicine_screen.dart with real Practitioner/Slot providers; class deleted.
- video_call_screen.dart no longer hardcodes "Dr. Arpan K. Sharma"; accepts route query params (`name`, `specialty`).
- `MockSeed.seedIfEmpty()` gated behind `ENV=dev` in main.dart.
- Immunizations section added to patient_detail_screen.dart between Medications and Visit Timeline, wired to `patientImmunizationsProvider`.

## TODOs (prioritised)

1. **Admin "Clear Demo Data"** action to purge seeded patientRefs from Hive (for when the app is used in production with leftover seed data).
2. **Wire runtime audit logging** — write `AuditEvent` on login, encounter create, prescription, consent grant/revoke.
3. **Design sparse/single-point state** for vitals chart painter.
4. **Replace AI Triage `isComingSoon: true`** with real implementation (or keep as deferred).
5. **Integrate a payment gateway** (Khalti / eSewa for Nepal, Stripe for cross-border).
6. **Wire WebRTC** into video_call_screen.
7. **FHIR REST sync** — implement `_history`/`_since` for server↔client sync beyond storage-level reconciliation.

---

## How to keep this file useful

When you add/fix/defer a feature:
1. Update the relevant row (or add one) with `file_path:line` references.
2. If behaviour changed, also add an entry to [CHANGELOG.md](../CHANGELOG.md).
3. Use absolute dates (`2026-04-14`, not "today").
4. Rescan mock/TODO markers at least at each release cut.
