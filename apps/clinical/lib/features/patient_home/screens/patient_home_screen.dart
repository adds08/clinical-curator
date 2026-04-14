import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_core/router/route_names.dart';
import '../../../domain/providers/auth_provider.dart';
import '../../../domain/providers/patient_data_provider.dart';

/// Typography scale used on this screen:
///   24px w700  — page greeting
///   16px w600  — section titles
///   14px w500  — body, labels, buttons
///   12px w500  — captions, units, metadata
///
/// Radius: 16px cards, 8px small elements
/// Spacing: 20px screen padding, 32px between sections, 16px between cards

class PatientHomeScreen extends ConsumerWidget {
  const PatientHomeScreen({super.key});

  String _greetingText() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final userName = user?.displayName ?? 'User';
    final firstName = userName.split(' ').first;
    final rawPatientId = user?.fhirPatientId ?? '';
    final patientRef = rawPatientId.isNotEmpty ? 'Patient/$rawPatientId' : '';

    final heartRate = patientRef.isNotEmpty
        ? ref.watch(latestHeartRateProvider(patientRef))
        : '--';
    final bloodPressure = patientRef.isNotEmpty
        ? ref.watch(latestBloodPressureProvider(patientRef))
        : '--/--';

    final colors = Theme.of(context).colorScheme;
    final greeting = _greetingText();

    return Scaffold(
      backgroundColor: colors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroBentoGrid(
                greeting: greeting,
                firstName: firstName,
                fullName: userName,
                healthId: user?.healthId,
                email: user?.email,
                heartRate: heartRate,
                bloodPressure: bloodPressure,
                onViewDetails: () => _openVitalsDrawer(context, heartRate, bloodPressure),
              ),
              const SizedBox(height: 24),
              const _ProfileCompletion(),
              const SizedBox(height: 32),
              const _HealthAlerts(),
              const SizedBox(height: 32),
              const _Services(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _openVitalsDrawer(BuildContext context, String heartRate, String bloodPressure) {
    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (_) => _VitalsDrawer(heartRate: heartRate, bloodPressure: bloodPressure),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero Bento Grid — staggered card layout with greeting, user info & vitals
// ─────────────────────────────────────────────────────────────────────────────

class _HeroBentoGrid extends StatelessWidget {
  final String greeting;
  final String firstName;
  final String fullName;
  final String? healthId;
  final String? email;
  final String heartRate;
  final String bloodPressure;
  final VoidCallback onViewDetails;

  const _HeroBentoGrid({
    required this.greeting,
    required this.firstName,
    required this.fullName,
    this.healthId,
    this.email,
    required this.heartRate,
    required this.bloodPressure,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    const gap = 12.0;

    return Column(
      children: [
        // Row 1: Greeting (wide) + Avatar card (compact)
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: _GreetingCard(
                  greeting: greeting,
                  firstName: firstName,
                  healthId: healthId,
                ),
              ),
              const SizedBox(width: gap),
              Expanded(
                flex: 2,
                child: _AvatarCard(fullName: fullName, email: email),
              ),
            ],
          ),
        ),
        const SizedBox(height: gap),

        // Row 2: Heart Rate (tall) + BP & Temp (stacked)
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _VitalCardLarge(
                  icon: Icons.favorite_rounded,
                  color: Theme.of(context).colorScheme.heartRate,
                  bg: Theme.of(context).colorScheme.heartBg,
                  value: heartRate,
                  unit: 'bpm',
                  label: 'Heart Rate',
                  trend: '+3%',
                  trendUp: true,
                ),
              ),
              const SizedBox(width: gap),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _VitalCardCompact(
                        icon: Icons.water_drop_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        bg: Theme.of(context).colorScheme.oxygenBg,
                        value: bloodPressure,
                        unit: 'mmHg',
                        label: 'Blood Pressure',
                      ),
                    ),
                    const SizedBox(height: gap),
                    Expanded(
                      child: _VitalCardCompact(
                        icon: Icons.thermostat_rounded,
                        color: Theme.of(context).colorScheme.temperature,
                        bg: Theme.of(context).colorScheme.tempBg,
                        value: '98.6',
                        unit: '\u00B0F',
                        label: 'Temperature',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: gap),

        // Row 3: SpO2 + Resp Rate + View Details button
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _VitalCardCompact(
                  icon: Icons.air_rounded,
                  color: Theme.of(context).colorScheme.oxygenSat,
                  bg: Theme.of(context).colorScheme.oxygenBg,
                  value: '98',
                  unit: '%',
                  label: 'SpO\u2082',
                ),
              ),
              const SizedBox(width: gap),
              Expanded(
                child: _VitalCardCompact(
                  icon: Icons.monitor_heart_rounded,
                  color: const Color(0xFF7C3AED),
                  bg: Theme.of(context).colorScheme.sleepBg,
                  value: '16',
                  unit: '/min',
                  label: 'Resp Rate',
                ),
              ),
              const SizedBox(width: gap),
              Expanded(
                child: _ViewDetailsCard(onTap: onViewDetails),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Greeting Card — large, prominent card with greeting & health ID
// ─────────────────────────────────────────────────────────────────────────────

class _GreetingCard extends StatelessWidget {
  final String greeting;
  final String firstName;
  final String? healthId;
  const _GreetingCard({required this.greeting, required this.firstName, this.healthId});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = colors.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1E3A5F), const Color(0xFF0F2744)]
              : [const Color(0xFF004AC6), const Color(0xFF2563EB)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting,',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.8)),
              ),
              const SizedBox(height: 4),
              Text(
                firstName,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.5),
              ),
            ],
          ),
          if (healthId != null)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                healthId!,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.9), fontFamily: 'monospace', letterSpacing: 0.5),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Avatar Card — user avatar with initials, date, and status dot
