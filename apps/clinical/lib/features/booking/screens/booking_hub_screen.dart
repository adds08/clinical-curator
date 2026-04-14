import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import '../../../domain/providers/booking_flow_provider.dart';
import 'package:cc_ui_kit/widgets/sub_page_scaffold.dart';

class BookingHubScreen extends ConsumerWidget {
  const BookingHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    return SubPageScaffold(
      title: 'Book Appointment',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How would you like to book?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: colors.foreground,
                letterSpacing: -0.3,
              ),
            ),
            const Gap(6),
            Text(
              'Choose a path that works best for you',
              style: TextStyle(
                fontSize: 14,
                color: colors.mutedForeground,
              ),
            ),
            const Gap(AppSpacing.xxl),

            // Find a Doctor
            _BookingPathCard(
              icon: Icons.person_search_rounded,
              title: 'Find a Doctor',
              description:
                  'Search by name, specialty, or availability. Book directly with your preferred practitioner.',
              gradient: [
                colors.primary,
                colors.primary.withValues(alpha: 0.8),
              ],
              onTap: () {
                ref.read(bookingFlowProvider.notifier).reset();
                context.push('/booking/doctor-search');
              },
            ),
            const Gap(AppSpacing.lg),

            // Find a Hospital
            _BookingPathCard(
              icon: Icons.local_hospital_rounded,
              title: 'Find a Hospital',
              description:
                  'Browse hospitals first, then choose from doctors available at that facility.',
              gradient: const [
                Color(0xFF0D9488),
                Color(0xFF14B8A6),
              ],
              onTap: () {
                ref.read(bookingFlowProvider.notifier).reset();
                context.push('/service/hospitals');
              },
            ),
            const Gap(AppSpacing.lg),

            // Describe Symptoms
            _BookingPathCard(
              icon: Icons.psychology_rounded,
              title: 'Describe Symptoms',
              description:
                  'Tell us what you\'re experiencing and we\'ll recommend the right specialist for you.',
              gradient: [
                const Color(0xFF7C3AED),
                const Color(0xFF7C3AED).withValues(alpha: 0.8),
              ],
              isComingSoon: true,
              onTap: () {},
            ),

            const Gap(AppSpacing.xxxl),

            // Quick action: My Appointments
            GestureDetector(
              onTap: () => context.push('/booking/my-appointments'),
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
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.calendar_month_rounded,
                          color: colors.primary, size: 22),
                    ),
                    const Gap(14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Appointments',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: colors.foreground,
                            ),
                          ),
                          const Gap(2),
                          Text(
                            'View upcoming and past appointments',
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: colors.mutedForeground),
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
}

class _BookingPathCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradient;
  final VoidCallback onTap;
  final bool isComingSoon;

  const _BookingPathCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    required this.onTap,
    this.isComingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isComingSoon ? null : onTap,
      child: Opacity(
        opacity: isComingSoon ? 0.6 : 1.0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const Spacer(),
                  if (isComingSoon)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Coming Soon',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    )
                  else
                    Icon(Icons.arrow_forward_rounded,
                        color: Colors.white.withValues(alpha: 0.7), size: 22),
                ],
              ),
              const Gap(AppSpacing.lg),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const Gap(6),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
