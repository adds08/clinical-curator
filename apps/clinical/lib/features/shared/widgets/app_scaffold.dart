import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/router/route_names.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_fhir_models/models/user_role.dart';
import '../../../domain/providers/ambulance_provider.dart';
import '../../../domain/providers/auth_provider.dart';
import '../../../domain/providers/role_provider.dart';

class _NavItem {
  final IconData selectedIcon;
  final IconData unselectedIcon;
  final String label;
  const _NavItem({required this.selectedIcon, required this.unselectedIcon, required this.label});
}

const _kDesktopBreak = 768.0;

class AppScaffold extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  const AppScaffold({super.key, required this.navigationShell});

  List<_NavItem> _items(UserRole role) {
    switch (role) {
      case UserRole.patient:
        return const [
          _NavItem(selectedIcon: LucideIcons.house, unselectedIcon: LucideIcons.house, label: 'Home'),
          _NavItem(selectedIcon: LucideIcons.folder, unselectedIcon: LucideIcons.folder, label: 'Records'),
          _NavItem(selectedIcon: LucideIcons.briefcaseMedical, unselectedIcon: LucideIcons.briefcaseMedical, label: 'Services'),
          _NavItem(selectedIcon: LucideIcons.bell, unselectedIcon: LucideIcons.bell, label: 'Alerts'),
          _NavItem(selectedIcon: LucideIcons.user, unselectedIcon: LucideIcons.user, label: 'Profile'),
        ];
      case UserRole.clinician:
        return const [
          _NavItem(selectedIcon: LucideIcons.layoutDashboard, unselectedIcon: LucideIcons.layoutDashboard, label: 'Dashboard'),
          _NavItem(selectedIcon: LucideIcons.users, unselectedIcon: LucideIcons.users, label: 'Patients'),
          _NavItem(selectedIcon: LucideIcons.calendar, unselectedIcon: LucideIcons.calendar, label: 'Schedule'),
          _NavItem(selectedIcon: LucideIcons.briefcaseMedical, unselectedIcon: LucideIcons.briefcaseMedical, label: 'Services'),
          _NavItem(selectedIcon: LucideIcons.bell, unselectedIcon: LucideIcons.bell, label: 'Alerts'),
          _NavItem(selectedIcon: LucideIcons.user, unselectedIcon: LucideIcons.user, label: 'Profile'),
        ];
      case UserRole.admin:
        return const [
          _NavItem(selectedIcon: LucideIcons.shieldCheck, unselectedIcon: LucideIcons.shieldCheck, label: 'Verify'),
          _NavItem(selectedIcon: LucideIcons.building, unselectedIcon: LucideIcons.building, label: 'Facilities'),
          _NavItem(selectedIcon: LucideIcons.lightbulb, unselectedIcon: LucideIcons.lightbulb, label: 'Health Tips'),
        ];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleProvider);
    final items = _items(role);
    final idx = navigationShell.currentIndex;
    final isDesktop = MediaQuery.sizeOf(context).width >= _kDesktopBreak;

    if (isDesktop) return _buildDesktop(context, ref, items, idx);
    return _buildMobile(context, ref, items, idx);
  }

  // ── Mobile ──────────────────────────────────────────────────────────────

  Widget _buildMobile(BuildContext context, WidgetRef ref, List<_NavItem> items, int idx) {
    final activeAmbulance = ref.watch(activeAmbulanceRequestProvider);
    final user = ref.watch(authProvider).user;
    final showBanner = user != null && user.isPractitioner && !user.isVerified;

    return Scaffold(
      headers: [
        if (showBanner) const _UnverifiedBanner(),
      ],
      footers: [
        if (activeAmbulance != null)
          _ActiveAmbulanceCard(request: activeAmbulance),
        _buildBottomNav(context, items, idx),
      ],
      child: navigationShell,
    );
  }

  Widget _buildBottomNav(BuildContext context, List<_NavItem> items, int idx) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: colors.background,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final item = items[i];
            final selected = idx == i;
            final color = selected ? colors.primary : colors.mutedForeground;

            return Expanded(
              child: GestureDetector(
                onTap: () => navigationShell.goBranch(i, initialLocation: i == idx),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: selected ? colors.primary.withValues(alpha: 0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          selected ? item.selectedIcon : item.unselectedIcon,
                          size: 22,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          color: color,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ── Desktop ─────────────────────────────────────────────────────────────

  Widget _buildDesktop(BuildContext context, WidgetRef ref, List<_NavItem> items, int idx) {
    final colors = Theme.of(context).colorScheme;
    final activeAmbulance = ref.watch(activeAmbulanceRequestProvider);
    final user = ref.watch(authProvider).user;
    final showBanner = user != null && user.isPractitioner && !user.isVerified;

    return Scaffold(
      child: Row(
        children: [
          Container(
            width: 220,
            decoration: BoxDecoration(color: colors.card),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Row(
                    children: [
                      Icon(LucideIcons.hospital, color: colors.primary, size: 28),
                      const SizedBox(width: 10),
                      Text(
                        'Clinical\nCurator',
                        style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700,
                          color: colors.foreground, height: 1.2, letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: NavigationSidebar(
                    backgroundColor: colors.card,
                    labelType: NavigationLabelType.all,
                    children: List.generate(items.length, (i) {
                      final item = items[i];
                      final selected = idx == i;
                      return NavigationItem(
                        label: Text(item.label),
                        selected: selected,
                        onChanged: (s) {
                          if (s) navigationShell.goBranch(i, initialLocation: i == idx);
                        },
                        child: Icon(
                          selected ? item.selectedIcon : item.unselectedIcon,
                          size: 20,
                        ),
                      );
                    }),
                  ),
                ),
                // Ambulance card at bottom of sidebar on desktop
                if (activeAmbulance != null)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: _ActiveAmbulanceCard(request: activeAmbulance),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                if (showBanner) const _UnverifiedBanner(),
                Expanded(child: navigationShell),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Floating card that shows when an ambulance request is active.
/// Visible above the bottom nav on all tabbed pages.
class _ActiveAmbulanceCard extends StatelessWidget {
  final dynamic request; // AmbulanceRequestLocal
  const _ActiveAmbulanceCard({required this.request});

  bool get _isArrived => request.status == 'arrived';

  String get _statusLabel {
    switch (request.status) {
      case 'requested':
        return 'Dispatch Pending';
      case 'dispatched':
        return 'Ambulance Dispatched';
      case 'enroute':
        return 'Ambulance En Route';
      case 'arrived':
        return 'Ambulance Arrived!';
      default:
        return 'In Progress';
    }
  }

  String get _statusDetail {
    if (_isArrived) {
      return 'Tap to confirm patient received';
    }
    final eta = request.estimatedArrivalMinutes;
    if (request.status == 'enroute' && eta != null && eta > 0) {
      return 'ETA ~$eta min • ${request.assignedVehicleNumber ?? ''}';
    }
    if (request.status == 'dispatched') {
      return '${request.assignedDriverName ?? 'Driver'} assigned';
    }
    return 'Waiting for dispatch...';
  }

  IconData get _statusIcon {
    switch (request.status) {
      case 'arrived':
        return LucideIcons.mapPinCheck;
      case 'enroute':
        return LucideIcons.truck;
      case 'dispatched':
        return LucideIcons.circleCheck;
      default:
        return LucideIcons.clock;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final cardColor = _isArrived ? colors.success : colors.destructive;

    return GestureDetector(
      onTap: () => context.push(RouteNames.serviceAmbulanceConfirmation),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              cardColor,
              cardColor.withValues(alpha: 0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: cardColor.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_statusIcon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _statusLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    _statusDetail,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Track',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(LucideIcons.chevronRight,
                      size: 10, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnverifiedBanner extends StatelessWidget {
  const _UnverifiedBanner();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colors.warning.withValues(alpha: 0.08),
        border: Border(
          bottom: BorderSide(color: colors.warning.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.shieldAlert, size: 16, color: colors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Identity not verified \u2014 consent sharing restricted',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: colors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
