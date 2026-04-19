import 'package:cc_core/router/route_names.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'domain/providers/admin_auth_provider.dart';
import 'features/admin/screens/admin_dashboard_screen.dart';
import 'features/admin/screens/admin_panel_screen.dart';
import 'features/admin/screens/audit_log_screen.dart';
import 'features/admin/screens/manage_health_tips_screen.dart';
import 'features/admin/screens/manage_organizations_screen.dart';
import 'features/admin/screens/manage_rbac_screen.dart';
import 'features/admin/screens/manage_users_screen.dart';
import 'features/admin/screens/verification_detail_screen.dart';
import 'features/auth/screens/admin_login_screen.dart';

const _adminLoginPath = '/admin/login';

/// Builds a router bound to the provided [ref] so redirects can observe
/// `adminAuthProvider` live — unauthenticated users get bounced to
/// `/admin/login`; already-authenticated admins landing on `/admin/login`
/// get bounced to the dashboard.
GoRouter buildAdminRouter(WidgetRef ref) {
  final router = GoRouter(
    initialLocation: _adminLoginPath,
    refreshListenable: _AuthListenable(ref),
    redirect: (context, state) {
      final auth = ref.read(adminAuthProvider);
      final loc = state.matchedLocation;
      final onLogin = loc == _adminLoginPath;
      if (!auth.isAuthenticated && !onLogin) return _adminLoginPath;
      if (auth.isAuthenticated && onLogin) return RouteNames.adminDashboard;
      return null;
    },
    routes: [
      GoRoute(
        path: _adminLoginPath,
        builder: (_, __) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: RouteNames.adminDashboard,
        builder: (_, __) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.adminVerifications,
        builder: (_, __) => const AdminPanelScreen(),
      ),
      GoRoute(
        path: RouteNames.verificationDetail,
        builder: (_, __) => const VerificationDetailScreen(),
      ),
      GoRoute(
        path: RouteNames.adminFacilities,
        builder: (_, __) => const ManageOrganizationsScreen(),
      ),
      GoRoute(
        path: RouteNames.adminHealthTips,
        builder: (_, __) => const ManageHealthTipsScreen(),
      ),
      GoRoute(
        path: RouteNames.adminUsers,
        builder: (_, __) => const ManageUsersScreen(),
      ),
      GoRoute(
        path: RouteNames.adminAuditLog,
        builder: (_, __) => const AuditLogScreen(),
      ),
      GoRoute(
        path: RouteNames.adminRbac,
        builder: (_, __) => const ManageRbacScreen(),
      ),
    ],
    errorBuilder: (_, state) => Container(
      alignment: Alignment.center,
      child: Text('Route not found: ${state.uri}'),
    ),
  );
  return router;
}

/// Bridges Riverpod → GoRouter's refreshListenable so auth-state changes
/// rerun the redirect logic (e.g. on login success / logout).
class _AuthListenable extends ChangeNotifier {
  _AuthListenable(WidgetRef ref) {
    _sub = ref.listenManual<AdminAuthState>(
      adminAuthProvider,
      (_, __) => notifyListeners(),
    );
  }
  late final ProviderSubscription<AdminAuthState> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
