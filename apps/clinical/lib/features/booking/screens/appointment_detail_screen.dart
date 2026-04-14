import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_fhir_models/collections/appointment_collection.dart';
import '../../../domain/providers/appointment_provider.dart';
import 'package:cc_ui_kit/widgets/sub_page_scaffold.dart';

class AppointmentDetailScreen extends ConsumerStatefulWidget {
  final String appointmentKey;

  const AppointmentDetailScreen({super.key, required this.appointmentKey});

  @override
  ConsumerState<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState
    extends ConsumerState<AppointmentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final key = int.tryParse(widget.appointmentKey);
    final appointment =
        key != null ? DatabaseService.appointments.get(key) : null;

    if (appointment == null) {
      return SubPageScaffold(
        title: 'Appointment',
        child: Center(
          child: Text(
            'Appointment not found',
            style: TextStyle(color: colors.mutedForeground),
          ),
        ),
      );
    }

    final isCancellable = appointment.status == 'booked' ||
        appointment.status == 'confirmed';
    final isUpcoming = appointment.scheduledAt.isAfter(DateTime.now()) &&
        isCancellable;

    return SubPageScaffold(
      title: 'Appointment Details',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _statusColor(appointment.status, colors)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _statusLabel(appointment.status),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _statusColor(appointment.status, colors),
                  ),
                ),
              ),
            ),
            const Gap(AppSpacing.xxl),

            // Doctor card
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
                        _initials(appointment.practitionerName),
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
                          'Dr. ${appointment.practitionerName}',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: colors.foreground,
                          ),
                        ),
                        const Gap(3),
                        Text(
                          appointment.specialty ?? 'General',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Gap(AppSpacing.xxl),

            // Details
            Text(
              'DETAILS',
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
                    value: _formatFullDate(appointment.scheduledAt),
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    icon: Icons.access_time_rounded,
                    label: 'Time',
                    value: _formatTime(appointment.scheduledAt),
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    icon: Icons.timer_rounded,
                    label: 'Duration',
                    value: '${appointment.durationMinutes} minutes',
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    icon: Icons.medical_services_rounded,
                    label: 'Type',
                    value: _appointmentTypeLabel(appointment.appointmentType),
                  ),
                ],
              ),
            ),

            if (appointment.notes != null &&
                appointment.notes!.isNotEmpty) ...[
              const Gap(AppSpacing.xxl),
              Text(
                'NOTES',
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
                child: Text(
                  appointment.notes!,
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.foreground,
                    height: 1.5,
                  ),
                ),
              ),
            ],

            // Status timeline
            const Gap(AppSpacing.xxl),
            Text(
              'STATUS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: colors.mutedForeground,
                letterSpacing: 1,
              ),
            ),
            const Gap(AppSpacing.md),
            _StatusTimeline(status: appointment.status),

            // Actions
            if (isUpcoming) ...[
              const Gap(AppSpacing.xxxl),
              SizedBox(
                width: double.infinity,
                child: Button.outline(
                  onPressed: () {
                    context.push(
                        '/booking/reschedule/${appointment.key}');
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit_calendar_rounded, size: 18),
                      Gap(8),
                      Text(
                        'Reschedule',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: Button.destructive(
                  onPressed: () => _cancelAppointment(appointment),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel_rounded, size: 18),
                      Gap(8),
                      Text(
                        'Cancel Appointment',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const Gap(AppSpacing.section),
          ],
        ),
      ),
    );
  }

  Future<void> _cancelAppointment(AppointmentLocal appointment) async {
    await ref
        .read(appointmentProvider.notifier)
        .cancelAppointment(appointment.key as int);
    setState(() {});
  }

  Color _statusColor(String status, ColorScheme colors) {
    switch (status) {
      case 'booked':
      case 'confirmed':
        return colors.primary;
      case 'checked-in':
      case 'in-progress':
        return colors.warning;
      case 'completed':
        return colors.success;
      case 'cancelled':
      case 'no-show':
        return colors.destructive;
      default:
        return colors.mutedForeground;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'booked':
        return 'Booked';
      case 'confirmed':
        return 'Confirmed';
      case 'checked-in':
        return 'Checked In';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : '?';
  }

  String _appointmentTypeLabel(String type) {
    switch (type) {
      case 'routine':
        return 'Routine Visit';
      case 'followup':
        return 'Follow-up';
      case 'emergency':
        return 'Emergency';
      case 'telemedicine':
        return 'Telemedicine';
      default:
        return type;
    }
  }

  String _formatFullDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
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
          style: TextStyle(fontSize: 13, color: colors.mutedForeground),
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

class _StatusTimeline extends StatelessWidget {
  final String status;

  const _StatusTimeline({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final steps = ['Booked', 'Confirmed', 'Checked In', 'Completed'];
    final statusIndex = _statusIndex(status);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: List.generate(steps.length, (i) {
          final isCompleted = i <= statusIndex;
          final isCurrent = i == statusIndex;

          return Padding(
            padding:
                EdgeInsets.only(bottom: i < steps.length - 1 ? 16 : 0),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? colors.primary.withValues(alpha: 0.15)
                        : colors.muted,
                    shape: BoxShape.circle,
                    border: isCurrent
                        ? Border.all(color: colors.primary, width: 2)
                        : null,
                  ),
                  child: isCompleted
                      ? Icon(Icons.check_rounded,
                          size: 16, color: colors.primary)
                      : null,
                ),
                const Gap(AppSpacing.md),
                Text(
                  steps[i],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        isCurrent ? FontWeight.w600 : FontWeight.w400,
                    color: isCompleted
                        ? colors.foreground
                        : colors.mutedForeground,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  int _statusIndex(String status) {
    switch (status) {
      case 'booked':
        return 0;
      case 'confirmed':
        return 1;
      case 'checked-in':
        return 2;
      case 'completed':
        return 3;
      case 'cancelled':
        return -1;
      default:
        return 0;
    }
  }
}
