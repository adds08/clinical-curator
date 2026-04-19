import 'package:cc_repositories/cc_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'serverpod_provider.dart';

/// Repository bindings for admin. All admin data flows through these —
/// screens depend on the abstract interface, not the Serverpod client
/// directly. Swapping to a mock or alternative backend means overriding
/// these providers in tests / alternative shells.

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return ServerUserRepository(ref.watch(serverpodClientProvider));
});

final healthTipRepositoryProvider = Provider<HealthTipRepository>((ref) {
  return ServerHealthTipRepository(ref.watch(serverpodClientProvider));
});

final organizationRepositoryProvider = Provider<OrganizationRepository>((ref) {
  return ServerOrganizationRepository(ref.watch(serverpodClientProvider));
});

final auditRepositoryProvider = Provider<AuditRepository>((ref) {
  return ServerAuditRepository(ref.watch(serverpodClientProvider));
});

final rbacRepositoryProvider = Provider<RbacRepository>((ref) {
  return ServerRbacRepository(ref.watch(serverpodClientProvider));
});

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return ServerAnalyticsRepository(ref.watch(serverpodClientProvider));
});

/// Global refresh tick. Bumping this invalidates every async repo query
/// below so refactored screens can cross-refresh each other (e.g.
/// approving a practitioner bumps dashboard analytics).
final repoRefreshProvider = StateProvider<int>((_) => 0);
void bumpRepos(WidgetRef ref) {
  ref.read(repoRefreshProvider.notifier).state++;
}
