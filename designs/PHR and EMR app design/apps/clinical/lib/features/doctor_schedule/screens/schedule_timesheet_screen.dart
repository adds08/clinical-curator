import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/router/route_names.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_fhir_models/collections/appointment_collection.dart';
import 'package:cc_fhir_models/collections/schedule_slot_collection.dart';
import '../../../domain/providers/auth_provider.dart';
import 'package:cc_data/providers/practitioner_data_provider.dart';

enum _ScheduleView { week, calendar }

class ScheduleTimesheetScreen extends ConsumerStatefulWidget {
  const ScheduleTimesheetScreen({super.key});

  @override
  ConsumerState<ScheduleTimesheetScreen> createState() => _ScheduleTimesheetScreenState();
}

class _ScheduleTimesheetScreenState extends ConsumerState<ScheduleTimesheetScreen> {
  _ScheduleView _viewMode = _ScheduleView.week;
  late DateTime _currentWeekStart;
  int _selectedDateIndex = 0;
  late List<DateTime> _weekDates;
  DateTime? _calendarSelectedDate;

  @override
  void initState() {
    super.initState();
    _currentWeekStart = _findMonday(DateTime.now());
    _buildWeekDates();
    _selectedDateIndex = _weekDates.indexOf(_findToday());
    if (_selectedDateIndex < 0) _selectedDateIndex = 0;
  }

  DateTime _findMonday(DateTime d) => d.subtract(Duration(days: d.weekday - 1));
  DateTime _findToday() {
    final now = DateTime.now();
    return _weekDates.firstWhere((d) => d.year == now.year && d.month == now.month && d.day == now.day, orElse: () => _weekDates[0]);
  }

  void _buildWeekDates() {
    _weekDates = List.generate(7, (i) => _currentWeekStart.add(Duration(days: i)));
  }

