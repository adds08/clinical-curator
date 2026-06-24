import 'package:clinical_curator_client/clinical_curator_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_core/theme/clinical_colors.dart';

import '../../../domain/providers/repository_providers.dart';
import '../../../domain/providers/serverpod_provider.dart';

final _orgsProvider = FutureProvider.autoDispose<List<Organization>>((ref) {
  ref.watch(repoRefreshProvider);
  return ref.read(serverpodClientProvider).organization.listAll();
});

class ManageOrganizationsScreen extends ConsumerStatefulWidget {
  const ManageOrganizationsScreen({super.key});

  @override
  ConsumerState<ManageOrganizationsScreen> createState() => _ManageOrganizationsScreenState();
}

class _ManageOrganizationsScreenState extends ConsumerState<ManageOrganizationsScreen> {
  String _searchQuery = '';
  String _typeFilter = 'all';

  bool _matches(Organization org) {
    if (_typeFilter != 'all' && org.type != _typeFilter) return false;
    if (_searchQuery.isEmpty) return true;
    final q = _searchQuery.toLowerCase();
    return org.name.toLowerCase().contains(q) ||
        (org.address?.toLowerCase().contains(q) ?? false) ||
        (org.phone?.toLowerCase().contains(q) ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final orgsAsync = ref.watch(_orgsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      child: SafeArea(
        child: orgsAsync.when(
          loading: () => const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text('Failed to load organizations: $e', style: TextStyle(color: colors.destructive)),
            ),
          ),
          data: (orgs) => _buildContent(context, orgs),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Organization> orgs) {
    final colors = Theme.of(context).colorScheme;
    final displayList = orgs.where(_matches).toList()..sort((a, b) => a.name.compareTo(b.name));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Organizations',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: colors.foreground, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 2),
                  Text('${orgs.length} facilities', style: TextStyle(fontSize: 12, color: colors.mutedForeground)),
                ],
              ),
              Button.primary(
                onPressed: () => _openOrgDrawer(context, null),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 16),
                    SizedBox(width: 4),
                    Text('Add', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: TextArea(
              initialValue: _searchQuery,
              placeholder: const Text('Search facilities...'),
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
                for (final f in ['all', 'hospital', 'clinic', 'pharmacy', 'lab'])
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: GestureDetector(
                      onTap: () => setState(() => _typeFilter = f),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: _typeFilter == f ? colors.primary : colors.surfaceLow,
                          borderRadius: AppRadius.chipRadius,
                        ),
                        child: Text(
                          f[0].toUpperCase() + f.substring(1),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _typeFilter == f ? colors.primaryForeground : colors.mutedForeground,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          if (displayList.isEmpty)
            Card(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
              borderRadius: AppRadius.cardRadius,
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.business, size: 40, color: colors.mutedForeground.withValues(alpha: 0.4)),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No organizations found',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.mutedForeground),
                    ),
                  ],
                ),
              ),
            )
          else
            ...displayList.map(
              (org) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _buildOrgCard(context, org),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrgCard(BuildContext context, Organization org) {
    final colors = Theme.of(context).colorScheme;
    final client = ref.read(serverpodClientProvider);

    return Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
      borderRadius: AppRadius.cardRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: colors.primary.withValues(alpha: 0.1), borderRadius: AppRadius.inputRadius),
                alignment: Alignment.center,
                child: Icon(Icons.local_hospital_rounded, size: 20, color: colors.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      org.name,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: colors.foreground),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: _typeColor(org.type, colors).withValues(alpha: 0.12),
                        borderRadius: AppRadius.chipRadius,
                      ),
                      child: Text(
                        org.type.toUpperCase(),
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: _typeColor(org.type, colors), letterSpacing: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (org.address != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 14, color: colors.mutedForeground),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(org.address!, style: TextStyle(fontSize: 12, color: colors.foreground)),
                  ),
                ],
              ),
            ),
          if (org.phone != null)
            Row(
              children: [
                Icon(Icons.phone_outlined, size: 14, color: colors.mutedForeground),
                const SizedBox(width: 4),
                Text(org.phone!, style: TextStyle(fontSize: 12, color: colors.foreground)),
                const Spacer(),
                Text('24h', style: TextStyle(fontSize: 11, color: colors.mutedForeground)),
              ],
            ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Button.outline(
                  onPressed: () => _openOrgDrawer(context, org),
                  child: const Text('Edit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Button.destructive(
                  onPressed: () async {
                    if (org.id == null) return;
                    await client.organization.delete(org.id!);
                    bumpRepos(ref);
                    if (!context.mounted) return;
                    showToast(
                      context: context,
                      builder: (c, o) => SurfaceCard(child: Basic(title: Text('${org.name} removed'))),
                    );
                  },
                  child: const Text('Remove', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _typeColor(String type, ColorScheme colors) {
    return switch (type) {
      'hospital' => colors.primary,
      'clinic' => colors.success,
      'pharmacy' => colors.warning,
      'lab' => colors.secondary,
      _ => colors.mutedForeground,
    };
  }

  void _openOrgDrawer(BuildContext context, Organization? existing) {
    final colors = Theme.of(context).colorScheme;
    final isEdit = existing != null;
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final addressCtrl = TextEditingController(text: existing?.address ?? '');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '');
    final hoursCtrl = TextEditingController(text: existing?.openHours ?? '');
    String type = existing?.type ?? 'hospital';
    bool hasEmergency = existing?.hasEmergency ?? false;
    bool is24Hours = existing?.openHours == '24/7';

    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDrawerState) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? 'Edit Organization' : 'New Organization',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.foreground),
              ),
              const SizedBox(height: 20),
              TextField(controller: nameCtrl, placeholder: const Text('Name')),
              const SizedBox(height: 12),
              TextField(controller: addressCtrl, placeholder: const Text('Address')),
              const SizedBox(height: 12),
              TextField(controller: phoneCtrl, placeholder: const Text('Phone')),
              const SizedBox(height: 12),
              TextField(controller: hoursCtrl, placeholder: const Text('Open hours (e.g. 8:00-20:00)')),
              const SizedBox(height: 16),
              Text(
                'Type',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.mutedForeground),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['hospital', 'clinic', 'pharmacy', 'lab'].map((t) {
                  final isSelected = type == t;
                  return GestureDetector(
                    onTap: () => setDrawerState(() => type = t),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? colors.primary : colors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isSelected ? colors.primary : colors.border),
                      ),
                      child: Text(
                        t[0].toUpperCase() + t.substring(1),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? colors.primaryForeground : colors.mutedForeground,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => setDrawerState(() => hasEmergency = !hasEmergency),
                child: Row(
                  children: [
                    Checkbox(
                      state: hasEmergency ? CheckboxState.checked : CheckboxState.unchecked,
                      onChanged: (s) => setDrawerState(() => hasEmergency = s == CheckboxState.checked),
                    ),
                    const SizedBox(width: 8),
                    Text('Has Emergency', style: TextStyle(fontSize: 13, color: colors.foreground)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => setDrawerState(() => is24Hours = !is24Hours),
                child: Row(
                  children: [
                    Checkbox(
                      state: is24Hours ? CheckboxState.checked : CheckboxState.unchecked,
                      onChanged: (s) => setDrawerState(() => is24Hours = s == CheckboxState.checked),
                    ),
                    const SizedBox(width: 8),
                    Text('Open 24 Hours', style: TextStyle(fontSize: 13, color: colors.foreground)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Button.primary(
                  onPressed: () async {
                    final name = nameCtrl.text.trim();
                    if (name.isEmpty) {
                      closeDrawer(context);
                      return;
                    }
                    final client = ref.read(serverpodClientProvider);
                    final phone = phoneCtrl.text.trim();
                    final hours = hoursCtrl.text.trim();
                    try {
                      if (isEdit) {
                        await client.organization.update(
                          existing.copyWith(
                            name: name,
                            type: type,
                            address: addressCtrl.text.trim(),
                            phone: phone.isEmpty ? null : phone,
                            openHours: hours.isEmpty ? null : hours,
                            hasEmergency: hasEmergency,
                          ),
                        );
                      } else {
                        await client.organization.create(
                          Organization(
                            name: name,
                            type: type,
                            address: addressCtrl.text.trim(),
                            phone: phone.isEmpty ? null : phone,
                            openHours: hours.isEmpty ? null : hours,
                            hasEmergency: hasEmergency,
                            isOpen24Hours: is24Hours,
                            createdAt: DateTime.now(),
                          ),
                        );
                      }
                      bumpRepos(ref);
                      if (!context.mounted) return;
                      closeDrawer(context);
                      showToast(
                        context: context,
                        builder: (c, o) => SurfaceCard(child: Basic(title: Text(isEdit ? '"$name" updated' : '"$name" added'))),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      showToast(
                        context: context,
                        builder: (c, o) => SurfaceCard(
                          child: Basic(title: const Text('Save failed'), subtitle: Text(e.toString())),
                        ),
                      );
                    }
                  },
                  child: Text(isEdit ? 'Save Changes' : 'Add Organization'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
