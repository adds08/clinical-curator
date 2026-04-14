import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import '../../../domain/providers/appointment_provider.dart';
import '../../../domain/providers/auth_provider.dart';
import '../../../domain/providers/booking_flow_provider.dart';
import '../../../domain/providers/schedule_provider.dart';
import 'package:cc_ui_kit/widgets/sub_page_scaffold.dart';

class BookingConfirmationScreen extends ConsumerStatefulWidget {
  const BookingConfirmationScreen({super.key});

  @override
  ConsumerState<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState
    extends ConsumerState<BookingConfirmationScreen> {
  final _reasonController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final booking = ref.watch(bookingFlowProvider);
    final authState = ref.watch(authProvider);

    final doctorName = booking.selectedDoctor?.practitionerName ?? 'Unknown';
    final specialty = booking.selectedDoctor?.specialty ?? 'General';
    final orgName = booking.selectedOrgName ??
        booking.selectedDoctor?.organizationName ??
        '';
    final slot = booking.selectedSlot;
    final date = booking.selectedDate;
    final patientName = authState.user?.displayName ?? 'Patient';

    return SubPageScaffold(
      title: 'Confirm Booking',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor info card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        _initials(doctorName),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ),
                  const Gap(AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. $doctorName',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: colors.foreground,
                          ),
                        ),
                        const Gap(3),
                        Text(
                          specialty,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colors.primary,
                          ),
                        ),
                        if (orgName.isNotEmpty) ...[
                          const Gap(2),
                          Text(
                            orgName,
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.mutedForeground,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Gap(AppSpacing.xxl),

            // Appointment details
            Text(
              'APPOINTMENT DETAILS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: colors.mutedForeground,
                letterSpacing: 1,
              ),
            ),
            const Gap(AppSpacing.md),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _DetailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date',
                    value: date != null ? _formatFullDate(date) : '--',
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    icon: Icons.access_time_rounded,
                    label: 'Time',
                    value: slot != null
                        ? '${slot.startTime} - ${slot.endTime}'
                        : '--',
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    icon: Icons.timer_rounded,
                    label: 'Duration',
                    value: slot != null
                        ? '${slot.slotDurationMinutes} minutes'
                        : '--',
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    icon: Icons.person_rounded,
                    label: 'Patient',
                    value: patientName,
                  ),
                  if (slot?.isTelehealth == true) ...[
                    const Divider(height: 24),
                    _DetailRow(
                      icon: Icons.videocam_rounded,
                      label: 'Type',
                      value: 'Telemedicine',
                    ),
                  ],
                ],
              ),
            ),

            const Gap(AppSpacing.xxl),

            // Reason for visit
            Text(
              'REASON FOR VISIT',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: colors.mutedForeground,
                letterSpacing: 1,
              ),
            ),
            const Gap(AppSpacing.md),
            TextArea(
              controller: _reasonController,
              placeholder: const Text('Describe your symptoms or reason for the visit...'),
              minLines: 3,
              maxLines: 5,
            ),

            const Gap(AppSpacing.xxxl),

            // Confirm button
            SizedBox(
              width: double.infinity,
              child: Button.primary(
                onPressed: _isSubmitting
                    ? null
                    : () => _confirmBooking(context, ref),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_rounded, size: 18),
                          Gap(8),
                          Text(
                            'Confirm Booking',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
              ),
            ),

            const Gap(AppSpacing.section),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmBooking(BuildContext context, WidgetRef ref) async {
    setState(() => _isSubmitting = true);

    try {
      final booking = ref.read(bookingFlowProvider);
      final authState = ref.read(authProvider);
      final slot = booking.selectedSlot;

      if (slot == null || booking.selectedDate == null) return;

      final patientId = authState.user?.fhirPatientId ?? '';
      final patientRef =
          patientId.isNotEmpty ? 'Patient/$patientId' : 'Patient/unknown';
      final patientName = authState.user?.displayName ?? 'Patient';

      // Build scheduled time from date + slot start time
      final date = booking.selectedDate!;
      final scheduledAt = DateTime(
          date.year, date.month, date.day,
          _parseHour(slot.startTime), _parseMinute(slot.startTime));

      // Create appointment
      await ref.read(appointmentProvider.notifier).bookAppointment(
            patientRef: patientRef,
            practitionerRef: booking.selectedDoctor!.practitionerRef,
            practitionerName:
                booking.selectedDoctor!.practitionerName ?? 'Unknown',
            patientName: patientName,
            appointmentType: booking.appointmentType,
            scheduledAt: scheduledAt,
            durationMinutes: slot.slotDurationMinutes,
            specialty: booking.selectedDoctor!.specialty,
            notes: _reasonController.text.trim().isNotEmpty
                ? _reasonController.text.trim()
                : null,
          );

      // Update slot booked count
      if (slot.key != null) {
        await ref.read(scheduleProvider.notifier).bookSlot(slot.key as int);
      }

      // Set reason in flow state
      if (_reasonController.text.trim().isNotEmpty) {
        ref
            .read(bookingFlowProvider.notifier)
            .setReason(_reasonController.text.trim());
      }

      if (mounted) {
        // ignore: use_build_context_synchronously
        context.go('/booking/success');
      }
    } catch (_) {
      setState(() => _isSubmitting = false);
    }
  }

  int _parseHour(String time) {
    // Parse "08:00 AM" or "02:30 PM" format
    final parts = time.split(':');
    var hour = int.tryParse(parts[0].trim()) ?? 0;
    if (time.toUpperCase().contains('PM') && hour != 12) hour += 12;
    if (time.toUpperCase().contains('AM') && hour == 12) hour = 0;
    return hour;
  }

  int _parseMinute(String time) {
    final parts = time.split(':');
    if (parts.length < 2) return 0;
    return int.tryParse(parts[1].trim().replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : '?';
  }

  String _formatFullDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 18, color: colors.mutedForeground),
        const Gap(AppSpacing.md),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: colors.mutedForeground,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colors.foreground,
          ),
        ),
      ],
    );
  }
}
