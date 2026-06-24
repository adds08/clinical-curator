⚠️ DEPRECATED — Superseded by docs/plan/12-18
This describes the legacy mock-data architecture. See 18-nepal-complete-system.md for current FHIR-native design.
---
# Feature 11 — Testing & Deployment

## Overview

Add unit tests and key widget tests for v1 (integration tests deferred). Set up CI/CD pipelines for automated testing, building, and deployment. Configure production environments for both the Serverpod backend and Flutter app. Deploy targets: **Android + iOS + Web**.

## Dependencies

- All features (tests cover functionality from all 10 previous features)

## What Already Exists

### Test Files (Stubs)

| File | Status |
|------|--------|
| `test/widget_test.dart` | Basic smoke test |
| `test/core/constants/fhir_constants_test.dart` | Stub |
| `test/core/network/sync_service_test.dart` | Stub |
| `test/core/network/api_client_test.dart` | Stub |
| `test/core/network/api_exceptions_test.dart` | Stub |
| `test/core/utils/validators_test.dart` | Stub |
| `test/core/utils/date_formatters_test.dart` | Stub |
| `test/core/utils/fhir_helpers_test.dart` | Stub |
| `test/domain/providers/auth_provider_test.dart` | Stub |
| `test/domain/models/app_user_test.dart` | Stub |

### Build Configuration
- `pubspec.yaml` — Flutter project with all dependencies
- `analysis_options.yaml` — lint rules
- `docker-compose.yaml` — PostgreSQL + Redis for Serverpod
- `Makefile` — `db-up`, `server`, `server-migrate`, `seed`, `all` targets
- `clinical_curator_server/` — Serverpod project with `dart_test.yaml`

### CI/CD
- `.github/` directory exists (empty or minimal)
- No CI/CD workflows configured

## What Needs to Be Built

---

### A. Test Infrastructure

#### 1. Test Helpers — `test/helpers/`

**`hive_test_helper.dart`** (new):
```dart
// Initialize Hive in temporary directory for tests
// Register all 26 adapters
// Open all boxes
// Provide tearDown to clean up
Future<void> setupHiveForTests();
Future<void> tearDownHive();
```

**`mock_providers.dart`** (new):
```dart
// Override providers for testing
// Mock AuthNotifier, SyncNotifier, etc.
// Use ProviderContainer for unit testing providers
```

**`test_data_factory.dart`** (new):
```dart
// Factory methods for creating test data
// createTestUser(), createTestPatient(), createTestEncounter(), etc.
// All use realistic but predictable values
```

#### 2. Test Fixtures — `test/fixtures/`

Sample FHIR JSON resources for testing:
- `patient.json` — valid FHIR R4 Patient resource
- `observation_vitals.json` — blood pressure, heart rate observations
- `encounter.json` — ambulatory encounter
- `condition.json` — hypertension condition
- `medication_request.json` — medication prescription

---

### B. Unit Tests

#### Data Layer — `test/data/`

**`test/data/collections/`** — serialization tests for each Hive collection:
- Verify `@HiveType` / `@HiveField` serialization round-trip
- Test nullable vs required fields
- Test syncStatus values (0, 1, 2)
- One test file per collection (26 files)

**`test/data/repositories/`** — repository CRUD tests:
- `base_repository_test.dart` — CRUD operations on FhirResource box
- `patient_repository_test.dart` — patient-specific queries
- `encounter_repository_test.dart` — encounter filtering by patient, practitioner, date
- `condition_repository_test.dart` — active/resolved filtering
- Test for each repository (11+ files)

#### Domain Layer — `test/domain/`

**`test/domain/providers/`** — provider tests using `ProviderContainer`:
- `auth_provider_test.dart` — login, signup, logout, checkAuthStatus
- `role_provider_test.dart` — role switching, persistence
- `appointment_provider_test.dart` — book, cancel, complete, list
- `encounter_workflow_provider_test.dart` — encounter lifecycle
- `rbac_provider_test.dart` — permission checks per role
- `sync_provider_test.dart` — sync state transitions
- Test for each provider (19+ files)

**`test/domain/models/`** — model tests:
- `app_user_test.dart` — canToggleRole logic, role mapping
- `triage_assessment_test.dart` — assessment serialization

#### Core Layer — `test/core/`

**`test/core/utils/`** — utility tests:
- `fhir_helpers_test.dart` — FHIR resource manipulation functions
- `validators_test.dart` — email, password, phone validation
- `date_formatters_test.dart` — date/time formatting
- `audit_logger_test.dart` — audit event creation

**`test/core/constants/`**:
- `fhir_constants_test.dart` — LOINC/SNOMED code validity

**`test/core/network/`**:
- `sync_engine_test.dart` — upload, download, conflict resolution logic
- `sync_service_test.dart` — SyncNotifier state transitions
- `fhir_api_service_test.dart` — API client request/response handling

---

### C. Widget Tests

#### Key Screens — `test/features/`

**Auth:**
- `test/features/auth/login_screen_test.dart` — form validation, submit, error display
- `test/features/auth/signup_screen_test.dart` — field validation, account creation

**Patient:**
- `test/features/patient_home/patient_home_screen_test.dart` — dashboard layout, data display
- `test/features/medical_records/medical_records_screen_test.dart` — tab switching, record display

**Doctor:**
- `test/features/doctor_dashboard/doctor_dashboard_screen_test.dart` — stats, schedule timeline
- `test/features/patient_management/patient_management_screen_test.dart` — search, filter

**Clinical:**
- `test/features/clinical/encounter_workspace_test.dart` — tab navigation, data entry
- `test/features/clinical/add_condition_test.dart` — form validation

