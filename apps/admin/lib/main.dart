import 'package:cc_core/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'domain/providers/admin_auth_provider.dart';
import 'domain/providers/theme_provider.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Shared `.env` (bundled from the repo root — see pubspec.yaml assets).
  // Loaded before anything that may read AppConfig (e.g. the Serverpod
  // client provider).
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Fall back to --dart-define / defaults.
  }

  // Admin is Serverpod-only: no local Hive, no mock seed, no local
  // database. Every screen resolves data through `cc_repositories` →
  // Serverpod. Keeps the admin console a thin, always-fresh view of the
  // backend.

  runApp(const ProviderScope(child: AdminApp()));
}

class AdminApp extends ConsumerStatefulWidget {
  const AdminApp({super.key});

  @override
  ConsumerState<AdminApp> createState() => _AdminAppState();
}

class _AdminAppState extends ConsumerState<AdminApp> {
  bool _ready = false;
  GoRouter? _router;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Rehydrate theme + session *before* mounting the router so the
    // initial redirect decision sees a stable auth state (avoids a flash
    // of the login screen for already-authenticated admins).
    await ref.read(themeProvider.notifier).loadTheme();
    await ref.read(adminAuthProvider.notifier).restore();
    if (mounted) setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    if (!_ready) {
      return ShadcnApp(
        title: 'Clinical Curator — Admin',
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: themeMode,
        debugShowCheckedModeBanner: false,
        home: const _SplashScreen(),
        builder: _wrapWithSystemChrome,
      );
    }

    _router ??= buildAdminRouter(ref);
    return ShadcnApp.router(
      title: 'Clinical Curator — Admin',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: _router!,
      debugShowCheckedModeBanner: false,
      builder: _wrapWithSystemChrome,
    );
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

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.background,
      child: const Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
