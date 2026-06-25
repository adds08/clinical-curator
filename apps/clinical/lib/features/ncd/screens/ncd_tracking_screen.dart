import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/fhir_resource_collection.dart';
import '../../../domain/providers/ncd_provider.dart';

class NcdTrackingScreen extends ConsumerStatefulWidget {
  final String patientId;

  const NcdTrackingScreen({super.key, required this.patientId});

  @override
  ConsumerState<NcdTrackingScreen> createState() => _NcdTrackingScreenState();
}

class _NcdTrackingScreenState extends ConsumerState<NcdTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final patientRef = 'Patient/${widget.patientId}';
    final conditions = ref.watch(ncdConditionsProvider(patientRef));
    final bpReadings = ref.watch(ncdBpReadingsProvider(patientRef));

    final ncdList = conditions.map((r) {
      try {
        return jsonDecode(r.jsonData) as Map<String, dynamic>;
      } catch (_) {
        return <String, dynamic>{};
      }
    }).toList();

    return Scaffold(
      headers: [
        AppBar(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          backgroundColor: colors.background,
          leading: [
            IconButton.ghost(icon: const Icon(LucideIcons.arrowLeft, size: 22), onPressed: () => GoRouter.of(context).pop()),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'NCD Tracking',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.foreground),
                  ),
                  Text('Patient: ${widget.patientId}', style: TextStyle(fontSize: 12, color: colors.mutedForeground)),
                ],
              ),
            ),
          ],
        ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Blood Pressure Readings',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: colors.foreground),
            ),
            const SizedBox(height: AppSpacing.md),
            if (bpReadings.isEmpty)
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(color: colors.card, borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text('No BP readings recorded', style: TextStyle(color: colors.mutedForeground)),
                ),
              )
            else
              ...bpReadings.reversed.take(20).map((r) {
                String systolic = '', diastolic = '', dateStr = '';
                try {
                  final json = jsonDecode(r.jsonData) as Map<String, dynamic>;
                  final comps = json['component'] as List? ?? [];
                  for (final c in comps) {
                    final code = c['code']?['coding']?.first?['code'] ?? '';
                    final val = c['valueQuantity']?['value'];
                    if (code == '8480-6' && val != null) systolic = val.toString();
                    if (code == '8462-4' && val != null) diastolic = val.toString();
                    if (systolic.isNotEmpty && diastolic.isNotEmpty) break;
                  }
                  final dt = json['effectiveDateTime'] as String? ?? '';
                  if (dt.isNotEmpty) dateStr = DateFormat('MMM d, yyyy').format(DateTime.parse(dt));
                } catch (_) {}
                if (systolic.isEmpty && diastolic.isEmpty) return const SizedBox.shrink();
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(color: colors.card, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Icon(LucideIcons.activity, size: 18, color: colors.primary),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$systolic / $diastolic mmHg',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: colors.foreground),
                            ),
                            if (dateStr.isNotEmpty) Text(dateStr, style: TextStyle(fontSize: 12, color: colors.mutedForeground)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),

            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Active Conditions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: colors.foreground),
            ),
            const SizedBox(height: AppSpacing.md),
            if (ncdList.isEmpty)
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(color: colors.card, borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text('No conditions recorded', style: TextStyle(color: colors.mutedForeground)),
                ),
              )
            else
              ...ncdList.map((c) {
                final display = c['code']?['coding']?.first?['display'] ?? c['code']?['text'] ?? 'Condition';
                final status = c['clinicalStatus']?['coding']?.first?['code'] ?? 'unknown';
                final isActive = status == 'active';
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(color: colors.card, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: isActive ? colors.success : colors.mutedForeground),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          display,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.foreground),
                        ),
                      ),
                      PrimaryBadge(child: Text(status, style: const TextStyle(fontSize: 10))),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
