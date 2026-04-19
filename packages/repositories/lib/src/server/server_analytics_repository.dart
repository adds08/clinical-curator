import 'package:clinical_curator_client/clinical_curator_client.dart';

import '../analytics_repository.dart';

class ServerAnalyticsRepository implements AnalyticsRepository {
  ServerAnalyticsRepository(this._client);
  final Client _client;

  @override
  Future<AnalyticsSnapshot> getSnapshot() async {
    final map = await _client.admin.getAnalytics();
    return AnalyticsSnapshot.fromMap(map);
  }
}