// ─────────────────────────────────────────────────────────────────────────────

class _AvatarCard extends StatelessWidget {
  final String fullName;
  final String? email;
  const _AvatarCard({required this.fullName, this.email});

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final now = DateTime.now();
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateStr = '${months[now.month - 1]} ${now.day}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [SurfaceTheme.ambientShadow],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colors.primary.withValues(alpha: 0.15),
                      colors.primary.withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    _initials(fullName),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: colors.primary),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: colors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.card, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(dateStr, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.foreground)),
          const SizedBox(height: 2),
          Text('Patient', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: colors.mutedForeground)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Vital Card — Large (tall, for hero metric like heart rate)
// ─────────────────────────────────────────────────────────────────────────────

class _VitalCardLarge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;
  final String value;
  final String unit;
  final String label;
  final String? trend;
  final bool trendUp;

  const _VitalCardLarge({
    required this.icon,
    required this.color,
    required this.bg,
    required this.value,
    required this.unit,
    required this.label,
    this.trend,
    this.trendUp = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (trendUp ? colors.success : colors.destructive).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trendUp ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                        size: 12,
                        color: trendUp ? colors.success : colors.destructive,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        trend!,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: trendUp ? colors.success : colors.destructive),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: colors.foreground, height: 1, letterSpacing: -0.5)),
          const SizedBox(height: 4),
          Text(unit, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: colors.mutedForeground)),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Vital Card — Compact (for smaller metrics)
// ─────────────────────────────────────────────────────────────────────────────

class _VitalCardCompact extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;
  final String value;
  final String unit;
  final String label;
  const _VitalCardCompact({required this.icon, required this.color, required this.bg, required this.value, required this.unit, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: colors.mutedForeground), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Flexible(
                      child: Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: colors.foreground, height: 1), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 3),
                    Text(unit, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: colors.mutedForeground)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// View Details Card — action card to open vitals drawer
// ─────────────────────────────────────────────────────────────────────────────

class _ViewDetailsCard extends StatelessWidget {
  final VoidCallback onTap;
  const _ViewDetailsCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.primary.withValues(alpha: 0.15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.open_in_full_rounded, size: 15, color: colors.primary),
            ),
            const SizedBox(height: 6),
            Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.primary)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Vitals Drawer
// ─────────────────────────────────────────────────────────────────────────────

