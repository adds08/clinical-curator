import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Convenience accessor for clinical color extensions.
class ClinicalColors {
  ClinicalColors._();

  /// Returns the [ColorScheme] from the nearest [Theme], which has all
  /// the [ClinicalColorScheme] extension getters available on it.
  static ColorScheme of(BuildContext context) =>
      Theme.of(context).colorScheme;
}

/// Extension on shadcn ColorScheme for clinical-specific semantic colors
/// that adapt to light/dark mode automatically.
extension ClinicalColorScheme on ColorScheme {
  // Status colors
  Color get success => brightness == Brightness.light
      ? const Color(0xFF16A34A)
      : const Color(0xFF4ADE80);
  Color get successBackground => brightness == Brightness.light
      ? const Color(0xFFF0FDF4)
      : const Color(0xFF14532D);

  Color get warning => brightness == Brightness.light
      ? const Color(0xFFF59E0B)
      : const Color(0xFFFBBF24);
  Color get warningBackground => brightness == Brightness.light
      ? const Color(0xFFFFFBEB)
      : const Color(0xFF78350F);

  Color get critical => destructive; // alias
  Color get criticalBackground => brightness == Brightness.light
      ? const Color(0xFFFEF2F2)
      : const Color(0xFF450A0A);

  // Surface levels for no-line tonal hierarchy
  Color get surfaceLow => brightness == Brightness.light
      ? const Color(0xFFF1F5F9)
      : const Color(0xFF1E293B);
  Color get surfaceHigh => brightness == Brightness.light
      ? const Color(0xFFE2E8F0)
      : const Color(0xFF334155);

  // Clinical accent colors
  Color get heartRate => brightness == Brightness.light
      ? const Color(0xFFEF4444)
      : const Color(0xFFFCA5A5);
  Color get bloodPressure => primary;
  Color get oxygenSat => brightness == Brightness.light
      ? const Color(0xFF0EA5E9)
      : const Color(0xFF7DD3FC);
  Color get temperature => brightness == Brightness.light
      ? const Color(0xFFF97316)
      : const Color(0xFFFDBA74);

  // Pastel bento card backgrounds
  Color get heartBg => brightness == Brightness.light
      ? const Color(0xFFFFF1F2)
      : const Color(0xFF4C1D2A);
  Color get oxygenBg => brightness == Brightness.light
      ? const Color(0xFFF0F9FF)
      : const Color(0xFF0C2D48);
  Color get tempBg => brightness == Brightness.light
      ? const Color(0xFFFFF7ED)
      : const Color(0xFF431407);
  Color get stepsBg => brightness == Brightness.light
      ? const Color(0xFFF0FDF4)
      : const Color(0xFF14532D);
  Color get sleepBg => brightness == Brightness.light
      ? const Color(0xFFF5F3FF)
      : const Color(0xFF2E1065);
  Color get scheduleBg => brightness == Brightness.light
      ? const Color(0xFFFFFBEB)
      : const Color(0xFF78350F);
}
