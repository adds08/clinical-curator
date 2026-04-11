import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import '../constants/app_radius.dart';
import 'clinical_colors.dart';

/// Surface level hierarchy — implements the "No-Line" rule.
/// Boundaries are defined through background color shifts, NOT borders.
enum SurfaceLevel {
  lowest, // card — white in light, near-black in dark
  low, // section blocks
  base, // scaffold background
  high, // elevated sections
  highest, // top-level emphasis
}

class SurfaceTheme {
  SurfaceTheme._();

  /// Returns the appropriate surface color for the given [level],
  /// reading brightness from [context] so it works for both light & dark.
  static Color colorFor(SurfaceLevel level, BuildContext context) {
    final colors = shadcn.Theme.of(context).colorScheme;
    final isDark = colors.brightness == Brightness.dark;

    if (isDark) {
      switch (level) {
        case SurfaceLevel.lowest:
          return colors.card;
        case SurfaceLevel.low:
          return colors.muted;
        case SurfaceLevel.base:
          return colors.background;
        case SurfaceLevel.high:
          return colors.surfaceHigh;
        case SurfaceLevel.highest:
          return const Color(0xFF333538);
      }
    }
    switch (level) {
      case SurfaceLevel.lowest:
        return colors.card;
      case SurfaceLevel.low:
        return colors.muted;
      case SurfaceLevel.base:
        return colors.background;
      case SurfaceLevel.high:
        return colors.surfaceHigh;
      case SurfaceLevel.highest:
        return const Color(0xFFE0E3E5);
    }
  }

  /// Ambient shadow for floating elements only. Per DESIGN.md:
  /// 24px blur, 4% opacity. No traditional drop shadows.
  static BoxShadow get ambientShadow => BoxShadow(
        color: Colors.black.withValues(alpha: 0.03),
        blurRadius: 32,
        offset: const Offset(0, 2),
      );

  /// Ghost border — reads border color from theme context.
  static Border ghostBorder(BuildContext context) {
    final colors = shadcn.Theme.of(context).colorScheme;
    return Border.all(
      color: colors.border.withValues(alpha: 0.15),
      width: 1,
    );
  }

  /// Standard decoration for surface cards (no border, tonal background).
  static BoxDecoration cardDecoration({
    SurfaceLevel level = SurfaceLevel.lowest,
    bool withShadow = false,
    required BuildContext context,
  }) {
    return BoxDecoration(
      color: colorFor(level, context),
      borderRadius: AppRadius.cardRadius,
      boxShadow: withShadow ? [ambientShadow] : null,
    );
  }
}
