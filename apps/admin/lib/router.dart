import 'package:cc_core/router/route_names.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'features/admin/screens/admin_dashboard_screen.dart';
import 'features/admin/screens/admin_panel_screen.dart';
import 'features/admin/screens/audit_log_screen.dart';
import 'features/admin/screens/manage_health_tips_screen.dart';
import 'features/admin/screens/manage_organizations_screen.dart';
import 'features/admin/screens/manage_rbac_screen.dart';
import 'features/admin/screens/manage_users_screen.dart';
import 'features/admin/screens/verification_detail_screen.dart';

final adminRouter = GoRouter(
  initialLocation: RouteNames.adminDashboard,
  routes: [
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
