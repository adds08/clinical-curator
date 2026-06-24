import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:share_plus/share_plus.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_core/router/route_names.dart';
import '../../../domain/providers/auth_provider.dart';
import '../../../domain/providers/role_provider.dart';
import '../../../domain/providers/theme_provider.dart';
import 'package:cc_fhir_models/models/user_role.dart';
import '../widgets/qr_share_sheet.dart';

class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  bool _biometricLogin = true;
  bool _hideProfileInfo = false;
  bool _notifyMessages = true;
  bool _notifyAlerts = true;
  bool _notifyLabs = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final user = ref.watch(authProvider).user;
    final currentRole = ref.watch(roleProvider);
    final themeMode = ref.watch(themeProvider);
    final isPractitioner = currentRole.isPractitioner;

    final name = user?.displayName ?? 'User';
    final healthId = user?.healthId ?? 'NEP-0000-0000-00';
    final initials = _initials(name);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.lg, AppSpacing.xxl, AppSpacing.xxxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile hero ──
            _ProfileHero(
              name: name,
              initials: initials,
              healthId: healthId,
              isPractitioner: isPractitioner,
              onShareTap: () => QrShareSheet.show(context),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ── Role toggle ──
            if (user != null && user.canToggleRole) ...[
              _RoleToggle(
                currentRole: currentRole,
                onSwitch: (role) {
                  ref.read(roleProvider.notifier).setRole(role);
                  if (role == UserRole.patient) {
                    context.go(RouteNames.patientHome);
                  } else {
                    context.go(RouteNames.clinicianHome);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],

            // ── Preferences ──
            _SectionLabel(label: 'Preferences'),
            const SizedBox(height: AppSpacing.sm),
            _SettingsGroup(
              children: [
                _SettingRow(
                  icon: LucideIcons.moon,
                  label: 'Dark Mode',
                  trailing: Switch(value: themeMode == ThemeMode.dark, onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme()),
                ),
                _SettingRow(
                  icon: LucideIcons.languages,
                  label: 'Language',
                  trailing: Text('English', style: TextStyle(fontSize: 13, color: colors.mutedForeground)),
                  onTap: () => _openLanguageDrawer(),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ── Security ──
            _SectionLabel(label: 'Security & Privacy'),
            const SizedBox(height: AppSpacing.sm),
            _SettingsGroup(
              children: [
                _SettingRow(
                  icon: LucideIcons.fingerprint,
                  label: 'Biometric Login',
                  trailing: Switch(value: _biometricLogin, onChanged: (v) => setState(() => _biometricLogin = v)),
                ),
                _SettingRow(
                  icon: LucideIcons.shield,
                  label: 'Two-Factor Auth',
                  trailing: Icon(LucideIcons.chevronRight, size: 18, color: colors.mutedForeground),
                  onTap: () => _open2FADrawer(),
                ),
                _SettingRow(
                  icon: LucideIcons.eyeOff,
                  label: 'Hide Profile Info',
                  trailing: Switch(value: _hideProfileInfo, onChanged: (v) => setState(() => _hideProfileInfo = v)),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ── Notifications ──
            _SectionLabel(label: 'Notifications'),
            const SizedBox(height: AppSpacing.sm),
            _SettingsGroup(
              children: [
                _SettingRow(
                  icon: LucideIcons.messageSquare,
                  label: 'Patient Messages',
                  trailing: Switch(value: _notifyMessages, onChanged: (v) => setState(() => _notifyMessages = v)),
                ),
                _SettingRow(
                  icon: LucideIcons.bellRing,
                  label: 'System Alerts',
                  trailing: Switch(value: _notifyAlerts, onChanged: (v) => setState(() => _notifyAlerts = v)),
                ),
                _SettingRow(
                  icon: LucideIcons.microscope,
                  label: 'Lab Reports',
                  trailing: Switch(value: _notifyLabs, onChanged: (v) => setState(() => _notifyLabs = v)),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ── Backup ──
            _SectionLabel(label: 'Backup & Restore'),
            const SizedBox(height: AppSpacing.sm),
            _SettingsGroup(
              children: [
                _SettingRow(
                  icon: LucideIcons.download,
                  label: 'Export backup (local)',
                  trailing: Icon(LucideIcons.chevronRight, size: 18, color: colors.mutedForeground),
                  onTap: _exportLocal,
                ),
                _SettingRow(
                  icon: LucideIcons.upload,
                  label: 'Import backup (local)',
                  trailing: Icon(LucideIcons.chevronRight, size: 18, color: colors.mutedForeground),
                  onTap: _importLocal,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ── Support ──
            _SectionLabel(label: 'Help & Support'),
            const SizedBox(height: AppSpacing.sm),
            _SettingsGroup(
              children: [
                _SettingRow(
                  icon: LucideIcons.shield,
                  label: 'Consent Management',
                  trailing: Icon(LucideIcons.chevronRight, size: 18, color: colors.mutedForeground),
                  onTap: () => context.push(RouteNames.consent),
                ),
                if (isPractitioner)
                  _SettingRow(
                    icon: LucideIcons.clipboardPlus,
                    label: 'Clinician Settings',
                    trailing: Icon(LucideIcons.chevronRight, size: 18, color: colors.mutedForeground),
                    onTap: () => context.push(RouteNames.clinicianSettings),
                  ),
                _SettingRow(
                  icon: LucideIcons.messageCircle,
                  label: 'Live Chat',
                  trailing: Icon(LucideIcons.chevronRight, size: 18, color: colors.mutedForeground),
                  onTap: () => _openLiveChatDrawer(),
                ),
                _SettingRow(
                  icon: LucideIcons.bookOpen,
                  label: 'User Manual',
                  trailing: Icon(LucideIcons.chevronRight, size: 18, color: colors.mutedForeground),
                  onTap: () => context.push(RouteNames.userManual),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxxl),

            // ── Sign out ──
            Row(
              children: [
                Expanded(
                  child: Button.outline(onPressed: () => _lockApp(), child: const Text('Lock App')),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Button.destructive(
                    onPressed: () async {
                      await ref.read(authProvider.notifier).logout();
                      if (context.mounted) context.go(RouteNames.login);
                    },
                    child: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: Text(
                'v4.2.0 • Clinical Curator',
                style: TextStyle(fontSize: 11, color: colors.mutedForeground.withValues(alpha: 0.45)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _selectedLanguage = 'English';

  void _openLanguageDrawer() {
    final colors = Theme.of(context).colorScheme;
    final languages = ['English', 'नेपाली (Nepali)', 'हिन्दी (Hindi)', 'मैथिली (Maithili)'];
    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (ctx) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Language',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.foreground),
            ),
            const SizedBox(height: 4),
            Text('Select your preferred language', style: TextStyle(fontSize: 13, color: colors.mutedForeground)),
            const SizedBox(height: 20),
            ...languages.map((lang) {
              final isSelected = _selectedLanguage == lang || (_selectedLanguage == 'English' && lang == 'English');
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedLanguage = lang);
                  closeDrawer(ctx);
                  showToast(
                    context: context,
                    builder: (c, o) => SurfaceCard(child: Basic(title: Text('Language set to $lang'))),
                  );
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.primary.withValues(alpha: 0.08) : colors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected ? Border.all(color: colors.primary.withValues(alpha: 0.3)) : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          lang,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: colors.foreground,
                          ),
                        ),
                      ),
                      if (isSelected) Icon(LucideIcons.circleCheck, size: 20, color: colors.primary),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _open2FADrawer() {
    final colors = Theme.of(context).colorScheme;
    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (ctx) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Two-Factor Authentication',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.foreground),
            ),
            const SizedBox(height: 4),
            Text('Add an extra layer of security to your account', style: TextStyle(fontSize: 13, color: colors.mutedForeground)),
            const SizedBox(height: 24),
            _SettingRow(
              icon: LucideIcons.messageSquare,
              label: 'SMS Verification',
              trailing: Switch(value: true, onChanged: (_) {}),
            ),
            const SizedBox(height: 8),
            _SettingRow(
              icon: LucideIcons.mail,
              label: 'Email Verification',
              trailing: Switch(value: false, onChanged: (_) {}),
            ),
            const SizedBox(height: 24),
            Text(
              'Phone Number',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.foreground),
            ),
            const SizedBox(height: 8),
            const TextField(placeholder: Text('+977 98XXXXXXXX')),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Button.primary(
                onPressed: () {
                  closeDrawer(ctx);
                  showToast(
                    context: context,
                    builder: (c, o) => SurfaceCard(child: Basic(title: const Text('2FA settings updated'))),
                  );
                },
                child: const Text('Save Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openLiveChatDrawer() {
    final colors = Theme.of(context).colorScheme;
    final chatController = TextEditingController();
    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (ctx) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Support Chat',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.foreground),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: colors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(color: colors.success, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Online',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colors.success),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: colors.muted, borderRadius: BorderRadius.circular(12)),
              child: Text(
                'Hello! How can we help you today? Our support team typically responds within 5 minutes.',
                style: TextStyle(fontSize: 13, color: colors.foreground, height: 1.4),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(controller: chatController, placeholder: const Text('Type a message...')),
                ),
                const SizedBox(width: 8),
                Button.primary(
                  onPressed: () {
                    closeDrawer(ctx);
                    showToast(
                      context: context,
                      builder: (c, o) => SurfaceCard(child: Basic(title: const Text('Message sent! We\'ll respond shortly.'))),
                    );
                  },
                  child: const Icon(LucideIcons.send, size: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportLocal() async {
    showToast(
      context: context,
      builder: (c, o) => const SurfaceCard(child: Basic(title: Text('Export — use FhirFileCache.exportAll()'))),
    );
  }

  Future<void> _importLocal() async {
    showToast(
      context: context,
      builder: (c, o) => const SurfaceCard(child: Basic(title: Text('Import — use FhirFileCache for file import'))),
    );
  }

  void _lockApp() async {
    await ref.read(authProvider.notifier).logout();
    if (!mounted) return;
    // ignore: use_build_context_synchronously
    context.go(RouteNames.login);
  }

  String _initials(String name) {
    final clean = name.replaceAll(RegExp(r'Dr\.\s*'), '');
    final parts = clean.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts.isNotEmpty ? parts[0][0].toUpperCase() : 'U';
  }
}

// =============================================================================
// Profile Hero — avatar, name, health ID card
// =============================================================================

class _ProfileHero extends StatelessWidget {
  final String name;
  final String initials;
  final String healthId;
  final bool isPractitioner;
  final VoidCallback onShareTap;

  const _ProfileHero({
    required this.name,
    required this.initials,
    required this.healthId,
    required this.isPractitioner,
    required this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(color: colors.card, borderRadius: AppRadius.cardRadius, boxShadow: [SurfaceTheme.ambientShadow]),
      child: Column(
        children: [
          // Avatar
          Avatar(initials: initials, size: 68, backgroundColor: colors.primary),
          const SizedBox(height: AppSpacing.lg),

          // Name
          Text(
            name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.foreground),
          ),
          if (isPractitioner) ...[
            const SizedBox(height: 4),
            Text('Senior Cardiologist • Kathmandu', style: TextStyle(fontSize: 13, color: colors.mutedForeground)),
          ],

          const SizedBox(height: AppSpacing.lg),

          // Health ID card — tappable
          GestureDetector(
            onTap: onShareTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              decoration: BoxDecoration(color: colors.muted, borderRadius: BorderRadius.circular(AppRadius.md)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.badge, size: 16, color: colors.primary),
                  const SizedBox(width: 8),
                  Text(
                    healthId,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: colors.foreground,
                      fontFamily: 'monospace',
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(width: 1, height: 16, color: colors.mutedForeground.withValues(alpha: 0.2)),
                  const SizedBox(width: 10),
                  Icon(LucideIcons.qrCode, size: 16, color: colors.primary),
                  const SizedBox(width: 4),
                  Icon(LucideIcons.share2, size: 14, color: colors.primary),
                ],
              ),
            ),
          ),

          // Practitioner stats
          if (isPractitioner) ...[
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StatPill(value: '1,284', label: 'Consults', colors: colors),
                const SizedBox(width: AppSpacing.sm),
                _StatPill(value: '4.9 ★', label: 'Rating', colors: colors),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// Role Toggle — segmented control
// =============================================================================

class _RoleToggle extends StatelessWidget {
  final UserRole currentRole;
  final ValueChanged<UserRole> onSwitch;

  const _RoleToggle({required this.currentRole, required this.onSwitch});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isClinician = currentRole.isPractitioner;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: colors.muted, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Row(
        children: [
          Expanded(
            child: _SegmentButton(
              label: 'Clinician View',
              icon: LucideIcons.briefcaseMedical,
              isActive: isClinician,
              onTap: () => onSwitch(UserRole.clinician),
            ),
          ),
          Expanded(
            child: _SegmentButton(
              label: 'Patient View',
              icon: LucideIcons.user,
              isActive: !isClinician,
              onTap: () => onSwitch(UserRole.patient),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _SegmentButton({required this.label, required this.icon, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? colors.primary : const Color(0x00000000),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isActive ? colors.primaryForeground : colors.mutedForeground),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? colors.primaryForeground : colors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Section label
// =============================================================================

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Text(
      label,
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.mutedForeground, letterSpacing: 0.2),
    );
  }
}

// =============================================================================
// Settings group — card container with rows
// =============================================================================

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [SurfaceTheme.ambientShadow],
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Divider(height: 1, color: colors.muted),
              ),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// Setting row
// =============================================================================

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingRow({required this.icon, required this.label, required this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 13),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colors.mutedForeground),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.foreground),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Stat pill
// =============================================================================

class _StatPill extends StatelessWidget {
  final String value;
  final String label;
  final ColorScheme colors;
  const _StatPill({required this.value, required this.label, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: colors.muted, borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.foreground),
          ),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: colors.mutedForeground)),
        ],
      ),
    );
  }
}