class _VitalsDrawer extends StatelessWidget {
  final String heartRate;
  final String bloodPressure;
  const _VitalsDrawer({required this.heartRate, required this.bloodPressure});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Your Vitals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.foreground)),
              IconButton.ghost(
                onPressed: () => closeDrawer(context),
                icon: Icon(Icons.close_rounded, size: 20, color: colors.mutedForeground),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Large detailed cards
          Row(
            children: [
              Expanded(child: _DetailCard(icon: Icons.favorite_rounded, color: colors.heartRate, bg: colors.heartBg, value: heartRate, unit: 'bpm', label: 'Heart Rate')),
              const SizedBox(width: 12),
              Expanded(child: _DetailCard(icon: Icons.water_drop_rounded, color: colors.primary, bg: colors.oxygenBg, value: bloodPressure, unit: 'mmHg', label: 'Blood Pressure')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _DetailCard(icon: Icons.thermostat_rounded, color: colors.temperature, bg: colors.tempBg, value: '98.6', unit: '\u00B0F', label: 'Temperature')),
              const SizedBox(width: 12),
              Expanded(child: _DetailCard(icon: Icons.air_rounded, color: colors.oxygenSat, bg: colors.oxygenBg, value: '98', unit: '%', label: 'SpO\u2082')),
              const SizedBox(width: 12),
              Expanded(child: _DetailCard(icon: Icons.monitor_heart_rounded, color: const Color(0xFF7C3AED), bg: colors.sleepBg, value: '16', unit: '/min', label: 'Resp Rate')),
            ],
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Button.primary(
              onPressed: () {
                closeDrawer(context);
                GoRouter.of(context).go(RouteNames.patientRecords);
              },
              child: const Text('View Full Records', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;
  final String value;
  final String unit;
  final String label;
  const _DetailCard({required this.icon, required this.color, required this.bg, required this.value, required this.unit, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: colors.foreground, height: 1)),
          const SizedBox(height: 2),
          Text(unit, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: colors.mutedForeground)),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: colors.mutedForeground)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile Completion
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileCompletion extends StatelessWidget {
  const _ProfileCompletion();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [SurfaceTheme.ambientShadow],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.person_outline_rounded, color: colors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Complete Your Profile', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.foreground)),
                    Text('85%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: colors.primary)),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 6,
                    child: Stack(
                      children: [
                        Container(color: colors.muted),
                        FractionallySizedBox(
                          widthFactor: 0.85,
                          child: Container(
                            decoration: BoxDecoration(color: colors.primary, borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Add emergency contact & insurance details.',
                  style: TextStyle(fontSize: 12, color: colors.mutedForeground, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Health Alerts
// ─────────────────────────────────────────────────────────────────────────────

class _HealthAlerts extends StatelessWidget {
  const _HealthAlerts();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Health Updates', action: 'See all', onAction: () {
          context.go(RouteNames.patientAlerts);
        }),
        const SizedBox(height: 12),
        _AlertTile(icon: Icons.warning_amber_rounded, title: 'Dengue Alert', subtitle: 'High mosquito activity in your area.', isWarning: true),
        const SizedBox(height: 8),
        _AlertTile(icon: Icons.vaccines_rounded, title: 'Vaccination Drive', subtitle: 'Free flu & COVID boosters available.', isWarning: false),
      ],
    );
  }
}

class _AlertTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isWarning;
  const _AlertTile({required this.icon, required this.title, required this.subtitle, required this.isWarning});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bg = isWarning ? colors.warningBackground : colors.muted;
    final iconColor = isWarning ? colors.warning : colors.primary;
    final textColor = isWarning
        ? (colors.brightness == Brightness.light ? const Color(0xFF92400E) : colors.warning)
        : colors.foreground;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 12, color: textColor.withValues(alpha: 0.75), height: 1.3)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: 18, color: textColor.withValues(alpha: 0.4)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Services
// ─────────────────────────────────────────────────────────────────────────────

class _Services extends StatelessWidget {
  const _Services();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final items = [
      _SvcItem(Icons.calendar_month_rounded, 'Book Appt', const Color(0xFF2563EB), () => context.push(RouteNames.booking)),
      _SvcItem(Icons.folder_shared_rounded, 'Records', colors.primary, () => context.go(RouteNames.patientRecords)),
      _SvcItem(Icons.local_hospital_rounded, 'Hospitals', const Color(0xFF0D9488), () => context.push(RouteNames.serviceHospitals)),
      _SvcItem(Icons.video_call_rounded, 'Teleconsult', const Color(0xFF7C3AED), () => context.push(RouteNames.serviceTelemedicine)),
      _SvcItem(Icons.emergency_rounded, 'Ambulance', colors.destructive, () => context.push(RouteNames.serviceAmbulance)),
      _SvcItem(Icons.auto_stories_rounded, 'Health Tips', colors.temperature, () => context.push(RouteNames.serviceHealthTips)),
      _SvcItem(Icons.biotech_rounded, 'Lab Tests', colors.oxygenSat, () => context.push(RouteNames.serviceLabBooking)),
      _SvcItem(Icons.local_pharmacy_rounded, 'Pharmacy', colors.success, () => context.push(RouteNames.servicePharmacy)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Services'),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
          children: items.map((s) {
            return GestureDetector(
              onTap: s.onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colors.muted,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(s.icon, color: s.color, size: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(s.label, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: colors.foreground)),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

}

// ─────────────────────────────────────────────────────────────────────────────
// Shared — section header
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const _SectionHeader({required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.foreground)),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Row(
              children: [
                Text(action!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.primary)),
                const SizedBox(width: 2),
                Icon(Icons.chevron_right_rounded, size: 16, color: colors.primary),
              ],
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────

class _SvcItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _SvcItem(this.icon, this.label, this.color, this.onTap);
}
