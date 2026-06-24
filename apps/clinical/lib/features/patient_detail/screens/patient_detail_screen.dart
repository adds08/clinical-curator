import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_core/router/route_names.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_fhir_models/collections/appointment_collection.dart';
import 'package:cc_fhir_models/collections/fhir_resource_collection.dart';
import '../../../domain/providers/auth_provider.dart';
import '../../../domain/providers/patient_data_provider.dart';
import '../../../domain/services/audit_logger.dart';
import 'package:cc_core/widgets/sub_page_scaffold.dart';
import 'package:cc_rbac/can.dart';
import 'package:cc_core/theme/clinical_colors.dart';

class PatientDetailScreen extends ConsumerWidget {
  final String patientId;

  const PatientDetailScreen({
    super.key,
    required this.patientId,
  });

  // Guards duplicate data-access audits when the widget rebuilds for
  // unrelated state. Reset on hot restart / process launch.
  static final Set<String> _auditedThisSession = <String>{};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientRef = 'Patient/$patientId';

    // Fire a one-per-session FHIR data-access audit the first time a
    // clinician lands on a patient's detail screen.
    if (_auditedThisSession.add(patientRef)) {
      final agent = ref.read(authProvider).user;
      if (agent != null && agent.isPractitioner) {
        AuditLogger.dataAccessed(
          entityRef: patientRef,
          entityType: 'Patient',
          agentRef:
              'Practitioner/${agent.fhirPractitionerId ?? agent.email}',
          agentName: agent.displayName,
          agentRole: agent.practitionerType,
        );
      }
    }

    // Pre-load real patient data from FHIR providers
    final patientVitals = ref.watch(patientVitalsProvider(patientRef));
    final patientLabs = ref.watch(patientLabsProvider(patientRef));
    final patientMeds = ref.watch(patientMedicationsProvider(patientRef));
    final patientAllergies = ref.watch(patientAllergiesProvider(patientRef));
    final patientImmunizations = ref.watch(patientImmunizationsProvider(patientRef));

    // Derive latest weight / height from vitals (LOINC 29463-7 weight, 8302-2 height)
    final latestWeight = _latestObsValue(patientVitals, '29463-7');
    final latestHeight = _latestObsValue(patientVitals, '8302-2');

    // Resolve patient from FHIR provider
    final fhirPatient = ref.watch(patientFhirProvider(patientRef));
    String patientName = 'Patient';
    String patientInitials = 'P';
    if (fhirPatient != null) {
      patientName = fhirPatient.name?.firstOrNull?.text ??
          '${fhirPatient.name?.firstOrNull?.given?.join(' ') ?? ''} ${fhirPatient.name?.firstOrNull?.family ?? ''}'.trim();
      if (patientName.isEmpty) patientName = 'Patient';
      final parts = patientName.split(' ').where((p) => p.isNotEmpty).toList();
      patientInitials = parts.length >= 2
          ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
          : (parts.isNotEmpty ? parts[0][0].toUpperCase() : 'P');
    }

    // Real appointment data
    final nextAppt = ref.watch(patientNextAppointmentProvider(patientRef));
    final upcomingAppts = ref.watch(patientUpcomingAppointmentsProvider(patientRef));
    final pastAppts = ref.watch(patientPastAppointmentsProvider(patientRef));

    // Registration date & practitioner name
    final registrationDate = ref.watch(patientRegistrationDateProvider(patientRef));
    final user = ref.watch(authProvider).user;
    final practitionerName = user?.displayName ?? 'Unassigned';

    return SubPageScaffold(
      title: 'Patient Detail',
      child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile
                    _buildProfileSection(
                      context,
                      patientName,
                      patientInitials,
                      registrationDate: registrationDate,
                      nextAppointment: nextAppt,
                      practitionerName: practitionerName,
                      weightLabel: latestWeight,
                      heightLabel: latestHeight,
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Allergy Alert
                    _buildAllergyAlert(context, patientAllergies),
                    const SizedBox(height: AppSpacing.xxl),

                    // Vitals Trendline
                    _buildVitalsTrendline(context, patientVitals),
                    const SizedBox(height: AppSpacing.xxl),

                    // Lab Results
                    _buildLabResults(context, patientLabs),
                    const SizedBox(height: AppSpacing.xxl),

                    // Active Medications
                    _buildActiveMedications(context, patientMeds),
                    const SizedBox(height: AppSpacing.xxl),

                    // Immunizations
                    _buildImmunizations(context, patientImmunizations),
                    const SizedBox(height: AppSpacing.xxl),

                    // Visit Timeline
                    _buildVisitTimeline(context, upcomingAppts, pastAppts),
                    const SizedBox(height: AppSpacing.xxl),

                    // Clinical Actions
                    _buildClinicalActions(context, ref, patientRef, patientName),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
    );
  }

