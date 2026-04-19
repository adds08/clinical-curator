/// Repository abstractions shared between the clinical and admin apps.
///
/// Design rationale: admin must be a thin skin over Serverpod (no local
/// cache); clinical needs offline-first (Hive-backed with server sync).
/// Rather than scatter `if (isOnline)` branches through the UI, each
/// domain has an abstract repo with two planned implementations:
///
///   * [Server*Repository]  — hits Serverpod directly. Used by admin.
///   * Hive*Repository (tbd) — local-first with background sync. To be
///                             adopted by clinical when the offline-sync
///                             layer is refactored.
///
/// Adding a new storage strategy (e.g. REST, GraphQL, IndexedDB-only for
/// web) means implementing the interfaces — no screen edits.
library;

export 'src/analytics_repository.dart';
export 'src/audit_repository.dart';
export 'src/health_tip_repository.dart';
export 'src/organization_repository.dart';
export 'src/rbac_repository.dart';
export 'src/user_repository.dart';

export 'src/server/server_analytics_repository.dart';
export 'src/server/server_audit_repository.dart';
export 'src/server/server_health_tip_repository.dart';
export 'src/server/server_organization_repository.dart';
export 'src/server/server_rbac_repository.dart';
export 'src/server/server_user_repository.dart';