  void _previousWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.subtract(const Duration(days: 7));
      _buildWeekDates();
      _selectedDateIndex = 0;
    });
  }

  void _nextWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.add(const Duration(days: 7));
      _buildWeekDates();
      _selectedDateIndex = 0;
    });
  }

  DateTime get _selectedDate => _weekDates[_selectedDateIndex];

  int _slotCountForDate(DateTime date, List<ScheduleSlotLocal> slots) {
    return slots.where((s) => s.date.year == date.year && s.date.month == date.month && s.date.day == date.day).length;
  }

  Map<DateTime, List<ScheduleSlotLocal>> _groupedSlots(List<ScheduleSlotLocal> slots) {
    final map = <DateTime, List<ScheduleSlotLocal>>{};
    for (final s in slots) {
      final day = DateTime(s.date.year, s.date.month, s.date.day);
      map.putIfAbsent(day, () => []).add(s);
    }
    return map;
  }

  void _showSlotInfo() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('What is a Slot?'),
        content: const Text(
          'A Schedule Slot represents a block of time when you are available to see patients. '
          'Each slot defines:\n\n'
          '• Date & time range\n'
          '• Facility location\n'
          '• Duration per patient\n'
          '• Max patients (capacity)\n'
          '• Emergency override toggle\n'
          '• Telehealth option\n\n'
          'Patients book appointments within your available slots. '
          'You can long-press any slot to delete it.',
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Got it'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final user = ref.watch(authProvider).user;
    final rawRef = user?.fhirPractitionerId ?? user?.id ?? '';
    final practRef = rawRef.startsWith('Practitioner/') ? rawRef : 'Practitioner/$rawRef';

    final todayAppts = ref.watch(todayAppointmentsProvider(practRef));
    final opdAppts = ref.watch(todayOpdProvider(practRef));
    final slots = ref.watch(practitionerSlotsProvider(practRef));

    final completedCount = todayAppts.where((a) => a.status == 'completed').length;
    final checkedInCount = todayAppts.where((a) => a.status == 'checked-in').length;
    final bookedCount = todayAppts.where((a) => a.status == 'booked').length;
    final allSlotsCount = slots.length;

    return Container(
      color: colors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -- Compact header row --
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Schedule',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: colors.foreground),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: _showSlotInfo,
                            child: Icon(LucideIcons.info, size: 16, color: colors.mutedForeground),
                          ),
                        ],
                      ),
                      Text(
                        DateFormat('EEEE, MMM d, yyyy').format(DateTime.now()),
                        style: TextStyle(fontSize: 11, color: colors.mutedForeground),
                      ),
                    ],
                  ),
                  Button.primary(
                    onPressed: () => context.push(RouteNames.scheduleEntry),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.plus, size: 14),
                        SizedBox(width: 4),
                        Text('Add Slot', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // -- Mini stats row (compact) --
              SurfaceCard(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _miniStat('${todayAppts.length}', 'Today', colors.primary),
                    _miniStat('$completedCount', 'Done', colors.success),
                    _miniStat('$checkedInCount', 'Queue', colors.warning),
                    _miniStat('$bookedCount', 'Booked', colors.primary),
                    _miniStat('$allSlotsCount', 'Slots', colors.mutedForeground),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // -- View toggle (compact) --
              SurfaceCard(
                padding: EdgeInsets.zero,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _viewMode = _ScheduleView.week),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
                          decoration: BoxDecoration(
                            color: _viewMode == _ScheduleView.week ? colors.primary : Colors.transparent,
                            borderRadius: AppRadius.inputRadius,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.calendarDays,
                                size: 14,
                                color: _viewMode == _ScheduleView.week ? colors.primaryForeground : colors.mutedForeground,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _viewMode = _ScheduleView.calendar;
                          _calendarSelectedDate ??= _selectedDate;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
                          decoration: BoxDecoration(
                            color: _viewMode == _ScheduleView.calendar ? colors.primary : Colors.transparent,
                            borderRadius: AppRadius.inputRadius,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.calendar,
                                size: 14,
                                color: _viewMode == _ScheduleView.calendar ? colors.primaryForeground : colors.mutedForeground,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // -- Week / Calendar --
              if (_viewMode == _ScheduleView.week) _buildWeekView(slots) else _buildCalendarView(slots, todayAppts),
              const SizedBox(height: AppSpacing.lg),

              // -- OPD Queue (compact) --
              if (opdAppts.isNotEmpty) ...[
                Text(
                  'OPD Queue',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: colors.foreground, letterSpacing: -0.3),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...opdAppts
                    .take(3)
                    .map(
                      (a) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _buildCompactApptCard(a),
                      ),
                    ),
                if (opdAppts.length > 3) ...[
                  const SizedBox(height: 2),
                  Text('+ ${opdAppts.length - 3} more', style: TextStyle(fontSize: 11, color: colors.mutedForeground)),
                ],
                const SizedBox(height: AppSpacing.md),
              ],

              // -- Today's Agenda (compact) --
              if (todayAppts.isNotEmpty) ...[
                Text(
                  "Today's Agenda",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: colors.foreground, letterSpacing: -0.3),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...todayAppts
                    .take(4)
                    .map(
                      (a) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _buildCompactApptCard(a),
                      ),
                    ),
                if (todayAppts.length > 4) ...[
                  const SizedBox(height: 2),
                  Text('+ ${todayAppts.length - 4} more', style: TextStyle(fontSize: 11, color: colors.mutedForeground)),
                ],
                const SizedBox(height: AppSpacing.md),
              ],

              // -- Schedule slots --
              if (slots.isNotEmpty) ...[
                Row(
                  children: [
                    Text(
                      'Schedule Slots',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: colors.foreground, letterSpacing: -0.3),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: colors.muted, borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        '$allSlotsCount',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: colors.mutedForeground),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                ..._groupedSlots(slots).entries.map(
                  (entry) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: 4),
                        child: Text(
                          DateFormat('EEEE, MMM d, yyyy').format(entry.key),
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: colors.mutedForeground),
                        ),
                      ),
                      ...entry.value.map(
                        (s) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _buildCompactSlotCard(s),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                _buildEmptyState('No schedule slots yet', LucideIcons.calendarPlus),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: Button.primary(
                    onPressed: () => context.push(RouteNames.scheduleEntry),
                    child: const Text('Create Your First Slot'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniStat(String value, String label, Color color) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colors.foreground, height: 1.2),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: color),
        ),
      ],
    );
  }

  // -- Week view --
  Widget _buildWeekView(List<ScheduleSlotLocal> slots) {
    final colors = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final weekLabel = '${DateFormat('MMM d').format(_weekDates.first)} – ${DateFormat('MMM d').format(_weekDates.last)}';
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: _previousWeek,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: colors.card, borderRadius: AppRadius.inputRadius),
                child: Icon(LucideIcons.chevronLeft, size: 16, color: colors.foreground),
              ),
            ),
            Text(
              weekLabel,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.foreground),
            ),
            GestureDetector(
              onTap: _nextWeek,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: colors.card, borderRadius: AppRadius.inputRadius),
                child: Icon(LucideIcons.chevronRight, size: 16, color: colors.foreground),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 76,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _weekDates.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
            itemBuilder: (ctx, i) {
              final d = _weekDates[i];
              final isSelected = i == _selectedDateIndex;
              final isToday = d.year == now.year && d.month == now.month && d.day == now.day;
              final count = _slotCountForDate(d, slots);
              return GestureDetector(
                onTap: () => setState(() => _selectedDateIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 46,
                  decoration: BoxDecoration(color: isSelected ? colors.primary : colors.card, borderRadius: AppRadius.cardRadius),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('E').format(d),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? colors.primaryForeground.withValues(alpha: 0.7) : colors.mutedForeground,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        width: 28,
                        height: 28,
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
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? colors.primaryForeground : colors.foreground,
                          ),
                        ),
                      ),
                      if (count > 0) ...[
                        const SizedBox(height: 1),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0),
                          decoration: BoxDecoration(
                            color: isSelected ? colors.primaryForeground.withValues(alpha: 0.3) : colors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$count',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? colors.primaryForeground : colors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // -- Calendar view --
  Widget _buildCalendarView(List<ScheduleSlotLocal> slots, List<AppointmentLocal> appts) {
    final now = DateTime.now();
    return SurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Calendar(
        view: CalendarView.fromDateTime(_calendarSelectedDate ?? now),
        selectionMode: CalendarSelectionMode.single,
        value: _calendarSelectedDate != null ? CalendarValue.single(_calendarSelectedDate!) : null,
        onChanged: (value) {
          if (value is SingleCalendarValue) {
            setState(() {
              _calendarSelectedDate = value.date;
              _currentWeekStart = _findMonday(value.date);
              _buildWeekDates();
              _selectedDateIndex = _weekDates.indexOf(value.date);
              if (_selectedDateIndex < 0) _selectedDateIndex = 0;
            });
          }
        },
        stateBuilder: (date) {
          final isPast = date.isBefore(now.subtract(const Duration(days: 1)));
          if (isPast) return DateState.disabled;
          return DateState.enabled;
        },
      ),
    );
  }

  // -- Compact appointment card --
  Widget _buildCompactApptCard(AppointmentLocal appt) {
    final colors = Theme.of(context).colorScheme;
    final timeStr = DateFormat('hh:mm a').format(appt.scheduledAt);
    final initials = appt.patientName.split(' ').where((w) => w.isNotEmpty).take(2).map((w) => w[0].toUpperCase()).join();

    Color dotColor;
    switch (appt.status) {
      case 'checked-in':
        dotColor = colors.warning;
        break;
      case 'completed':
        dotColor = colors.success;
        break;
      case 'cancelled':
        dotColor = colors.destructive;
        break;
      default:
        dotColor = colors.primary;
    }

    return GestureDetector(
      onTap: () {
        final patientId = appt.patientRef.replaceFirst('Patient/', '');
        context.push('/patient-detail/$patientId');
      },
      child: Card(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              timeStr,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: colors.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Avatar(initials: initials, size: 28),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                appt.patientName,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.foreground),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -- Compact slot card --
  Widget _buildCompactSlotCard(ScheduleSlotLocal slot) {
    final colors = Theme.of(context).colorScheme;
    final dateStr = DateFormat('EEE, MMM d').format(slot.date);
    final remaining = slot.maxPatients - slot.bookedCount;
    final fillRatio = slot.maxPatients > 0 ? slot.bookedCount / slot.maxPatients : 0.0;

    return GestureDetector(
      onLongPress: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Slot?'),
            content: Text('Remove $dateStr ${slot.startTime}–${slot.endTime}?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text('Delete', style: TextStyle(color: colors.destructive)),
              ),
            ],
          ),
        );
        if (confirmed == true) {
          await slot.delete();
          ref.read(slotRefreshProvider.notifier).state++;
        }
      },
      child: Card(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: colors.primary.withValues(alpha: 0.08), borderRadius: AppRadius.inputRadius),
                  child: Icon(LucideIcons.clock, color: colors.primary, size: 16),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${slot.startTime} – ${slot.endTime}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.foreground),
                      ),
                      Row(
                        children: [
                          Text(slot.facilityName ?? 'Clinic', style: TextStyle(fontSize: 10, color: colors.mutedForeground)),
                          if (slot.isTelehealth) ...[const SizedBox(width: 6), Icon(LucideIcons.video, size: 10, color: colors.primary)],
                          if (slot.isEmergencyOverride) ...[
                            const SizedBox(width: 6),
                            Icon(LucideIcons.shieldAlert, size: 10, color: colors.warning),
                          ],
                        ],
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
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: remaining > 0 ? colors.success : colors.destructive,
                      ),
                    ),
                    Text('${slot.bookedCount}/${slot.maxPatients}', style: TextStyle(fontSize: 10, color: colors.mutedForeground)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: fillRatio,
                backgroundColor: colors.muted.withValues(alpha: 0.3),
                color: fillRatio > 0.8 ? colors.destructive : (fillRatio > 0.5 ? colors.warning : colors.success),
                minHeight: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      padding: const EdgeInsets.all(AppSpacing.xl),
      fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 28, color: colors.mutedForeground.withValues(alpha: 0.4)),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.mutedForeground),
            ),
          ],
        ),
      ),
    );
  }
}
