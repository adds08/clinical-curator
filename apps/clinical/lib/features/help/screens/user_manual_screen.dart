import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_ui_kit/widgets/sub_page_scaffold.dart';

import '../../../domain/providers/role_provider.dart';

enum _ManualTab { patient, clinician }

class UserManualScreen extends ConsumerStatefulWidget {
  const UserManualScreen({super.key});

  @override
  ConsumerState<UserManualScreen> createState() => _UserManualScreenState();
}

class _UserManualScreenState extends ConsumerState<UserManualScreen> {
  _ManualTab? _tab;

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(roleProvider);
    // Default to the manual matching the current role; user can switch tabs.
    _tab ??= role.isPractitioner ? _ManualTab.clinician : _ManualTab.patient;

    return SubPageScaffold(
      title: 'User Manual',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.sm),
            child: _ManualTabBar(
              value: _tab!,
              onChanged: (t) => setState(() => _tab = t),
            ),
          ),
          Expanded(
            child: _ManualBody(tab: _tab!),
          ),
        ],
      ),
    );
  }
}

class _ManualTabBar extends StatelessWidget {
  final _ManualTab value;
  final ValueChanged<_ManualTab> onChanged;
  const _ManualTabBar({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.muted,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: 'Patient',
              icon: LucideIcons.user,
              active: value == _ManualTab.patient,
              onTap: () => onChanged(_ManualTab.patient),
            ),
          ),
          Expanded(
            child: _TabButton(
              label: 'Clinician',
              icon: LucideIcons.briefcaseMedical,
              active: value == _ManualTab.clinician,
              onTap: () => onChanged(_ManualTab.clinician),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  const _TabButton({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? colors.primary : const Color(0x00000000),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: active ? colors.primaryForeground : colors.mutedForeground,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color:
                    active ? colors.primaryForeground : colors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManualBody extends StatelessWidget {
  final _ManualTab tab;
  const _ManualBody({required this.tab});

  String get _asset => switch (tab) {
        _ManualTab.patient => 'docs/manual/PATIENT_MANUAL.md',
        _ManualTab.clinician => 'docs/manual/CLINICIAN_MANUAL.md',
      };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return FutureBuilder<String>(
      // Keyed by asset path so switching tabs forces a reload.
      key: ValueKey(_asset),
      future: rootBundle.loadString(_asset),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        if (snap.hasError || !snap.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text(
                'Could not load the manual.\n${snap.error ?? ''}',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.mutedForeground, fontSize: 13),
              ),
            ),
          );
        }
        return Markdown(
          data: snap.data!,
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.xxxl),
          styleSheet: _styleSheet(context),
          selectable: true,
        );
      },
    );
  }
}

MarkdownStyleSheet _styleSheet(BuildContext context) {
  final colors = Theme.of(context).colorScheme;
  final fg = colors.foreground;
  final muted = colors.mutedForeground;

  TextStyle h(double size, {FontWeight weight = FontWeight.w700, Color? color}) =>
      TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color ?? fg,
        height: 1.25,
        letterSpacing: -0.3,
      );

  return MarkdownStyleSheet(
    h1: h(24),
    h2: h(20),
    h3: h(17),
    h4: h(15),
    h5: h(14),
    h6: h(13, color: muted),
    p: TextStyle(fontSize: 14, height: 1.55, color: fg),
    em: TextStyle(fontStyle: FontStyle.italic, color: fg),
    strong: TextStyle(fontWeight: FontWeight.w700, color: fg),
    listBullet: TextStyle(fontSize: 14, height: 1.55, color: fg),
    blockquote: TextStyle(fontSize: 14, height: 1.55, color: muted),
    blockquoteDecoration: BoxDecoration(
      color: colors.muted,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      border: Border(left: BorderSide(color: colors.primary, width: 3)),
    ),
    blockquotePadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
    code: TextStyle(
      fontFamily: 'monospace',
      fontSize: 12.5,
      color: colors.primary,
      backgroundColor: colors.muted,
    ),
    codeblockDecoration: BoxDecoration(
      color: colors.muted,
      borderRadius: BorderRadius.circular(AppRadius.sm),
    ),
    codeblockPadding: const EdgeInsets.all(12),
    horizontalRuleDecoration: BoxDecoration(
      border: Border(
        top: BorderSide(color: colors.border, width: 1),
      ),
    ),
    a: TextStyle(
      color: colors.primary,
      decoration: TextDecoration.underline,
      decorationColor: colors.primary.withValues(alpha: 0.4),
    ),
    tableHead: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: fg,
    ),
    tableBody: TextStyle(fontSize: 13, color: fg),
    tableBorder: TableBorder.all(color: colors.border, width: 1),
    tableCellsPadding:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    h1Padding: const EdgeInsets.only(top: 8, bottom: 8),
    h2Padding: const EdgeInsets.only(top: 16, bottom: 6),
    h3Padding: const EdgeInsets.only(top: 12, bottom: 4),
  );
}

