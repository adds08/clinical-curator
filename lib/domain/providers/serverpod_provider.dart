import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:clinical_curator_client/clinical_curator_client.dart';

import '../../core/config/app_environment.dart';

final serverpodClientProvider = Provider<Client>((ref) {
  return Client(
    '${AppEnvironment.apiBaseUrl}/',
  )..connectivityMonitor = FlutterConnectivityMonitor();
});
