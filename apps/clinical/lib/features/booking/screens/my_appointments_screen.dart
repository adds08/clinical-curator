import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_fhir_models/collections/appointment_collection.dart';
import '../../../domain/providers/auth_provider.dart';
import 'package:cc_ui_kit/widgets/sub_page_scaffold.dart';

class MyAppointmentsScreen extends ConsumerStatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  ConsumerState<MyAppointmentsScreen> createState() =>
      _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState
    extends ConsumerState<MyAppointmentsScreen> {
  int _selectedTab = 0;
  static const _tabs = ['Upcoming', 'Past', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final authState = ref.watch(authProvider);
    final patientId = authState.user?.fhirPatientId ?? '';
    final patientRef =
        patientId.isNotEmpty ? 'Patient/$patientId' : '';

    final now = DateTime.now();
    final allAppointments = DatabaseService.appointments.values
        .where((a) => a.patientRef == patientRef)
        .toList()
      ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));

    final upcoming = allAppointments
        .where((a) =>
            a.scheduledAt.isAfter(now) &&
            a.status != 'cancelled' &&
            a.status != 'completed')
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    final past = allAppointments
        .where((a) =>
            a.scheduledAt.isBefore(now) || a.status == 'completed')
        .where((a) => a.status != 'cancelled')
        .toList();

    final cancelled = allAppointments
        .where((a) => a.status == 'cancelled')
        .toList();

    final lists = [upcoming, past, cancelled];
    final currentList = lists[_selectedTab];

    return SubPageScaffold(
      title: 'My Appointments',
      child: Column(
        children: [
          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl, vertical: AppSpacing.md),
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final selected = _selectedTab == i;
                final count = lists[i].length;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = i),
                    child: Container(
                      margin: EdgeInsets.only(
                          right: i < _tabs.length - 1 ? AppSpacing.sm : 0),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: selected
                            ? colors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: selected
                            ? null
                            : Border.all(
                                color:
                                    colors.border.withValues(alpha: 0.3)),
                      ),
                      child: Center(
                        child: Text(
                          '${_tabs[i]} ($count)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? colors.primaryForeground
                                : colors.foreground,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          // List
          Expanded(
            child: currentList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            size: 48, color: colors.mutedForeground),
                        const Gap(AppSpacing.md),
                        Text(
                          'No ${_tabs[_selectedTab].toLowerCase()} appointments',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colors.mutedForeground,
                          ),
                        ),
                        if (_selectedTab == 0) ...[
                          const Gap(AppSpacing.lg),
                          Button.primary(
                            onPressed: () => context.push('/booking'),
                            child: const Text('Book an Appointment'),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl),
                    itemCount: currentList.length,
                    separatorBuilder: (_, _) =>
                        const Gap(AppSpacing.md),
                    itemBuilder: (context, index) {
                      final appt = currentList[index];
                      return _AppointmentCard(
                        appointment: appt,
                        onTap: () {
                          context.push(
                              '/booking/appointment/${appt.key}');
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final AppointmentLocal appointment;
  final VoidCallback onTap;

  const _AppointmentCard({
    required this.appointment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final statusColor = _statusColor(appointment.status, colors);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      _initials(appointment.practitionerName),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.primary,
                      ),
                    ),
                  ),
                ),
                const Gap(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. ${appointment.practitionerName}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: colors.foreground,
                        ),
                      ),
                      const Gap(2),
                      Text(
                        appointment.specialty ?? 'General',
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _statusLabel(appointment.status),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.md),
            Row(
              children: [
                Icon(Icons.calendar_today_rounded,
                    size: 14, color: colors.mutedForeground),
                const Gap(6),
                Text(
                  _formatDate(appointment.scheduledAt),
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.mutedForeground,
                  ),
                ),
                const Gap(AppSpacing.lg),
                Icon(Icons.access_time_rounded,
                    size: 14, color: colors.mutedForeground),
                const Gap(6),
                Text(
                  _formatTime(appointment.scheduledAt),
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.mutedForeground,
                  ),
                ),
                const Gap(AppSpacing.lg),
                Icon(Icons.timer_rounded,
                    size: 14, color: colors.mutedForeground),
                const Gap(6),
                Text(
                  '${appointment.durationMinutes} min',
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
      case 'in-progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'no-show':
        return 'No Show';
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

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
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
