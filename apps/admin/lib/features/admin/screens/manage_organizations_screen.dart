import 'package:clinical_curator_client/clinical_curator_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_core/theme/clinical_colors.dart';

import '../../../domain/providers/repository_providers.dart';

final _orgsProvider = FutureProvider.autoDispose<List<Organization>>((ref) {
  ref.watch(repoRefreshProvider);
  return ref.read(organizationRepositoryProvider).listAll();
});

class ManageOrganizationsScreen extends ConsumerStatefulWidget {
  const ManageOrganizationsScreen({super.key});

  @override
  ConsumerState<ManageOrganizationsScreen> createState() =>
      _ManageOrganizationsScreenState();
}

class _ManageOrganizationsScreenState
    extends ConsumerState<ManageOrganizationsScreen> {
  String _filter = 'all'; // 'all', 'hospital', 'pharmacy'

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final orgsAsync = ref.watch(_orgsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      child: SafeArea(
        child: orgsAsync.when(
          loading: () => const Center(
              child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2))),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text('Failed to load organizations: $e',
                  style: TextStyle(color: colors.destructive)),
            ),
          ),
          data: (all) => _buildContent(context, all),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Organization> allOrgs) {
    final colors = Theme.of(context).colorScheme;
    final hospitals = allOrgs
        .where((o) =>
            o.type == 'hospital' ||
            o.type == 'government' ||
            o.type == 'private')
        .toList();
    final pharmacies = allOrgs.where((o) => o.type == 'pharmacy').toList();

    final displayList = _filter == 'hospital'
        ? hospitals
        : _filter == 'pharmacy'
            ? pharmacies
            : allOrgs;

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
                  Text('Facilities',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: colors.foreground,
                          letterSpacing: -0.5)),
                  const SizedBox(height: 2),
                  Text('Manage hospitals & pharmacies',
                      style: TextStyle(
                          fontSize: 12, color: colors.mutedForeground)),
                ],
              ),
              Button.primary(
                onPressed: () => _openOrgDrawer(context, null),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 16),
                    SizedBox(width: 4),
                    Text('Add',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                  child: _StatChip(
                      label: 'Hospitals',
                      count: hospitals.length,
                      color: colors.primary)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                  child: _StatChip(
                      label: 'Pharmacies',
                      count: pharmacies.length,
                      color: colors.success)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                  child: _StatChip(
                      label: 'Total',
                      count: allOrgs.length,
                      color: colors.foreground)),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              _FilterChip(
                  label: 'All',
                  isSelected: _filter == 'all',
                  onTap: () => setState(() => _filter = 'all')),
              const SizedBox(width: AppSpacing.sm),
              _FilterChip(
                  label: 'Hospitals',
                  isSelected: _filter == 'hospital',
                  onTap: () => setState(() => _filter = 'hospital')),
              const SizedBox(width: AppSpacing.sm),
              _FilterChip(
                  label: 'Pharmacies',
                  isSelected: _filter == 'pharmacy',
                  onTap: () => setState(() => _filter = 'pharmacy')),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          if (displayList.isEmpty)
            Card(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
              borderRadius: AppRadius.cardRadius,
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.business,
                        size: 36,
                        color: colors.mutedForeground.withValues(alpha: 0.4)),
                    const SizedBox(height: AppSpacing.md),
                    Text('No facilities yet',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colors.mutedForeground)),
                  ],
                ),
              ),
            )
          else
            ...displayList.map((org) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _buildOrgCard(context, org),
                )),
        ],
      ),
    );
  }

  Widget _buildOrgCard(BuildContext context, Organization org) {
    final colors = Theme.of(context).colorScheme;
    final isHospital = org.type == 'hospital';

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
                decoration: BoxDecoration(
                  color: (isHospital ? colors.primary : colors.success)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                    isHospital
                        ? Icons.local_hospital
                        : Icons.local_pharmacy,
                    color: isHospital ? colors.primary : colors.success,
                    size: 20),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(org.name,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: colors.foreground)),
                    const SizedBox(height: 2),
                    Text(org.address,
                        style: TextStyle(
                            fontSize: 12, color: colors.mutedForeground)),
                  ],
                ),
              ),
              isHospital
                  ? const PrimaryBadge(child: Text('HOSPITAL'))
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: colors.success.withValues(alpha: 0.1),
                          borderRadius: AppRadius.chipRadius),
                      child: Text('PHARMACY',
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: colors.success,
                              letterSpacing: 0.5)),
                    ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: SurfaceTheme.colorFor(SurfaceLevel.low, context),
              borderRadius: AppRadius.inputRadius,
            ),
            child: Row(
              children: [
                if (org.phone != null) ...[
                  Icon(Icons.phone, size: 12, color: colors.mutedForeground),
                  const SizedBox(width: 4),
                  Text(org.phone!,
                      style: TextStyle(
                          fontSize: 11, color: colors.mutedForeground)),
                  const SizedBox(width: AppSpacing.md),
                ],
                Icon(Icons.schedule, size: 12, color: colors.mutedForeground),
                const SizedBox(width: 4),
                Text(org.openHours ?? 'N/A',
                    style: TextStyle(
                        fontSize: 11, color: colors.mutedForeground)),
                const Spacer(),
                if (org.hasEmergency)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        color: colors.destructive.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4)),
                    child: Text('ER',
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: colors.destructive)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Button.outline(
                  onPressed: () => _openOrgDrawer(context, org),
                  child: const Text('Edit',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Button.destructive(
                  onPressed: () async {
                    if (org.id == null) return;
                    await ref.read(organizationRepositoryProvider).delete(org.id!);
                    bumpRepos(ref);
                    if (!context.mounted) return;
                    showToast(
                        context: context,
                        builder: (c, o) => SurfaceCard(
                            child: Basic(title: Text('${org.name} removed'))));
                  },
                  child: const Text('Remove',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
    bool is24Hours = existing?.isOpen24Hours ?? false;

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
              Text(isEdit ? 'Edit Facility' : 'Add Facility',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: colors.foreground)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setDrawerState(() => type = 'hospital'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: type == 'hospital'
                              ? colors.primary.withValues(alpha: 0.08)
                              : colors.card,
                          borderRadius: AppRadius.inputRadius,
                          border: Border.all(
                              color: type == 'hospital'
                                  ? colors.primary
                                  : colors.border),
                        ),
                        child: Center(
                            child: Text('Hospital',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: type == 'hospital'
                                        ? colors.primary
                                        : colors.mutedForeground))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setDrawerState(() => type = 'pharmacy'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: type == 'pharmacy'
                              ? colors.success.withValues(alpha: 0.08)
                              : colors.card,
                          borderRadius: AppRadius.inputRadius,
                          border: Border.all(
                              color: type == 'pharmacy'
                                  ? colors.success
                                  : colors.border),
                        ),
                        child: Center(
                            child: Text('Pharmacy',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: type == 'pharmacy'
                                        ? colors.success
                                        : colors.mutedForeground))),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                  controller: nameCtrl,
                  placeholder: const Text('Facility name')),
              const SizedBox(height: 12),
              TextField(
                  controller: addressCtrl, placeholder: const Text('Address')),
              const SizedBox(height: 12),
              TextField(
                  controller: phoneCtrl,
                  placeholder: const Text('Phone number')),
              const SizedBox(height: 12),
              TextField(
                  controller: hoursCtrl,
                  placeholder: const Text('Open hours (e.g. 24/7)')),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () =>
                    setDrawerState(() => hasEmergency = !hasEmergency),
                child: Row(
                  children: [
                    Checkbox(
                      state: hasEmergency
                          ? CheckboxState.checked
                          : CheckboxState.unchecked,
                      onChanged: (s) => setDrawerState(
                          () => hasEmergency = s == CheckboxState.checked),
                    ),
                    const SizedBox(width: 8),
                    Text('Has Emergency Department',
                        style: TextStyle(
                            fontSize: 13, color: colors.foreground)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => setDrawerState(() => is24Hours = !is24Hours),
                child: Row(
                  children: [
                    Checkbox(
                      state: is24Hours
                          ? CheckboxState.checked
                          : CheckboxState.unchecked,
                      onChanged: (s) => setDrawerState(
                          () => is24Hours = s == CheckboxState.checked),
                    ),
                    const SizedBox(width: 8),
                    Text('Open 24 Hours',
                        style: TextStyle(
                            fontSize: 13, color: colors.foreground)),
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
                    final repo = ref.read(organizationRepositoryProvider);
                    final phone = phoneCtrl.text.trim();
                    final hours = hoursCtrl.text.trim();
                    try {
                      if (isEdit) {
                        await repo.update(existing.copyWith(
                          name: name,
                          type: type,
                          address: addressCtrl.text.trim(),
                          phone: phone.isEmpty ? null : phone,
                          openHours: hours.isEmpty ? null : hours,
                          hasEmergency: hasEmergency,
                          isOpen24Hours: is24Hours,
                        ));
                      } else {
                        await repo.create(Organization(
                          fhirId: 'org-${name.toLowerCase().replaceAll(' ', '-')}',
                          name: name,
                          type: type,
                          address: addressCtrl.text.trim(),
                          phone: phone.isEmpty ? null : phone,
                          openHours: hours.isEmpty ? null : hours,
                          hasEmergency: hasEmergency,
                          isOpen24Hours: is24Hours,
                          createdAt: DateTime.now(),
                        ));
                      }
                      bumpRepos(ref);
                      if (!context.mounted) return;
                      closeDrawer(context);
                      showToast(
                          context: context,
                          builder: (c, o) => SurfaceCard(
                              child: Basic(
                                  title: Text(isEdit
                                      ? '"$name" updated'
                                      : '"$name" added'))));
                    } catch (e) {
                      if (!context.mounted) return;
                      showToast(
                          context: context,
                          builder: (c, o) => SurfaceCard(
                              child: Basic(
                                  title: const Text('Save failed'),
                                  subtitle: Text(e.toString()))));
                    }
                  },
                  child: Text(isEdit ? 'Save Changes' : 'Add Facility'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _StatChip(
      {required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: AppRadius.cardRadius,
      ),
      child: Column(
        children: [
          Text('$count',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800, color: color)),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: colors.mutedForeground)),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: isSelected ? colors.primary : colors.border),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? colors.primaryForeground
                    : colors.mutedForeground)),
      ),
    );
  }
}
