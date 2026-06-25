import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_data/providers/emr_providers.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/fhir_resource_collection.dart';

/// Tabbed EMR Patient Chart — matches design spec Screen 2
class PatientChartScreen extends ConsumerStatefulWidget {
  final String patientId;

  const PatientChartScreen({super.key, required this.patientId});

  @override
  ConsumerState<PatientChartScreen> createState() => _PatientChartScreenState();
}

class _PatientChartScreenState extends ConsumerState<PatientChartScreen> {
  int _selectedTab = 0;

  static const _tabLabels = ['Overview', 'Encounters', 'Vitals', 'Labs', 'Medications', 'Immunizations'];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final chartData = ref.watch(patientChartProvider(widget.patientId));

    final patientName = chartData.encounters.isNotEmpty ? _extractPatientName(chartData.encounters.first) ?? 'Patient' : 'Patient';

    return Scaffold(
      headers: [
        AppBar(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          backgroundColor: colors.background,
          leading: [
            IconButton.ghost(
              icon: const Icon(LucideIcons.arrowLeft, size: 22),
              onPressed: () {
                if (context.canPop()) context.pop();
              },
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    patientName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.foreground),
                  ),
                  Text(
                    'Health ID: ${widget.patientId}',
                    style: TextStyle(fontSize: 12, color: colors.mutedForeground, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
          trailing: [
            Button.primary(
              onPressed: () => context.push('/clinical/start-encounter', extra: {'patientId': widget.patientId}),
              child: const Text('Start Encounter'),
            ),
          ],
        ),
      ],
      child: Column(
        children: [
          // Chip-based Tab selector
          Container(
            color: colors.background,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_tabLabels.length, (i) {
                  final selected = _selectedTab == i;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: selected ? colors.primary : Colors.transparent,
                          borderRadius: AppRadius.chipRadius,
                          border: selected ? null : Border.all(color: colors.border.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          _tabLabels[i],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: selected ? colors.primaryForeground : colors.mutedForeground,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          // Tab content
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                _OverviewTab(patientId: widget.patientId, chartData: chartData),
                _EncountersTab(patientId: widget.patientId, encounters: chartData.encounters),
                _VitalsTab(patientId: widget.patientId, vitals: chartData.vitals),
                _LabsTab(patientId: widget.patientId, labs: chartData.labs),
                _MedicationsTab(patientId: widget.patientId, medications: chartData.medications),
                _ImmunizationsTab(patientId: widget.patientId, immunizations: chartData.immunizations),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _extractPatientName(Map<String, dynamic> resource) {
    try {
      if (resource['subject'] != null && resource['subject']['display'] != null) {
        return resource['subject']['display'] as String;
      }
    } catch (_) {}
    return null;
  }
}

// =============================================================================
// Overview Tab
// =============================================================================

class _OverviewTab extends ConsumerWidget {
  final String patientId;
  final PatientChartData chartData;

  const _OverviewTab({required this.patientId, required this.chartData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final allergies = chartData.allergies;
    final conditions = chartData.conditions;
    final activeMeds = chartData.medications.where((m) => m['status'] == 'active').toList();
    const recentEncountersLimit = 3;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Allergies + Conditions chips
          if (allergies.isNotEmpty || conditions.isNotEmpty) ...[
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                ...allergies.map(
                  (a) => DestructiveBadge(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.triangleAlert, size: 12),
                        const SizedBox(width: 4),
                        Text(a['code']['coding']?.first?['display'] ?? 'Allergy', style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                ),
                ...conditions
                    .where((c) => c['clinicalStatus']?['coding']?.first?['code'] == 'active' || c['verificationStatus'] == null)
                    .map(
                      (c) => SecondaryBadge(
                        child: Text(
                          c['code']['coding']?.first?['display'] ?? c['code']['text'] ?? 'Condition',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Vitals Summary Cards
          if (chartData.vitals.isNotEmpty) ...[
            Text(
              'Vitals Summary',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: colors.foreground),
            ),
            const SizedBox(height: AppSpacing.md),
            _VitalsSummaryRow(vitals: chartData.vitals),
            const SizedBox(height: AppSpacing.xl),
          ],

          // Active Medications
          if (activeMeds.isNotEmpty) ...[
            Text(
              'Active Medications',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: colors.foreground),
            ),
            const SizedBox(height: AppSpacing.md),
            ...activeMeds
                .take(5)
                .map(
                  (m) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _FhirCard(
                      icon: LucideIcons.pill,
                      title: m['medicationCodeableConcept']?['text'] ?? m['medicationReference']?['display'] ?? 'Medication',
                      subtitle: m['status'] ?? '',
                    ),
                  ),
                ),
            const SizedBox(height: AppSpacing.xl),
          ],

          // Recent Encounters
          if (chartData.encounters.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Encounters',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: colors.foreground),
                ),
                GestureDetector(
                  onTap: () => context.push('/clinical/encounters'),
                  child: Text(
                    'View All',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: colors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...chartData.encounters
                .take(recentEncountersLimit)
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _EncounterCard(encounter: e),
                  ),
                ),
          ],

          if (chartData.vitals.isEmpty && activeMeds.isEmpty && chartData.encounters.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Center(
                child: Column(
                  children: [
                    Icon(LucideIcons.fileQuestion, size: 48, color: colors.mutedForeground),
                    const SizedBox(height: AppSpacing.md),
                    Text('No clinical data yet', style: TextStyle(fontSize: 16, color: colors.mutedForeground)),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Start an encounter to begin documenting', style: TextStyle(fontSize: 13, color: colors.mutedForeground)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// =============================================================================
// Encounters Tab
// =============================================================================

class _EncountersTab extends StatelessWidget {
  final String patientId;
  final List<Map<String, dynamic>> encounters;

  const _EncountersTab({required this.patientId, required this.encounters});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (encounters.isEmpty) {
      return Center(
        child: Text('No encounters recorded', style: TextStyle(color: colors.mutedForeground)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: encounters.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final e = encounters[index];
        return _EncounterCard(encounter: e);
      },
    );
  }
}

// =============================================================================
// Vitals Tab
// =============================================================================

class _VitalsTab extends StatelessWidget {
  final String patientId;
  final List<Map<String, dynamic>> vitals;

  const _VitalsTab({required this.patientId, required this.vitals});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (vitals.isEmpty) {
      return Center(
        child: Text('No vitals recorded', style: TextStyle(color: colors.mutedForeground)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: vitals.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final v = vitals[index];
        final codeDisplay = v['code']?['coding']?.first?['display'] ?? v['code']?['text'] ?? 'Observation';
        final value = v['valueQuantity'] != null ? '${v['valueQuantity']['value']} ${v['valueQuantity']['unit'] ?? ''}' : '';
        final effectiveDate = v['effectiveDateTime'] ?? v['issued'] ?? '';
        final dateStr = effectiveDate is String && effectiveDate.isNotEmpty
            ? DateFormat('MMM d, yyyy HH:mm').format(DateTime.parse(effectiveDate))
            : '';

        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: colors.card, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: colors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(LucideIcons.heartPulse, size: 18, color: colors.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      codeDisplay,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.foreground),
                    ),
                    if (dateStr.isNotEmpty) Text(dateStr, style: TextStyle(fontSize: 11, color: colors.mutedForeground)),
                  ],
                ),
              ),
              if (value.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: colors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.primary),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// Labs Tab
// =============================================================================

class _LabsTab extends StatelessWidget {
  final String patientId;
  final List<Map<String, dynamic>> labs;

  const _LabsTab({required this.patientId, required this.labs});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (labs.isEmpty) {
      return Center(
        child: Text('No lab results', style: TextStyle(color: colors.mutedForeground)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: labs.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final lab = labs[index];
        final codeDisplay = lab['code']?['coding']?.first?['display'] ?? lab['code']?['text'] ?? 'Lab';
        final value = lab['valueQuantity'] != null
            ? '${lab['valueQuantity']['value']} ${lab['valueQuantity']['unit'] ?? ''}'
            : lab['valueString'] ?? lab['valueCodeableConcept']?['text'] ?? '';
        final hasRefRange = lab['referenceRange'] != null && lab['referenceRange'].isNotEmpty;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: colors.card, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.flaskConical, size: 16, color: colors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      codeDisplay,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.foreground),
                    ),
                  ),
                  if (value.isNotEmpty)
                    Text(
                      value,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.foreground),
                    ),
                ],
              ),
              if (hasRefRange) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Ref: ${lab['referenceRange'].first['low']?['value'] ?? "?"} - ${lab['referenceRange'].first['high']?['value'] ?? "?"} ${lab['referenceRange'].first['low']?['unit'] ?? lab['valueQuantity']?['unit'] ?? ''}',
                  style: TextStyle(fontSize: 11, color: colors.mutedForeground),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// Medications Tab
// =============================================================================

class _MedicationsTab extends StatelessWidget {
  final String patientId;
  final List<Map<String, dynamic>> medications;

  const _MedicationsTab({required this.patientId, required this.medications});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (medications.isEmpty) {
      return Center(
        child: Text('No medications', style: TextStyle(color: colors.mutedForeground)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: medications.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final m = medications[index];
        final name = m['medicationCodeableConcept']?['text'] ?? m['medicationReference']?['display'] ?? 'Medication';
        final status = m['status'] ?? '';
        final dosage = m['dosageInstruction']?.first?['text'] ?? '';
        final isActive = status == 'active';

        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(12),
            border: isActive ? Border.all(color: colors.success.withValues(alpha: 0.3)) : null,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (isActive ? colors.success : colors.mutedForeground).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(LucideIcons.pill, size: 18, color: isActive ? colors.success : colors.mutedForeground),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.foreground),
                    ),
                    if (dosage.isNotEmpty) Text(dosage, style: TextStyle(fontSize: 12, color: colors.mutedForeground)),
                  ],
                ),
              ),
              PrimaryBadge(child: Text(status, style: const TextStyle(fontSize: 11))),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// Immunizations Tab
// =============================================================================

class _ImmunizationsTab extends StatelessWidget {
  final String patientId;
  final List<Map<String, dynamic>> immunizations;

  const _ImmunizationsTab({required this.patientId, required this.immunizations});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (immunizations.isEmpty) {
      return Center(
        child: Text('No immunizations recorded', style: TextStyle(color: colors.mutedForeground)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: immunizations.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final im = immunizations[index];
        final vaccineName = im['vaccineCode']?['coding']?.first?['display'] ?? im['vaccineCode']?['text'] ?? 'Vaccine';
        final occDate = im['occurrenceDateTime'] ?? '';
        final dateStr = occDate is String && occDate.isNotEmpty ? DateFormat('MMM d, yyyy').format(DateTime.parse(occDate)) : '';
        final status = im['status'] ?? '';

        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: colors.card, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: colors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(LucideIcons.syringe, size: 18, color: colors.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vaccineName,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.foreground),
                    ),
                    if (dateStr.isNotEmpty) Text(dateStr, style: TextStyle(fontSize: 12, color: colors.mutedForeground)),
                  ],
                ),
              ),
              if (status.isNotEmpty) PrimaryBadge(child: Text(status, style: const TextStyle(fontSize: 11))),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// Shared Widgets
// =============================================================================

class _VitalsSummaryRow extends StatelessWidget {
  final List<Map<String, dynamic>> vitals;
  const _VitalsSummaryRow({required this.vitals});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final latest = <String, Map<String, dynamic>>{};

    for (final v in vitals) {
      final code = v['code']?['coding']?.first?['code'] ?? '';
      if (code.isNotEmpty && !latest.containsKey(code)) {
        latest[code] = v;
      }
    }

    final summaryCards = <Widget>[];
    void _addCard(String code, IconData icon, String label, String unit) {
      final v = latest[code];
      if (v == null) return;
      final value = v['valueQuantity'];
      if (value == null) return;
      summaryCards.add(_MiniVitalCard(icon: icon, label: label, value: '${value['value']}', unit: unit, color: colors.primary));
    }

    _addCard('8480-6', LucideIcons.activity, 'Systolic', 'mmHg');
    _addCard('8462-4', LucideIcons.activity, 'Diastolic', 'mmHg');
    _addCard('8867-4', LucideIcons.heart, 'HR', 'bpm');
    _addCard('2708-6', LucideIcons.wind, 'SpO2', '%');
    _addCard('8310-5', LucideIcons.thermometer, 'Temp', '°C');
    _addCard('9279-1', LucideIcons.waves, 'RR', '/min');

    if (summaryCards.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: summaryCards.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (_, i) => summaryCards[i],
      ),
    );
  }
}

class _MiniVitalCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _MiniVitalCard({required this.icon, required this.label, required this.value, required this.unit, required this.color});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: colors.card, borderRadius: BorderRadius.circular(12), boxShadow: [SurfaceTheme.ambientShadow]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Text(label, style: TextStyle(fontSize: 10, color: colors.mutedForeground)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$value $unit',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: colors.foreground),
          ),
        ],
      ),
    );
  }
}

class _FhirCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FhirCard({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: colors.card, borderRadius: BorderRadius.circular(12), boxShadow: [SurfaceTheme.ambientShadow]),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.foreground),
                ),
                if (subtitle.isNotEmpty) Text(subtitle, style: TextStyle(fontSize: 12, color: colors.mutedForeground)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EncounterCard extends StatelessWidget {
  final Map<String, dynamic> encounter;

  const _EncounterCard({required this.encounter});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final status = encounter['status'] ?? '';
    final classDisplay = encounter['class']?['display'] ?? encounter['class']?['code'] ?? 'OPD';
    final period = encounter['period'];
    final dateStr = period != null && period['start'] != null
        ? DateFormat('MMM d, yyyy').format(DateTime.parse(period['start'] as String))
        : '';
    final diagnosisList = encounter['diagnosis'] as List? ?? [];
    final diagnoses = diagnosisList.map((d) => d['condition']?['display'] ?? '').where((s) => s.isNotEmpty).join(', ');

    final encId = encounter['id'] as String? ?? '';

    return GestureDetector(
      onTap: encId.isNotEmpty ? () => context.push('/clinical/workspace/$encId') : null,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(color: colors.card, borderRadius: BorderRadius.circular(12), boxShadow: [SurfaceTheme.ambientShadow]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: status == 'finished'
                        ? colors.success
                        : status == 'in-progress'
                        ? colors.warning
                        : colors.mutedForeground,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  classDisplay,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: colors.foreground),
                ),
                const Spacer(),
                if (dateStr.isNotEmpty) Text(dateStr, style: TextStyle(fontSize: 11, color: colors.mutedForeground)),
              ],
            ),
            if (diagnoses.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                diagnoses,
                style: TextStyle(fontSize: 12, color: colors.mutedForeground),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
