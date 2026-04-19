import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fhir/r4.dart' as fhir;
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_data/database/isar_service.dart';
import 'package:cc_core/router/route_names.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_fhir_models/collections/appointment_collection.dart';
import 'package:cc_fhir_models/collections/fhir_resource_collection.dart';
import '../../../domain/providers/auth_provider.dart';
import '../../shared/widgets/sync_chip.dart';
import 'package:cc_data/providers/practitioner_data_provider.dart';

class DoctorDashboardScreen extends ConsumerWidget {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final authState = ref.watch(authProvider);
    final patientCount = ref.watch(patientCountProvider);
    final practRef = authState.user?.fhirPractitionerId ?? '';
    final todayAppts = ref.watch(todayAppointmentsProvider(practRef));
    final opdAppts = ref.watch(todayOpdProvider(practRef));
    final doctorName =
        (authState.user?.displayName ?? 'Doctor').replaceAll('Dr. ', '');

    final completedCount =
        todayAppts.where((a) => a.status == 'completed').length;

    return Scaffold(
      backgroundColor: colors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting + sync chip
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good morning,',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colors.mutedForeground)),
                        const SizedBox(height: 2),
                        Text('Dr. $doctorName',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: colors.foreground,
                                letterSpacing: -0.3)),
                      ],
                    ),
                  ),
                  const SyncChip(),
                ],
              ),

              const SizedBox(height: 24),
              _StatsRow(
                patientCount: patientCount,
                opdCount: opdAppts.length,
                completedCount: completedCount,
              ),

              const SizedBox(height: 32),
              _TodaysSchedule(appointments: todayAppts),

              const SizedBox(height: 32),
              _PatientQueue(opdAppointments: opdAppts),

              const SizedBox(height: 32),
              _PendingConsults(),

              const SizedBox(height: 32),
              _QuickTools(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final int patientCount;
  final int opdCount;
  final int completedCount;
  const _StatsRow({
    required this.patientCount,
    required this.opdCount,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
            child: _StatCard(
                icon: LucideIcons.users,
                value: '$patientCount',
                label: 'Patients',
                bg: colors.oxygenBg,
                iconColor: colors.primary)),
        const SizedBox(width: 12),
        Expanded(
            child: _StatCard(
                icon: LucideIcons.calendarDays,
                value: '$opdCount',
                label: 'OPD Today',
                bg: colors.stepsBg,
                iconColor: colors.success)),
        const SizedBox(width: 12),
        Expanded(
            child: _StatCard(
                icon: LucideIcons.circleCheck,
                value: '$completedCount',
                label: 'Completed',
                bg: colors.sleepBg,
                iconColor: const Color(0xFF7C3AED))),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color bg;
  final Color iconColor;
  const _StatCard(
      {required this.icon,
      required this.value,
      required this.label,
      required this.bg,
      required this.iconColor});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 12),
          Text(value,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: colors.foreground)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colors.mutedForeground)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _TodaysSchedule extends StatelessWidget {
  final List<AppointmentLocal> appointments;
  const _TodaysSchedule({required this.appointments});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Today's Schedule",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.foreground)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  color: colors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6)),
              child: Text('LIVE',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: colors.success,
                      letterSpacing: 0.5)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: appointments.isEmpty
              ? Center(
                  child: Text('No appointments today',
                      style: TextStyle(
                          fontSize: 13, color: colors.mutedForeground)))
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: appointments.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final appt = appointments[index];
                    final isActive = appt.status == 'checked-in';
                    final isComplete = appt.status == 'completed';
                    final timeStr =
                        DateFormat('hh:mm a').format(appt.scheduledAt);
                    return _ScheduleCard(
                      time: timeStr,
                      title: appt.patientName,
                      subtitle: _typeLabel(appt.appointmentType),
                      isActive: isActive,
                      isComplete: isComplete,
                    );
                  },
                ),
        ),
      ],
    );
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'opd':
        return 'OPD';
      case 'telemedicine':
        return 'Virtual';
      default:
        return type;
    }
  }
}

