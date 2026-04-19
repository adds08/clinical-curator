import 'package:cc_repositories/cc_repositories.dart';
import 'package:clinical_curator_client/clinical_curator_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_ui_kit/widgets/sub_page_scaffold.dart';

import '../../../domain/providers/repository_providers.dart';

final _rbacProvider =
    FutureProvider.autoDispose<List<RbacPermission>>((ref) {
  ref.watch(repoRefreshProvider);
  return ref.read(rbacRepositoryProvider).listAll();
});

class ManageRbacScreen extends ConsumerStatefulWidget {
  const ManageRbacScreen({super.key});

  @override
  ConsumerState<ManageRbacScreen> createState() => _ManageRbacScreenState();
}

class _ManageRbacScreenState extends ConsumerState<ManageRbacScreen> {
  String _selectedRole = 'patient';

  static const _roles = [
    {'id': 'patient', 'name': 'Patient'},
    {'id': 'doctor', 'name': 'Doctor'},
    {'id': 'nurse', 'name': 'Nurse'},
    {'id': 'admin', 'name': 'Admin'},
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final permsAsync = ref.watch(_rbacProvider);

    return SubPageScaffold(
      title: 'Manage Permissions',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Row(
              children: _roles.map((role) {
                final selected = _selectedRole == role['id'];
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _selectedRole = role['id']!),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color:
                            selected ? colors.primary : colors.surfaceLow,
                        borderRadius: AppRadius.chipRadius,
                      ),
                      child: Text(
                        role['name']!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: selected
                              ? colors.primaryForeground
                              : colors.mutedForeground,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: permsAsync.when(
              loading: () => const Center(
                  child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2))),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Text('Failed to load permissions: $e',
                      style: TextStyle(color: colors.destructive)),
                ),
              ),
              data: (all) => _buildMatrix(context, all),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatrix(BuildContext context, List<RbacPermission> all) {
    final colors = Theme.of(context).colorScheme;
    final rolePerms = all.where((p) => p.roleId == _selectedRole);
    final roleName =
        _roles.firstWhere((r) => r['id'] == _selectedRole)['name']!;

    final permsByResource = <String, Map<String, bool>>{};
    for (final resource in RbacResources.all) {
      permsByResource[resource] = {};
      for (final action in RbacActions.all) {
        final match = rolePerms.where(
            (p) => p.resource == resource && p.action == action);
        permsByResource[resource]![action] =
            match.isNotEmpty && match.first.isAllowed;
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      itemCount: RbacResources.all.length,
      itemBuilder: (_, index) {
        final resource = RbacResources.all[index];
        final actions = permsByResource[resource]!;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: SurfaceTheme.cardDecoration(context: context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resource.replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.foreground,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: RbacActions.all.map((action) {
                    final allowed = actions[action] ?? false;
                    return GestureDetector(
                      onTap: () async {
                        try {
                          await ref
                              .read(rbacRepositoryProvider)
                              .setPermission(
                                roleId: _selectedRole,
                                roleName: roleName,
                                resource: resource,
                                action: action,
                                isAllowed: !allowed,
                              );
                          bumpRepos(ref);
                        } catch (e) {
                          if (!context.mounted) return;
                          showToast(
                            context: context,
                            builder: (_, __) => SurfaceCard(
                              child: Basic(
                                title: const Text('Update failed'),
                                subtitle: Text(e.toString()),
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: allowed
                              ? colors.success.withValues(alpha: 0.12)
                              : colors.surfaceLow,
                          borderRadius: AppRadius.chipRadius,
                          border: allowed
                              ? Border.all(
                                  color: colors.success
                                      .withValues(alpha: 0.3),
                                  width: 1)
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (allowed)
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Icon(Icons.check_rounded,
                                    size: 14, color: colors.success),
                              ),
                            Text(
                              action,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: allowed
                                    ? colors.success
                                    : colors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
