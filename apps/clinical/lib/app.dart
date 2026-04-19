import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/config/app_environment.dart';
import 'package:cc_core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'domain/providers/auto_sync_provider.dart';
import 'domain/services/fhir_sync_service.dart';
import 'domain/providers/theme_provider.dart';
import 'domain/providers/auth_provider.dart';
import 'domain/services/verification_watcher.dart';

class ClinicalCuratorApp extends ConsumerStatefulWidget {
  const ClinicalCuratorApp({super.key});

  @override
  ConsumerState<ClinicalCuratorApp> createState() => _ClinicalCuratorAppState();
}

class _ClinicalCuratorAppState extends ConsumerState<ClinicalCuratorApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVerification());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkVerification();
  }

  void _checkVerification() {
    if (!mounted) return;
    VerificationWatcher.check(context: context, ref: ref);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(appRouterProvider);

    // Re-check whenever auth state flips from unauthenticated → authenticated
    // (e.g. fresh login) — covers the case where admin approved during the
    // previous session.
    ref.listen(authProvider, (prev, next) {
      if (next.isAuthenticated && (prev?.isAuthenticated != true)) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _checkVerification());
      }
    });

    ref.watch(autoSyncProvider);
    // Eagerly instantiate the FHIR sync service so the timer + lifecycle
    // observer start immediately.
    ref.watch(fhirSyncServiceProvider);

    Widget app = ShadcnApp.router(
      title: 'Clinical Curator',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: _wrapWithSystemChrome,
    );

    if (AppEnvironment.showDebugBanner) {
      app = Directionality(
        textDirection: TextDirection.ltr,
        child: Banner(
          message: AppEnvironment.label,
          location: BannerLocation.topStart,
          color: AppEnvironment.isDev
              ? const Color(0xFF16A34A)
              : const Color(0xFFEA580C),
          child: app,
        ),
      );
    }

    return app;
  }
}

// Applied once at the app root so every route gets status-bar–safe insets
// and theme-correct status bar icon tinting — no per-screen SafeArea needed.
// ColoredBox paints the status-bar strip in the theme background so the
// OS window black doesn't bleed through behind the SafeArea.
Widget _wrapWithSystemChrome(BuildContext context, Widget? child) {
  final theme = Theme.of(context);
  final dark = theme.brightness == Brightness.dark;
  final overlay = (dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
      .copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: theme.colorScheme.background,
        systemNavigationBarIconBrightness: dark ? Brightness.light : Brightness.dark,
      );
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: overlay,
    child: ColoredBox(
      color: theme.colorScheme.background,
      child: SafeArea(
        bottom: false,
        child: child ?? const SizedBox.shrink(),
      ),
    ),
  );
}
