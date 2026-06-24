import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import '../../../domain/providers/schedule_provider.dart';
import '../../../domain/providers/slot_availability_provider.dart';
import 'package:cc_core/widgets/sub_page_scaffold.dart';

class RescheduleScreen extends ConsumerStatefulWidget {
  final String appointmentKey;

  const RescheduleScreen({super.key, required this.appointmentKey});

  @override
  ConsumerState<RescheduleScreen> createState() => _RescheduleScreenState();
}

class _RescheduleScreenState extends ConsumerState<RescheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  int? _selectedSlotKey;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final key = int.tryParse(widget.appointmentKey);
    final appointment =
        key != null ? DatabaseService.appointments.get(key) : null;

    if (appointment == null) {
      return SubPageScaffold(
        title: 'Reschedule',
        child: Center(
          child: Text(
            'Appointment not found',
            style: TextStyle(color: colors.mutedForeground),
          ),
        ),
      );
    }

    final practitionerRef = appointment.practitionerRef;
    final availableDates =
        ref.watch(availableDatesProvider(practitionerRef));
    final slotsForDate = ref.watch(slotsByDateProvider((
      practitionerRef: practitionerRef,
      date: _selectedDate,
    )));

    return SubPageScaffold(
      title: 'Reschedule Appointment',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current appointment info
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl, AppSpacing.md, AppSpacing.xl, 0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: colors.warning.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.info,
                      size: 20, color: colors.warning),
                  const Gap(AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Current: ${_formatDate(appointment.scheduledAt)} at ${_formatTime(appointment.scheduledAt)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: colors.foreground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Gap(AppSpacing.lg),

          // Date selector
          SizedBox(
            height: 88,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl, vertical: AppSpacing.md),
              itemCount: 14,
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index));
                final dateOnly =
                    DateTime(date.year, date.month, date.day);
                final isSelected = _selectedDate.year == dateOnly.year &&
                    _selectedDate.month == dateOnly.month &&
                    _selectedDate.day == dateOnly.day;
                final hasSlots = availableDates.contains(dateOnly);

                return Padding(
                  padding: EdgeInsets.only(
                      right: index < 13 ? AppSpacing.sm : 0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = dateOnly;
                        _selectedSlotKey = null;
                      });
                    },
                    child: Container(
                      width: 56,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.primary
                            : hasSlots
                                ? colors.card
                                : colors.muted.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(14),
                        border: isSelected
                            ? null
                            : hasSlots
                                ? Border.all(
                                    color:
                                        colors.border.withValues(alpha: 0.2))
                                : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _dayName(dateOnly),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? colors.primaryForeground
                                  : colors.mutedForeground,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            '${dateOnly.day}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? colors.primaryForeground
                                  : hasSlots
                                      ? colors.foreground
                                      : colors.mutedForeground,
                            ),
                          ),
                          if (hasSlots && !isSelected) ...[
                            const Gap(4),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: colors.success,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Slots
          Expanded(
            child: slotsForDate.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.calendarX,
                            size: 48, color: colors.mutedForeground),
                        const Gap(AppSpacing.md),
                        Text(
                          'No slots available on this date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl),
                    itemCount: slotsForDate.length,
                    itemBuilder: (context, index) {
                      final slot = slotsForDate[index];
                      final remaining = slot.maxPatients - slot.bookedCount;
                      final isSelected = _selectedSlotKey == slot.key;

                      return Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedSlotKey = slot.key);
                          },
                          child: Container(
                            padding:
                                const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colors.primary.withValues(alpha: 0.08)
                                  : colors.card,
                              borderRadius: BorderRadius.circular(14),
                              border: isSelected
                                  ? Border.all(
                                      color: colors.primary
                                          .withValues(alpha: 0.3))
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Icon(LucideIcons.clock,
                                    size: 20,
                                    color: isSelected
                                        ? colors.primary
                                        : colors.mutedForeground),
                                const Gap(14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${slot.startTime} - ${slot.endTime}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: colors.foreground,
                                        ),
                                      ),
                                      const Gap(2),
                                      Text(
                                        '$remaining slot${remaining == 1 ? '' : 's'} left',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: remaining <= 2
                                              ? colors.warning
                                              : colors.success,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(LucideIcons.circleCheck,
                                      color: colors.primary, size: 22),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Confirm reschedule
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: SizedBox(
              width: double.infinity,
              child: Button.primary(
                onPressed: _selectedSlotKey != null && !_isSubmitting
                    ? () => _reschedule(appointment.key as int)
                    : null,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Confirm Reschedule',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _reschedule(int appointmentKey) async {
    setState(() => _isSubmitting = true);

    try {
      final appointment = DatabaseService.appointments.get(appointmentKey);
      if (appointment == null) return;

      final slot = DatabaseService.scheduleSlots.get(_selectedSlotKey!);
      if (slot == null) return;

      // Parse new time
      final date = _selectedDate;
      final newScheduledAt = DateTime(
          date.year, date.month, date.day,
          _parseHour(slot.startTime), _parseMinute(slot.startTime));

      // Update appointment
      appointment
        ..scheduledAt = newScheduledAt
        ..durationMinutes = slot.slotDurationMinutes
        ..updatedAt = DateTime.now()
        ..syncStatus = 1;
      await appointment.save();

      // Book new slot
      await ref
          .read(scheduleProvider.notifier)
          .bookSlot(_selectedSlotKey!);

      if (mounted) {
        context.pop();
      }
    } catch (_) {
      setState(() => _isSubmitting = false);
    }
  }

  int _parseHour(String time) {
    final parts = time.split(':');
    var hour = int.tryParse(parts[0].trim()) ?? 0;
    if (time.toUpperCase().contains('PM') && hour != 12) hour += 12;
    if (time.toUpperCase().contains('AM') && hour == 12) hour = 0;
    return hour;
  }

  int _parseMinute(String time) {
    final parts = time.split(':');
    if (parts.length < 2) return 0;
    return int.tryParse(parts[1].trim().replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
  }

  String _dayName(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    if (hour == 0) return '12:$minute AM';
    if (hour < 12) return '$hour:$minute AM';
    if (hour == 12) return '12:$minute PM';
    return '${hour - 12}:$minute PM';
  }
}
