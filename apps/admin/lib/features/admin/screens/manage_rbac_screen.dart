import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_fhir_models/models/rbac_permission.dart';
import 'package:cc_data/providers/rbac_provider.dart';
import 'package:cc_ui_kit/widgets/sub_page_scaffold.dart';

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
    final box = DatabaseService.rbacPermissions;

    // Get permissions for selected role
    final rolePerms = box.values
        .where((p) => p.roleId == _selectedRole)
        .toList();

    // Group by resource
    final permsByResource = <String, Map<String, bool>>{};
    for (final resource in RbacResources.all) {
      permsByResource[resource] = {};
      for (final action in RbacActions.all) {
        final perm = rolePerms
            .where((p) => p.resource == resource && p.action == action);
        permsByResource[resource]![action] =
            perm.isNotEmpty && perm.first.isAllowed;
      }
    }

    return SubPageScaffold(
      title: 'Manage Permissions',
      child: Column(
        children: [
          // Role selector
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
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: selected
                            ? colors.primary
                            : colors.surfaceLow,
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

          // Permission matrix
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              itemCount: RbacResources.all.length,
              itemBuilder: (context, index) {
                final resource = RbacResources.all[index];
                final actions = permsByResource[resource]!;

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration:
                        SurfaceTheme.cardDecoration(context: context),
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
                                await ref
                                    .read(rbacProvider.notifier)
                                    .setPermission(
                                      roleId: _selectedRole,
                                      roleName: _roles.firstWhere((r) =>
                                          r['id'] ==
                                          _selectedRole)['name']!,
                                      resource: resource,
                                      action: action,
                                      isAllowed: !allowed,
                                    );
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: AppSpacing.xs),
                                decoration: BoxDecoration(
                                  color: allowed
                                      ? colors.success
                                          .withValues(alpha: 0.12)
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
                                        padding: const EdgeInsets.only(
                                            right: 4),
                                        child: Icon(
                                            Icons.check_rounded,
                                            size: 14,
                                            color: colors.success),
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
            ),
          ),
        ],
      ),
    );
  }
}
