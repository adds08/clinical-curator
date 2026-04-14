import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/theme/clinical_colors.dart';

class ServicesHubScreen extends StatelessWidget {
  const ServicesHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    // Sub-pages are now root-level routes; no basePath needed.

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Services',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: colors.foreground,
                letterSpacing: -0.3,
              ),
            ),
            const Gap(4),
            Text(
              'Browse available medical services',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: colors.mutedForeground,
              ),
            ),

            const Gap(28),

            // Emergency banner
            GestureDetector(
              onTap: () => context.push('/service/ambulance'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colors.destructive,
                      colors.destructive.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.emergency_rounded,
                          color: Colors.white, size: 26),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Emergency Ambulance',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            'Request immediate medical transport',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.white, size: 16),
                  ],
                ),
              ),
            ),

            const Gap(24),

            // Main services
            Text(
              'QUICK ACCESS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: colors.mutedForeground,
                letterSpacing: 1,
              ),
            ),
            const Gap(14),

            _ServiceRow(
              icon: Icons.calendar_month_rounded,
              title: 'Book Appointment',
              subtitle: 'Find a doctor and book a visit',
              color: const Color(0xFF2563EB),
              onTap: () => context.push('/booking'),
            ),
            const Gap(10),
            _ServiceRow(
              icon: Icons.videocam_rounded,
              title: 'Telemedicine',
              subtitle: 'Video consult with specialists',
              color: const Color(0xFF7C3AED),
              onTap: () => context.push('/service/telemedicine'),
            ),
            const Gap(10),
            _ServiceRow(
              icon: Icons.tips_and_updates_rounded,
              title: 'Health Tips',
              subtitle: 'Evidence-based wellness articles',
              color: colors.temperature,
              onTap: () => context.push('/service/health-tips'),
            ),

            const Gap(28),

            Text(
              'MORE SERVICES',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: colors.mutedForeground,
                letterSpacing: 1,
              ),
            ),
            const Gap(14),

            Row(
              children: [
                Expanded(
                  child: _ServiceCard(
                    icon: Icons.science_rounded,
                    label: 'Lab Booking',
                    description: 'Book tests nearby',
                    color: colors.oxygenSat,
                    onTap: () => context.push('/service/lab-booking'),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: _ServiceCard(
                    icon: Icons.medication_rounded,
                    label: 'Pharmacy',
                    description: 'Order medicines',
                    color: colors.success,
                    onTap: () => context.push('/service/pharmacy'),
                  ),
                ),
              ],
            ),
            const Gap(12),
            Row(
              children: [
                Expanded(
                  child: _ServiceCard(
                    icon: Icons.local_hospital_rounded,
                    label: 'Hospitals',
                    description: 'Find nearby',
                    color: const Color(0xFF0D9488),
                    onTap: () => context.push('/service/hospitals'),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: _ServiceCard(
                    icon: Icons.shield_rounded,
                    label: 'Insurance',
                    description: 'Claims & billing',
                    color: const Color(0xFF4F46E5),
                    onTap: () => context.push('/service/insurance'),
                  ),
                ),
              ],
            ),

            const Gap(40),
          ],
        ),
      ),
    );
  }

}

/// A row-style service card — icon, title, subtitle, arrow.
class _ServiceRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ServiceRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.foreground,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    subtitle,
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
    );
  }
}

/// A card-style service tile — icon, label, description.
class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const Gap(12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.foreground,
              ),
            ),
            const Gap(2),
            Text(
              description,
              style: TextStyle(
                fontSize: 11,
                color: colors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
