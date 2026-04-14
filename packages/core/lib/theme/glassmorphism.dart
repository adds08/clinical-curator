import 'dart:ui';
import 'package:flutter/material.dart';

/// Glassmorphism decoration builder for floating/premium elements.
/// Used on: cardiovascular bottom sheet, floating info cards.
class Glassmorphism {
  Glassmorphism._();

  static BoxDecoration decoration({
    Color color = const Color(0xB3FFFFFF), // white at 70%
    double borderRadius = 16.0,
    double borderOpacity = 0.2,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Colors.white.withValues(alpha: borderOpacity),
        width: 1,
      ),
    );
  }

  /// Wrap a widget with backdrop blur for glassmorphic effect.
  static Widget blurContainer({
    required Widget child,
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    Color color = const Color(0xB3FFFFFF),
    double borderRadius = 16.0,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: Container(
          decoration: decoration(
            color: color,
            borderRadius: borderRadius,
          ),
          child: child,
        ),
      ),
    );
  }

  /// Dark variant for use on dark backgrounds.
  static BoxDecoration darkDecoration({
    double borderRadius = 16.0,
  }) {
    return BoxDecoration(
      color: const Color(0x80000000), // black at 50%
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.1),
        width: 1,
      ),
    );
  }
}
