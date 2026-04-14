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
import 'package:cc_ui_kit/widgets/sub_page_scaffold.dart';
import 'package:cc_rbac/can.dart';
import 'package:cc_core/theme/clinical_colors.dart';

class PatientDetailScreen extends ConsumerWidget {
  final String patientId;

  const PatientDetailScreen({
    super.key,
    this.patientId = '0922-A',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientRef = 'Patient/$patientId';

    // Pre-load real patient data from FHIR providers (used by sub-widgets)
    // ignore: unused_local_variable
    final patientVitals = ref.watch(patientVitalsProvider(patientRef));
    // ignore: unused_local_variable
    final patientLabs = ref.watch(patientLabsProvider(patientRef));
    // ignore: unused_local_variable
    final patientMeds = ref.watch(patientMedicationsProvider(patientRef));
    // ignore: unused_local_variable
    final patientAllergies = ref.watch(patientAllergiesProvider(patientRef));

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
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Allergy Alert
                    _buildAllergyAlert(context),
                    const SizedBox(height: AppSpacing.xxl),

                    // Vitals Trendline
                    _buildVitalsTrendline(context),
                    const SizedBox(height: AppSpacing.xxl),

                    // Lab Results
                    _buildLabResults(context),
                    const SizedBox(height: AppSpacing.xxl),

                    // Active Medications
                    _buildActiveMedications(context),
                    const SizedBox(height: AppSpacing.xxl),

                    // Visit Timeline
                    _buildVisitTimeline(context, upcomingAppts, pastAppts),
                    const SizedBox(height: AppSpacing.xxl),

                    // Clinical Actions
                    _buildClinicalActions(context, patientRef, patientName),
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
                Row(
                  children: [
                    _buildInfoChip(context, Icons.monitor_weight_outlined, '68.4 kg'),
                    const SizedBox(width: AppSpacing.sm),
                    _buildInfoChip(context, Icons.height, '172 cm'),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildProfileInfoRow(
                  context,
                  Icons.calendar_today,
                  'Registered: $regText',
                ),
                const SizedBox(height: 4),
                _buildProfileInfoRow(
                  context,
                  Icons.event,
                  nextText != null ? 'Next visit: $nextText' : 'No upcoming visits',
                  highlight: nextText != null,
                ),
                const SizedBox(height: 4),
                _buildProfileInfoRow(
                  context,
                  Icons.medical_services_outlined,
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
  Widget _buildAllergyAlert(BuildContext context) {
      final colors = Theme.of(context).colorScheme;
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
              Icon(
                Icons.warning_amber_rounded,
                color: colors.primaryForeground,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Penicillin',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: colors.primaryForeground,
                  ),
                ),
              ),
              PrimaryBadge(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 3,
                  ),
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
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Severe reaction reported 2019. Avoid all Beta-lactam antibiotics. Patient carries EpiPen.',
            style: TextStyle(
              fontSize: 12,
              color: colors.primaryForeground.withValues(alpha: 0.85),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Vitals Trendline
  // ---------------------------------------------------------------------------
  Widget _buildVitalsTrendline(BuildContext context) {
      final colors = Theme.of(context).colorScheme;
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
          'Last 6 Months (BP & Heart Rate)',
          style: TextStyle(
            fontSize: 12,
            color: colors.mutedForeground,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
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
                    ),
                    size: Size.infinite,
                  ),
                ),

                // X-axis labels
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Jan',
                        style: TextStyle(
                            fontSize: 9, color: colors.mutedForeground)),
                    Text('Feb',
                        style: TextStyle(
                            fontSize: 9, color: colors.mutedForeground)),
                    Text('Mar',
                        style: TextStyle(
                            fontSize: 9, color: colors.mutedForeground)),
                    Text('Apr',
                        style: TextStyle(
                            fontSize: 9, color: colors.mutedForeground)),
                    Text('May',
                        style: TextStyle(
                            fontSize: 9, color: colors.mutedForeground)),
                    Text('Jun',
                        style: TextStyle(
                            fontSize: 9, color: colors.mutedForeground)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
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
  Widget _buildLabResults(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lab Results',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.foreground,
              ),
            ),
            GhostButton(
              density: ButtonDensity.compact,
              onPressed: () {
                showToast(
                  context: context,
                  builder: (ctx, overlay) => SurfaceCard(
                    child: Basic(
                      title: const Text('Loading all lab panels...'),
                      subtitle: const Text(
                          'Fetching complete lab history for Sarah J. Miller'),
                      leading: const Icon(Icons.science_outlined, size: 18),
                    ),
                  ),
                  location: ToastLocation.bottomRight,
                );
              },
              child: Text(
                'View All Panels',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _buildLabResultItem(context, 
          testName: 'Glucose, Fasting',
          value: '104 mg/dL',
          status: 'HIGH',
          statusColor: colors.destructive,
          date: '12 Jul 2023',
        ),
        const SizedBox(height: AppSpacing.md),
        _buildLabResultItem(context, 
          testName: 'Hemoglobin A1c',
          value: '5.4%',
          status: 'Normal',
          statusColor: colors.success,
          date: '12 Jul 2023',
        ),
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
            child: Icon(Icons.science_outlined, color: statusColor, size: 18),
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
                  '$value  •  $date',
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
  Widget _buildActiveMedications(BuildContext context) {
      final colors = Theme.of(context).colorScheme;
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
        _buildMedicationItem(context, 
          name: 'Amoxicillin 500mg',
          dosage: '3x daily • Oral',
          prescriber: 'Dr. Marcus Thorne',
        ),
        const SizedBox(height: AppSpacing.md),
        _buildMedicationItem(context, 
          name: 'Lisinopril 10mg',
          dosage: '1x daily • Oral',
          prescriber: 'Dr. Thorne',
        ),
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
              Icons.medication_outlined,
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
                  '$dosage  •  $prescriber',
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
                  Icon(Icons.event_busy, size: 32, color: colors.mutedForeground.withValues(alpha: 0.5)),
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
        return Icons.person_rounded;
      case 'telemedicine':
        return Icons.videocam_rounded;
      default:
        return Icons.local_hospital_rounded;
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
  Widget _buildClinicalActions(BuildContext context, String patientRef, String patientName) {
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
            onPressed: () => _openCheckupSheet(context, patientRef, patientName),
            leading: const Icon(Icons.medical_services, size: 20),
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
                    icon: Icons.science_outlined,
                    label: 'Lab Report',
                    color: colors.primary,
                    width: tileWidth,
                    onTap: () => _openLabReportDrawer(context, patientRef, patientName),
                  ),
                ),
                _ActionTile(
                  icon: Icons.assignment_outlined,
                  label: 'Diagnosis',
                  color: colors.warning,
                  width: tileWidth,
                  onTap: () => _openDiagnosisDrawer(context, patientRef, patientName),
                ),
                Can(
                  permission: 'prescription.issue',
                  child: _ActionTile(
                    icon: Icons.medication_outlined,
                    label: 'Prescription',
                    color: colors.success,
                    width: tileWidth,
                    onTap: () => _openPrescriptionDrawer(context, patientRef, patientName),
                  ),
                ),
                _ActionTile(
                  icon: Icons.monitor_heart_outlined,
                  label: 'Vitals',
                  color: colors.destructive,
                  width: tileWidth,
                  onTap: () => _openVitalsDrawer(context, patientRef, patientName),
                ),
                _ActionTile(
                  icon: Icons.note_add_outlined,
                  label: 'Clinical Note',
                  color: const Color(0xFF7C3AED),
                  width: tileWidth,
                  onTap: () => _openClinicalNoteDrawer(context, patientRef, patientName),
                ),
                _ActionTile(
                  icon: Icons.picture_as_pdf_outlined,
                  label: 'Export PDF',
                  color: colors.mutedForeground,
                  width: tileWidth,
                  onTap: () {
                    showToast(
                      context: context,
                      builder: (ctx, overlay) => SurfaceCard(
                        child: Basic(
                          title: const Text('Exporting PDF report...'),
                          leading: const Icon(Icons.picture_as_pdf_outlined, size: 18),
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

  void _openCheckupSheet(BuildContext context, String patientRef, String patientName) {
    final colors = Theme.of(context).colorScheme;
    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (_) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Checkup', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.foreground)),
            const SizedBox(height: 4),
            Text('Patient: $patientName', style: TextStyle(fontSize: 13, color: colors.mutedForeground)),
            const SizedBox(height: 20),
            _CheckupActionRow(
              icon: Icons.monitor_heart_outlined,
              label: 'Record Vitals',
              subtitle: 'BP, Heart Rate, Temp, SpO\u2082',
              color: colors.destructive,
              onTap: () { closeDrawer(context); WidgetsBinding.instance.addPostFrameCallback((_) { if (context.mounted) _openVitalsDrawer(context, patientRef, patientName); }); },
            ),
            const SizedBox(height: 10),
            _CheckupActionRow(
              icon: Icons.note_add_outlined,
              label: 'Clinical Note (SOAP)',
              subtitle: 'Subjective, Objective, Assessment, Plan',
              color: const Color(0xFF7C3AED),
              onTap: () { closeDrawer(context); WidgetsBinding.instance.addPostFrameCallback((_) { if (context.mounted) _openClinicalNoteDrawer(context, patientRef, patientName); }); },
            ),
            const SizedBox(height: 10),
            _CheckupActionRow(
              icon: Icons.assignment_outlined,
              label: 'Add Diagnosis',
              subtitle: 'ICD-10 code and clinical notes',
              color: colors.warning,
              onTap: () { closeDrawer(context); WidgetsBinding.instance.addPostFrameCallback((_) { if (context.mounted) _openDiagnosisDrawer(context, patientRef, patientName); }); },
            ),
            const SizedBox(height: 10),
            _CheckupActionRow(
              icon: Icons.medication_outlined,
              label: 'Prescribe Medication',
              subtitle: 'E-Prescribe with dosage instructions',
              color: colors.success,
              onTap: () { closeDrawer(context); WidgetsBinding.instance.addPostFrameCallback((_) { if (context.mounted) _openPrescriptionDrawer(context, patientRef, patientName); }); },
            ),
            const SizedBox(height: 10),
            _CheckupActionRow(
              icon: Icons.science_outlined,
              label: 'Order Lab Test',
              subtitle: 'Request diagnostic report',
              color: colors.primary,
              onTap: () { closeDrawer(context); WidgetsBinding.instance.addPostFrameCallback((_) { if (context.mounted) _openLabReportDrawer(context, patientRef, patientName); }); },
            ),
            const SizedBox(height: 20),
            Divider(color: colors.border),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlineButton(
                onPressed: () {
                  closeDrawer(context);
                  context.push(RouteNames.clinicalStartEncounter);
                },
                leading: const Icon(Icons.open_in_new, size: 16),
                child: const Text('Start Full Encounter'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openLabReportDrawer(BuildContext context, String patientRef, String patientName) {
    final colors = Theme.of(context).colorScheme;
    final testNameCtrl = TextEditingController();
    final resultCtrl = TextEditingController();
    final conclusionCtrl = TextEditingController();

    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (_) => SingleChildScrollView(
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
                  if (testName.isEmpty) { closeDrawer(context); return; }
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

                  if (!context.mounted) return;
                  closeDrawer(context);
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

  void _openDiagnosisDrawer(BuildContext context, String patientRef, String patientName) {
    final colors = Theme.of(context).colorScheme;
    final diagnosisCtrl = TextEditingController();
    final icdCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (_) => SingleChildScrollView(
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
                  if (diagnosis.isEmpty) { closeDrawer(context); return; }
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

                  if (!context.mounted) return;
                  closeDrawer(context);
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

  void _openPrescriptionDrawer(BuildContext context, String patientRef, String patientName) {
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
      builder: (_) => SingleChildScrollView(
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
                  if (med.isEmpty) { closeDrawer(context); return; }
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

                  if (!context.mounted) return;
                  closeDrawer(context);
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

  void _openVitalsDrawer(BuildContext context, String patientRef, String patientName) {
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
      builder: (_) => SingleChildScrollView(
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

                  if (!context.mounted) return;
                  closeDrawer(context);
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

  void _openClinicalNoteDrawer(BuildContext context, String patientRef, String patientName) {
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
      builder: (_) => SingleChildScrollView(
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

                  if (noteText.isEmpty) { closeDrawer(context); return; }

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

                  if (!context.mounted) return;
                  closeDrawer(context);
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
            Icon(Icons.chevron_right, size: 18, color: colors.mutedForeground),
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

  _VitalsTrendPainter({
    required this.primaryColor,
    required this.destructiveColor,
    required this.successColor,
    required this.borderColor,
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

    final xStep = size.width / 5; // 6 data points

    // Systolic BP data (normalized 110-140 range mapped to canvas height)
    final systolicData = [128.0, 132.0, 125.0, 130.0, 122.0, 126.0];
    final systolicPath = Path();
    for (int i = 0; i < systolicData.length; i++) {
      final x = xStep * i;
      final y = size.height - ((systolicData[i] - 60) / 100) * size.height;
      if (i == 0) {
        systolicPath.moveTo(x, y);
      } else {
        systolicPath.lineTo(x, y);
      }
    }
    canvas.drawPath(systolicPath, systolicPaint);

    // Draw dots for systolic
    dotPaint.color = primaryColor;
    for (int i = 0; i < systolicData.length; i++) {
      final x = xStep * i;
      final y = size.height - ((systolicData[i] - 60) / 100) * size.height;
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }

    // Heart Rate data (60-100 range)
    final hrData = [74.0, 78.0, 72.0, 80.0, 76.0, 73.0];
    final hrPath = Path();
    for (int i = 0; i < hrData.length; i++) {
      final x = xStep * i;
      final y = size.height - ((hrData[i] - 60) / 100) * size.height;
      if (i == 0) {
        hrPath.moveTo(x, y);
      } else {
        hrPath.lineTo(x, y);
      }
    }
    canvas.drawPath(hrPath, heartRatePaint);

    // Draw dots for HR
    dotPaint.color = destructiveColor;
    for (int i = 0; i < hrData.length; i++) {
      final x = xStep * i;
      final y = size.height - ((hrData[i] - 60) / 100) * size.height;
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }

    // Diastolic BP data (70-90 range)
    final diastolicData = [82.0, 85.0, 80.0, 83.0, 78.0, 81.0];
    final diastolicPath = Path();
    for (int i = 0; i < diastolicData.length; i++) {
      final x = xStep * i;
      final y = size.height - ((diastolicData[i] - 60) / 100) * size.height;
      if (i == 0) {
        diastolicPath.moveTo(x, y);
      } else {
        diastolicPath.lineTo(x, y);
      }
    }
    canvas.drawPath(diastolicPath, diastolicPaint);

    // Draw dots for diastolic
    dotPaint.color = successColor;
    for (int i = 0; i < diastolicData.length; i++) {
      final x = xStep * i;
      final y = size.height - ((diastolicData[i] - 60) / 100) * size.height;
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
