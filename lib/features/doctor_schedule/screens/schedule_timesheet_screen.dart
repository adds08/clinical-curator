import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/surface_theme.dart';
import '../../../core/theme/clinical_colors.dart';
import '../../../data/collections/appointment_collection.dart';
import '../../../data/collections/schedule_slot_collection.dart';
import '../../../domain/providers/auth_provider.dart';
import '../../../domain/providers/practitioner_data_provider.dart';

class ScheduleTimesheetScreen extends ConsumerStatefulWidget {
  const ScheduleTimesheetScreen({super.key});

  @override
  ConsumerState<ScheduleTimesheetScreen> createState() =>
      _ScheduleTimesheetScreenState();
}

class _ScheduleTimesheetScreenState
    extends ConsumerState<ScheduleTimesheetScreen> {
  int _selectedDateIndex = 0; // index into _weekDates

  late final List<DateTime> _weekDates;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Build Mon-Sat of the current week
    final monday = now.subtract(Duration(days: now.weekday - 1));
    _weekDates = List.generate(6, (i) => monday.add(Duration(days: i)));
    // Select today by default
    _selectedDateIndex = _weekDates.indexWhere((d) =>
        d.year == now.year && d.month == now.month && d.day == now.day);
    if (_selectedDateIndex < 0) _selectedDateIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final colors = shadcn.Theme.of(context).colorScheme;
    final user = ref.watch(authProvider).user;
    final practRef = user?.fhirPractitionerId ?? '';

    final todayAppts = ref.watch(todayAppointmentsProvider(practRef));
    final opdAppts = ref.watch(todayOpdProvider(practRef));
    final slots = ref.watch(practitionerSlotsProvider(practRef));

    // Stats
    final completedCount =
        todayAppts.where((a) => a.status == 'completed').length;
    final checkedInCount =
        todayAppts.where((a) => a.status == 'checked-in').length;
    final bookedCount =
        todayAppts.where((a) => a.status == 'booked').length;

    return Container(
      color: colors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -- Header --
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Schedule',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: colors.foreground,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Manage your availability & view today\'s patients',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.mutedForeground,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('EEEE, MMM d').format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  shadcn.Button.primary(
                    onPressed: () => context.push(RouteNames.scheduleEntry),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 16),
                        SizedBox(width: 4),
                        Text('Add Slot',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // -- Date strip --
              _buildDateStrip(),
              const SizedBox(height: AppSpacing.xxl),

              // -- Today's summary card --
              _buildSummaryCard(
                  todayAppts.length, completedCount, checkedInCount, bookedCount),
              const SizedBox(height: AppSpacing.xxl),

              // -- OPD Queue Section --
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'OPD Queue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colors.foreground,
                      letterSpacing: -0.3,
                    ),
                  ),
                  shadcn.PrimaryBadge(
                    child: Text('${opdAppts.length} PATIENTS'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              if (opdAppts.isEmpty)
                _buildEmptyState('No OPD patients today', Icons.event_available)
              else
                ...opdAppts.map((a) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _buildOpdCard(a),
                    )),

              const SizedBox(height: AppSpacing.xxl),

              // -- Full Agenda --
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Agenda",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colors.foreground,
                      letterSpacing: -0.3,
                    ),
                  ),
                  shadcn.SecondaryBadge(
                    child: Text('${todayAppts.length} TOTAL'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              if (todayAppts.isEmpty)
                _buildEmptyState(
                    'No appointments scheduled', Icons.calendar_today)
              else
                ...todayAppts.map((a) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _buildAgendaBlock(a),
                    )),

              const SizedBox(height: AppSpacing.xxl),

              // -- Upcoming Slots --
              if (slots.isNotEmpty) ...[
                Text(
                  'Upcoming Slots',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colors.foreground,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ...slots.map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _buildSlotCard(s),
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // -- Date strip --
  Widget _buildDateStrip() {
    final colors = shadcn.Theme.of(context).colorScheme;
    final now = DateTime.now();
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _weekDates.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final d = _weekDates[index];
          final isSelected = index == _selectedDateIndex;
          final isToday =
              d.year == now.year && d.month == now.month && d.day == now.day;
          return GestureDetector(
            onTap: () => setState(() => _selectedDateIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52,
              decoration: BoxDecoration(
                color: isSelected ? colors.primary : colors.card,
                borderRadius: AppRadius.cardRadius,
              ),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(d),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? colors.primaryForeground.withValues(alpha: 0.7)
                          : colors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? colors.primaryForeground.withValues(alpha: 0.2)
                          : isToday
                              ? colors.primary.withValues(alpha: 0.1)
                              : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${d.day}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? colors.primaryForeground
                            : colors.foreground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // -- Summary card --
  Widget _buildSummaryCard(
      int total, int completed, int checkedIn, int booked) {
    final colors = shadcn.Theme.of(context).colorScheme;
    return shadcn.Card(
      padding: const EdgeInsets.all(AppSpacing.xl),
      fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TODAY'S OVERVIEW",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: colors.mutedForeground,
                  letterSpacing: 1,
                ),
              ),
              shadcn.SecondaryBadge(
                child: Text(DateFormat('MMM d').format(DateTime.now())),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '$total appointments',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: colors.foreground,
              height: 1,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          shadcn.Progress(
              progress: total > 0 ? completed / total : 0),
          const SizedBox(height: AppSpacing.lg),
          _buildStatRow('Completed', '$completed', colors.success),
          const SizedBox(height: AppSpacing.sm),
          _buildStatRow('Checked In', '$checkedIn', colors.warning),
          const SizedBox(height: AppSpacing.sm),
          _buildStatRow('Upcoming', '$booked', colors.primary),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color dotColor) {
    final colors = shadcn.Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
            width: 8,
            height: 8,
            decoration:
                BoxDecoration(color: dotColor, shape: BoxShape.circle)),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: colors.mutedForeground)),
        ),
        Text(value,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: colors.foreground)),
      ],
    );
  }

  // -- OPD Card --
  Widget _buildOpdCard(AppointmentLocal appt) {
    final colors = shadcn.Theme.of(context).colorScheme;
    final timeStr = DateFormat('hh:mm a').format(appt.scheduledAt);

    Color statusColor;
    String statusLabel;
    switch (appt.status) {
      case 'checked-in':
        statusColor = colors.warning;
        statusLabel = 'CHECKED IN';
        break;
      case 'completed':
        statusColor = colors.success;
        statusLabel = 'DONE';
        break;
      case 'cancelled':
        statusColor = colors.destructive;
        statusLabel = 'CANCELLED';
        break;
      default:
        statusColor = colors.primary;
        statusLabel = 'WAITING';
    }

    final initials = appt.patientName
        .split(' ')
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    return GestureDetector(
      onTap: () {
        final patientId = appt.patientRef.replaceFirst('Patient/', '');
        context.push('/patient-detail/$patientId');
      },
      child: shadcn.Card(
        padding: const EdgeInsets.all(AppSpacing.lg),
        fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
        child: Row(
          children: [
            // Token / Time
            SizedBox(
              width: 56,
              child: Column(
                children: [
                  Text(
                    timeStr,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${appt.durationMinutes}m',
                    style: TextStyle(
                        fontSize: 10, color: colors.mutedForeground),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Avatar
            shadcn.Avatar(initials: initials, size: 36),
            const SizedBox(width: AppSpacing.md),
            // Patient info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appt.patientName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colors.foreground,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    appt.notes ?? appt.specialty ?? 'OPD Visit',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.mutedForeground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Status badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: AppRadius.chipRadius,
              ),
              child: Text(
                statusLabel,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -- Agenda block (all appointment types) --
  Widget _buildAgendaBlock(AppointmentLocal appt) {
    final colors = shadcn.Theme.of(context).colorScheme;
    final timeStr = DateFormat('hh:mm a').format(appt.scheduledAt);

    IconData icon;
    switch (appt.appointmentType) {
      case 'telemedicine':
        icon = Icons.videocam;
        break;
      case 'opd':
        icon = Icons.person;
        break;
      default:
        icon = Icons.local_hospital;
    }

    Widget? badge;
    switch (appt.status) {
      case 'checked-in':
        badge = Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: colors.warning.withValues(alpha: 0.1),
            borderRadius: AppRadius.chipRadius,
          ),
          child: Text('IN QUEUE',
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: colors.warning,
                  letterSpacing: 0.5)),
        );
        break;
      case 'completed':
        badge = Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: colors.successBackground,
            borderRadius: AppRadius.chipRadius,
          ),
          child: Text('DONE',
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: colors.success,
                  letterSpacing: 0.5)),
        );
        break;
      case 'booked':
        if (appt.appointmentType == 'telemedicine') {
          badge = shadcn.PrimaryBadge(child: const Text('VIRTUAL'));
        }
        break;
      default:
        break;
    }

    return GestureDetector(
      onTap: () {
        final patientId = appt.patientRef.replaceFirst('Patient/', '');
        context.push('/patient-detail/$patientId');
      },
      child: shadcn.Card(
        padding: const EdgeInsets.all(AppSpacing.lg),
        fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 64,
              child: Text(
                timeStr,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: colors.primary),
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.08),
                borderRadius: AppRadius.inputRadius,
              ),
              child: Icon(icon, color: colors.primary, size: 18),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          appt.patientName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: colors.foreground,
                          ),
                        ),
                      ),
                      if (badge != null) badge,
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _appointmentTypeLabel(appt.appointmentType),
                    style: TextStyle(
                        fontSize: 12, color: colors.mutedForeground),
                  ),
                  if (appt.notes != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      appt.notes!,
                      style: TextStyle(
                          fontSize: 11, color: colors.mutedForeground),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -- Slot card --
  Widget _buildSlotCard(ScheduleSlotLocal slot) {
    final colors = shadcn.Theme.of(context).colorScheme;
    final dateStr = DateFormat('EEE, MMM d').format(slot.date);
    final remaining = slot.maxPatients - slot.bookedCount;
    return shadcn.Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.08),
              borderRadius: AppRadius.inputRadius,
            ),
            child:
                Icon(Icons.calendar_month, color: colors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$dateStr  •  ${slot.startTime} – ${slot.endTime}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colors.foreground,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${slot.facilityName ?? "Clinic"} • ${slot.slotDurationMinutes}m slots',
                  style: TextStyle(
                      fontSize: 12, color: colors.mutedForeground),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$remaining left',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: remaining > 0 ? colors.success : colors.destructive,
                ),
              ),
              Text(
                '${slot.bookedCount}/${slot.maxPatients}',
                style:
                    TextStyle(fontSize: 11, color: colors.mutedForeground),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // -- Empty state --
  Widget _buildEmptyState(String message, IconData icon) {
    final colors = shadcn.Theme.of(context).colorScheme;
    return shadcn.Card(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
      child: Center(
        child: Column(
          children: [
            Icon(icon,
                size: 36,
                color: colors.mutedForeground.withValues(alpha: 0.4)),
            const SizedBox(height: AppSpacing.md),
            Text(message,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.mutedForeground)),
          ],
        ),
      ),
    );
  }

  String _appointmentTypeLabel(String type) {
    switch (type) {
      case 'opd':
        return 'OPD Consultation';
      case 'telemedicine':
        return 'Telemedicine';
      case 'in-person':
        return 'In-Person Visit';
      default:
        return type;
    }
  }
}