class _ScheduleCard extends StatelessWidget {
  final String time;
  final String title;
  final String subtitle;
  final bool isActive;
  final bool isComplete;
  const _ScheduleCard(
      {required this.time,
      required this.title,
      required this.subtitle,
      this.isActive = false,
      this.isComplete = false});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isActive
            ? colors.primary.withValues(alpha: 0.06)
            : colors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isActive ? [] : [SurfaceTheme.ambientShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(time,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isActive
                          ? colors.primary
                          : colors.mutedForeground)),
              const SizedBox(height: 4),
              Text(title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colors.foreground),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
          if (isActive)
            Row(children: [
              Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                      color: colors.success, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Text('Checked In',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colors.success)),
            ])
          else if (isComplete)
            Row(children: [
              Icon(LucideIcons.check, size: 12, color: colors.mutedForeground),
              const SizedBox(width: 4),
              Text('Done',
                  style: TextStyle(
                      fontSize: 11, color: colors.mutedForeground)),
            ])
          else
            Text(subtitle,
                style:
                    TextStyle(fontSize: 12, color: colors.mutedForeground)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _PatientQueue extends StatelessWidget {
  final List<AppointmentLocal> opdAppointments;
  const _PatientQueue({required this.opdAppointments});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Show only non-completed OPD patients
    final queue =
        opdAppointments.where((a) => a.status != 'completed').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('OPD Patient Queue',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.foreground)),
            GestureDetector(
              onTap: () => context.go(RouteNames.clinicianSchedule),
              child: Row(children: [
                Text('View All',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colors.primary)),
                const SizedBox(width: 2),
                Icon(LucideIcons.chevronRight,
                    size: 16, color: colors.primary),
              ]),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (queue.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [SurfaceTheme.ambientShadow]),
            child: Center(
              child: Text('No patients in OPD queue',
                  style: TextStyle(
                      fontSize: 13, color: colors.mutedForeground)),
            ),
          )
        else
          ...queue.asMap().entries.map((entry) {
            final i = entry.key;
            final appt = entry.value;
            final initials = appt.patientName
                .split(' ')
                .where((w) => w.isNotEmpty)
                .take(2)
                .map((w) => w[0].toUpperCase())
                .join();
            final timeStr =
                DateFormat('hh:mm a').format(appt.scheduledAt);
            final isCheckedIn = appt.status == 'checked-in';

            return Padding(
              padding: EdgeInsets.only(bottom: i < queue.length - 1 ? 8 : 0),
              child: _QueueCard(
                name: appt.patientName,
                initials: initials,
                time: timeStr,
                condition: appt.notes ?? appt.specialty ?? 'OPD',
                isCheckedIn: isCheckedIn,
                showActions: isCheckedIn,
                patientRef: appt.patientRef,
              ),
            );
          }),
      ],
    );
  }
}

