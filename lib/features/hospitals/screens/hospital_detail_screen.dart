import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/theme/clinical_colors.dart';
import '../../../core/theme/surface_theme.dart';
import '../../../data/collections/organization_collection.dart';
import '../../../domain/providers/healthcare_service_provider.dart';
import '../../../domain/providers/location_provider.dart';
import '../../../domain/providers/practitioner_role_provider.dart';
import '../../shared/widgets/sub_page_scaffold.dart';

class HospitalDetailScreen extends ConsumerStatefulWidget {
  final String organizationId;

  const HospitalDetailScreen({super.key, required this.organizationId});

  @override
  ConsumerState<HospitalDetailScreen> createState() =>
      _HospitalDetailScreenState();
}

class _HospitalDetailScreenState
    extends ConsumerState<HospitalDetailScreen> {
  int _selectedTab = 0;
  static const _tabs = ['Overview', 'Staff', 'Services', 'Locations'];

  OrganizationLocal? _getOrganization() {
    final box = DatabaseService.organizations;
    try {
      return box.values
          .firstWhere((o) => o.fhirId == widget.organizationId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final org = _getOrganization();

    if (org == null) {
      return SubPageScaffold(
        title: 'Hospital',
        child: Center(
          child: Text('Organization not found',
              style: TextStyle(color: colors.mutedForeground)),
        ),
      );
    }

    final orgRef = 'Organization/${org.fhirId}';
    final staff = ref.watch(rolesByOrgProvider(orgRef));
    final services = ref.watch(servicesByOrgProvider(orgRef));
    final locations = ref.watch(locationsByOrgProvider(orgRef));

    // Parse departments
    List<String> departments = [];
    if (org.departmentsJson != null) {
      try {
        departments = (jsonDecode(org.departmentsJson!) as List).cast<String>();
      } catch (_) {}
    }

    return SubPageScaffold(
      title: org.name,
      child: Column(
        children: [
          // Tab selector
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl, vertical: AppSpacing.md),
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final selected = _selectedTab == i;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: selected
                            ? colors.primary
                            : Colors.transparent,
                        borderRadius: AppRadius.chipRadius,
                        border: selected
                            ? null
                            : Border.all(
                                color:
                                    colors.border.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        _tabs[i],
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
              }),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                _OverviewTab(org: org, departments: departments),
                _StaffTab(staff: staff),
                _ServicesTab(services: services),
                _LocationsTab(locations: locations),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Overview Tab
// =============================================================================

class _OverviewTab extends StatelessWidget {
  final OrganizationLocal org;
  final List<String> departments;

  const _OverviewTab({required this.org, required this.departments});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type & status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: AppRadius.chipRadius,
                ),
                child: Text(org.type.toUpperCase(),
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colors.primary,
                        letterSpacing: 0.5)),
              ),
              if (org.hasEmergency) ...[
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: colors.destructive.withValues(alpha: 0.1),
                    borderRadius: AppRadius.chipRadius,
                  ),
                  child: Text('EMERGENCY',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colors.destructive,
                          letterSpacing: 0.5)),
                ),
              ],
              if (org.isOpen24Hours) ...[
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: colors.success.withValues(alpha: 0.1),
                    borderRadius: AppRadius.chipRadius,
                  ),
                  child: Text('24/7',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colors.success)),
                ),
              ],
            ],
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Contact info
          _InfoSection(
            title: 'Contact',
            children: [
              _InfoRow(icon: Icons.location_on_outlined, text: org.address),
              if (org.phone != null)
                _InfoRow(icon: Icons.phone_outlined, text: org.phone!),
              if (org.openHours != null)
                _InfoRow(
                    icon: Icons.access_time_rounded,
                    text: 'Hours: ${org.openHours}'),
              if (org.rating != null)
                _InfoRow(
                    icon: Icons.star_outline_rounded,
                    text: '${org.rating} rating'),
            ],
          ),

          if (departments.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxl),
            _InfoSection(
              title: 'Departments (${departments.length})',
              children: departments
                  .map((d) => _InfoRow(
                      icon: Icons.domain_rounded, text: d))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// Staff Tab
// =============================================================================

class _StaffTab extends StatelessWidget {
  final List<dynamic> staff;
  const _StaffTab({required this.staff});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    if (staff.isEmpty) {
      return Center(
        child: Text('No staff assigned',
            style: TextStyle(color: colors.mutedForeground)),
      );
    }

    // Group by specialty
    final bySpecialty = <String, List<dynamic>>{};
    for (final role in staff) {
      final specialty = role.specialty ?? 'General';
      bySpecialty.putIfAbsent(specialty, () => []).add(role);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${staff.length} staff members',
              style: TextStyle(
                  fontSize: 13, color: colors.mutedForeground)),
          const SizedBox(height: AppSpacing.lg),
          for (final entry in bySpecialty.entries) ...[
            Text(entry.key,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.foreground)),
            const SizedBox(height: AppSpacing.sm),
            ...entry.value.map((role) => Padding(
                  padding:
                      const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: SurfaceTheme.cardDecoration(
                        context: context),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: colors.primary
                                .withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            role.code == 'nurse'
                                ? Icons.local_hospital_rounded
                                : Icons.medical_services_rounded,
                            size: 18,
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
                                role.practitionerName ?? 'Unknown',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: colors.foreground),
                              ),
                              Text(
                                role.code,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: colors.mutedForeground),
                              ),
                            ],
                          ),
                        ),
                        if (role.active)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: colors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: AppSpacing.lg),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// Services Tab
