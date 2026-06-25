import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Clinical Precision Framework — Border Radius Tokens
/// Soft, friendly geometry inspired by modern health apps
class AppRadius {
  AppRadius._();

  static const double xs = 6.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 28.0;

  static BorderRadius get cardRadius => BorderRadius.circular(xxl);
  static BorderRadius get bentoRadius => BorderRadius.circular(xl);
  static BorderRadius get buttonRadius => BorderRadius.circular(md);
  static BorderRadius get chipRadius => BorderRadius.circular(sm);
  static BorderRadius get inputRadius => BorderRadius.circular(md);
  static BorderRadius get iconRadius => BorderRadius.circular(lg);
  static BorderRadius get sheetRadius => const BorderRadius.vertical(
        top: Radius.circular(24),
      );
}
