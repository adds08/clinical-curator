import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:clinical_curator_client/clinical_curator_client.dart';

import 'package:cc_core/config/app_config.dart';

/// Shared Serverpod client for the admin app. Reads the backend URL from
/// `AppConfig.serverpodUrl` (sourced from the repo-root `.env`) so the
/// admin app always hits the same Serverpod instance as the clinical app.
final serverpodClientProvider = Provider<Client>((ref) {
  return Client(AppConfig.serverpodUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor();
});