**Admin:**
- `test/features/admin/admin_panel_test.dart` — verification list, approve/reject
- `test/features/admin/manage_users_test.dart` — user list, search, filter

**Shared:**
- `test/features/shared/permission_gate_test.dart` — show/hide based on permissions
- `test/features/shared/sync_status_indicator_test.dart` — pending count, sync state

---

### D. Integration Tests — Deferred to v2

> **Decision:** Integration tests (end-to-end flows) deferred to v2. Focus on unit + widget tests for v1 launch.

When added later, key flows to test:
- Login flow with role-based routing
- Appointment booking end-to-end
- Clinical encounter documentation
- Offline sync cycle

---

### E. Server-Side Tests

**`clinical_curator_server/test/`:**

- `auth_endpoint_test.dart` — login, signup, password hashing
- `fhir_resource_endpoint_test.dart` — CRUD, getChangesSince
- `appointment_endpoint_test.dart` — booking, cancellation
- `admin_endpoint_test.dart` — verification, user management
- One test per endpoint (12+ files)

---

### F. CI/CD Pipeline

#### GitHub Actions Workflows — `.github/workflows/`

**`ci.yml`** — runs on every push and PR:
```yaml
jobs:
  analyze:
    # dart analyze / flutter analyze
  test:
    # flutter test with coverage
  build-android:
    # flutter build apk --debug
  build-web:
    # flutter build web
  server-test:
    # cd clinical_curator_server && dart test
    services:
      postgres: ...
      redis: ...
```

**`build-release.yml`** — runs on tag/release:
```yaml
jobs:
  build-android:
    # flutter build appbundle --release
    # Upload to GitHub Releases
  build-ios:
    # flutter build ipa (requires macOS runner)
  build-web:
    # flutter build web --release
    # Deploy to hosting
```

**`deploy-server.yml`** — server deployment:
```yaml
jobs:
  deploy:
    # Build Serverpod Docker image
    # Push to container registry
    # Deploy to hosting (e.g., Railway, Fly.io, AWS)
    # Run database migrations
```

#### Code Coverage

- Add `--coverage` flag to test commands
- Generate `lcov` report
- Set minimum coverage threshold (aim for 60% initially, increase over time)
- Badge in README

---

### G. Deployment Configuration

#### Server Production Config

**`clinical_curator_server/config/production.yaml`** (new):
```yaml
apiServer:
  port: 8080
  publicHost: api.clinical-curator.example.com
  publicScheme: https
database:
  host: ${DB_HOST}
  port: 5432
  name: clinical_curator
  user: ${DB_USER}
  password: ${DB_PASSWORD}
redis:
  host: ${REDIS_HOST}
  port: 6379
```

#### Docker Production Build

**`clinical_curator_server/Dockerfile`** (new or update):
```dockerfile
FROM dart:stable AS build
WORKDIR /app
COPY . .
RUN dart pub get
RUN dart compile exe bin/main.dart -o bin/server

FROM debian:bookworm-slim
COPY --from=build /app/bin/server /app/bin/server
EXPOSE 8080
CMD ["/app/bin/server", "--mode", "production"]
```

#### App Signing (Android)

- Create `android/app/upload-keystore.jks` (not committed — document process)
- Configure `android/key.properties` (gitignored)
- Update `android/app/build.gradle` for release signing

#### App Signing (iOS)

- Apple Developer account setup
- Provisioning profiles and certificates
- Configure `ios/Runner.xcodeproj` for release signing
- App Store Connect setup for TestFlight / App Store distribution

#### Web Deployment

- `flutter build web --release`
- Deploy to hosting (Firebase Hosting, Vercel, or Nginx)
- Configure CORS for Serverpod API access
- PWA configuration (manifest, service worker)

#### Database Migrations

- Document migration strategy for Serverpod schema changes
- Create migration scripts for production data

## Implementation Order

1. Create test helpers and fixtures
2. Write unit tests for core utilities (validators, formatters, helpers)
3. Write unit tests for data layer (collections, repositories)
4. Write unit tests for domain layer (providers, models)
5. Write widget tests for key screens
6. Write integration tests for major flows
7. Write server-side endpoint tests
8. Set up GitHub Actions CI workflow
9. Configure code coverage reporting
10. Set up server deployment pipeline
11. Configure app signing and release builds
12. Document deployment process

## Acceptance Criteria

- [ ] Unit test coverage for all repositories and providers
- [ ] Widget tests for critical screens (auth, doctor dashboard, encounter workspace, admin panel)
- [ ] CI pipeline runs on every push, blocks merge on failure
- [ ] All existing test stubs replaced with real tests
- [ ] Server endpoint tests pass against test database
- [ ] Android release build produces signed APK/AAB
- [ ] iOS release build produces signed IPA
- [ ] Web build produces deployable artifacts
- [ ] Server Docker image builds and runs successfully
- [ ] Production config supports environment variable injection
- [ ] Integration tests deferred to v2

## FHIR Compliance Notes

Tests should verify FHIR R4 compliance:
- Resources serialize/deserialize correctly via `fhir ^0.12.1`
- Required FHIR fields are present (resourceType, id)
- Coding systems use correct URIs (LOINC, SNOMED, ICD-10)
- References follow `ResourceType/id` format

## Mock Data Requirements

- Test fixtures with valid FHIR R4 JSON resources
- Test database seed for server-side integration tests
- Predictable test data for assertion (known IDs, timestamps)

## Complexity Estimate

**Very High** — spans the entire codebase. Writing meaningful tests for 26 collections, 19+ providers, 31 screens, and 12 endpoints is a large effort. CI/CD setup requires GitHub Actions configuration and deployment infrastructure decisions. However, each individual test follows standard Flutter/Dart testing patterns.
