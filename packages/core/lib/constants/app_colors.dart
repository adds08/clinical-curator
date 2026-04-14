import 'dart:ui';

/// Clinical Precision Framework — Color Token System
/// Derived from Stitch HTML prototypes and DESIGN.md
class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF004AC6);
  static const Color primaryContainer = Color(0xFF2563EB);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFD6E3FF);

  // Secondary
  static const Color secondary = Color(0xFF545F73);
  static const Color secondaryContainer = Color(0xFFD8DEE9);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF111C2E);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF410002);

  // Success (stable/normal indicators)
  static const Color success = Color(0xFF00A86B);
  static const Color successContainer = Color(0xFFD4F5E4);

  // Warning (pending/amber indicators)
  static const Color warning = Color(0xFFFACC15);
  static const Color warningContainer = Color(0xFFFFF3C4);

  // Surface hierarchy — "No-Line" tonal layering
  static const Color surface = Color(0xFFF7F9FB);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F4F6);
  static const Color surfaceContainer = Color(0xFFECEEF0);
  static const Color surfaceContainerHigh = Color(0xFFE6E8EA);
  static const Color surfaceContainerHighest = Color(0xFFE0E3E5);

  // Text colors
  static const Color onSurface = Color(0xFF191C1E);
  static const Color onSurfaceVariant = Color(0xFF434655);
  static const Color outline = Color(0xFF737686);
  static const Color outlineVariant = Color(0xFFC4C6CF);

  // Semantic status colors
  static const Color critical = Color(0xFFBA1A1A);
  static const Color stable = Color(0xFF00A86B);
  static const Color pending = Color(0xFFF59E0B);
  static const Color active = Color(0xFF004AC6);

  // Dark theme overrides
  static const Color darkSurface = Color(0xFF111318);
  static const Color darkSurfaceContainer = Color(0xFF1D1F24);
  static const Color darkSurfaceContainerHigh = Color(0xFF282A2F);
  static const Color darkOnSurface = Color(0xFFE2E2E9);
  static const Color darkOnSurfaceVariant = Color(0xFFC4C6CF);
}
