import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import '../../../domain/providers/booking_flow_provider.dart';
import '../../../domain/providers/practitioner_role_provider.dart';
import '../../../domain/providers/slot_availability_provider.dart';
import 'package:cc_core/widgets/sub_page_scaffold.dart';
import '../../shared/widgets/practitioner_verified_badge.dart';

class DoctorProfileScreen extends ConsumerWidget {
  final String practitionerRef;

  const DoctorProfileScreen({super.key, required this.practitionerRef});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final roles = ref.watch(rolesByPractitionerProvider(practitionerRef));
    final availableSlots =
        ref.watch(availableSlotsProvider(practitionerRef));
    final bookingState = ref.watch(bookingFlowProvider);

    if (roles.isEmpty) {
      return SubPageScaffold(
        title: 'Doctor Profile',
        child: Center(
          child: Text(
            'Doctor not found',
            style: TextStyle(color: colors.mutedForeground),
          ),
        ),
      );
    }

    final primaryRole = bookingState.selectedDoctor ?? roles.first;
    final name = primaryRole.practitionerName ?? 'Unknown';
    final specialty = primaryRole.specialty ?? 'General Medicine';

    // All organizations this doctor works at
    final organizations = roles
        .where((r) => r.organizationName != null)
        .map((r) => (ref: r.organizationRef, name: r.organizationName!))
        .toSet()
        .toList();

    final selectedOrgRef = bookingState.selectedOrgRef;
    final nextSlotDate =
        availableSlots.isNotEmpty ? availableSlots.first.date : null;

    return SubPageScaffold(
      title: 'Doctor Profile',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        _initials(name),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ),
                  const Gap(AppSpacing.lg),
                  Text(
                    'Dr. $name',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: colors.foreground,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    specialty,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: colors.primary,
                    ),
                  ),
                  const Gap(AppSpacing.sm),
                  PractitionerVerifiedBadge(practitionerRef: practitionerRef),
                  const Gap(AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatBadge(
                        icon: LucideIcons.star,
                        label: '4.8',
                        color: colors.warning,
                      ),
                      const Gap(AppSpacing.md),
                      _StatBadge(
                        icon: LucideIcons.users,
                        label: '500+ patients',
                        color: colors.success,
                      ),
                      const Gap(AppSpacing.md),
                      _StatBadge(
                        icon: LucideIcons.calendar,
                        label: nextSlotDate != null
                            ? 'Next: ${_formatShortDate(nextSlotDate)}'
                            : 'No slots',
                        color: colors.oxygenSat,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Gap(AppSpacing.xxxl),

            // Select Institution
            if (organizations.length > 1) ...[
              Text(
                'SELECT INSTITUTION',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colors.mutedForeground,
                  letterSpacing: 1,
                ),
              ),
              const Gap(AppSpacing.md),
              ...organizations.map((org) {
                final isSelected = selectedOrgRef == org.ref;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: GestureDetector(
                    onTap: () => ref
                        .read(bookingFlowProvider.notifier)
                        .selectOrganization(org.ref, org.name),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.primary.withValues(alpha: 0.08)
                            : colors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: isSelected
                            ? Border.all(
                                color: colors.primary.withValues(alpha: 0.3))
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.hospital,
                            color: isSelected
                                ? colors.primary
                                : colors.mutedForeground,
                            size: 20,
                          ),
                          const Gap(AppSpacing.md),
                          Expanded(
                            child: Text(
                              org.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? colors.primary
                                    : colors.foreground,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(LucideIcons.circleCheck,
                                color: colors.primary, size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const Gap(AppSpacing.xxl),
            ] else if (organizations.length == 1) ...[
              // Auto-select single org
              Builder(builder: (_) {
                if (selectedOrgRef == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ref.read(bookingFlowProvider.notifier).selectOrganization(
                        organizations.first.ref, organizations.first.name);
                  });
                }
                return const SizedBox.shrink();
              }),
            ],

            // Available Slots Preview
            Text(
              'AVAILABILITY',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: colors.mutedForeground,
                letterSpacing: 1,
              ),
            ),
            const Gap(AppSpacing.md),

            if (availableSlots.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Icon(LucideIcons.calendarX,
                        size: 32, color: colors.mutedForeground),
                    const Gap(AppSpacing.sm),
                    Text(
                      'No available slots',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              // Show first 3 available dates
              ...availableSlots.take(3).map((slot) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(LucideIcons.clock,
                                color: colors.primary, size: 20),
                          ),
                          const Gap(AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _formatFullDate(slot.date),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: colors.foreground,
                                  ),
                                ),
                                const Gap(2),
                                Text(
                                  '${slot.startTime} - ${slot.endTime}  •  ${slot.maxPatients - slot.bookedCount} slots left',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],

            const Gap(AppSpacing.xxxl),

            // Book Appointment CTA
            SizedBox(
              width: double.infinity,
              child: Button.primary(
                onPressed: (organizations.length <= 1 ||
                        selectedOrgRef != null)
                    ? () {
                        context.push(
                          '/booking/slots/${Uri.encodeComponent(practitionerRef)}',
                        );
                      }
                    : null,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.calendar, size: 18),
                    Gap(8),
                    Text(
                      'Select Time Slot',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),

            if (organizations.length > 1 && selectedOrgRef == null) ...[
              const Gap(AppSpacing.sm),
              Center(
                child: Text(
                  'Please select an institution first',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.mutedForeground,
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

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : '?';
  }

  String _formatShortDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatFullDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const Gap(4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.foreground,
            ),
          ),
        ],
      ),
    );
  }
}
