import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/surface_theme.dart';
import '../../../data/collections/user_account_collection.dart';
import '../../../domain/providers/practitioner_data_provider.dart';
import '../../../core/theme/clinical_colors.dart';

class AdminPanelScreen extends ConsumerStatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  ConsumerState<AdminPanelScreen> createState() =>
      _AdminPanelScreenState();
}

class _AdminPanelScreenState
    extends ConsumerState<AdminPanelScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final pendingVerifications =
        ref.watch(pendingVerificationsProvider);

    // Compute stats from real data
    final allAccounts = DatabaseService.userAccounts.values.toList();
    final totalPractitioners =
        allAccounts.where((a) => a.isPractitioner).length;
    final verifiedCount =
        allAccounts.where((a) => a.isPractitioner && a.isVerified).length;
    final pendingCount = pendingVerifications.length;

    // Filter based on selected tab
    List<UserAccount> displayList;
    switch (_selectedTab) {
      case 1: // Approved
        displayList = allAccounts
            .where((a) => a.isPractitioner && a.isVerified)
            .toList();
        break;
      case 2: // Rejected (non-practitioner accounts that were previously practitioners)
        displayList = []; // No rejection tracking yet
        break;
      default: // Pending
        displayList = pendingVerifications;
    }

    return Scaffold(
      backgroundColor: colors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -- Header --
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: colors.primary
                          .withValues(alpha: 0.1),
                      borderRadius: AppRadius.inputRadius,
                    ),
                    child: Icon(
                      Icons.shield,
                      size: 22,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin Panel',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: colors.foreground,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Practitioner verification & oversight',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              // -- Dashboard Stats --
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(context, 
                      label: 'Total Pending',
                      value: '$pendingCount',
                      color: colors.warning,
                      icon: Icons.hourglass_empty,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildStatCard(context, 
                      label: 'Verified',
                      value: '$verifiedCount',
                      color: colors.success,
                      icon: Icons.check_circle_outline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(context, 
                      label: 'Total Practitioners',
                      value: '$totalPractitioners',
                      color: colors.primary,
                      icon: Icons.people_outline,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildStatCard(context, 
                      label: 'Total Users',
                      value: '${allAccounts.length}',
                      color: colors.secondary,
                      icon: Icons.group_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              // -- Filter Tabs --
              _buildFilterTabs(context, pendingCount, verifiedCount),
              const SizedBox(height: AppSpacing.lg),

              // -- Verification Queue --
              Text(
                _selectedTab == 0
                    ? 'Verification Queue'
                    : _selectedTab == 1
                        ? 'Approved Practitioners'
                        : 'Rejected Applications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.foreground,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              if (displayList.isEmpty)
                Card(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
                  borderRadius: AppRadius.cardRadius,
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 40,
                          color: colors.mutedForeground.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          _selectedTab == 0
                              ? 'No pending verifications'
                              : 'No entries to display',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...displayList.map((account) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: AppSpacing.md),
                    child: _buildVerificationCard(context, account),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, {
    required String label,
    required String value,
    required Color color,
    required IconData icon,
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
              Icon(icon, size: 16, color: color),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: colors.mutedForeground,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(BuildContext context, int pendingCount, int verifiedCount) {
    final colors = Theme.of(context).colorScheme;
    final tabs = ['Pending', 'Approved', 'Rejected'];

    return Row(
      children: tabs.asMap().entries.map((entry) {
        final index = entry.key;
        final label = entry.value;
        final isSelected = _selectedTab == index;

        return Padding(
          padding:
              const EdgeInsets.only(right: AppSpacing.sm),
          child: Chip(
            onPressed: () {
              setState(() => _selectedTab = index);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? colors.primary
                        : colors.mutedForeground,
                  ),
                ),
                if (index == 0 && pendingCount > 0) ...[
                  const SizedBox(width: AppSpacing.xs),
                  SecondaryBadge(
                    child: Text('$pendingCount'),
                  ),
                ],
                if (index == 1 && verifiedCount > 0) ...[
                  const SizedBox(width: AppSpacing.xs),
                  SecondaryBadge(
                    child: Text('$verifiedCount'),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVerificationCard(BuildContext context, UserAccount account) {
    final colors = Theme.of(context).colorScheme;
    final isDoctor = account.practitionerType != 'nurse';
    final initials = _extractInitials(account.displayName);
    final d = account.createdAt;
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final submittedDate = '${months[d.month - 1]} ${d.day.toString().padLeft(2, '0')}, ${d.year}';

    return Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
      borderRadius: AppRadius.cardRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: avatar + name + type badge
          Row(
            children: [
              Avatar(initials: initials, size: 40),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.displayName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colors.foreground,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      account.email,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              isDoctor
                  ? const PrimaryBadge(
                      child: Text('DOCTOR'))
                  : const SecondaryBadge(
                      child: Text('NURSE')),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Detail row
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color:
                  SurfaceTheme.colorFor(SurfaceLevel.low, context),
              borderRadius: AppRadius.inputRadius,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.business,
                  size: 14,
                  color: colors.mutedForeground,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    account.practitionerType ?? 'Practitioner',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.foreground,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 12,
                  color: colors.mutedForeground,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  submittedDate,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Review button
          SizedBox(
            width: double.infinity,
            child: Button.primary(
              onPressed: () {
                context.push(
                  RouteNames.verificationDetail
                      .replaceFirst(':id', account.key.toString()),
                );
              },
              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(Icons.rate_review_outlined,
                      size: 14),
                  SizedBox(width: 6),
                  Text('Review'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _extractInitials(String name) {
    final cleaned = name.replaceAll('Dr. ', '').replaceAll('dr. ', '');
    final parts = cleaned.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts.isNotEmpty ? parts[0][0].toUpperCase() : 'U';
  }
}
