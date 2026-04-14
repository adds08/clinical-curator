import 'package:cc_data/database/isar_service.dart';
import 'package:cc_core/theme/app_theme.dart';
import 'package:cc_data/mock/mock_seed.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Admin shares the Hive database with the clinical app — both binaries
  // open the same boxes via DatabaseService. Two binaries cannot run against
  // the same Hive instance simultaneously, but admin and clinical are
  // separate user journeys so this is acceptable for v1.
  await DatabaseService.initialize();
  await MockSeed.seedIfEmpty();

  runApp(const ProviderScope(child: AdminApp()));
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp.router(
      title: 'Clinical Curator — Admin',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: adminRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
