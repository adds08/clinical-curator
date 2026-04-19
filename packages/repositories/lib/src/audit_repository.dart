import 'package:clinical_curator_client/clinical_curator_client.dart';

abstract class AuditRepository {
  Future<List<AuditEvent>> list({String? action, int? limit, int? offset});
  Future<List<AuditEvent>> recent({int limit = 20});
  Future<AuditEvent> record(AuditEvent event);
}
