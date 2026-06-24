import 'package:clinical_curator_client/clinical_curator_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'serverpod_provider.dart';

/// Repository bindings for admin — direct Serverpod client calls.
/// These replaced the former abstract repository layer (removed).
///
/// Screens depend on these providers and the client SDK types directly.
/// Swapping to a mock backend means overriding these providers in tests.

/// List pending practitioner verifications.
final pendingPractitionersProvider = FutureProvider.autoDispose<List<UserAccount>>((ref) {
  return ref.watch(serverpodClientProvider).admin.listPendingVerifications();
});

/// List verified practitioners.
final verifiedPractitionersProvider = FutureProvider.autoDispose<List<UserAccount>>((ref) {
  return ref.watch(serverpodClientProvider).admin.listVerifiedPractitioners();
});

/// All users, optionally filtered by account type.
final allUsersProvider = FutureProvider.autoDispose.family<List<UserAccount>, String?>((ref, accountType) {
  return ref.watch(serverpodClientProvider).admin.listAllUsers(accountType: accountType);
});

/// Dashboard analytics (map with totalPatients, totalPractitioners, etc.).
final analyticsProvider = FutureProvider.autoDispose<Map<String, int>>((ref) {
  ref.watch(repoRefreshProvider);
  return ref.watch(serverpodClientProvider).admin.getAnalytics();
});

/// Recent audit events for the dashboard panel.
final recentAuditProvider = FutureProvider.autoDispose<List<AuditEvent>>((ref) {
  ref.watch(repoRefreshProvider);
  return ref.watch(serverpodClientProvider).audit.recent(limit: 5);
});

/// All RBAC permissions.
final rbacPermissionsProvider = FutureProvider.autoDispose<List<RbacPermission>>((ref) {
  return ref.watch(serverpodClientProvider).rbac.listAll();
});

/// RBAC permissions for a specific role.
final rbacPermissionsForRoleProvider = FutureProvider.autoDispose.family<List<RbacPermission>, String>((ref, roleId) {
  return ref.watch(serverpodClientProvider).rbac.listForRole(roleId);
});

/// All health tips (admin view — includes inactive).
final healthTipsAdminProvider = FutureProvider.autoDispose<List<HealthTip>>((ref) {
  return ref.watch(serverpodClientProvider).healthTip.listAllAdmin();
});

/// All organizations.
final organizationsProvider = FutureProvider.autoDispose<List<Organization>>((ref) {
  return ref.watch(serverpodClientProvider).organization.listAll();
});

/// Global refresh tick. Bumping this invalidates every async query so
/// screens can cross-refresh each other.
final repoRefreshProvider = StateProvider<int>((_) => 0);
void bumpRepos(WidgetRef ref) {
  ref.read(repoRefreshProvider.notifier).state++;
}
