# Feature 02 — Auth & RBAC

## Overview

Replace the current local-only password-matching auth with a dual-mode system: Serverpod Auth when online, Hive fallback when offline. Add JWT token management, password hashing, and implement granular RBAC permission enforcement across the app.

## Dependencies

- Feature 01 (Data Layer) — needs `RbacPermissionLocal` collection (TypeId 24)

## What Already Exists

### Auth Provider
- `lib/domain/providers/auth_provider.dart` — `AuthNotifier` with `login()`, `signup()`, `logout()`, `checkAuthStatus()`. Currently does Hive-local email/password lookup with plaintext comparison. Persists login state via `SharedPreferences`.

### Role System
- `lib/domain/providers/role_provider.dart` — `RoleNotifier` persisting active role to SharedPreferences
- `lib/domain/models/user_role.dart` — enum: `patient`, `doctor`, `nurse`, `admin`
- `lib/domain/models/app_user.dart` — `AppUser` with `canToggleRole` logic

### Router Guards
- `lib/core/router/app_router.dart` — redirect guard checking `authProvider` and `roleProvider` for role-based shell routing (patient/doctor/admin shells)

### User Account Model
- `lib/data/collections/user_account_collection.dart` — `UserAccount` with `passwordHash` (stored as plaintext), `accountType`, `isPractitioner`, `isVerified`

### Server Auth
- `clinical_curator_server/lib/src/endpoints/auth_endpoint.dart` — server-side login/signup with plaintext password comparison
- `clinical_curator_server/lib/src/auth/` — contains `email_idp_endpoint.dart` and `jwt_refresh_endpoint.dart` stubs

## What Needs to Be Built

### 1. Password Hashing — Server Side

**File:** `clinical_curator_server/lib/src/endpoints/auth_endpoint.dart`
- Replace plaintext password comparison with bcrypt hashing
- Add `bcrypt` package to server `pubspec.yaml`
- Hash on signup, verify on login

### 2. JWT Token Management — Client Side

**File:** `lib/core/auth/token_service.dart` (new)
- Store JWT access token and refresh token in `flutter_secure_storage`
- Token expiry checking
- Auto-refresh via `jwt_refresh_endpoint.dart`
- Clear tokens on logout

### 3. Auth Provider Rewrite — `lib/domain/providers/auth_provider.dart`

- **Online mode:** Call Serverpod `AuthEndpoint.login()` → receive JWT → store tokens → cache user in Hive
- **Offline mode:** Fall back to Hive-local lookup (existing behavior)
- Check `connectivityProvider` to determine mode
- On successful online login, update local Hive cache for offline fallback

### 4. RBAC Permission Model

**File:** `lib/domain/models/rbac_permission.dart` (new)
- Permission definition: `(resource, action, isAllowed)`
- Resources: `patients`, `encounters`, `appointments`, `organizations`, `users`, `audit_log`, `settings`, `reports`
- Actions: `read`, `create`, `update`, `delete`, `export`

### 5. RBAC Provider — `lib/domain/providers/rbac_provider.dart` (new)

- `RbacNotifier` loads permissions for current role from `RbacPermissionLocal` Hive box
- `hasPermission(String resource, String action) → bool`
- `permissionsFor(String resource) → List<String>`
- Default permission sets seeded per role:
  - **patient:** read own records, create appointments, manage consent
  - **doctor:** read/create/update patient records, encounters, prescriptions
  - **nurse:** read patient records, create vitals, update encounters
  - **admin:** all permissions including user management, audit log, RBAC config

### 6. Permission Gate Widget — `lib/features/shared/widgets/permission_gate.dart` (new)

```dart
PermissionGate(
  resource: 'encounters',
  action: 'create',
  child: StartEncounterButton(),
  fallback: SizedBox.shrink(), // or disabled state
)
```

### 7. Admin RBAC Management Screen — `lib/features/admin/screens/manage_rbac_screen.dart` (new)

- List all roles with their permission sets
- Toggle individual permissions per role
- Create custom roles
- Changes write to `RbacPermissionLocal` box

### 8. Router Guard Enhancement — `lib/core/router/app_router.dart`

- Add RBAC checks to route redirects, not just role-based routing
- Certain routes require specific permissions beyond just role membership

### 9. Default Permission Seed — `lib/data/mock/mock_seed.dart`

- Seed default RBAC permissions for all 4 roles
- Include in initial app boot

## Implementation Order

1. Add `RbacPermissionLocal` collection (Feature 01 prerequisite)
2. Create `rbac_permission.dart` domain model
3. Create `rbac_provider.dart` with default permission sets
4. Create `permission_gate.dart` widget
5. Add permission gate to key screens (admin panel, patient data, encounters)
6. Create `token_service.dart` for JWT management
7. Rewrite `auth_provider.dart` for dual-mode auth
8. Update server `auth_endpoint.dart` with bcrypt
9. Create `manage_rbac_screen.dart` admin screen
10. Update router with RBAC guards

## Acceptance Criteria

- [ ] Login works online (Serverpod) and offline (Hive fallback)
- [ ] JWT tokens stored in `flutter_secure_storage`, auto-refresh on expiry
- [ ] Passwords stored as bcrypt hash on server, not plaintext
- [ ] Each role has a defined default permission set
- [ ] `PermissionGate` widget hides/disables UI for unauthorized actions
- [ ] Admin can view and modify role permissions via RBAC management screen
- [ ] Router guards enforce RBAC beyond simple role checks
- [ ] Existing login/signup/role-toggle flows continue to work

## FHIR Compliance Notes

No direct FHIR resource types. RBAC enforcement protects access to FHIR resources (Patient, Encounter, etc.) at the application level.

## Mock Data Requirements

- Default permission sets for 4 roles (patient, doctor, nurse, admin)
- At least 8 resources × 5 actions = 40 permission records per role
- Seed in `mock_seed.dart` alongside existing user accounts

## Complexity Estimate

**High** — touches the auth flow (security-critical), adds a new cross-cutting concern (RBAC), and requires changes across server, providers, widgets, and router.
