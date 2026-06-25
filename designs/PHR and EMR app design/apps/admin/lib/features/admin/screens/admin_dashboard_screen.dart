import 'package:clinical_curator_client/clinical_curator_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/config/app_config.dart';
import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_core/theme/surface_theme.dart';

import '../../../domain/providers/admin_auth_provider.dart';
import '../../../domain/providers/repository_providers.dart';
import '../../../domain/providers/serverpod_provider.dart';
import '../widgets/theme_toggle_button.dart';

String get _kEnv => AppConfig.env;

final _analyticsProvider = FutureProvider.autoDispose<Map<String, int>>((ref) {
  ref.watch(repoRefreshProvider);
  return ref.read(serverpodClientProvider).admin.getAnalytics();
});

final _recentAuditProvider = FutureProvider.autoDispose<List<AuditEvent>>((ref) {
  ref.watch(repoRefreshProvider);
  return ref.read(serverpodClientProvider).audit.recent(limit: 5);
});

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final analyticsAsync = ref.watch(_analyticsProvider);
    final auditAsync = ref.watch(_recentAuditProvider);

    final snapshot = analyticsAsync.valueOrNull ?? <String, int>{};
    final recentAudit = auditAsync.valueOrNull ?? const <AuditEvent>[];

    return Scaffold(
      backgroundColor: colors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Admin Dashboard',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: colors.foreground, letterSpacing: -0.3),
                    ),
                  ),
                  IconButton.ghost(icon: const Icon(LucideIcons.refreshCw, size: 18), onPressed: () => bumpRepos(ref)),
                  const ThemeToggleButton(),
                  const SizedBox(width: 4),
                  IconButton.ghost(
                    icon: const Icon(LucideIcons.logOut, size: 18),
                    onPressed: () => ref.read(adminAuthProvider.notifier).logout(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              if (analyticsAsync.hasError) _errorBanner(context, analyticsAsync.error!),

              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  _StatCard(
                    label: 'Patients',
                    value: '${snapshot['totalPatients'] ?? 0}',
                    icon: Icons.people_outline_rounded,
                    color: colors.primary,
                  ),
                  _StatCard(
                    label: 'Practitioners',
                    value: '${snapshot['totalPractitioners'] ?? 0}',
                    icon: Icons.medical_services_outlined,
                    color: colors.success,
                  ),
                  _StatCard(
                    label: 'Appts Today',
                    value: '${snapshot['appointmentsToday'] ?? 0}',
                    icon: Icons.calendar_today_rounded,
                    color: colors.warning,
                  ),
                  _StatCard(
                    label: 'Pending',
                    value: '${snapshot['pendingVerifications'] ?? 0}',
                    icon: Icons.pending_actions_rounded,
                    color: colors.destructive,
                  ),
                  _StatCard(
                    label: 'Active Enc.',
                    value: '${snapshot['activeEncounters'] ?? 0}',
                    icon: Icons.local_hospital_rounded,
                    color: colors.oxygenSat,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxxl),

              Text(
                'Quick Actions',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: colors.foreground),
              ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _QuickAction(label: 'Users', icon: Icons.people_rounded, onTap: () => context.push('/admin/users')),
                  _QuickAction(label: 'Audit Log', icon: Icons.history_rounded, onTap: () => context.push('/admin/audit-log')),
                  _QuickAction(label: 'Permissions', icon: Icons.security_rounded, onTap: () => context.push('/admin/rbac')),
                ],
              ),

              if (_kEnv == 'mock') ...[
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  'Demo Controls',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: colors.foreground),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: Button.destructive(
                    onPressed: () => _confirmClearDemoData(context, ref),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(LucideIcons.trash2, size: 16), SizedBox(width: 8), Text('Clear Demo Data')],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.xxxl),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Activity',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: colors.foreground),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/admin/audit-log'),
                    child: Text(
                      'View all',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: colors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              if (recentAudit.isEmpty)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: SurfaceTheme.cardDecoration(context: context),
                  child: Text('No activity yet', style: TextStyle(fontSize: 12, color: colors.mutedForeground)),
                )
              else
                ...recentAudit.map(
                  (event) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: SurfaceTheme.cardDecoration(context: context),
                      child: Row(
                        children: [
                          Icon(_iconForAction(event.action), size: 16, color: colors.mutedForeground),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${event.agentName} · ${event.action}',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: colors.foreground),
                                ),
                                if (event.detail != null)
                                  Text(
                                    event.detail!,
                                    style: TextStyle(fontSize: 12, color: colors.mutedForeground),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          Text(DateFormat('HH:mm').format(event.recorded), style: TextStyle(fontSize: 11, color: colors.mutedForeground)),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorBanner(BuildContext context, Object error) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(color: colors.destructive.withValues(alpha: 0.08), borderRadius: AppRadius.cardRadius),
        child: Row(
          children: [
            Icon(Icons.error_outline, size: 18, color: colors.destructive),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text('Could not reach server: $error', style: TextStyle(fontSize: 12, color: colors.destructive)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmClearDemoData(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear demo data?'),
        content: const Text('This will permanently delete all demo patient data on the server. Continue?'),
        actions: [
          OutlineButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          DestructiveButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Clear')),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;

    int serverDeleted = 0;
    String? errorMsg;

    try {
      final adminEmail = ref.read(adminAuthProvider).email;
      final client = ref.read(serverpodClientProvider);
      serverDeleted = await client.fhirSync.purgeDemoData(adminEmail: adminEmail);

      final now = DateTime.now();
      await ref
          .read(serverpodClientProvider)
          .audit
          .record(
            AuditEvent(
              fhirId: 'audit-${now.microsecondsSinceEpoch}',
              type: 'rest',
              action: 'delete',
              recorded: now,
              agentRef: 'User/${adminEmail ?? 'admin'}',
              agentName: adminEmail ?? 'admin',
              entityType: 'Bundle',
              outcome: 'success',
              detail: 'purge-demo-data server=$serverDeleted',
              createdAt: now,
              syncVersion: 0,
            ),
          );
      bumpRepos(ref);
    } catch (e) {
      errorMsg = e.toString();
    }

    if (!context.mounted) return;
    showToast(
      context: context,
      builder: (c, o) => SurfaceCard(
        child: Basic(
          leading: Icon(errorMsg == null ? LucideIcons.trash2 : LucideIcons.circleAlert, size: 18),
          title: Text(errorMsg == null ? 'Cleared $serverDeleted server records' : 'Server purge failed'),
          subtitle: errorMsg == null ? const Text('Demo patients removed.') : Text(errorMsg),
        ),
      ),
    );
  }

  IconData _iconForAction(String action) {
    return switch (action) {
      'login' => Icons.login_rounded,
      'logout' => Icons.logout_rounded,
      'create' => Icons.add_circle_outline_rounded,
      'update' => Icons.edit_outlined,
      'delete' => Icons.delete_outline_rounded,
      'read' => Icons.visibility_outlined,
      _ => Icons.info_outline_rounded,
    };
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: 100,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: SurfaceTheme.cardDecoration(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: colors.foreground),
          ),
          Text(label, style: TextStyle(fontSize: 11, color: colors.mutedForeground)),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAction({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(color: colors.primary.withValues(alpha: 0.08), borderRadius: AppRadius.buttonRadius),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: colors.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: colors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
