import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_fhir_models/collections/encounter_collection.dart';
import '../../../domain/providers/condition_provider.dart';
import '../../../domain/providers/procedure_provider.dart';
import '../../../domain/providers/service_request_provider.dart';
import 'package:cc_core/widgets/sub_page_scaffold.dart';

class EncounterSummaryScreen extends ConsumerWidget {
  final String encounterId;

  const EncounterSummaryScreen({super.key, required this.encounterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final dateFormat = DateFormat('MMM d, yyyy HH:mm');

    EncounterLocal? encounter;
    final box = DatabaseService.encounters;
    try {
      encounter =
          box.values.firstWhere((e) => e.fhirId == encounterId);
    } catch (_) {}

    if (encounter == null) {
      return SubPageScaffold(
        title: 'Encounter Summary',
        child: Center(
          child: Text('Encounter not found',
              style: TextStyle(color: colors.mutedForeground)),
        ),
      );
    }

    final encRef = 'Encounter/${encounter.fhirId}';
    final conditions =
        ref.watch(allConditionsProvider(encounter.patientRef));
    final procedures = ref.watch(proceduresByEncounterProvider(encRef));
    final orders = ref.watch(ordersByEncounterProvider(encRef));

    final statusColor = switch (encounter.status) {
      'finished' => colors.success,
      'in-progress' => colors.warning,
      'cancelled' => colors.destructive,
      _ => colors.mutedForeground,
    };

    return SubPageScaffold(
      title: 'Encounter Summary',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: AppRadius.chipRadius,
              ),
              child: Text(
                encounter.status.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Visit details
            _SectionCard(
              title: 'Visit Details',
              children: [
                _DetailRow(
                    label: 'Patient', value: encounter.patientName ?? '—'),
                _DetailRow(
                    label: 'Provider',
                    value: encounter.practitionerName ?? '—'),
                _DetailRow(
                    label: 'Type',
                    value: switch (encounter.classCode) {
                      'AMB' => 'Ambulatory',
                      'EMER' => 'Emergency',
                      'IMP' => 'Inpatient',
                      _ => encounter.classCode,
                    }),
                _DetailRow(
                    label: 'Started',
                    value: dateFormat.format(encounter.startDate)),
                if (encounter.endDate != null)
                  _DetailRow(
                      label: 'Ended',
                      value: dateFormat.format(encounter.endDate!)),
                if (encounter.serviceType != null)
                  _DetailRow(
                      label: 'Service', value: encounter.serviceType!),
              ],
            ),

            if (conditions.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xxl),
              _SectionCard(
                title: 'Conditions (${conditions.length})',
                children: conditions
                    .map((c) => _DetailRow(
                        label: c.displayName,
                        value: c.clinicalStatus))
                    .toList(),
              ),
            ],

            if (procedures.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xxl),
              _SectionCard(
                title: 'Procedures (${procedures.length})',
                children: procedures
                    .map((p) =>
                        _DetailRow(label: p.displayName, value: p.status))
                    .toList(),
              ),
            ],

            if (orders.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xxl),
              _SectionCard(
                title: 'Orders (${orders.length})',
                children: orders
                    .map((o) => _DetailRow(
                        label: o.displayName,
                        value:
                            '${o.category ?? "order"} · ${o.status}'))
                    .toList(),
              ),
            ],

            if (encounter.notes != null &&
                encounter.notes!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xxl),
              _SectionCard(
                title: 'Clinical Notes',
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Text(
                      encounter.notes!,
                      style: TextStyle(
                          fontSize: 13, color: colors.foreground, height: 1.5),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

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

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: TextStyle(
                    fontSize: 13, color: colors.mutedForeground)),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colors.foreground)),
          ),
        ],
      ),
    );
  }
}
