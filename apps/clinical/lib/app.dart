import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/config/app_environment.dart';
import 'package:cc_core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'domain/providers/auto_sync_provider.dart';
import 'domain/providers/theme_provider.dart';

class ClinicalCuratorApp extends ConsumerWidget {
  const ClinicalCuratorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(appRouterProvider);

    // Activate auto-sync (triggers when connectivity changes)
    ref.watch(autoSyncProvider);

    Widget app = ShadcnApp.router(
      title: 'Clinical Curator',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );

    // Show environment banner in non-production builds
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
