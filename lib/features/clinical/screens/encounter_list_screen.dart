import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/clinical_colors.dart';
import '../../../core/theme/surface_theme.dart';
import '../../../data/collections/encounter_collection.dart';
import '../../../domain/providers/auth_provider.dart';
import '../../../domain/providers/encounter_provider.dart';
import '../../shared/widgets/sub_page_scaffold.dart';

class EncounterListScreen extends ConsumerStatefulWidget {
  const EncounterListScreen({super.key});

  @override
  ConsumerState<EncounterListScreen> createState() =>
      _EncounterListScreenState();
}

class _EncounterListScreenState extends ConsumerState<EncounterListScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final authState = ref.watch(authProvider);
    final practRef = authState.user?.fhirPractitionerId != null
        ? 'Practitioner/${authState.user!.fhirPractitionerId}'
        : '';

    final allEncounters =
        ref.watch(encountersByPractitionerProvider(practRef));

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final weekStart = todayStart.subtract(Duration(days: todayStart.weekday));

    final todayEncounters = allEncounters
        .where((e) => e.startDate.isAfter(todayStart))
        .toList();
    final weekEncounters = allEncounters
        .where((e) => e.startDate.isAfter(weekStart))
        .toList();

    final displayList = _selectedTab == 0
        ? todayEncounters
        : _selectedTab == 1
            ? weekEncounters
            : allEncounters;

    return SubPageScaffold(
      title: 'Encounters',
      trailing: [
        IconButton.ghost(
          icon: const Icon(Icons.add_rounded, size: 22),
          onPressed: () => context.push('/clinical/start-encounter'),
        ),
      ],
      child: Column(
        children: [
          // Tab bar
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl, vertical: AppSpacing.md),
            child: Row(
              children: [
                _TabChip(
                    label: 'Today',
                    count: todayEncounters.length,
                    selected: _selectedTab == 0,
                    onTap: () => setState(() => _selectedTab = 0)),
                const SizedBox(width: AppSpacing.sm),
                _TabChip(
                    label: 'This Week',
                    count: weekEncounters.length,
                    selected: _selectedTab == 1,
                    onTap: () => setState(() => _selectedTab = 1)),
                const SizedBox(width: AppSpacing.sm),
                _TabChip(
                    label: 'All',
                    count: allEncounters.length,
                    selected: _selectedTab == 2,
                    onTap: () => setState(() => _selectedTab = 2)),
              ],
            ),
          ),
          // List
          Expanded(
            child: displayList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.medical_services_outlined,
                            size: 48, color: colors.mutedForeground),
                        const SizedBox(height: AppSpacing.md),
                        Text('No encounters',
                            style: TextStyle(
                                color: colors.mutedForeground, fontSize: 15)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    itemCount: displayList.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      return _EncounterCard(
                        encounter: displayList[index],
                        onTap: () {
                          final enc = displayList[index];
                          if (enc.status == 'in-progress') {
                            context.push(
                                '/clinical/workspace/${enc.fhirId}');
                          } else {
                            context.push(
                                '/clinical/summary/${enc.fhirId}');
                          }
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

class _TabChip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? colors.primary : colors.surfaceLow,
          borderRadius: AppRadius.chipRadius,
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? colors.primaryForeground : colors.mutedForeground,
          ),
        ),
      ),
    );
  }
}

class _EncounterCard extends StatelessWidget {
  final EncounterLocal encounter;
  final VoidCallback onTap;

  const _EncounterCard({required this.encounter, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('HH:mm');

    final statusColor = switch (encounter.status) {
      'in-progress' => colors.success,
      'finished' => colors.primary,
      'cancelled' => colors.destructive,
      'planned' => colors.warning,
      _ => colors.mutedForeground,
    };

    final classLabel = switch (encounter.classCode) {
      'AMB' => 'Ambulatory',
      'EMER' => 'Emergency',
      'IMP' => 'Inpatient',
      'OBSENC' => 'Observation',
      _ => encounter.classCode,
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: SurfaceTheme.cardDecoration(context: context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    encounter.patientName ?? 'Unknown Patient',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.foreground,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: AppRadius.chipRadius,
                  ),
                  child: Text(
                    encounter.status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(Icons.calendar_today_rounded,
                    size: 13, color: colors.mutedForeground),
                const SizedBox(width: 4),
                Text(
                  '${dateFormat.format(encounter.startDate)} at ${timeFormat.format(encounter.startDate)}',
                  style: TextStyle(
                      fontSize: 12, color: colors.mutedForeground),
                ),
                const SizedBox(width: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colors.surfaceLow,
                    borderRadius: AppRadius.chipRadius,
                  ),
                  child: Text(
                    classLabel,
                    style: TextStyle(
                        fontSize: 11, color: colors.mutedForeground),
                  ),
                ),
              ],
            ),
            if (encounter.serviceType != null) ...[
              const SizedBox(height: 4),
              Text(
                encounter.serviceType!,
                style:
                    TextStyle(fontSize: 12, color: colors.mutedForeground),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
