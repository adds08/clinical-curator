import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

import 'router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return shadcn.ShadcnApp.router(
      title: 'The Clinical Curator',
      theme: shadcn.ThemeData(
        colorScheme: shadcn.ColorScheme(
          brightness: Brightness.light,
          primary: const Color(0xFF004ac6), // Primary
          primaryForeground: const Color(0xFFffffff), // On Primary
          secondary: const Color(0xFF545f73), // Secondary
          secondaryForeground: const Color(0xFFffffff), // On Secondary
          destructive: const Color(0xFFba1a1a), // Error
          destructiveForeground: const Color(0xFFffffff), // On Error
          background: const Color(0xFFf7f9fb), // Background
          foreground: const Color(0xFF191c1e), // On Background
          card: const Color(0xFFffffff), // Card (default to white for now based on UI)
          cardForeground: const Color(0xFF191c1e), // Card Foreground
          popover: const Color(0xFFffffff), // Popover
          popoverForeground: const Color(0xFF191c1e), // Popover Foreground
          muted: const Color(0xFFe0e3e5), // Surface Variant / Muted
          mutedForeground: const Color(0xFF434655), // On Surface Variant / Muted Foreground
          accent: const Color(0xFFd5e0f8), // Secondary Container / Accent
          accentForeground: const Color(0xFF586377), // On Secondary Container / Accent Foreground
          border: const Color(0xFFc3c6d7), // Outline Variant
          input: const Color(0xFF737686), // Outline / Input
          ring: const Color(0xFF004ac6), // Ring / Primary focus
          chart1: const Color(0xFF2662D9),
          chart2: const Color(0xFFE23670),
          chart3: const Color(0xFFE88C30),
          chart4: const Color(0xFFAF57DB),
          chart5: const Color(0xFF2EB88A),
        ),
        radius: 0.5,
      ),
      routerConfig: goRouter,
    );
  }
}
