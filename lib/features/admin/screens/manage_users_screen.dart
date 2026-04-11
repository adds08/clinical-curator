import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/theme/clinical_colors.dart';
import '../../../core/theme/surface_theme.dart';
import '../../../data/collections/user_account_collection.dart';
import '../../shared/widgets/sub_page_scaffold.dart';

class ManageUsersScreen extends ConsumerStatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  ConsumerState<ManageUsersScreen> createState() =>
      _ManageUsersScreenState();
}

class _ManageUsersScreenState extends ConsumerState<ManageUsersScreen> {
  String _searchQuery = '';
  String _roleFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final allUsers = DatabaseService.userAccounts.values.toList();

    var filtered = allUsers.where((u) {
      if (_roleFilter != 'all') {
        if (_roleFilter == 'patient' && (u.isPractitioner || u.accountType == 'admin')) return false;
        if (_roleFilter == 'doctor' && u.practitionerType != 'doctor') return false;
        if (_roleFilter == 'nurse' && u.practitionerType != 'nurse') return false;
        if (_roleFilter == 'admin' && u.accountType != 'admin') return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return u.displayName.toLowerCase().contains(q) ||
            u.email.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return SubPageScaffold(
      title: 'Manage Users',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                // Search
                SizedBox(
                  width: double.infinity,
                  child: TextArea(
                    initialValue: _searchQuery,
                    placeholder: const Text('Search by name or email...'),
                    onChanged: (v) => setState(() => _searchQuery = v),
                    expandableWidth: false,
                    minLines: 1,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                // Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final filter in [
                        'all', 'patient', 'doctor', 'nurse', 'admin'
                      ])
                        Padding(
                          padding:
                              const EdgeInsets.only(right: AppSpacing.sm),
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _roleFilter = filter),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: _roleFilter == filter
                                    ? colors.primary
                                    : colors.surfaceLow,
                                borderRadius: AppRadius.chipRadius,
                              ),
                              child: Text(
                                filter[0].toUpperCase() +
                                    filter.substring(1),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: _roleFilter == filter
                                      ? colors.primaryForeground
                                      : colors.mutedForeground,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Results
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text('No users found',
                        style: TextStyle(color: colors.mutedForeground)))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      return _UserCard(
                        user: filtered[index],
                        onToggleVerification: () {
                          setState(() {
                            filtered[index].isVerified =
                                !filtered[index].isVerified;
                            filtered[index].save();
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final UserAccount user;
  final VoidCallback onToggleVerification;

  const _UserCard({
    required this.user,
    required this.onToggleVerification,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dateFormat = DateFormat('MMM d, yyyy');

    final role = user.accountType == 'admin'
        ? 'Admin'
        : user.isPractitioner
            ? (user.practitionerType == 'nurse' ? 'Nurse' : 'Doctor')
            : 'Patient';

    final roleColor = switch (role) {
      'Admin' => colors.destructive,
      'Doctor' => colors.primary,
      'Nurse' => colors.success,
      _ => colors.mutedForeground,
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: SurfaceTheme.cardDecoration(context: context),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: roleColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              user.displayName.isNotEmpty
                  ? user.displayName[0].toUpperCase()
                  : '?',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: roleColor),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        user.displayName,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colors.foreground),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: roleColor.withValues(alpha: 0.12),
                        borderRadius: AppRadius.chipRadius,
                      ),
                      child: Text(role,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: roleColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${user.email} · Joined ${dateFormat.format(user.createdAt)}',
                  style: TextStyle(
                      fontSize: 11, color: colors.mutedForeground),
                ),
              ],
            ),
          ),
          if (user.isPractitioner)
            GestureDetector(
              onTap: onToggleVerification,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 3),
                decoration: BoxDecoration(
                  color: user.isVerified
                      ? colors.success.withValues(alpha: 0.12)
                      : colors.warning.withValues(alpha: 0.12),
                  borderRadius: AppRadius.chipRadius,
                ),
                child: Text(
                  user.isVerified ? 'Verified' : 'Pending',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: user.isVerified
                        ? colors.success
                        : colors.warning,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