  // ---------------------------------------------------------------------------
  // Profile Section
  // ---------------------------------------------------------------------------
  Widget _buildProfileSection(
    BuildContext context,
    String name,
    String initials, {
    DateTime? registrationDate,
    AppointmentLocal? nextAppointment,
    String? practitionerName,
    String? weightLabel,
    String? heightLabel,
  }) {
    final colors = Theme.of(context).colorScheme;
    final regText = registrationDate != null
        ? DateFormat('MMM d, yyyy').format(registrationDate)
        : 'Unknown';
    final nextText = nextAppointment != null
        ? DateFormat('MMM d, yyyy  •  hh:mm a').format(nextAppointment.scheduledAt)
        : null;

    return Card(
      padding: const EdgeInsets.all(AppSpacing.xl),
      fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
      borderRadius: AppRadius.cardRadius,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(initials: initials, size: 64),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: colors.foreground,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                if (weightLabel != null || heightLabel != null) ...[
                  Row(
                    children: [
                      if (weightLabel != null)
                        _buildInfoChip(context, LucideIcons.scale, weightLabel),
                      if (weightLabel != null && heightLabel != null)
                        const SizedBox(width: AppSpacing.sm),
                      if (heightLabel != null)
                        _buildInfoChip(context, LucideIcons.ruler, heightLabel),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                _buildProfileInfoRow(
                  context,
                  LucideIcons.calendar,
                  'Registered: $regText',
                ),
                const SizedBox(height: 4),
                _buildProfileInfoRow(
                  context,
                  LucideIcons.calendar,
                  nextText != null ? 'Next visit: $nextText' : 'No upcoming visits',
                  highlight: nextText != null,
                ),
                const SizedBox(height: 4),
                _buildProfileInfoRow(
                  context,
                  LucideIcons.briefcaseMedical,
                  practitionerName ?? 'Unassigned',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoRow(BuildContext context, IconData icon, String text, {bool highlight = false}) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 14, color: highlight ? colors.primary : colors.mutedForeground),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: highlight ? colors.primary : colors.mutedForeground,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String text) {
      final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: SurfaceTheme.colorFor(SurfaceLevel.low, context),
        borderRadius: AppRadius.chipRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: colors.mutedForeground),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colors.foreground,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Allergy Alert
  // ---------------------------------------------------------------------------
  Widget _buildAllergyAlert(BuildContext context, List<fhir.AllergyIntolerance> allergies) {
    final colors = Theme.of(context).colorScheme;
    if (allergies.isEmpty) {
      return _buildEmptyStateCard(
        context,
        icon: LucideIcons.shieldCheck,
        message: 'No allergies on record',
      );
    }

    final primary = allergies.first;
    final name = primary.code?.coding?.firstOrNull?.display ??
        primary.code?.text ??
        'Unknown allergen';
    final reactions = primary.reaction
            ?.map((r) => r.manifestation
                .map((m) => m.text ?? m.coding?.firstOrNull?.display ?? '')
                .where((s) => s.isNotEmpty)
                .join(', '))
            .where((s) => s.isNotEmpty)
            .join('; ') ??
        '';
    final notes = primary.note?.map((n) => n.text?.value ?? '').where((s) => s.isNotEmpty).join(' • ') ?? '';
    final subtitle = [reactions, notes].where((s) => s.isNotEmpty).join(' — ');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: AppRadius.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.triangleAlert, color: colors.primaryForeground, size: 22),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  allergies.length > 1 ? '$name  (+${allergies.length - 1} more)' : name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: colors.primaryForeground,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.primaryForeground,
                  borderRadius: AppRadius.chipRadius,
                ),
                child: Text(
                  'ALLERGY ALERT',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: colors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: colors.primaryForeground.withValues(alpha: 0.85),
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyStateCard(BuildContext context, {required IconData icon, required String message}) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      padding: const EdgeInsets.all(AppSpacing.xl),
      fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
      borderRadius: AppRadius.cardRadius,
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 28, color: colors.mutedForeground.withValues(alpha: 0.5)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.mutedForeground),
            ),
          ],
        ),
      ),
    );
  }

  // Returns the latest value string for an Observation identified by LOINC code,
  // formatted as "<value> <unit>" (e.g. "68.4 kg"). Null when no data.
  static String? _latestObsValue(List<fhir.Observation> vitals, String loinc) {
    final matches = vitals.where((o) =>
        o.code.coding?.any((c) => c.code?.value == loinc) ?? false).toList();
    if (matches.isEmpty) return null;
    matches.sort((a, b) {
      final aD = a.effectiveDateTime?.value;
      final bD = b.effectiveDateTime?.value;
      if (aD == null && bD == null) return 0;
      if (aD == null) return 1;
      if (bD == null) return -1;
      return bD.compareTo(aD);
    });
    final q = matches.first.valueQuantity;
    final v = q?.value?.value;
    if (v == null) return null;
    final display = v == v.roundToDouble() ? v.toInt().toString() : v.toString();
    final unit = q?.unit ?? '';
    return unit.isEmpty ? display : '$display $unit';
  }

  // ---------------------------------------------------------------------------
  // Vitals Trendline
  // ---------------------------------------------------------------------------
  Widget _buildVitalsTrendline(BuildContext context, List<fhir.Observation> vitals) {
    final colors = Theme.of(context).colorScheme;

    // Collect series from real observations.
    final systolic = <DateTime, double>{};
    final diastolic = <DateTime, double>{};
    final heartRate = <DateTime, double>{};

    for (final obs in vitals) {
      final date = obs.effectiveDateTime?.value;
      if (date == null) continue;
      final isBP = obs.code.coding?.any((c) => c.code?.value == '85354-9') ?? false;
      final isHR = obs.code.coding?.any((c) => c.code?.value == '8867-4') ?? false;
      if (isBP) {
        for (final comp in obs.component ?? []) {
          final sys = comp.code.coding?.any((c) => c.code?.value == '8480-6') ?? false;
          final dia = comp.code.coding?.any((c) => c.code?.value == '8462-4') ?? false;
          final v = comp.valueQuantity?.value?.value;
          if (v == null) continue;
          if (sys) systolic[date] = v;
          if (dia) diastolic[date] = v;
        }
      } else if (isHR) {
        final v = obs.valueQuantity?.value?.value;
        if (v != null) heartRate[date] = v;
      }
    }

    final hasAny = systolic.isNotEmpty || diastolic.isNotEmpty || heartRate.isNotEmpty;
    // Sparse = at least one data point exists but no series has ≥2 points,
    // so we can't draw a trendline yet (a lone dot is misleading).
    final hasTrend = systolic.length >= 2 || diastolic.length >= 2 || heartRate.length >= 2;
    final isSparse = hasAny && !hasTrend;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vitals Trendline',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: colors.foreground,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Recorded BP & Heart Rate',
          style: TextStyle(
            fontSize: 12,
            color: colors.mutedForeground,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (!hasAny)
          _buildEmptyStateCard(
            context,
            icon: LucideIcons.heartPulse,
            message: 'No vitals recorded',
          )
        else if (isSparse)
          _buildEmptyStateCard(
            context,
            icon: LucideIcons.trendingUp,
            message: 'Add at least 2 vitals to see a trend',
          )
        else
        Card(
          padding: const EdgeInsets.all(AppSpacing.lg),
          fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
          borderRadius: AppRadius.cardRadius,
          child: SizedBox(
            height: 160,
            child: Column(
              children: [
                // Legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendDot(context, colors.primary, 'Systolic BP'),
                    const SizedBox(width: AppSpacing.lg),
                    _buildLegendDot(context, colors.destructive, 'Heart Rate'),
                    const SizedBox(width: AppSpacing.lg),
                    _buildLegendDot(context, colors.success, 'Diastolic BP'),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Chart with custom paint
                Expanded(
                  child: CustomPaint(
                    painter: _VitalsTrendPainter(
                      primaryColor: colors.primary,
                      destructiveColor: colors.destructive,
                      successColor: colors.success,
                      borderColor: colors.border,
                      systolicSeries: _seriesFrom(systolic),
                      diastolicSeries: _seriesFrom(diastolic),
                      heartRateSeries: _seriesFrom(heartRate),
                    ),
                    size: Size.infinite,
                  ),
                ),

                // X-axis labels (month of first/last observation)
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _buildAxisLabels(context, systolic, diastolic, heartRate),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Converts a date->value map into an ascending-by-date list of values.
  static List<double> _seriesFrom(Map<DateTime, double> map) {
    final entries = map.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    return entries.map((e) => e.value).toList();
  }

  List<Widget> _buildAxisLabels(
    BuildContext context,
    Map<DateTime, double> s,
    Map<DateTime, double> d,
    Map<DateTime, double> hr,
  ) {
    final colors = Theme.of(context).colorScheme;
    final allDates = <DateTime>[...s.keys, ...d.keys, ...hr.keys]..sort();
    if (allDates.isEmpty) return const [];
    final first = allDates.first;
    final last = allDates.last;
    final fmt = DateFormat('MMM d');
    final labels = first == last
        ? [fmt.format(first)]
        : [fmt.format(first), fmt.format(last)];
    return labels
        .map((t) => Text(t, style: TextStyle(fontSize: 9, color: colors.mutedForeground)))
        .toList();
  }

  Widget _buildLegendDot(BuildContext context, Color color, String label) {
      final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: colors.mutedForeground,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Lab Results
  // ---------------------------------------------------------------------------
  Widget _buildLabResults(BuildContext context, List<fhir.DiagnosticReport> labs) {
    final colors = Theme.of(context).colorScheme;

    final sorted = [...labs]..sort((a, b) {
      final aD = a.effectiveDateTime?.value ?? a.issued?.value;
      final bD = b.effectiveDateTime?.value ?? b.issued?.value;
      if (aD == null && bD == null) return 0;
      if (aD == null) return 1;
      if (bD == null) return -1;
      return bD.compareTo(aD);
    });
    final recent = sorted.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lab Results',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: colors.foreground,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (recent.isEmpty)
          _buildEmptyStateCard(
            context,
            icon: LucideIcons.flaskConical,
            message: 'No lab reports',
          )
        else
          for (int i = 0; i < recent.length; i++) ...[
            _buildLabResultItem(
              context,
              testName: recent[i].code.coding?.firstOrNull?.display ??
                  recent[i].code.text ??
                  'Lab report',
              value: recent[i].conclusion ?? '',
              status: 'FINAL',
              statusColor: colors.primary,
              date: recent[i].effectiveDateTime?.value != null
                  ? DateFormat('d MMM yyyy').format(recent[i].effectiveDateTime!.value)
                  : (recent[i].issued?.value != null
                      ? DateFormat('d MMM yyyy').format(recent[i].issued!.value)
                      : ''),
            ),
            if (i < recent.length - 1) const SizedBox(height: AppSpacing.md),
          ],
      ],
    );
  }

  Widget _buildLabResultItem(BuildContext context, {
    required String testName,
    required String value,
    required String status,
    required Color statusColor,
    required String date,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
      borderRadius: AppRadius.cardRadius,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.08),
              borderRadius: AppRadius.inputRadius,
            ),
            child: Icon(LucideIcons.flaskConical, color: statusColor, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  testName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colors.foreground,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  [value, date].where((s) => s.isNotEmpty).join('  •  '),
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          if (status == 'HIGH')
            DestructiveBadge(
              child: Text(
                status,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            PrimaryBadge(
              child: Text(
                status,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Active Medications
  // ---------------------------------------------------------------------------
  Widget _buildActiveMedications(BuildContext context, List<fhir.MedicationRequest> meds) {
    final colors = Theme.of(context).colorScheme;

    final active = meds
        .where((m) => (m.status?.value ?? 'active') == 'active')
        .toList()
      ..sort((a, b) {
        final aD = a.authoredOn?.value;
        final bD = b.authoredOn?.value;
        if (aD == null && bD == null) return 0;
        if (aD == null) return 1;
        if (bD == null) return -1;
        return bD.compareTo(aD);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Medications',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: colors.foreground,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (active.isEmpty)
          _buildEmptyStateCard(
            context,
            icon: LucideIcons.pill,
            message: 'No medications',
          )
        else
          for (int i = 0; i < active.length; i++) ...[
            _buildMedicationItem(
              context,
              name: active[i].medicationCodeableConcept?.coding?.firstOrNull?.display ??
                  active[i].medicationCodeableConcept?.text ??
                  'Medication',
              dosage: active[i].dosageInstruction?.isNotEmpty == true
                  ? (active[i].dosageInstruction!.first.text ?? '')
                  : '',
              prescriber: active[i].requester?.display ?? '',
            ),
            if (i < active.length - 1) const SizedBox(height: AppSpacing.md),
          ],
      ],
    );
  }

  Widget _buildMedicationItem(BuildContext context, {
    required String name,
    required String dosage,
    required String prescriber,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
      borderRadius: AppRadius.cardRadius,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.08),
              borderRadius: AppRadius.inputRadius,
            ),
            child: Icon(
              LucideIcons.pill,
              color: colors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colors.foreground,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  [dosage, prescriber].where((s) => s.isNotEmpty).join('  •  '),
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          const PrimaryBadge(
            child: Text(
              'ACTIVE',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Immunizations
  // ---------------------------------------------------------------------------
  Widget _buildImmunizations(
      BuildContext context, List<fhir.Immunization> immunizations) {
    final colors = Theme.of(context).colorScheme;

    final sorted = [...immunizations]
      ..sort((a, b) {
        final aD = a.occurrenceDateTime?.value;
        final bD = b.occurrenceDateTime?.value;
        if (aD == null && bD == null) return 0;
        if (aD == null) return 1;
        if (bD == null) return -1;
        return bD.compareTo(aD);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Immunizations',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: colors.foreground,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (sorted.isEmpty)
          _buildEmptyStateCard(
            context,
            icon: LucideIcons.syringe,
            message: 'No immunizations on record',
          )
        else
          for (int i = 0; i < sorted.length; i++) ...[
            _buildImmunizationItem(
              context,
              name: sorted[i].vaccineCode.coding?.firstOrNull?.display ??
                  sorted[i].vaccineCode.text ??
                  'Vaccine',
              date: sorted[i].occurrenceDateTime?.value,
              status: sorted[i].status?.value ?? 'completed',
            ),
            if (i < sorted.length - 1) const SizedBox(height: AppSpacing.md),
          ],
      ],
    );
  }

  Widget _buildImmunizationItem(
    BuildContext context, {
    required String name,
    required DateTime? date,
    required String status,
  }) {
    final colors = Theme.of(context).colorScheme;
    final dateLabel = date != null
        ? DateFormat('MMM d, yyyy').format(date)
        : 'Date unknown';
    return Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
      borderRadius: AppRadius.cardRadius,
      child: Basic(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colors.warning.withValues(alpha: 0.12),
            borderRadius: AppRadius.inputRadius,
          ),
          child: Icon(LucideIcons.syringe, color: colors.warning, size: 18),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: colors.foreground,
          ),
        ),
        subtitle: Text(
          dateLabel,
          style: TextStyle(
            fontSize: 11,
            color: colors.mutedForeground,
          ),
        ),
        trailing: SecondaryBadge(
          child: Text(
            status.toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Visit Timeline
  // ---------------------------------------------------------------------------
  Widget _buildVisitTimeline(
    BuildContext context,
    List<AppointmentLocal> upcoming,
    List<AppointmentLocal> past,
  ) {
    final colors = Theme.of(context).colorScheme;
    final hasAny = upcoming.isNotEmpty || past.isNotEmpty;

    // Build merged list: up to 1 upcoming + up to 3 past
    final nextAppt = upcoming.isNotEmpty ? upcoming.first : null;
    final recentPast = past.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Visit Timeline',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.foreground,
              ),
            ),
            if (hasAny)
              GhostButton(
                density: ButtonDensity.compact,
                onPressed: () {
                  showToast(
                    context: context,
                    builder: (ctx, overlay) => SurfaceCard(
                      child: Basic(
                        title: const Text('Loading visit history...'),
                      ),
                    ),
                    location: ToastLocation.bottomRight,
                  );
                },
                child: Text(
                  'View Full History',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colors.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (!hasAny)
          Card(
            padding: const EdgeInsets.all(AppSpacing.xl),
            fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
            borderRadius: AppRadius.cardRadius,
            child: Center(
              child: Column(
                children: [
                  Icon(LucideIcons.calendarX, size: 32, color: colors.mutedForeground.withValues(alpha: 0.5)),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'No visit history yet',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.mutedForeground),
                  ),
                ],
              ),
            ),
          )
        else ...[
          if (nextAppt != null)
            _buildTimelineEntry(
              context: context,
              isNext: true,
              icon: _appointmentIcon(nextAppt.appointmentType),
              iconColor: colors.primary,
              title: nextAppt.specialty?.isNotEmpty == true
                  ? nextAppt.specialty!
                  : _appointmentLabel(nextAppt.appointmentType),
              date: DateFormat('MMM d, yyyy  •  hh:mm a').format(nextAppt.scheduledAt),
              description: nextAppt.notes,
              badge: nextAppt.appointmentType.toUpperCase(),
              isLast: recentPast.isEmpty,
            ),
          for (int i = 0; i < recentPast.length; i++)
            _buildTimelineEntry(
              context: context,
              icon: _appointmentIcon(recentPast[i].appointmentType),
              iconColor: recentPast[i].status == 'completed'
                  ? colors.success
                  : colors.mutedForeground,
              title: recentPast[i].specialty?.isNotEmpty == true
                  ? recentPast[i].specialty!
                  : _appointmentLabel(recentPast[i].appointmentType),
              date: DateFormat('MMM d, yyyy').format(recentPast[i].scheduledAt),
              description: recentPast[i].notes,
              badge: recentPast[i].status == 'completed' ? 'COMPLETED' : null,
              isLast: i == recentPast.length - 1,
            ),
        ],
      ],
    );
  }

  IconData _appointmentIcon(String type) {
    switch (type) {
      case 'opd':
        return LucideIcons.user;
      case 'telemedicine':
        return LucideIcons.video;
      default:
        return LucideIcons.hospital;
    }
  }

  String _appointmentLabel(String type) {
    switch (type) {
      case 'opd':
        return 'OPD Consultation';
      case 'telemedicine':
        return 'Telemedicine Visit';
      default:
        return 'Appointment';
    }
  }

  Widget _buildTimelineEntry({
    required BuildContext context,
    required String title,
    required String date,
    required IconData icon,
    required Color iconColor,
    String? description,
    String? badge,
    bool isNext = false,
    bool isLast = false,
  }) {
    final colors = Theme.of(context).colorScheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline rail: icon + connecting line
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 16, color: iconColor),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.border.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Content card
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: badge/next indicator + date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (isNext)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'NEXT VISIT',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: colors.primary, letterSpacing: 0.3),
                          ),
                        )
                      else if (badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: colors.primary),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      Text(
                        date,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: colors.mutedForeground),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Title
                  Text(
                    title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: colors.foreground, height: 1.2),
                  ),

                  if (badge != null && !isNext) ...[
                    const SizedBox(height: 4),
                    Text(badge, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: colors.mutedForeground)),
                  ],

                  if (description != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: colors.muted.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        description,
                        style: TextStyle(fontSize: 12, color: colors.mutedForeground, height: 1.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Action Buttons
  // ---------------------------------------------------------------------------
  Widget _buildClinicalActions(BuildContext context, WidgetRef ref, String patientRef, String patientName) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Clinical Actions',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.foreground)),
        const SizedBox(height: AppSpacing.lg),

        // Primary action — Start Checkup
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            density: ButtonDensity.normal,
            onPressed: () => _openCheckupSheet(context, ref, patientRef, patientName),
            leading: const Icon(LucideIcons.briefcaseMedical, size: 20),
            child: const Text('Start Checkup',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Secondary actions — responsive Wrap
        LayoutBuilder(
          builder: (context, constraints) {
            final tileWidth = (constraints.maxWidth - 10) / 2;
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                Can(
                  permission: 'order.lab',
                  child: _ActionTile(
                    icon: LucideIcons.flaskConical,
                    label: 'Lab Report',
                    color: colors.primary,
                    width: tileWidth,
                    onTap: () => _openLabReportDrawer(context, ref, patientRef, patientName),
                  ),
                ),
                _ActionTile(
                  icon: LucideIcons.clipboardList,
                  label: 'Diagnosis',
                  color: colors.warning,
                  width: tileWidth,
                  onTap: () => _openDiagnosisDrawer(context, ref, patientRef, patientName),
                ),
                Can(
                  permission: 'prescription.issue',
                  child: _ActionTile(
                    icon: LucideIcons.pill,
                    label: 'Prescription',
                    color: colors.success,
                    width: tileWidth,
                    onTap: () => _openPrescriptionDrawer(context, ref, patientRef, patientName),
                  ),
                ),
                _ActionTile(
                  icon: LucideIcons.heartPulse,
                  label: 'Vitals',
                  color: colors.destructive,
                  width: tileWidth,
                  onTap: () => _openVitalsDrawer(context, ref, patientRef, patientName),
                ),
                _ActionTile(
                  icon: LucideIcons.filePlus,
                  label: 'Clinical Note',
                  color: const Color(0xFF7C3AED),
                  width: tileWidth,
                  onTap: () => _openClinicalNoteDrawer(context, ref, patientRef, patientName),
                ),
                _ActionTile(
                  icon: LucideIcons.fileText,
                  label: 'Export PDF',
                  color: colors.mutedForeground,
                  width: tileWidth,
                  onTap: () {
                    showToast(
                      context: context,
                      builder: (ctx, overlay) => SurfaceCard(
                        child: Basic(
                          title: const Text('Exporting PDF report...'),
                          leading: const Icon(LucideIcons.fileText, size: 18),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _openCheckupSheet(BuildContext context, WidgetRef ref, String patientRef, String patientName) {
    final colors = Theme.of(context).colorScheme;
    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (ctx) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Checkup', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.foreground)),
            const SizedBox(height: 4),
            Text('Patient: $patientName', style: TextStyle(fontSize: 13, color: colors.mutedForeground)),
            const SizedBox(height: 20),
            _CheckupActionRow(
              icon: LucideIcons.heartPulse,
              label: 'Record Vitals',
              subtitle: 'BP, Heart Rate, Temp, SpO\u2082',
              color: colors.destructive,
              onTap: () { closeDrawer(ctx); WidgetsBinding.instance.addPostFrameCallback((_) { if (context.mounted) _openVitalsDrawer(context, ref, patientRef, patientName); }); },
            ),
            const SizedBox(height: 10),
            _CheckupActionRow(
              icon: LucideIcons.filePlus,
              label: 'Clinical Note (SOAP)',
              subtitle: 'Subjective, Objective, Assessment, Plan',
              color: const Color(0xFF7C3AED),
              onTap: () { closeDrawer(ctx); WidgetsBinding.instance.addPostFrameCallback((_) { if (context.mounted) _openClinicalNoteDrawer(context, ref, patientRef, patientName); }); },
            ),
            const SizedBox(height: 10),
            _CheckupActionRow(
              icon: LucideIcons.clipboardList,
              label: 'Add Diagnosis',
              subtitle: 'ICD-10 code and clinical notes',
              color: colors.warning,
              onTap: () { closeDrawer(ctx); WidgetsBinding.instance.addPostFrameCallback((_) { if (context.mounted) _openDiagnosisDrawer(context, ref, patientRef, patientName); }); },
            ),
            const SizedBox(height: 10),
            _CheckupActionRow(
              icon: LucideIcons.pill,
              label: 'Prescribe Medication',
              subtitle: 'E-Prescribe with dosage instructions',
              color: colors.success,
              onTap: () { closeDrawer(ctx); WidgetsBinding.instance.addPostFrameCallback((_) { if (context.mounted) _openPrescriptionDrawer(context, ref, patientRef, patientName); }); },
            ),
            const SizedBox(height: 10),
            _CheckupActionRow(
              icon: LucideIcons.flaskConical,
              label: 'Order Lab Test',
              subtitle: 'Request diagnostic report',
              color: colors.primary,
              onTap: () { closeDrawer(ctx); WidgetsBinding.instance.addPostFrameCallback((_) { if (context.mounted) _openLabReportDrawer(context, ref, patientRef, patientName); }); },
            ),
            const SizedBox(height: 20),
            Divider(color: colors.border),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlineButton(
                onPressed: () {
                  closeDrawer(ctx);
                  context.push(RouteNames.clinicalStartEncounter);
                },
                leading: const Icon(LucideIcons.externalLink, size: 16),
                child: const Text('Start Full Encounter'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openLabReportDrawer(BuildContext context, WidgetRef ref, String patientRef, String patientName) {
    final colors = Theme.of(context).colorScheme;
    final testNameCtrl = TextEditingController();
    final resultCtrl = TextEditingController();
    final conclusionCtrl = TextEditingController();

    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (ctx) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Lab Report', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.foreground)),
            const SizedBox(height: 4),
            Text('Patient: $patientName', style: TextStyle(fontSize: 13, color: colors.mutedForeground)),
            const SizedBox(height: 20),
            TextField(controller: testNameCtrl, placeholder: const Text('Test name (e.g. Full Lipid Panel)')),
            const SizedBox(height: 12),
            TextField(controller: resultCtrl, placeholder: const Text('Key result value (e.g. LDL 142 mg/dL)')),
            const SizedBox(height: 12),
            TextField(controller: conclusionCtrl, placeholder: const Text('Conclusion / Interpretation...'), maxLines: 3),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: () async {
                  final testName = testNameCtrl.text.trim();
                  if (testName.isEmpty) { closeDrawer(ctx); return; }
                  final now = DateTime.now();
                  final id = 'diag-${now.millisecondsSinceEpoch}';

                  final report = fhir.DiagnosticReport(
                    fhirId: id,
                    status: fhir.FhirCode('final'),
                    code: fhir.CodeableConcept(text: testName),
                    subject: fhir.Reference(reference: patientRef),
                    issued: fhir.FhirInstant(now),
                    effectiveDateTime: fhir.FhirDateTime(now),
                    conclusion: '${resultCtrl.text.trim()}\n${conclusionCtrl.text.trim()}'.trim(),
                  );

                  await DatabaseService.fhirResources.add(FhirResource()
                    ..fhirId = id
                    ..resourceType = 'DiagnosticReport'
                    ..jsonData = jsonEncode(report.toJson())
                    ..patientReference = patientRef
                    ..category = 'laboratory'
                    ..syncStatus = 1
                    ..isDownloadedOffline = true
                    ..lastUpdated = now
                    ..createdAt = now);
                  ref.invalidate(patientLabsProvider(patientRef));

                  if (!context.mounted) return;
                  closeDrawer(ctx);
                  showToast(context: context, builder: (c, o) => SurfaceCard(child: Basic(title: Text('Lab report "$testName" saved'))));
                },
                child: const Text('Save Lab Report'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDiagnosisDrawer(BuildContext context, WidgetRef ref, String patientRef, String patientName) {
    final colors = Theme.of(context).colorScheme;
    final diagnosisCtrl = TextEditingController();
    final icdCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (ctx) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Diagnosis', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.foreground)),
            const SizedBox(height: 4),
            Text('Patient: $patientName', style: TextStyle(fontSize: 13, color: colors.mutedForeground)),
            const SizedBox(height: 20),
            TextField(controller: diagnosisCtrl, placeholder: const Text('Diagnosis (e.g. Essential Hypertension)')),
            const SizedBox(height: 12),
            TextField(controller: icdCtrl, placeholder: const Text('ICD-10 Code (e.g. I10)')),
            const SizedBox(height: 12),
            TextField(controller: notesCtrl, placeholder: const Text('Clinical notes...'), maxLines: 3),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: () async {
                  final diagnosis = diagnosisCtrl.text.trim();
                  if (diagnosis.isEmpty) { closeDrawer(ctx); return; }
                  final now = DateTime.now();
                  final id = 'condition-${now.millisecondsSinceEpoch}';

                  final condition = fhir.Condition(
                    fhirId: id,
                    clinicalStatus: fhir.CodeableConcept(coding: [
                      fhir.Coding(system: fhir.FhirUri('http://terminology.hl7.org/CodeSystem/condition-clinical'), code: fhir.FhirCode('active'))
                    ]),
                    verificationStatus: fhir.CodeableConcept(coding: [
                      fhir.Coding(system: fhir.FhirUri('http://terminology.hl7.org/CodeSystem/condition-ver-status'), code: fhir.FhirCode('confirmed'))
                    ]),
                    code: fhir.CodeableConcept(
                      coding: icdCtrl.text.trim().isNotEmpty
                          ? [fhir.Coding(system: fhir.FhirUri('http://hl7.org/fhir/sid/icd-10'), code: fhir.FhirCode(icdCtrl.text.trim()), display: diagnosis)]
                          : null,
                      text: diagnosis,
                    ),
                    subject: fhir.Reference(reference: patientRef),
                    recordedDate: fhir.FhirDateTime(now),
                    note: notesCtrl.text.trim().isNotEmpty
                        ? [fhir.Annotation(text: fhir.FhirMarkdown(notesCtrl.text.trim()))]
                        : null,
                  );

                  await DatabaseService.fhirResources.add(FhirResource()
                    ..fhirId = id
                    ..resourceType = 'Condition'
                    ..jsonData = jsonEncode(condition.toJson())
                    ..patientReference = patientRef
                    ..category = 'diagnosis'
                    ..syncStatus = 1
                    ..isDownloadedOffline = true
                    ..lastUpdated = now
                    ..createdAt = now);
                  ref.invalidate(patientRecordsProvider(patientRef));

                  if (!context.mounted) return;
                  closeDrawer(ctx);
                  showToast(context: context, builder: (c, o) => SurfaceCard(child: Basic(title: Text('Diagnosis "$diagnosis" saved'))));
                },
                child: const Text('Save Diagnosis'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openPrescriptionDrawer(BuildContext context, WidgetRef ref, String patientRef, String patientName) {
    final colors = Theme.of(context).colorScheme;
    final medCtrl = TextEditingController();
    final dosageCtrl = TextEditingController();
    final durationCtrl = TextEditingController();
    final instructionsCtrl = TextEditingController();

    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (ctx) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('E-Prescribe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.foreground)),
            const SizedBox(height: 4),
            Text('Patient: $patientName', style: TextStyle(fontSize: 13, color: colors.mutedForeground)),
            const SizedBox(height: 20),
            TextField(controller: medCtrl, placeholder: const Text('Medication name (e.g. Amoxicillin 500mg)')),
            const SizedBox(height: 12),
            TextField(controller: dosageCtrl, placeholder: const Text('Dosage & frequency (e.g. 3x daily)')),
            const SizedBox(height: 12),
            TextField(controller: durationCtrl, placeholder: const Text('Duration (e.g. 7 days)')),
            const SizedBox(height: 12),
            TextField(controller: instructionsCtrl, placeholder: const Text('Special instructions...'), maxLines: 2),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: () async {
                  final med = medCtrl.text.trim();
                  if (med.isEmpty) { closeDrawer(ctx); return; }
                  final now = DateTime.now();
                  final id = 'medreq-${now.millisecondsSinceEpoch}';

                  final dosageText = [dosageCtrl.text.trim(), if (durationCtrl.text.trim().isNotEmpty) 'for ${durationCtrl.text.trim()}', if (instructionsCtrl.text.trim().isNotEmpty) instructionsCtrl.text.trim()].join(', ');

                  final medReq = fhir.MedicationRequest(
                    fhirId: id,
                    status: fhir.FhirCode('active'),
                    intent: fhir.FhirCode('order'),
                    medicationCodeableConcept: fhir.CodeableConcept(text: med),
                    subject: fhir.Reference(reference: patientRef),
                    authoredOn: fhir.FhirDateTime(now),
                    dosageInstruction: dosageText.isNotEmpty ? [fhir.Dosage(text: dosageText)] : null,
                  );

                  await DatabaseService.fhirResources.add(FhirResource()
                    ..fhirId = id
                    ..resourceType = 'MedicationRequest'
                    ..jsonData = jsonEncode(medReq.toJson())
                    ..patientReference = patientRef
                    ..syncStatus = 1
                    ..isDownloadedOffline = true
                    ..lastUpdated = now
                    ..createdAt = now);
                  ref.invalidate(patientMedicationsProvider(patientRef));
                  final prescriber = ref.read(authProvider).user;
                  if (prescriber != null) {
                    AuditLogger.prescriptionIssued(
                      medicationRequestRef: 'MedicationRequest/$id',
                      agentRef: 'Practitioner/${prescriber.fhirPractitionerId ?? prescriber.email}',
                      agentName: prescriber.displayName,
                      agentRole: prescriber.practitionerType,
                    );
                  }

                  if (!context.mounted) return;
                  closeDrawer(ctx);
                  showToast(context: context, builder: (c, o) => SurfaceCard(child: Basic(title: Text('Prescription "$med" saved'))));
                },
                child: const Text('Save Prescription'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openVitalsDrawer(BuildContext context, WidgetRef ref, String patientRef, String patientName) {
    final colors = Theme.of(context).colorScheme;
    final sysCtrl = TextEditingController();
    final diaCtrl = TextEditingController();
    final hrCtrl = TextEditingController();
    final tempCtrl = TextEditingController();
    final spo2Ctrl = TextEditingController();

    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (ctx) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Record Vitals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.foreground)),
            const SizedBox(height: 4),
            Text('Patient: $patientName', style: TextStyle(fontSize: 13, color: colors.mutedForeground)),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Systolic', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.foreground)),
                const SizedBox(height: 6),
                TextField(controller: sysCtrl, placeholder: const Text('120')),
              ])),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Diastolic', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.foreground)),
                const SizedBox(height: 6),
                TextField(controller: diaCtrl, placeholder: const Text('80')),
              ])),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Heart Rate', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.foreground)),
                const SizedBox(height: 6),
                TextField(controller: hrCtrl, placeholder: const Text('72')),
              ])),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Temp (\u00B0F)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.foreground)),
                const SizedBox(height: 6),
                TextField(controller: tempCtrl, placeholder: const Text('98.6')),
              ])),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('SpO\u2082 %', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.foreground)),
                const SizedBox(height: 6),
                TextField(controller: spo2Ctrl, placeholder: const Text('98')),
              ])),
            ]),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: () async {
                  final now = DateTime.now();
                  int saved = 0;

                  final sys = double.tryParse(sysCtrl.text);
                  final dia = double.tryParse(diaCtrl.text);
                  if (sys != null && dia != null) {
                    final bpId = 'obs-bp-${now.millisecondsSinceEpoch}';
                    final bp = fhir.Observation(
                      fhirId: bpId,
                      status: fhir.FhirCode('final'),
                      code: fhir.CodeableConcept(coding: [fhir.Coding(system: fhir.FhirUri('http://loinc.org'), code: fhir.FhirCode('85354-9'), display: 'Blood Pressure')]),
                      subject: fhir.Reference(reference: patientRef),
                      effectiveDateTime: fhir.FhirDateTime(now),
                      component: [
                        fhir.ObservationComponent(code: fhir.CodeableConcept(coding: [fhir.Coding(system: fhir.FhirUri('http://loinc.org'), code: fhir.FhirCode('8480-6'))]), valueQuantity: fhir.Quantity(value: fhir.FhirDecimal(sys), unit: 'mmHg')),
                        fhir.ObservationComponent(code: fhir.CodeableConcept(coding: [fhir.Coding(system: fhir.FhirUri('http://loinc.org'), code: fhir.FhirCode('8462-4'))]), valueQuantity: fhir.Quantity(value: fhir.FhirDecimal(dia), unit: 'mmHg')),
                      ],
                    );
                    await DatabaseService.fhirResources.add(FhirResource()..fhirId = bpId..resourceType = 'Observation'..jsonData = jsonEncode(bp.toJson())..patientReference = patientRef..category = 'vital-signs'..syncStatus = 1..isDownloadedOffline = true..lastUpdated = now..createdAt = now);
                    saved++;
                  }

                  final hr = double.tryParse(hrCtrl.text);
                  if (hr != null) {
                    final hrId = 'obs-hr-${now.millisecondsSinceEpoch}';
                    final hrObs = fhir.Observation(
                      fhirId: hrId, status: fhir.FhirCode('final'),
                      code: fhir.CodeableConcept(coding: [fhir.Coding(system: fhir.FhirUri('http://loinc.org'), code: fhir.FhirCode('8867-4'), display: 'Heart Rate')]),
                      subject: fhir.Reference(reference: patientRef),
                      effectiveDateTime: fhir.FhirDateTime(now),
                      valueQuantity: fhir.Quantity(value: fhir.FhirDecimal(hr), unit: 'bpm'),
                    );
                    await DatabaseService.fhirResources.add(FhirResource()..fhirId = hrId..resourceType = 'Observation'..jsonData = jsonEncode(hrObs.toJson())..patientReference = patientRef..category = 'vital-signs'..syncStatus = 1..isDownloadedOffline = true..lastUpdated = now..createdAt = now);
                    saved++;
                  }

                  final temp = double.tryParse(tempCtrl.text);
                  if (temp != null) {
                    final tempId = 'obs-temp-${now.millisecondsSinceEpoch}';
                    final tempObs = fhir.Observation(
                      fhirId: tempId, status: fhir.FhirCode('final'),
                      code: fhir.CodeableConcept(coding: [fhir.Coding(system: fhir.FhirUri('http://loinc.org'), code: fhir.FhirCode('8310-5'), display: 'Body Temperature')]),
                      subject: fhir.Reference(reference: patientRef),
                      effectiveDateTime: fhir.FhirDateTime(now),
                      valueQuantity: fhir.Quantity(value: fhir.FhirDecimal(temp), unit: '\u00B0F'),
                    );
                    await DatabaseService.fhirResources.add(FhirResource()..fhirId = tempId..resourceType = 'Observation'..jsonData = jsonEncode(tempObs.toJson())..patientReference = patientRef..category = 'vital-signs'..syncStatus = 1..isDownloadedOffline = true..lastUpdated = now..createdAt = now);
                    saved++;
                  }

                  final spo2 = double.tryParse(spo2Ctrl.text);
                  if (spo2 != null) {
                    final spo2Id = 'obs-spo2-${now.millisecondsSinceEpoch}';
                    final spo2Obs = fhir.Observation(
                      fhirId: spo2Id, status: fhir.FhirCode('final'),
                      code: fhir.CodeableConcept(coding: [fhir.Coding(system: fhir.FhirUri('http://loinc.org'), code: fhir.FhirCode('2708-6'), display: 'Oxygen Saturation')]),
                      subject: fhir.Reference(reference: patientRef),
                      effectiveDateTime: fhir.FhirDateTime(now),
                      valueQuantity: fhir.Quantity(value: fhir.FhirDecimal(spo2), unit: '%'),
                    );
                    await DatabaseService.fhirResources.add(FhirResource()..fhirId = spo2Id..resourceType = 'Observation'..jsonData = jsonEncode(spo2Obs.toJson())..patientReference = patientRef..category = 'vital-signs'..syncStatus = 1..isDownloadedOffline = true..lastUpdated = now..createdAt = now);
                    saved++;
                  }

                  if (saved > 0) {
                    ref.invalidate(patientVitalsProvider(patientRef));
                  }

                  if (!context.mounted) return;
                  closeDrawer(ctx);
                  if (saved > 0) {
                    showToast(context: context, builder: (c, o) => SurfaceCard(child: Basic(title: Text('$saved vital(s) saved for $patientName'))));
                  }
                },
                child: const Text('Save Vitals'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openClinicalNoteDrawer(BuildContext context, WidgetRef ref, String patientRef, String patientName) {
    final colors = Theme.of(context).colorScheme;
    final complaintCtrl = TextEditingController();
    final findingsCtrl = TextEditingController();
    final assessmentCtrl = TextEditingController();
    final planCtrl = TextEditingController();

    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (ctx) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Clinical Note (SOAP)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.foreground)),
            const SizedBox(height: 4),
            Text('Patient: $patientName', style: TextStyle(fontSize: 13, color: colors.mutedForeground)),
            const SizedBox(height: 20),
            TextField(controller: complaintCtrl, placeholder: const Text('Subjective — Chief complaint...')),
            const SizedBox(height: 12),
            TextField(controller: findingsCtrl, placeholder: const Text('Objective — Exam findings...'), maxLines: 3),
            const SizedBox(height: 12),
            TextField(controller: assessmentCtrl, placeholder: const Text('Assessment — Diagnosis...')),
            const SizedBox(height: 12),
            TextField(controller: planCtrl, placeholder: const Text('Plan — Orders / follow-up...')),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: () async {
                  final now = DateTime.now();
                  final noteText = [
                    if (complaintCtrl.text.trim().isNotEmpty) 'S: ${complaintCtrl.text.trim()}',
                    if (findingsCtrl.text.trim().isNotEmpty) 'O: ${findingsCtrl.text.trim()}',
                    if (assessmentCtrl.text.trim().isNotEmpty) 'A: ${assessmentCtrl.text.trim()}',
                    if (planCtrl.text.trim().isNotEmpty) 'P: ${planCtrl.text.trim()}',
                  ].join('\n');

                  if (noteText.isEmpty) { closeDrawer(ctx); return; }

                  final obsId = 'obs-note-${now.millisecondsSinceEpoch}';
                  final obs = fhir.Observation(
                    fhirId: obsId,
                    status: fhir.FhirCode('final'),
                    code: fhir.CodeableConcept(
                      coding: [fhir.Coding(system: fhir.FhirUri('http://loinc.org'), code: fhir.FhirCode('34109-9'), display: 'Clinical Note')],
                      text: 'Clinical Note',
                    ),
                    subject: fhir.Reference(reference: patientRef),
                    effectiveDateTime: fhir.FhirDateTime(now),
                    valueString: noteText,
                  );

                  await DatabaseService.fhirResources.add(FhirResource()
                    ..fhirId = obsId
                    ..resourceType = 'Observation'
                    ..jsonData = jsonEncode(obs.toJson())
                    ..patientReference = patientRef
                    ..category = 'clinical-note'
                    ..syncStatus = 1
                    ..isDownloadedOffline = true
                    ..lastUpdated = now
                    ..createdAt = now);
                  ref.invalidate(patientRecordsProvider(patientRef));

                  if (!context.mounted) return;
                  closeDrawer(ctx);
                  showToast(context: context, builder: (c, o) => SurfaceCard(child: Basic(title: Text('Clinical note saved for $patientName'))));
                },
                child: const Text('Save Note'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Action tile widget
// ---------------------------------------------------------------------------
class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final double? width;
  final VoidCallback onTap;
  const _ActionTile({required this.icon, required this.label, required this.color, required this.onTap, this.width});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
            borderRadius: AppRadius.cardRadius,
            boxShadow: [SurfaceTheme.ambientShadow],
          ),
          child: Row(
            children: [
              Container(
                width: 34, height: 34,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 17),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.foreground))),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckupActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  const _CheckupActionRow({required this.icon, required this.label, required this.subtitle, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
          borderRadius: AppRadius.cardRadius,
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: colors.foreground)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 11, color: colors.mutedForeground)),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, size: 18, color: colors.mutedForeground),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Custom chart painter for vitals trendline
// ---------------------------------------------------------------------------
class _VitalsTrendPainter extends CustomPainter {
  final Color primaryColor;
  final Color destructiveColor;
  final Color successColor;
  final Color borderColor;
  final List<double> systolicSeries;
  final List<double> diastolicSeries;
  final List<double> heartRateSeries;

  _VitalsTrendPainter({
    required this.primaryColor,
    required this.destructiveColor,
    required this.successColor,
    required this.borderColor,
    required this.systolicSeries,
    required this.diastolicSeries,
    required this.heartRateSeries,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final systolicPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final heartRatePaint = Paint()
      ..color = destructiveColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final diastolicPaint = Paint()
      ..color = successColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = borderColor.withValues(alpha: 0.15)
      ..strokeWidth = 0.5;

    // Draw horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    _drawSeries(canvas, size, systolicSeries, systolicPaint, primaryColor, dotPaint);
    _drawSeries(canvas, size, heartRateSeries, heartRatePaint, destructiveColor, dotPaint);
    _drawSeries(canvas, size, diastolicSeries, diastolicPaint, successColor, dotPaint);
  }

  void _drawSeries(Canvas canvas, Size size, List<double> data, Paint linePaint, Color dotColor, Paint dotPaint) {
    if (data.isEmpty) return;
    final maxStep = data.length > 1 ? data.length - 1 : 1;
    final xStep = size.width / maxStep;
    // Auto-scale: map values to canvas, with small vertical padding.
    final minV = data.reduce((a, b) => a < b ? a : b);
    final maxV = data.reduce((a, b) => a > b ? a : b);
    final range = (maxV - minV).abs() < 0.001 ? 1.0 : (maxV - minV);
    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final x = data.length == 1 ? size.width / 2 : xStep * i;
      final y = size.height - ((data[i] - minV) / range) * size.height * 0.9 - size.height * 0.05;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, linePaint);
    dotPaint.color = dotColor;
    for (int i = 0; i < data.length; i++) {
      final x = data.length == 1 ? size.width / 2 : xStep * i;
      final y = size.height - ((data[i] - minV) / range) * size.height * 0.9 - size.height * 0.05;
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _VitalsTrendPainter oldDelegate) =>
      oldDelegate.systolicSeries != systolicSeries ||
      oldDelegate.diastolicSeries != diastolicSeries ||
      oldDelegate.heartRateSeries != heartRateSeries;
}
