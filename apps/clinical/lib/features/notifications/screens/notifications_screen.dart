import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_data/database/isar_service.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import '../../../domain/providers/auth_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final user = ref.watch(authProvider).user;
    final userEmail = user?.email ?? '';

    // Read real notifications from Hive
    final allNotifications = DatabaseService.notificationRecords.values
        .where((n) => n.userEmail == userEmail)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final unreadNotifications = allNotifications.where((n) => !n.isRead).toList();
    final readNotifications = allNotifications.where((n) => n.isRead).toList();

    // If no real notifications, show fallback UI
    final hasRealData = allNotifications.isNotEmpty;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          // Title + mark all read
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Notifications', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: colors.foreground, letterSpacing: -0.3)),
              GestureDetector(
                onTap: () async {
                  for (final n in allNotifications) {
                    if (!n.isRead) {
                      n.isRead = true;
                      await n.save();
                    }
                  }
                  setState(() {});
                  if (mounted) {
                    // ignore: use_build_context_synchronously
                    showToast(context: context, builder: (ctx, overlay) => SurfaceCard(child: Basic(title: const Text('All marked as read'))));
                  }
                },
                child: Text('Mark all read', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primary)),
              ),
            ],
          ),
          const Gap(24),

          if (hasRealData) ...[
            if (unreadNotifications.isNotEmpty) ...[
              _SectionHeader(label: 'UNREAD', colors: colors),
              const Gap(10),
              ...unreadNotifications.map((n) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () async {
                    n.isRead = true;
                    await n.save();
                    setState(() {});
                    if (n.relatedRoute != null && n.relatedRoute!.isNotEmpty && mounted) {
                      // ignore: use_build_context_synchronously
                      context.push(n.relatedRoute!);
                    }
                  },
                  child: _NotificationTile(
                    icon: _iconForType(n.type),
                    iconColor: _colorForType(n.type, colors),
                    iconBg: _colorForType(n.type, colors).withValues(alpha: 0.1),
                    title: n.title,
                    subtitle: n.body,
                    time: _timeAgo(n.createdAt),
                    isActive: !n.isRead,
                    colors: colors,
                  ),
                ),
              )),
              const Gap(16),
            ],
            if (readNotifications.isNotEmpty) ...[
              _SectionHeader(label: 'READ', colors: colors),
              const Gap(10),
              ...readNotifications.map((n) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    if (n.relatedRoute != null && n.relatedRoute!.isNotEmpty) {
                      context.push(n.relatedRoute!);
                    }
                  },
                  child: _NotificationTile(
                    icon: _iconForType(n.type),
                    iconColor: colors.mutedForeground,
                    iconBg: colors.muted,
                    title: n.title,
                    subtitle: n.body,
                    time: _timeAgo(n.createdAt),
                    isRead: true,
                    colors: colors,
                  ),
                ),
              )),
            ],
          ] else ...[
            // Fallback: show static notifications when no real data
            _SectionHeader(label: 'ACTIVE SERVICES', colors: colors),
            const Gap(10),
            _NotificationTile(
              icon: LucideIcons.siren,
              iconColor: colors.destructive,
              iconBg: colors.criticalBackground,
              title: 'Ambulance Dispatched',
              subtitle: 'ETA 5-8 minutes',
              time: 'Just now',
              isActive: true,
              colors: colors,
            ),
            const Gap(8),
            _NotificationTile(
              icon: LucideIcons.video,
              iconColor: const Color(0xFF7C3AED),
              iconBg: const Color(0xFF7C3AED).withValues(alpha: 0.1),
              title: 'Upcoming Teleconsult',
              subtitle: 'Cardiology consultation',
              time: 'Today, 3:00 PM',
              isActive: true,
              colors: colors,
            ),
            const Gap(24),
            _SectionHeader(label: 'RECENT', colors: colors),
            const Gap(10),
            _NotificationTile(
              icon: LucideIcons.microscope,
              iconColor: colors.oxygenSat,
              iconBg: colors.oxygenSat.withValues(alpha: 0.1),
              title: 'Lab Results Ready',
              subtitle: 'Full Lipid Panel results available',
              time: '2h ago',
              colors: colors,
            ),
            const Gap(8),
            _NotificationTile(
              icon: LucideIcons.syringe,
              iconColor: colors.primary,
              iconBg: colors.primary.withValues(alpha: 0.1),
              title: 'Vaccination Reminder',
              subtitle: 'Annual flu shot due this month',
              time: 'Yesterday',
              colors: colors,
            ),
          ],

          const Gap(40),
        ],
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'ambulance': return LucideIcons.siren;
      case 'appointment': return LucideIcons.calendar;
      case 'lab': return LucideIcons.microscope;
      case 'pharmacy': return LucideIcons.pill;
      case 'alert': return LucideIcons.triangleAlert;
      case 'consent': return LucideIcons.shield;
      default: return LucideIcons.bell;
    }
  }

  Color _colorForType(String type, ColorScheme colors) {
    switch (type) {
      case 'ambulance': return colors.destructive;
      case 'appointment': return colors.primary;
      case 'lab': return colors.oxygenSat;
      case 'pharmacy': return colors.success;
      case 'alert': return colors.warning;
      default: return colors.primary;
    }
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    return '${(diff.inDays / 30).floor()}mo ago';
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final ColorScheme colors;
  const _SectionHeader({required this.label, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: colors.mutedForeground,
        letterSpacing: 1,
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String time;
  final bool isActive;
  final bool isRead;
  final ColorScheme colors;

  const _NotificationTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isActive = false,
    this.isRead = false,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isActive
            ? colors.accent
            : isRead
                ? colors.background
                : colors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isRead ? FontWeight.w500 : FontWeight.w600,
                          color: isRead
                              ? colors.mutedForeground
                              : colors.foreground,
                        ),
                      ),
                    ),
                    if (isActive)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.primary,
                        ),
                      ),
                  ],
                ),
                const Gap(3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.mutedForeground,
                  ),
                ),
                const Gap(4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.mutedForeground.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