// =============================================================================

class _ServicesTab extends StatelessWidget {
  final List<dynamic> services;
  const _ServicesTab({required this.services});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    if (services.isEmpty) {
      return Center(
        child: Text('No services listed',
            style: TextStyle(color: colors.mutedForeground)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.xl),
      itemCount: services.length,
      separatorBuilder: (_, _) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final svc = services[index];
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration:
              SurfaceTheme.cardDecoration(context: context),
          child: Row(
            children: [
              Icon(
                _iconForServiceType(svc.type),
                size: 20,
                color: colors.primary,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(svc.name,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colors.foreground)),
                    if (svc.specialty != null)
                      Text(svc.specialty!,
                          style: TextStyle(
                              fontSize: 12,
                              color: colors.mutedForeground)),
                    if (svc.comment != null)
                      Text(svc.comment!,
                          style: TextStyle(
                              fontSize: 11,
                              color: colors.mutedForeground)),
                  ],
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: svc.active
                      ? colors.success
                      : colors.mutedForeground,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _iconForServiceType(String type) {
    return switch (type) {
      'emergency' => Icons.emergency_rounded,
      'laboratory' => Icons.science_outlined,
      'radiology' => Icons.image_outlined,
      'pharmacy' => Icons.local_pharmacy_outlined,
      _ => Icons.medical_services_outlined,
    };
  }
}

// =============================================================================
// Locations Tab
// =============================================================================

class _LocationsTab extends StatelessWidget {
  final List<dynamic> locations;
  const _LocationsTab({required this.locations});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    if (locations.isEmpty) {
      return Center(
        child: Text('No locations registered',
            style: TextStyle(color: colors.mutedForeground)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.xl),
      itemCount: locations.length,
      separatorBuilder: (_, _) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final loc = locations[index];
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration:
              SurfaceTheme.cardDecoration(context: context),
          child: Row(
            children: [
              Icon(
                switch (loc.type) {
                  'wing' => Icons.apartment_rounded,
                  'room' => Icons.meeting_room_outlined,
                  'bed' => Icons.bed_outlined,
                  'area' => Icons.grid_view_rounded,
                  _ => Icons.place_outlined,
                },
                size: 18,
                color: colors.primary,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loc.name,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colors.foreground)),
                    if (loc.description != null)
                      Text(loc.description!,
                          style: TextStyle(
                              fontSize: 12,
                              color: colors.mutedForeground)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.surfaceLow,
                  borderRadius: AppRadius.chipRadius,
                ),
                child: Text(loc.type,
                    style: TextStyle(
                        fontSize: 10, color: colors.mutedForeground)),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// Shared widgets
// =============================================================================

class _InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: SurfaceTheme.cardDecoration(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.foreground)),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 16, color: colors.mutedForeground),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 13, color: colors.foreground)),
          ),
        ],
      ),
    );
  }
}
