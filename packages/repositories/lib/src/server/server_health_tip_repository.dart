import 'package:clinical_curator_client/clinical_curator_client.dart';

import '../health_tip_repository.dart';

class ServerHealthTipRepository implements HealthTipRepository {
  ServerHealthTipRepository(this._client);
  final Client _client;

  @override
  Future<List<HealthTip>> listAllAdmin() => _client.healthTip.listAllAdmin();

  @override
  Future<List<HealthTip>> listActive({int? limit, int? offset}) =>
      _client.healthTip.listAll(limit: limit, offset: offset);

  @override
  Future<HealthTip?> getById(int id) => _client.healthTip.getById(id);

  @override
  Future<HealthTip> create(HealthTip tip) => _client.healthTip.create(tip);

  @override
  Future<HealthTip> update(HealthTip tip) => _client.healthTip.update(tip);

  @override
  Future<bool> delete(int id) => _client.healthTip.delete(id);
}
