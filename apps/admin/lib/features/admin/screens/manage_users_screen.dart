import 'package:clinical_curator_client/clinical_curator_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_ui_kit/widgets/sub_page_scaffold.dart';

import '../../../domain/providers/repository_providers.dart';

final _allUsersProvider = FutureProvider.autoDispose<List<UserAccount>>((ref) {
  ref.watch(repoRefreshProvider);
  return ref.read(userRepositoryProvider).listAll();
});

class ManageUsersScreen extends ConsumerStatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  ConsumerState<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends ConsumerState<ManageUsersScreen> {
  String _searchQuery = '';
  String _roleFilter = 'all';

  bool _matches(UserAccount u) {
    switch (_roleFilter) {
      case 'patient':
        if (u.isPractitioner || u.accountType == 'admin') return false;
        break;
      case 'doctor':
        if (u.practitionerType != 'doctor') return false;
        break;
      case 'nurse':
        if (u.practitionerType != 'nurse') return false;
        break;
      case 'admin':
        if (u.accountType != 'admin') return false;
        break;
    }
    if (_searchQuery.isEmpty) return true;
    final q = _searchQuery.toLowerCase();
    return u.displayName.toLowerCase().contains(q) ||
        u.email.toLowerCase().contains(q);
  }

  Future<void> _toggleVerification(UserAccount u) async {
    if (u.id == null) return;
    try {
      await ref.read(userRepositoryProvider).setVerified(u.id!, !u.isVerified);
      bumpRepos(ref);
    } catch (e) {
      if (!mounted) return;
      showToast(
        context: context,
        builder: (_, __) => SurfaceCard(
          child: Basic(
            title: const Text('Update failed'),
            subtitle: Text(e.toString()),
            leading: const Icon(Icons.error_outline, size: 16),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final usersAsync = ref.watch(_allUsersProvider);

    return SubPageScaffold(
      title: 'Manage Users',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final filter in ['all', 'patient', 'doctor', 'nurse', 'admin'])
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: GestureDetector(
                            onTap: () => setState(() => _roleFilter = filter),
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
                                filter[0].toUpperCase() + filter.substring(1),
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
          Expanded(
            child: usersAsync.when(
              loading: () => const Center(
                  child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2))),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Text('Failed to load users: $e',
                      style: TextStyle(color: colors.destructive)),
                ),
              ),
              data: (users) {
                final filtered = users.where(_matches).toList();
                if (filtered.isEmpty) {
                  return Center(
                      child: Text('No users found',
                          style: TextStyle(color: colors.mutedForeground)));
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (_, i) => _UserCard(
                    user: filtered[i],
                    onToggleVerification: () => _toggleVerification(filtered[i]),
                  ),
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
                  fontSize: 16, fontWeight: FontWeight.w600, color: roleColor),
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
                    color: user.isVerified ? colors.success : colors.warning,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
