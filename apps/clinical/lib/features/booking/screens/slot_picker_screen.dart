import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import '../../../domain/providers/booking_flow_provider.dart';
import '../../../domain/providers/slot_availability_provider.dart';
import 'package:cc_ui_kit/widgets/sub_page_scaffold.dart';

class SlotPickerScreen extends ConsumerStatefulWidget {
  final String practitionerRef;

  const SlotPickerScreen({super.key, required this.practitionerRef});

  @override
  ConsumerState<SlotPickerScreen> createState() => _SlotPickerScreenState();
}

class _SlotPickerScreenState extends ConsumerState<SlotPickerScreen> {
  DateTime _selectedDate = DateTime.now();
  int? _selectedSlotKey;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final availableDates =
        ref.watch(availableDatesProvider(widget.practitionerRef));
    final slotsForDate = ref.watch(slotsByDateProvider((
      practitionerRef: widget.practitionerRef,
      date: _selectedDate,
    )));

    return SubPageScaffold(
      title: 'Select Time Slot',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date selector — horizontal scrolling dates for next 14 days
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

          // Selected date label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              _formatFullDate(_selectedDate),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.foreground,
              ),
            ),
          ),

          const Gap(AppSpacing.lg),

          // Time slots
          Expanded(
            child: slotsForDate.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.event_busy_rounded,
                            size: 48, color: colors.mutedForeground),
                        const Gap(AppSpacing.md),
                        Text(
                          'No slots available',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colors.mutedForeground,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          'Try selecting a different date',
                          style: TextStyle(
                            fontSize: 13,
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
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? colors.primary
                                            .withValues(alpha: 0.15)
                                        : colors.muted,
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.access_time_rounded,
                                    color: isSelected
                                        ? colors.primary
                                        : colors.mutedForeground,
                                    size: 20,
                                  ),
                                ),
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
                                      const Gap(3),
                                      Row(
                                        children: [
                                          Text(
                                            '${slot.slotDurationMinutes} min',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  colors.mutedForeground,
                                            ),
                                          ),
                                          const Gap(8),
                                          Container(
                                            width: 4,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              color:
                                                  colors.mutedForeground,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const Gap(8),
                                          Text(
                                            '$remaining slot${remaining == 1 ? '' : 's'} left',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: remaining <= 2
                                                  ? colors.warning
                                                  : colors.success,
                                            ),
                                          ),
                                          if (slot.isTelehealth) ...[
                                            const Gap(8),
                                            Icon(
                                                Icons
                                                    .videocam_rounded,
                                                size: 14,
                                                color:
                                                    colors.oxygenSat),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(Icons.check_circle_rounded,
                                      color: colors.primary, size: 22),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Confirm button
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: SizedBox(
              width: double.infinity,
              child: Button.primary(
                onPressed: _selectedSlotKey != null
                    ? () {
                        final slot = slotsForDate.firstWhere(
                            (s) => s.key == _selectedSlotKey);
                        ref
                            .read(bookingFlowProvider.notifier)
                            .selectSlot(slot, _selectedDate, slot.startTime);
                        context.push('/booking/confirm');
                      }
                    : null,
                child: const Text(
                  'Continue to Confirmation',
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

  String _dayName(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String _formatFullDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday',
      'Sunday'
    ];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
}
