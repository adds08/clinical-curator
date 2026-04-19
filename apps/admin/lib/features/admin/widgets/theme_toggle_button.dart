import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../domain/providers/theme_provider.dart';

/// Cycles light → dark → system on tap. A full popover menu is overkill
/// for a three-option toggle and keeps the AppBar trailing slot compact.
/// Icon reflects the active mode so the state is always visible.
class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeProvider);
    final (icon, next) = switch (mode) {
      ThemeMode.light => (LucideIcons.sun, ThemeMode.dark),
      ThemeMode.dark => (LucideIcons.moon, ThemeMode.system),
      ThemeMode.system => (LucideIcons.monitor, ThemeMode.light),
    };
    return IconButton.ghost(
      icon: Icon(icon, size: 18),
      onPressed: () => ref.read(themeProvider.notifier).setThemeMode(next),
    );
  }
}
