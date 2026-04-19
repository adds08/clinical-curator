import 'package:clinical_curator_client/clinical_curator_client.dart';

import '../audit_repository.dart';

class ServerAuditRepository implements AuditRepository {
  ServerAuditRepository(this._client);
  final Client _client;

  @override
  Future<List<AuditEvent>> list({String? action, int? limit, int? offset}) =>
      _client.audit.list(action: action, limit: limit, offset: offset);

  @override
  Future<List<AuditEvent>> recent({int limit = 20}) =>
      _client.audit.recent(limit: limit);

  @override
  Future<AuditEvent> record(AuditEvent event) => _client.audit.record(event);
}
