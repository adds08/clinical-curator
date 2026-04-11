import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../domain/providers/booking_flow_provider.dart';
import '../../../domain/providers/doctor_search_provider.dart';
import '../../shared/widgets/sub_page_scaffold.dart';

class DoctorSearchScreen extends ConsumerStatefulWidget {
  final String? prefilterSpecialty;
  final String? prefilterOrgRef;

  const DoctorSearchScreen({
    super.key,
    this.prefilterSpecialty,
    this.prefilterOrgRef,
  });

  @override
  ConsumerState<DoctorSearchScreen> createState() => _DoctorSearchScreenState();
}

class _DoctorSearchScreenState extends ConsumerState<DoctorSearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(doctorSearchProvider.notifier);
      notifier.reset();
      if (widget.prefilterSpecialty != null) {
        notifier.setSpecialtyFilter(widget.prefilterSpecialty);
      }
      if (widget.prefilterOrgRef != null) {
        notifier.setOrgFilter(widget.prefilterOrgRef);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final searchState = ref.watch(doctorSearchProvider);
    final specialties = ref.watch(allSpecialtiesProvider);

    return SubPageScaffold(
      title: 'Find a Doctor',
      child: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl, AppSpacing.md, AppSpacing.xl, 0),
            child: TextField(
              controller: _searchController,
              placeholder: const Text('Search by name or specialty...'),
              onChanged: (value) {
                ref.read(doctorSearchProvider.notifier).setQuery(value);
              },
            ),
          ),

          // Filter chips
          if (specialties.isNotEmpty)
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: searchState.specialtyFilter == null,
                    onTap: () => ref
                        .read(doctorSearchProvider.notifier)
                        .setSpecialtyFilter(null),
                  ),
                  ...specialties.map((s) => Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.sm),
                        child: _FilterChip(
                          label: s,
                          selected: searchState.specialtyFilter == s,
                          onTap: () => ref
                              .read(doctorSearchProvider.notifier)
                              .setSpecialtyFilter(s),
                        ),
                      )),
                ],
              ),
            ),

          const Gap(AppSpacing.sm),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              children: [
                Text(
                  '${searchState.results.length} doctor${searchState.results.length == 1 ? '' : 's'} found',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),

          const Gap(AppSpacing.md),

          // Results list
          Expanded(
            child: searchState.results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 48, color: colors.mutedForeground),
                        const Gap(AppSpacing.md),
                        Text(
                          'No doctors found',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colors.mutedForeground,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          'Try adjusting your search or filters',
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl),
                    itemCount: searchState.results.length,
                    separatorBuilder: (_, _) => const Gap(AppSpacing.md),
                    itemBuilder: (context, index) {
                      final role = searchState.results[index];
                      return _DoctorCard(
                        name: role.practitionerName ?? 'Unknown',
                        specialty: role.specialty ?? 'General',
                        organization: role.organizationName ?? '',
                        practitionerRef: role.practitionerRef,
                        onTap: () {
                          ref
                              .read(bookingFlowProvider.notifier)
                              .selectDoctor(role);
                          context.push(
                            '/booking/doctor/${Uri.encodeComponent(role.practitionerRef)}',
                          );
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: selected
              ? null
              : Border.all(color: colors.border.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? colors.primaryForeground : colors.foreground,
          ),
        ),
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String organization;
  final String practitionerRef;
  final VoidCallback onTap;

  const _DoctorCard({
    required this.name,
    required this.specialty,
    required this.organization,
    required this.practitionerRef,
    required this.onTap,
  });

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  _initials(name),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colors.primary,
                  ),
                ),
              ),
            ),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dr. $name',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.foreground,
                    ),
                  ),
                  const Gap(3),
                  Text(
                    specialty,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: colors.primary,
                    ),
                  ),
                  if (organization.isNotEmpty) ...[
                    const Gap(2),
                    Text(
                      organization,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.mutedForeground,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: colors.mutedForeground),
          ],
        ),
      ),
    );
  }
}
