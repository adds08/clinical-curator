import 'package:clinical_curator_client/clinical_curator_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_core/widgets/sub_page_scaffold.dart';

import '../../../domain/providers/repository_providers.dart';
import '../../../domain/providers/serverpod_provider.dart';

final _allUsersProvider = FutureProvider.autoDispose<List<UserAccount>>((ref) {
  ref.watch(repoRefreshProvider);
  return ref.read(serverpodClientProvider).admin.listAllUsers();
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
    return u.displayName.toLowerCase().contains(q) || u.email.toLowerCase().contains(q);
  }

  Future<void> _toggleVerification(UserAccount u) async {
    if (u.id == null) return;
    try {
      await ref.read(serverpodClientProvider).admin.setUserVerified(u.id!, !u.isVerified);
      bumpRepos(ref);
    } catch (e) {
      if (!mounted) return;
      showToast(
        context: context,
        builder: (_, __) => SurfaceCard(
          child: Basic(title: const Text('Toggle failed'), subtitle: Text(e.toString())),
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
                    placeholder: const Text('Search users...'),
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
                      for (final f in ['all', 'patient', 'doctor', 'nurse', 'admin'])
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: GestureDetector(
                            onTap: () => setState(() => _roleFilter = f),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: _roleFilter == f ? colors.primary : colors.surfaceLow,
                                borderRadius: AppRadius.chipRadius,
                              ),
                              child: Text(
                                f[0].toUpperCase() + f.substring(1),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: _roleFilter == f ? colors.primaryForeground : colors.mutedForeground,
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
              loading: () => const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Text('Failed to load users: $e', style: TextStyle(color: colors.destructive)),
                ),
              ),
              data: (all) {
                final users = all.where(_matches).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  itemCount: users.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _UserRow(user: users[i], onToggleVerification: _toggleVerification),
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

class _UserRow extends StatelessWidget {
  final UserAccount user;
  final Future<void> Function(UserAccount) onToggleVerification;
  const _UserRow({required this.user, required this.onToggleVerification});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dateFormat = DateFormat('MMM d, yyyy');

    final roleBadge = switch (user.accountType) {
      'admin' => const PrimaryBadge(child: Text('ADMIN')),
      _ when user.isPractitioner && user.practitionerType == 'doctor' => const SecondaryBadge(child: Text('DOCTOR')),
      _ when user.isPractitioner => const SecondaryBadge(child: Text('NURSE')),
      _ => Chip(child: const Text('PATIENT')),
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: SurfaceTheme.cardDecoration(context: context),
      child: Row(
        children: [
          Avatar(initials: _extractInitials(user.displayName), size: 36),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.foreground),
                ),
                const SizedBox(height: 2),
                Text(user.email, style: TextStyle(fontSize: 12, color: colors.mutedForeground)),
                const SizedBox(height: 2),
                Text('Joined ${dateFormat.format(user.createdAt)}', style: TextStyle(fontSize: 11, color: colors.mutedForeground)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              roleBadge,
              const SizedBox(height: 4),
              if (user.accountType != 'admin')
                GestureDetector(
                  onTap: () => onToggleVerification(user),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                    decoration: BoxDecoration(
                      color: user.isVerified ? colors.success.withValues(alpha: 0.12) : colors.warning.withValues(alpha: 0.12),
                      borderRadius: AppRadius.chipRadius,
                    ),
                    child: Text(
                      user.isVerified ? 'Verified' : 'Pending',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: user.isVerified ? colors.success : colors.warning),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _extractInitials(String name) {
    final parts = name.replaceAll('Dr. ', '').split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts.isNotEmpty ? parts[0][0].toUpperCase() : 'U';
  }
}
