import 'package:clinical_curator_client/clinical_curator_client.dart';

abstract class HealthTipRepository {
  /// Admin view — includes inactive tips.
  Future<List<HealthTip>> listAllAdmin();

  /// Public view — active tips only.
  Future<List<HealthTip>> listActive({int? limit, int? offset});

  Future<HealthTip?> getById(int id);
  Future<HealthTip> create(HealthTip tip);
  Future<HealthTip> update(HealthTip tip);
  Future<bool> delete(int id);
}
