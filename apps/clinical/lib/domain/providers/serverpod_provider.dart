import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:clinical_curator_client/clinical_curator_client.dart';

import 'package:cc_core/config/app_config.dart';

final serverpodClientProvider = Provider<Client>((ref) {
  return Client(AppConfig.serverpodUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor();
});
