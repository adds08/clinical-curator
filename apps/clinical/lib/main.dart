import 'package:cc_data/database/isar_service.dart';
import 'package:cc_data/mock/mock_seed.dart';
import 'package:cc_rbac/can_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'domain/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseService.initialize();
  await MockSeed.seedIfEmpty();

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
