import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/theme/surface_theme.dart';
import '../../../domain/providers/auth_provider.dart';
import 'package:cc_ui_kit/widgets/sub_page_scaffold.dart';
import 'package:cc_core/theme/clinical_colors.dart';

class ClinicianSettingsScreen extends ConsumerWidget {
  const ClinicianSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final displayName = user?.displayName ?? 'Dr. User';
    final initials = _extractInitials(displayName);

    return SubPageScaffold(
      title: 'Clinician Settings',
      child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -- Doctor Profile Card --
                    Card(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      fillColor:
                          SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
                      borderRadius: AppRadius.cardRadius,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Avatar(initials: initials, size: 60),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: colors.foreground,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Cardiology & Internal Medicine',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.mutedForeground,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Row(
                                  children: [
                                    const PrimaryBadge(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.verified,
                                              size: 12,
                                              color: Colors.white),
                                          SizedBox(width: 4),
                                          Text('Identity Verified'),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                        width: AppSpacing.sm),
                                    Button.ghost(
                                      onPressed: () {
                                        showToast(
                                          context: context,
                                          builder: (ctx, overlay) =>
                                              SurfaceCard(
                                            child: Basic(
                                              title: const Text(
                                                  'Edit Profile'),
                                              subtitle: const Text(
                                                  'Profile editor opening...'),
                                              leading: const Icon(
                                                  Icons.edit,
                                                  size: 18),
                                            ),
                                          ),
                                          location: ToastLocation
                                              .bottomRight,
                                        );
                                      },
                                      child: const Icon(Icons.edit,
                                          size: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'Practice Efficiency: 98.4%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: colors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // -- Facility Management --
                    _buildSectionHeader(context, 'Facility Management'),
                    const SizedBox(height: AppSpacing.md),
                    _buildFacilityCard(
                      context: context,
                      name: 'St. Jude Medical Center',
                      role: 'Primary',
                      staff: 45,
                      patients: 120,
                      alerts: 3,
                      isActive: true,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildFacilityCard(
                      context: context,
                      name: 'Riverdale Clinic',
                      role: 'Part-time',
                      isActive: true,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildFacilityCard(
                      context: context,
                      name: 'City Hospital',
                      role: 'On-Call',
                      isActive: false,
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // -- Notification Preferences --
                    _buildSectionHeader(context, 'Notification Preferences'),
                    const SizedBox(height: AppSpacing.md),
                    _ClinicianNotificationToggles(),
                    const SizedBox(height: AppSpacing.xxl),

                    // -- Verification Audit Log --
                    _buildSectionHeader(context, 'Verification Audit Log'),
                    const SizedBox(height: AppSpacing.md),
                    Card(
                      padding: EdgeInsets.zero,
                      fillColor:
                          SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
                      borderRadius: AppRadius.cardRadius,
                      child: Column(
                        children: [
                          // Header row
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.md),
                            decoration: BoxDecoration(
                              color: colors.muted,
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(AppRadius.xl),
                                topRight:
                                    Radius.circular(AppRadius.xl),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'DOCUMENT',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          colors.mutedForeground,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'STATUS',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          colors.mutedForeground,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'EXPIRES',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          colors.mutedForeground,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildAuditRow(context,
                            document: 'Medical License',
                            statusWidget: const PrimaryBadge(
                                child: Text('ACTIVE')),
                            expires: 'Dec 2025',
                          ),
                          _buildAuditRow(context,
                            document: 'NMC Registration',
                            statusWidget: const SecondaryBadge(
                                child: Text('RENEW SOON')),
                            expires: 'Mar 2026',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // -- Export Data --
                    Center(
                      child: Button.outline(
                        onPressed: () {
                          showToast(
                            context: context,
                            builder: (ctx, overlay) => SurfaceCard(
                              child: Basic(
                                title:
                                    const Text('Exporting Data'),
                                subtitle: const Text(
                                    'Clinician data export in progress...'),
                                leading: const Icon(Icons.download,
                                    size: 18),
                              ),
                            ),
                            location: ToastLocation.bottomRight,
                          );
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.download, size: 16),
                            SizedBox(width: 6),
                            Text('Export Clinician Data'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                  ],
                ),
              ),
    );
  }

  // -- Helpers --

  Widget _buildSectionHeader(BuildContext context, String title) {
      final colors = Theme.of(context).colorScheme;
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: colors.foreground,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildFacilityCard({
    required BuildContext context,
    required String name,
    required String role,
    int? staff,
    int? patients,
    int? alerts,
    required bool isActive,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
      borderRadius: AppRadius.cardRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: colors.foreground,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              isActive
                  ? const PrimaryBadge(child: Text('Active'))
                  : const SecondaryBadge(child: Text('Inactive')),
            ],
          ),
          if (staff != null ||
              patients != null ||
              alerts != null) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                if (staff != null) ...[
                  _buildMiniStat(context, Icons.people, '$staff staff'),
                  const SizedBox(width: AppSpacing.lg),
                ],
                if (patients != null) ...[
                  _buildMiniStat(
                      context, Icons.person, '$patients patients'),
                  const SizedBox(width: AppSpacing.lg),
                ],
                if (alerts != null)
                  _buildMiniStat(
                      context, Icons.warning_amber, '$alerts alerts',
                      color: colors.warning),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Button.ghost(
            onPressed: () {
              showToast(
                context: context,
                builder: (ctx, overlay) => SurfaceCard(
                  child: Basic(
                    title: Text('$name Details'),
                    subtitle: const Text(
                        'Opening facility management...'),
                    leading:
                        const Icon(Icons.business, size: 18),
                  ),
                ),
                location: ToastLocation.bottomRight,
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colors.primary,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.chevron_right,
                    color: colors.primary, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(BuildContext context, IconData icon, String text,
      {Color? color}) {
    final colors = Theme.of(context).colorScheme;
    final c = color ?? colors.mutedForeground;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: c, size: 14),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: c,
          ),
        ),
      ],
    );
  }

  Widget _buildAuditRow(BuildContext context, {
    required String document,
    required Widget statusWidget,
    required String expires,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              document,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.foreground,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: statusWidget,
          ),
          Expanded(
            flex: 2,
            child: Text(
              expires,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12,
                color: colors.mutedForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _extractInitials(String name) {
    final cleaned =
        name.replaceAll('Dr. ', '').replaceAll('dr. ', '');
    final parts =
        cleaned.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (parts.isNotEmpty) {
      return parts[0]
          .substring(0, parts[0].length >= 2 ? 2 : 1)
          .toUpperCase();
    }
    return 'U';
  }
}

/// Stateful notification toggle section extracted to manage local state
/// within a ConsumerWidget parent.
class _ClinicianNotificationToggles extends StatefulWidget {
  @override
  State<_ClinicianNotificationToggles> createState() =>
      _ClinicianNotificationTogglesState();
}

class _ClinicianNotificationTogglesState
    extends State<_ClinicianNotificationToggles> {
  bool _vitalSigns = true;
  bool _labResults = true;
  bool _dailySummaryEmails = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
      borderRadius: AppRadius.cardRadius,
      child: Column(
        children: [
          _buildToggleRow(
            label: 'Vital signs alerts',
            value: _vitalSigns,
            onChanged: (v) {
              setState(() => _vitalSigns = v);
              showToast(
                context: context,
                builder: (ctx, overlay) => SurfaceCard(
                  child: Basic(
                    title: Text(
                        'Vital signs alerts ${v ? "enabled" : "disabled"}'),
                    leading:
                        const Icon(Icons.notifications, size: 18),
                  ),
                ),
                location: ToastLocation.bottomRight,
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildToggleRow(
            label: 'Lab results',
            value: _labResults,
            onChanged: (v) {
              setState(() => _labResults = v);
              showToast(
                context: context,
                builder: (ctx, overlay) => SurfaceCard(
                  child: Basic(
                    title: Text(
                        'Lab results alerts ${v ? "enabled" : "disabled"}'),
                    leading:
                        const Icon(Icons.notifications, size: 18),
                  ),
                ),
                location: ToastLocation.bottomRight,
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildToggleRow(
            label: 'Daily summary emails',
            value: _dailySummaryEmails,
            onChanged: (v) {
              setState(() => _dailySummaryEmails = v);
              showToast(
                context: context,
                builder: (ctx, overlay) => SurfaceCard(
                  child: Basic(
                    title: Text(
                        'Daily summary emails ${v ? "enabled" : "disabled"}'),
                    leading: const Icon(Icons.email, size: 18),
                  ),
                ),
                location: ToastLocation.bottomRight,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colors.foreground,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
