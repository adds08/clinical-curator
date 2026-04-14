import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import '../../../domain/providers/booking_flow_provider.dart';
import 'package:cc_ui_kit/widgets/sub_page_scaffold.dart';

class BookingSuccessScreen extends ConsumerWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final booking = ref.watch(bookingFlowProvider);

    final doctorName = booking.selectedDoctor?.practitionerName ?? 'Unknown';
    final specialty = booking.selectedDoctor?.specialty ?? '';
    final orgName = booking.selectedOrgName ??
        booking.selectedDoctor?.organizationName ??
        '';
    final date = booking.selectedDate;
    final slot = booking.selectedSlot;

    return SubPageScaffold(
      title: 'Booking Confirmed',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            const Gap(AppSpacing.xxxl),

            // Success icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.success.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                size: 44,
                color: colors.success,
              ),
            ),
            const Gap(AppSpacing.xxl),

            Text(
              'Appointment Booked!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: colors.foreground,
                letterSpacing: -0.3,
              ),
            ),
            const Gap(AppSpacing.sm),
            Text(
              'Your appointment has been successfully scheduled',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: colors.mutedForeground,
              ),
            ),

            const Gap(AppSpacing.xxxl),

            // Appointment summary card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
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
                  const Gap(AppSpacing.md),
                  Text(
                    'Dr. $doctorName',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: colors.foreground,
                    ),
                  ),
                  if (specialty.isNotEmpty) ...[
                    const Gap(3),
                    Text(
                      specialty,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colors.primary,
                      ),
                    ),
                  ],
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

                  const Gap(AppSpacing.xl),
                  const Divider(),
                  const Gap(AppSpacing.lg),

                  if (date != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            size: 16, color: colors.mutedForeground),
                        const Gap(8),
                        Text(
                          _formatFullDate(date),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colors.foreground,
                          ),
                        ),
                      ],
                    ),
                  if (slot != null) ...[
                    const Gap(AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.access_time_rounded,
                            size: 16, color: colors.mutedForeground),
                        const Gap(8),
                        Text(
                          '${slot.startTime} - ${slot.endTime}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colors.foreground,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const Gap(AppSpacing.xxxl),

            // Actions
            SizedBox(
              width: double.infinity,
              child: Button.primary(
                onPressed: () {
                  ref.read(bookingFlowProvider.notifier).reset();
                  context.go('/booking/my-appointments');
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_month_rounded, size: 18),
                    Gap(8),
                    Text(
                      'View My Appointments',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: Button.outline(
                onPressed: () {
                  ref.read(bookingFlowProvider.notifier).reset();
                  context.go('/booking');
                },
                child: const Text(
                  'Book Another Appointment',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const Gap(AppSpacing.section),
          ],
        ),
      ),
    );
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
