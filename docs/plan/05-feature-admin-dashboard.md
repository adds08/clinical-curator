⚠️ DEPRECATED — Superseded by docs/plan/12-18
This describes the legacy mock-data architecture. See 18-nepal-complete-system.md for current FHIR-native design.
---
# Feature 05 — Admin Dashboard

## Overview

Expand the admin panel from basic practitioner verification to a full administrative dashboard with system-wide analytics, user management, audit logging, and system configuration. The admin panel is the control center for managing the entire platform.

## Dependencies

- Feature 01 (Data Layer) — needs `AuditEventLocal` (TypeId 23), `RbacPermissionLocal` (TypeId 24)
- Feature 02 (Auth & RBAC) — RBAC enforcement for admin-only screens

## What Already Exists

### Admin Screens — `lib/features/admin/screens/`

| File | Purpose |
|------|---------|
| `admin_panel_screen.dart` | Practitioner verification list with stats cards (total, verified, pending) |
| `verification_detail_screen.dart` | Detail view for approving/rejecting individual practitioners |
| `manage_organizations_screen.dart` | CRUD for organizations |
| `manage_health_tips_screen.dart` | CRUD for health tips content |

### Admin Router
- `lib/core/router/app_router.dart` — admin shell with 3 bottom nav tabs: Verifications, Facilities, Health Tips

### Server Endpoint
- `clinical_curator_server/lib/src/endpoints/admin_endpoint.dart` — server-side admin operations

### Related Providers
- `lib/domain/providers/practitioner_data_provider.dart` — `pendingVerificationsProvider`
- `lib/domain/providers/organization_provider.dart` — organization list
- `lib/domain/providers/health_tip_provider.dart` — health tips CRUD

## What Needs to Be Built

### 1. Admin Dashboard Home — `lib/features/admin/screens/admin_dashboard_screen.dart` (new)

Replace the current verification-list landing with a full dashboard:
- **Stats row:** Total patients, total practitioners, appointments today, pending verifications, pending sync
- **Charts section** (using `fl_chart`):
  - Patient registration trend (last 30 days, line chart)
  - Appointment volume by day (bar chart)
  - Resource utilization by type (pie chart)
- **Quick actions:** Approve verifications, manage facilities, view audit log, manage users
- **Recent activity feed:** Last 10 audit events (AuditEventLocal)

### 2. User Management Screen — `lib/features/admin/screens/manage_users_screen.dart` (new)

- Searchable, filterable list of all `UserAccount` records
- Filters: by role (patient/doctor/nurse/admin), verification status, account status
- User row: avatar, name, email, role badge, verification status, last login
- Tap to view user detail:
  - Account info, role, verification status
  - Edit account type, toggle verification
  - Suspend/reactivate account
  - View user's audit trail
- Bulk operations: bulk verify, bulk suspend

### 3. Audit Log Screen — `lib/features/admin/screens/audit_log_screen.dart` (new)

- Chronological list of `AuditEventLocal` records
- Filters: by action type (login, data_access, create, update, delete), by user, by resource type, by date range
- Search by keyword in detail text
- Each entry shows: timestamp, user, action, resource, outcome
- Export to CSV (using `csv` package) or PDF (using existing `pdf` dependency)
- Pull-to-refresh

### 4. System Config Screen — `lib/features/admin/screens/system_config_screen.dart` (new)

- **Sync settings:** Auto-sync interval, force full resync button
- **Feature flags:** Enable/disable AI triage, telemedicine, payment gateway
- **App config:** Default language, timezone, notification preferences
- Settings stored in a dedicated Hive box or SharedPreferences

### 5. Admin Analytics Provider — `lib/domain/providers/admin_analytics_provider.dart` (new)

```dart
// Aggregation providers
final totalPatientsProvider = Provider<int>(...);
final totalPractitionersProvider = Provider<int>(...);
final appointmentsTodayProvider = Provider<int>(...);
final registrationTrendProvider = Provider<List<DailyCount>>(...);
final appointmentTrendProvider = Provider<List<DailyCount>>(...);
final resourceBreakdownProvider = Provider<Map<String, int>>(...);
final recentAuditEventsProvider = Provider<List<AuditEventLocal>>(...);
```

### 6. Audit Event Logger — `lib/core/utils/audit_logger.dart` (new)

Utility that writes `AuditEventLocal` records on significant actions:

```dart
class AuditLogger {
  static Future<void> log({
    required String action,      // login, logout, create, read, update, delete, export
    required String agentRef,    // user ID
    required String agentName,   // user display name
    String? entityRef,           // resource ID
    String? entityType,          // Patient, Encounter, etc.
    String? detail,              // additional context
    required String outcome,     // success, failure
  });
}
```

Hook into:
- `AuthNotifier.login()` / `logout()` — login/logout events
- `BaseRepository.saveLocally()` — create/update events
- `BaseRepository.deleteLocally()` — delete events
- Admin actions (verify, suspend, permission changes)

### 7. Extended Admin Navigation — `lib/core/router/app_router.dart`

Update admin shell from 3 tabs to 5 tabs:
1. Dashboard (new home)
2. Users (new)
3. Verifications (existing)
4. Facilities (existing)
5. Settings (new, includes health tips + system config)

Or use a sidebar navigation pattern for the admin section.

## Implementation Order

1. Create `AuditEventLocal` collection (Feature 01 prerequisite)
2. Create `audit_logger.dart` utility
3. Hook audit logger into auth and repository operations
4. Create `admin_analytics_provider.dart`
5. Create `admin_dashboard_screen.dart` with stats and charts
6. Create `manage_users_screen.dart`
7. Create `audit_log_screen.dart` with filters and export
8. Create `system_config_screen.dart`
9. Update admin router with new tabs/routes

## Acceptance Criteria

- [ ] Admin dashboard shows real-time system statistics (patient count, practitioner count, etc.)
- [ ] Charts render correctly using `fl_chart` (trend lines, bar charts)
- [ ] User management supports search, filter by role/status, and edit operations
- [ ] Audit log displays all logged events with working filters
- [ ] Audit log export produces valid CSV/PDF
- [ ] All admin operations themselves generate audit events (dogfooding)
- [ ] Only admin role can access these screens (guarded by router + RBAC)
- [ ] Existing admin screens (verification, organizations, health tips) continue to work
- [ ] System config changes persist across app restarts

## FHIR Compliance Notes

`AuditEventLocal` maps to the FHIR AuditEvent resource type for compliance tracking. The audit log structure follows FHIR AuditEvent fields: type, action, recorded, agent, entity, outcome.

## Mock Data Requirements

- Seed 10-15 audit events covering login, data access, verification actions
- Ensure enough `UserAccount` records exist to demonstrate user management (7 demo users already seeded)
- Create time-distributed data for chart demonstration

## Complexity Estimate

**Medium** — mostly new screens and providers following existing UI patterns. The audit logger is cross-cutting but straightforward. Charts require `fl_chart` configuration but the package is already a dependency.
