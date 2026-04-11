import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/theme/surface_theme.dart';
import '../../../data/collections/fhir_resource_collection.dart';
import '../../../domain/providers/patient_data_provider.dart';
import '../../shared/widgets/sub_page_scaffold.dart';
import '../../../core/theme/clinical_colors.dart';

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

    // Resolve patient name from FHIR resource
    String patientName = 'Patient';
    String patientInitials = 'P';
    final fhirBox = DatabaseService.fhirResources;
    for (final r in fhirBox.values) {
      if (r.resourceType == 'Patient' && r.fhirId == patientId) {
        try {
          final resource = fhir.Resource.fromJson(jsonDecode(r.jsonData) as Map<String, dynamic>);
          if (resource is fhir.Patient) {
            patientName = resource.name?.firstOrNull?.text ??
                '${resource.name?.firstOrNull?.given?.join(' ') ?? ''} ${resource.name?.firstOrNull?.family ?? ''}'.trim();
            if (patientName.isEmpty) patientName = 'Patient';
            final parts = patientName.split(' ').where((p) => p.isNotEmpty).toList();
            patientInitials = parts.length >= 2
                ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
                : (parts.isNotEmpty ? parts[0][0].toUpperCase() : 'P');
          }
        } catch (_) {}
        break;
      }
    }
    return SubPageScaffold(
      title: 'Patient Detail',
      child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile
                    _buildProfileSection(context, patientName, patientInitials),
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
                    _buildVisitTimeline(context),
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
  Widget _buildProfileSection(BuildContext context, String name, String initials) {
      final colors = Theme.of(context).colorScheme;
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
                Row(
                  children: [
                    Icon(
                      Icons.medical_services_outlined,
                      size: 14,
                      color: colors.mutedForeground,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Dr. Alexander Thorne',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
  Widget _buildVisitTimeline(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
        _buildTimelineEntry(
          context: context,
          isNext: true,
          icon: Icons.event_rounded,
          iconColor: colors.primary,
          title: 'Follow-up Consultation',
          date: 'Aug 24, 2023  •  10:30 AM',
          description: null,
          badge: 'Cardiology',
        ),
        _buildTimelineEntry(
          context: context,
          icon: Icons.health_and_safety_rounded,
          iconColor: colors.success,
          title: 'Annual Wellness Exam',
          date: 'Jun 12, 2023',
          description:
              'Patient reporting mild fatigue and occasional headaches. Vitals within normal limits.',
        ),
        _buildTimelineEntry(
          context: context,
          icon: Icons.medication_rounded,
          iconColor: colors.mutedForeground,
          title: 'Prescription Renewal',
          date: 'May 15, 2023',
          description: 'Lisinopril 10mg renewed for 90-day supply.',
          isLast: true,
        ),
      ],
    );
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
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.6,
          children: [
            _ActionTile(
              icon: Icons.science_outlined,
              label: 'Lab Report',
              color: colors.primary,
              onTap: () => _openLabReportDrawer(context, patientRef, patientName),
            ),
            _ActionTile(
              icon: Icons.assignment_outlined,
              label: 'Diagnosis',
              color: colors.warning,
              onTap: () => _openDiagnosisDrawer(context, patientRef, patientName),
            ),
            _ActionTile(
              icon: Icons.medication_outlined,
              label: 'Prescription',
              color: colors.success,
              onTap: () => _openPrescriptionDrawer(context, patientRef, patientName),
            ),
            _ActionTile(
              icon: Icons.monitor_heart_outlined,
              label: 'Vitals',
              color: colors.destructive,
              onTap: () => _openVitalsDrawer(context, patientRef, patientName),
            ),
            _ActionTile(
              icon: Icons.note_add_outlined,
              label: 'Clinical Note',
              color: const Color(0xFF7C3AED),
              onTap: () => _openClinicalNoteDrawer(context, patientRef, patientName),
            ),
            _ActionTile(
              icon: Icons.picture_as_pdf_outlined,
              label: 'Export PDF',
              color: colors.mutedForeground,
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
        ),
      ],
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
  final VoidCallback onTap;
  const _ActionTile({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
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
