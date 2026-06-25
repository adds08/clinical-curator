import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../constants/app_radius.dart';

/// Fallback font families applied to every shadcn `Typography.sans` style —
/// lets the engine render Devanagari (Nepali) input + emoji without the
/// "Could not find a set of Noto fonts" warning. Order matters: Devanagari
/// first (user-entered Nepali patient names/notes), then broad multi-script
/// coverage for anything else.
const List<String> _appFontFallback = <String>[
  'Noto Sans Devanagari',
  'Noto Sans',
  'Noto Color Emoji',
  'Apple Color Emoji',
];

shadcn.Typography _sansFallbackTypography() {
  return const shadcn.Typography.geist(
    sans: TextStyle(
      fontFamily: 'GeistSans',
      package: 'shadcn_flutter',
      fontFamilyFallback: _appFontFallback,
    ),
  );
}

/// Builds the shadcn_flutter theme data with Clinical Precision Framework tokens.
///
/// Key mapping notes (light theme):
///   muted        — slate-100 (#F1F5F9), a very light neutral for muted surfaces
///   mutedFg      — slate-500 (#64748B), readable but de-emphasised text
///   accent       — blue-50  (#EFF6FF), the lightest primary tint for highlights
///   accentFg     — primary blue, so accented text pops
///   border       — slate-200 (#E2E8F0), almost invisible separator lines
///   input        — slate-300 (#CBD5E1), subtle input field borders
///   background   — very faint off-white (#F8FAFC) so cards lift off it
///   radius       — 0.5 (tighter corners = more professional feel)
class AppTheme {
  AppTheme._();

  // ──────────────────────────── Light ────────────────────────────

  static shadcn.ThemeData light() {
    return shadcn.ThemeData(
      colorScheme: shadcn.ColorScheme(
        brightness: Brightness.light,

        // Primary
        primary: AppColors.primary,
        primaryForeground: AppColors.onPrimary,

        // Secondary
        secondary: AppColors.secondary,
        secondaryForeground: AppColors.onSecondary,

        // Destructive
        destructive: AppColors.error,
        destructiveForeground: AppColors.onError,

        // Background & foreground — faint off-white (slate-50)
        background: const Color(0xFFF8FAFC),
        foreground: AppColors.onSurface,

        // Muted — light neutral (slate-100 / slate-500)
        muted: const Color(0xFFF1F5F9),
        mutedForeground: const Color(0xFF64748B),

        // Card / popover — pure white so they lift off the background
        card: Colors.white,
        cardForeground: AppColors.onSurface,
        popover: Colors.white,
        popoverForeground: AppColors.onSurface,

        // Accent — very light primary tint (blue-50)
        accent: const Color(0xFFEFF6FF),
        accentForeground: AppColors.primary,

        // Border / input — almost invisible for no-line rule
        border: const Color(0xFFF1F5F9), // slate-100, same as muted — nearly invisible
        input: const Color(0xFFE2E8F0), // slate-200, subtle for inputs only

        // Ring — focus ring color
        ring: AppColors.primary,

        // Chart palette
        chart1: const Color(0xFF2662D9),
        chart2: const Color(0xFFE23670),
        chart3: const Color(0xFFE88C30),
        chart4: const Color(0xFFAF57DB),
        chart5: const Color(0xFF2EB88A),
      ),
      typography: _sansFallbackTypography(),
      radius: 0.75, // soft corners — warm friendly feel
    );
  }

  // ──────────────────────────── Dark ─────────────────────────────

  static shadcn.ThemeData dark() {
    return shadcn.ThemeData(
      colorScheme: shadcn.ColorScheme(
        brightness: Brightness.dark,

        // Primary
        primary: AppColors.primaryContainer,
        primaryForeground: AppColors.onPrimary,

        // Secondary
        secondary: AppColors.secondary,
        secondaryForeground: AppColors.onSecondary,

        // Destructive
        destructive: const Color(0xFFF87171),
        destructiveForeground: AppColors.onError,

        // Background & foreground — pure black / white
        background: const Color(0xFF000000),
        foreground: const Color(0xFFF1F5F9),

        // Muted — near-black / gray
        muted: const Color(0xFF1C1C1E),
        mutedForeground: const Color(0xFF8E8E93),

        // Card / popover — very dark gray
        card: const Color(0xFF0E0E0E),
        cardForeground: const Color(0xFFF1F5F9),
        popover: const Color(0xFF0E0E0E),
        popoverForeground: const Color(0xFFF1F5F9),

        // Accent — dark blue
        accent: const Color(0xFF0A1628),
        accentForeground: const Color(0xFF93C5FD),

        // Border / input — dark gray
        border: const Color(0xFF1C1C1E),
        input: const Color(0xFF2C2C2E),

        // Ring
        ring: AppColors.primaryContainer,

        // Chart palette (slightly brighter for dark bg)
        chart1: const Color(0xFF3B82F6),
        chart2: const Color(0xFFF472B6),
        chart3: const Color(0xFFFBBF24),
        chart4: const Color(0xFFC084FC),
        chart5: const Color(0xFF34D399),
      ),
      typography: _sansFallbackTypography(),
      radius: 0.75,
    );
  }

  // ──────────────────── Material fallback (light) ────────────────

  /// Material ThemeData for widgets that need it (e.g., flutter_map, fl_chart).
  static ThemeData materialLight() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: const Color(0xFFF8FAFC),
        onSurface: AppColors.onSurface,
        brightness: Brightness.light,
      ),
      textTheme: AppTypography.textTheme,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadius,
        ),
      ),
    );
  }

  // ──────────────────── Material fallback (dark) ─────────────────

  static ThemeData materialDark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primaryContainer,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: const Color(0xFF000000),
        onSurface: const Color(0xFFF1F5F9),
        brightness: Brightness.dark,
      ),
      textTheme: AppTypography.textTheme,
      scaffoldBackgroundColor: const Color(0xFF000000),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF0E0E0E),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadius,
        ),
      ),
    );
  }
}