class _QueueCard extends StatelessWidget {
  final String name, initials, time, condition;
  final bool isCheckedIn;
  final bool showActions;
  final String patientRef;
  const _QueueCard({
    required this.name,
    required this.initials,
    required this.time,
    required this.condition,
    required this.isCheckedIn,
    this.showActions = false,
    required this.patientRef,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        final patientId = patientRef.replaceFirst('Patient/', '');
        context.push('/patient-detail/$patientId');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [SurfaceTheme.ambientShadow]),
        child: Column(
          children: [
            Row(
              children: [
                Avatar(initials: initials, size: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(name,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: colors.foreground)),
                      ]),
                      const SizedBox(height: 4),
                      Row(children: [
                        Text(condition,
                            style: TextStyle(
                                fontSize: 12,
                                color: colors.mutedForeground),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        if (isCheckedIn) ...[
                          const SizedBox(width: 8),
                          DestructiveBadge(
                              child: const Text('IN QUEUE',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700))),
                        ],
                      ]),
                    ],
                  ),
                ),
                SecondaryBadge(
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(LucideIcons.clock, size: 12),
                  const SizedBox(width: 4),
                  Text(time,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600)),
                ])),
              ],
            ),
            if (showActions) ...[
              const SizedBox(height: 14),
              Row(children: [
                Expanded(
                    child: Button.primary(
                  onPressed: () => _openRecordDrawer(context),
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.mic, size: 14),
                        SizedBox(width: 4),
                        Text('Start Record',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600))
                      ]),
                )),
                const SizedBox(width: 8),
                Expanded(
                    child: Button.outline(
                  onPressed: () => _openVitalsDrawer(context),
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.heartPulse, size: 14),
                        SizedBox(width: 4),
                        Text('Vitals',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600))
                      ]),
                )),
              ]),
            ],
          ],
        ),
      ),
    );
  }

  void _openRecordDrawer(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final complaintCtrl = TextEditingController();
    final findingsCtrl = TextEditingController();
    final diagnosisCtrl = TextEditingController();
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
            Text('Clinical Record',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colors.foreground)),
            const SizedBox(height: 4),
            Text('Patient: $name',
                style:
                    TextStyle(fontSize: 13, color: colors.mutedForeground)),
            const SizedBox(height: 20),
            TextField(
                controller: complaintCtrl,
                placeholder: const Text('Chief complaint...')),
            const SizedBox(height: 12),
            TextField(
                controller: findingsCtrl,
                placeholder: const Text('Examination findings...'),
                maxLines: 3),
            const SizedBox(height: 12),
            TextField(
                controller: diagnosisCtrl,
                placeholder: const Text('Diagnosis / Assessment...')),
            const SizedBox(height: 12),
            TextField(
                controller: planCtrl,
                placeholder: const Text('Treatment plan / Orders...')),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Button.primary(
                onPressed: () async {
                  final now = DateTime.now();
                  final obsId =
                      'obs-note-${now.millisecondsSinceEpoch}';
                  final noteText = [
                    if (complaintCtrl.text.trim().isNotEmpty)
                      'Complaint: ${complaintCtrl.text.trim()}',
                    if (findingsCtrl.text.trim().isNotEmpty)
                      'Findings: ${findingsCtrl.text.trim()}',
                    if (diagnosisCtrl.text.trim().isNotEmpty)
                      'Assessment: ${diagnosisCtrl.text.trim()}',
                    if (planCtrl.text.trim().isNotEmpty)
                      'Plan: ${planCtrl.text.trim()}',
                  ].join('\n');

                  if (noteText.isEmpty) {
                    closeDrawer(ctx);
                    return;
                  }

                  final obs = fhir.Observation(
                    fhirId: obsId,
                    status: fhir.FhirCode('final'),
                    code: fhir.CodeableConcept(
                      coding: [
                        fhir.Coding(
                            system: fhir.FhirUri('http://loinc.org'),
                            code: fhir.FhirCode('34109-9'),
                            display: 'Clinical Note')
                      ],
                      text: 'Clinical Note',
                    ),
                    subject: fhir.Reference(reference: patientRef),
                    effectiveDateTime: fhir.FhirDateTime(now),
                    valueString: noteText,
                  );

                  final resource = FhirResource()
                    ..fhirId = obsId
                    ..resourceType = 'Observation'
                    ..jsonData = jsonEncode(obs.toJson())
                    ..patientReference = patientRef
                    ..category = 'clinical-note'
                    ..syncStatus = 1
                    ..isDownloadedOffline = true
                    ..lastUpdated = now
                    ..createdAt = now;

                  await DatabaseService.fhirResources.add(resource);

                  if (!context.mounted) return;
                  closeDrawer(ctx);
                  showToast(
                      context: context,
                      builder: (c, o) => SurfaceCard(
                          child: Basic(
                              title:
                                  Text('Record saved for $name'))));
                },
                child: const Text('Save Record'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openVitalsDrawer(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final sysCtrl = TextEditingController();
    final diaCtrl = TextEditingController();
    final hrCtrl = TextEditingController();
    final tempCtrl = TextEditingController();
    final spo2Ctrl = TextEditingController();
    final rrCtrl = TextEditingController();

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
            Text('Record Vitals',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colors.foreground)),
            const SizedBox(height: 4),
            Text('Patient: $name',
                style:
                    TextStyle(fontSize: 13, color: colors.mutedForeground)),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('Systolic (mmHg)',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.foreground)),
                    const SizedBox(height: 6),
                    TextField(
                        controller: sysCtrl,
                        placeholder: const Text('120')),
                  ])),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('Diastolic (mmHg)',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.foreground)),
                    const SizedBox(height: 6),
                    TextField(
                        controller: diaCtrl,
                        placeholder: const Text('80')),
                  ])),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('Heart Rate (bpm)',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.foreground)),
                    const SizedBox(height: 6),
                    TextField(
                        controller: hrCtrl,
                        placeholder: const Text('72')),
                  ])),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('Temperature (\u00B0F)',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.foreground)),
                    const SizedBox(height: 6),
                    TextField(
                        controller: tempCtrl,
                        placeholder: const Text('98.6')),
                  ])),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('SpO\u2082 (%)',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.foreground)),
                    const SizedBox(height: 6),
                    TextField(
                        controller: spo2Ctrl,
                        placeholder: const Text('98')),
                  ])),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('Resp Rate (/min)',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.foreground)),
                    const SizedBox(height: 6),
                    TextField(
                        controller: rrCtrl,
                        placeholder: const Text('16')),
                  ])),
            ]),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Button.primary(
                onPressed: () async {
                  final now = DateTime.now();

                  final sys = double.tryParse(sysCtrl.text);
                  final dia = double.tryParse(diaCtrl.text);
                  if (sys != null && dia != null) {
                    final bpId = 'obs-bp-${now.millisecondsSinceEpoch}';
                    final bp = fhir.Observation(
                      fhirId: bpId,
                      status: fhir.FhirCode('final'),
                      code: fhir.CodeableConcept(coding: [
                        fhir.Coding(
                            system: fhir.FhirUri('http://loinc.org'),
                            code: fhir.FhirCode('85354-9'),
                            display: 'Blood Pressure')
                      ]),
                      subject: fhir.Reference(reference: patientRef),
                      effectiveDateTime: fhir.FhirDateTime(now),
                      component: [
                        fhir.ObservationComponent(
                            code: fhir.CodeableConcept(coding: [
                              fhir.Coding(
                                  system:
                                      fhir.FhirUri('http://loinc.org'),
                                  code: fhir.FhirCode('8480-6'))
                            ]),
                            valueQuantity: fhir.Quantity(
                                value: fhir.FhirDecimal(sys),
                                unit: 'mmHg')),
                        fhir.ObservationComponent(
                            code: fhir.CodeableConcept(coding: [
                              fhir.Coding(
                                  system:
                                      fhir.FhirUri('http://loinc.org'),
                                  code: fhir.FhirCode('8462-4'))
                            ]),
                            valueQuantity: fhir.Quantity(
                                value: fhir.FhirDecimal(dia),
                                unit: 'mmHg')),
                      ],
                    );
                    await DatabaseService.fhirResources.add(FhirResource()
                      ..fhirId = bpId
                      ..resourceType = 'Observation'
                      ..jsonData = jsonEncode(bp.toJson())
                      ..patientReference = patientRef
                      ..category = 'vital-signs'
                      ..syncStatus = 1
                      ..isDownloadedOffline = true
                      ..lastUpdated = now
                      ..createdAt = now);
                  }

                  final hr = double.tryParse(hrCtrl.text);
                  if (hr != null) {
                    final hrId = 'obs-hr-${now.millisecondsSinceEpoch}';
                    final hrObs = fhir.Observation(
                      fhirId: hrId,
                      status: fhir.FhirCode('final'),
                      code: fhir.CodeableConcept(coding: [
                        fhir.Coding(
                            system: fhir.FhirUri('http://loinc.org'),
                            code: fhir.FhirCode('8867-4'),
                            display: 'Heart Rate')
                      ]),
                      subject: fhir.Reference(reference: patientRef),
                      effectiveDateTime: fhir.FhirDateTime(now),
                      valueQuantity: fhir.Quantity(
                          value: fhir.FhirDecimal(hr), unit: 'bpm'),
                    );
                    await DatabaseService.fhirResources.add(FhirResource()
                      ..fhirId = hrId
                      ..resourceType = 'Observation'
                      ..jsonData = jsonEncode(hrObs.toJson())
                      ..patientReference = patientRef
                      ..category = 'vital-signs'
                      ..syncStatus = 1
                      ..isDownloadedOffline = true
                      ..lastUpdated = now
                      ..createdAt = now);
                  }

                  if (!context.mounted) return;
                  closeDrawer(ctx);
                  showToast(
                      context: context,
                      builder: (c, o) => SurfaceCard(
                          child: Basic(
                              title:
                                  Text('Vitals saved for $name'))));
                },
                child: const Text('Save Vitals'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _PendingConsults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: colors.primary, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pending Consults',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colors.primaryForeground)),
          const SizedBox(height: 16),
          _ConsultItem(
              icon: LucideIcons.image,
              title: 'Radiology',
              subtitle: 'MRI Review - Ward 4B'),
          const SizedBox(height: 12),
          _ConsultItem(
              icon: LucideIcons.heartPulse,
              title: 'Cardiology',
              subtitle: 'ECG Interpretation'),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Button.outline(
              onPressed: () =>
                  GoRouter.of(context).go(RouteNames.clinicianPatients),
              child: Text('Review All (5)',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryForeground)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsultItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _ConsultItem(
      {required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              color: colors.primaryForeground.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: colors.primaryForeground, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.primaryForeground)),
            Text(subtitle,
                style: TextStyle(
                    fontSize: 12,
                    color:
                        colors.primaryForeground.withValues(alpha: 0.7))),
          ],
        )),
        Icon(LucideIcons.chevronRight,
            color: colors.primaryForeground.withValues(alpha: 0.5),
            size: 18),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _QuickTools extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Tools',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.foreground)),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.4,
          children: [
            _ToolCard(
                icon: LucideIcons.userSearch,
                label: 'Find Patient',
                onTap: () => context.go(RouteNames.clinicianPatients)),
            _ToolCard(
                icon: LucideIcons.send,
                label: 'New Referral',
                onTap: () => _openFormDrawer(context, 'New Referral', [
                      'Referring to (Specialist name)',
                      'Specialty / Department',
                      'Reason for referral',
                      'Urgency (Routine / Urgent)'
                    ])),
            _ToolCard(
                icon: LucideIcons.pill,
                label: 'E-Prescribe',
                onTap: () => _openFormDrawer(context, 'E-Prescribe', [
                      'Medication name',
                      'Dosage & frequency',
                      'Duration (days)',
                      'Special instructions'
                    ])),
            _ToolCard(
                icon: LucideIcons.flaskConical,
                label: 'Lab Orders',
                onTap: () => _openFormDrawer(context, 'Lab Order', [
                      'Test name(s)',
                      'Clinical indication',
                      'Fasting required? (Yes/No)',
                      'Urgency (Routine / STAT)'
                    ])),
          ],
        ),
      ],
    );
  }

  void _openFormDrawer(
      BuildContext context, String title, List<String> fields) {
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
            Text(title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colors.foreground)),
            const SizedBox(height: 20),
            ...fields.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextField(placeholder: Text(f)),
                )),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Button.primary(
                onPressed: () {
                  closeDrawer(ctx);
                  showToast(
                      context: context,
                      builder: (c, o) => SurfaceCard(
                          child: Basic(
                              title: Text(
                                  '$title submitted successfully'))));
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ToolCard(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [SurfaceTheme.ambientShadow]),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: colors.muted,
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: colors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Text(label,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.foreground))),
          ],
        ),
      ),
    );
  }
}
