import 'package:cc_core/config/app_config.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_data/mock/mock_seed.dart';
import 'package:cc_data/mock/reference_seed.dart';
import 'package:cc_rbac/can_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'app.dart';
import 'domain/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env (bundled as an asset — see pubspec.yaml `assets:`). Done
  // before anything that may read AppConfig (DB path, seed picker, the
  // Serverpod client provider).
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Running without a .env file — AppConfig falls back to
    // --dart-define values / hard-coded defaults.
  }

  await DatabaseService.initialize();

  // ENV ∈ {mock, dev, staging, prod}. AppConfig.env checks .env first,
  // then --dart-define=ENV=..., then defaults to 'dev'.
  final env = AppConfig.env;
  if (env == 'mock') {
    await MockSeed.seedIfEmpty();
  } else {
    await ReferenceSeed.seedIfEmpty();
  }

  runApp(
    ProviderScope(
      overrides: [
        // Wire cc_rbac's app-agnostic role-code hook to the clinical app's
        // auth layer so Can / canProvider see the real user.
        clinicianRoleCodeProvider.overrideWith((ref) {
          final user = ref.watch(authProvider).user;
          if (user == null || !user.isPractitioner) return null;
          return user.practitionerType;
        }),
      ],
      child: const ClinicalCuratorApp(),
    ),
  );
}
