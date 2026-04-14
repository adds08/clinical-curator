import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_data/providers/admin_analytics_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final totalPatients = ref.watch(totalPatientsProvider);
    final totalPractitioners = ref.watch(totalPractitionersProvider);
    final appointmentsToday = ref.watch(appointmentsTodayCountProvider);
    final pendingVerifications = ref.watch(pendingVerificationCountProvider);
    final activeEncounters = ref.watch(activeEncountersCountProvider);
    final recentAudit = ref.watch(recentAuditEventsProvider);
    final appointmentTrend = ref.watch(appointmentTrendProvider);

    return Scaffold(
      backgroundColor: colors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Admin Dashboard',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: colors.foreground,
                      letterSpacing: -0.3)),
              const SizedBox(height: AppSpacing.xxl),

              // Stats row
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  _StatCard(
                      label: 'Patients',
                      value: '$totalPatients',
                      icon: Icons.people_outline_rounded,
                      color: colors.primary),
                  _StatCard(
                      label: 'Practitioners',
                      value: '$totalPractitioners',
                      icon: Icons.medical_services_outlined,
                      color: colors.success),
                  _StatCard(
                      label: 'Appts Today',
                      value: '$appointmentsToday',
                      icon: Icons.calendar_today_rounded,
                      color: colors.warning),
                  _StatCard(
                      label: 'Pending',
                      value: '$pendingVerifications',
                      icon: Icons.pending_actions_rounded,
                      color: colors.destructive),
                  _StatCard(
                      label: 'Active Enc.',
                      value: '$activeEncounters',
                      icon: Icons.local_hospital_rounded,
                      color: colors.oxygenSat),
                ],
              ),

              const SizedBox(height: AppSpacing.xxxl),

              // Appointment trend chart
              Text('Appointment Trend (7 days)',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.foreground)),
              const SizedBox(height: AppSpacing.lg),
              Container(
                height: 180,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: SurfaceTheme.cardDecoration(context: context),
                child: appointmentTrend.isEmpty
                    ? Center(
                        child: Text('No data',
                            style: TextStyle(
                                color: colors.mutedForeground)))
                    : BarChart(
                        BarChartData(
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(
                                sideTitles:
                                    SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(
                                sideTitles:
                                    SideTitles(showTitles: false)),
                            leftTitles: const AxisTitles(
                                sideTitles:
                                    SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final idx = value.toInt();
                                  if (idx < 0 ||
                                      idx >= appointmentTrend.length) {
                                    return const SizedBox.shrink();
                                  }
                                  return Text(
                                    DateFormat('E')
                                        .format(appointmentTrend[idx].date),
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: colors.mutedForeground),
                                  );
                                },
                              ),
                            ),
                          ),
                          barGroups: appointmentTrend
                              .asMap()
                              .entries
                              .map((e) => BarChartGroupData(
                                    x: e.key,
                                    barRods: [
                                      BarChartRodData(
                                        toY: e.value.count.toDouble(),
                                        color: colors.primary,
                                        width: 16,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(4)),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ),
              ),

              const SizedBox(height: AppSpacing.xxxl),

              // Quick actions
              Text('Quick Actions',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.foreground)),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _QuickAction(
                      label: 'Users',
                      icon: Icons.people_rounded,
                      onTap: () => context.push('/admin/users')),
                  _QuickAction(
                      label: 'Audit Log',
                      icon: Icons.history_rounded,
                      onTap: () => context.push('/admin/audit-log')),
                  _QuickAction(
                      label: 'Permissions',
                      icon: Icons.security_rounded,
                      onTap: () => context.push('/admin/rbac')),
                  _QuickAction(
                      label: 'Encounters',
                      icon: Icons.medical_services_rounded,
                      onTap: () => context.push('/clinical/encounters')),
                ],
              ),

              const SizedBox(height: AppSpacing.xxxl),

              // Recent activity
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Activity',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: colors.foreground)),
                  GestureDetector(
                    onTap: () => context.push('/admin/audit-log'),
                    child: Text('View all',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: colors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ...recentAudit.take(5).map((event) => Padding(
                    padding:
                        const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: SurfaceTheme.cardDecoration(
                          context: context),
                      child: Row(
                        children: [
                          Icon(
                            _iconForAction(event.action),
                            size: 16,
                            color: colors.mutedForeground,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${event.agentName} · ${event.action}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: colors.foreground),
                                ),
                                if (event.detail != null)
                                  Text(
                                    event.detail!,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: colors.mutedForeground),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          Text(
                            DateFormat('HH:mm').format(event.recorded),
                            style: TextStyle(
                                fontSize: 11,
                                color: colors.mutedForeground),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
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

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

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
          Text(value,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: colors.foreground)),
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: colors.mutedForeground)),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.08),
          borderRadius: AppRadius.buttonRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: colors.primary),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colors.primary)),
          ],
        ),
      ),
    );
  }
}
