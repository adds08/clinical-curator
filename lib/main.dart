import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/database/isar_service.dart';
import 'data/mock/mock_seed.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive local database
  await DatabaseService.initialize();

  // Seed mock data on first run
  await MockSeed.seedIfEmpty();

  runApp(
    const ProviderScope(
      child: ClinicalCuratorApp(),
    ),
  );
}
