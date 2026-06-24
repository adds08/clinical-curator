import 'dart:convert';
import 'dart:math';

import 'package:serverpod/serverpod.dart';
import 'search_params.dart';

/// FHIR JSONB CRUD service using Serverpod's unsafeQuery/unsafeExecute API.
/// Uses named parameters (@param) syntax per Serverpod query parameter conventions.
class FhirStoreService {
  Future<Map<String, dynamic>> create(Session session, Map<String, dynamic> resource) async {
    final resourceType = resource['resourceType'] as String;
    final fhirId = _generateId();
    final now = DateTime.now().toUtc();

    resource['id'] = fhirId;
    resource['meta'] = {
      'versionId': '1',
      'lastUpdated': now.toIso8601String(),
    };

    final searchParams = extractSearchParams(resource);

    await _exec(
      session,
      'INSERT INTO fhir_resource (fhir_id, resource_type, resource_json, search_params, version_id, last_updated) VALUES (@id, @type, @json, @params, 1, @now)',
      {
        'id': fhirId,
        'type': resourceType,
        'json': resource,
        'params': searchParams,
        'now': now,
      },
    );

    await _exec(
      session,
      'INSERT INTO fhir_resource_history (fhir_id, resource_type, resource_json, version_id) VALUES (@id, @type, @json, 1)',
      {
        'id': fhirId,
        'type': resourceType,
        'json': resource,
      },
    );

    return resource;
  }

  Future<Map<String, dynamic>?> read(Session session, String resourceType, String fhirId) async {
    final rows = await _query(
      session,
      'SELECT resource_json FROM fhir_resource WHERE resource_type = @type AND fhir_id = @id AND is_deleted = false',
      {
        'type': resourceType,
        'id': fhirId,
      },
    );
    if (rows.isEmpty || rows.first.isEmpty) return null;
    return rows.first.first as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> update(Session session, String resourceType, String fhirId, Map<String, dynamic> resource) async {
    final existing = await _queryInt(
      session,
      'SELECT version_id FROM fhir_resource WHERE resource_type = @type AND fhir_id = @id AND is_deleted = false',
      {
        'type': resourceType,
        'id': fhirId,
      },
    );
    if (existing == null) throw AppException('Resource not found', statusCode: 404);

    final newVersion = existing + 1;
    final now = DateTime.now().toUtc();
    resource['id'] = fhirId;
    resource['resourceType'] = resourceType;
    resource['meta'] = {
      'versionId': '$newVersion',
      'lastUpdated': now.toIso8601String(),
    };
    final searchParams = extractSearchParams(resource);

    await _exec(
      session,
      'UPDATE fhir_resource SET resource_json = @json, search_params = @params, version_id = @version, last_updated = @now WHERE resource_type = @type AND fhir_id = @id',
      {
        'json': resource,
        'params': searchParams,
        'version': newVersion,
        'now': now,
        'type': resourceType,
        'id': fhirId,
      },
    );

    await _exec(
      session,
      'INSERT INTO fhir_resource_history (fhir_id, resource_type, resource_json, version_id) VALUES (@id, @type, @json, @version)',
      {
        'id': fhirId,
        'type': resourceType,
        'json': resource,
        'version': newVersion,
      },
    );

    return resource;
  }

  Future<void> delete(Session session, String resourceType, String fhirId) async {
    await _exec(session, 'UPDATE fhir_resource SET is_deleted = true WHERE resource_type = @type AND fhir_id = @id', {
      'type': resourceType,
      'id': fhirId,
    });
  }

  Future<SearchResult> search(Session session, String resourceType, Map<String, String> queryParams) async {
    final count = int.tryParse(queryParams['_count'] ?? '20') ?? 20;
    final offset = int.tryParse(queryParams['_offset'] ?? '0') ?? 0;
    final since = queryParams['_since'];

    final params = <String, dynamic>{'type': resourceType, 'count': count, 'offset': offset};
    var conditions = 'resource_type = @type AND is_deleted = false';

    if (since != null) {
      params['since'] = DateTime.tryParse(since) ?? DateTime.fromMillisecondsSinceEpoch(0);
      conditions += ' AND last_updated > @since';
    }

    if (queryParams.containsKey('patient')) {
      params['patient'] = queryParams['patient'];
      conditions += " AND search_params @> jsonb_build_object('patient', '@patient')";
    }

    final total = await _queryInt(session, 'SELECT COUNT(*) FROM fhir_resource WHERE $conditions', params) ?? 0;

    final rows = await _query(
      session,
      'SELECT resource_json FROM fhir_resource WHERE $conditions ORDER BY last_updated DESC LIMIT @count OFFSET @offset',
      params,
    );

    return SearchResult(
      entries: rows.map((r) => r.first as Map<String, dynamic>).toList(),
      total: total,
    );
  }

  Future<List<Map<String, dynamic>>> history(Session session, String resourceType, String fhirId) async {
    final rows = await _query(
      session,
      'SELECT resource_json FROM fhir_resource_history WHERE resource_type = @type AND fhir_id = @id ORDER BY version_id ASC',
      {
        'type': resourceType,
        'id': fhirId,
      },
    );
    return rows.map((r) => r.first as Map<String, dynamic>).toList();
  }

  // -- Private helpers that wrap unsafeExecute/unsafeQuery with JSONB encoding --

  Future<List<List<dynamic>>> _query(Session session, String sql, Map<String, dynamic> params) async {
    final encoded = _encodeParams(params);
    final result = await session.db.unsafeQuery(sql, parameters: QueryParameters.named(encoded));
    return result.map((row) => row.map(_decodeJsonb).toList()).toList();
  }

  Future<int?> _queryInt(Session session, String sql, Map<String, dynamic> params) async {
    final encoded = _encodeParams(params);
    final result = await session.db.unsafeQuery(sql, parameters: QueryParameters.named(encoded));
    if (result.isEmpty || result.first.isEmpty) return null;
    return result.first.first as int;
  }

  Future<void> _exec(Session session, String sql, Map<String, dynamic> params) async {
    final encoded = _encodeParams(params);
    await session.db.unsafeExecute(sql, parameters: QueryParameters.named(encoded));
  }

  /// Encode params: JSONB values as JSON strings, others pass through.
  Map<String, Object?> _encodeParams(Map<String, dynamic> raw) {
    return raw.map((k, v) {
      if (v is Map || v is List) return MapEntry(k, jsonEncode(v));
      if (v is DateTime) return MapEntry(k, v.toIso8601String());
      return MapEntry(k, v);
    });
  }

  /// Decode JSONB string back to dynamic.
  dynamic _decodeJsonb(dynamic value) {
    if (value is String) {
      try {
        return jsonDecode(value);
      } catch (_) {}
    }
    return value;
  }

  String _generateId() {
    final random = Random();
    const chars = 'abcdef0123456789';
    return 'fhir-${List.generate(8, (_) => chars[random.nextInt(chars.length)]).join()}';
  }
}

class SearchResult {
  final List<Map<String, dynamic>> entries;
  final int total;
  SearchResult({required this.entries, required this.total});
}

class AppException implements Exception {
  final String message;
  final int statusCode;
  const AppException(this.message, {this.statusCode = 400});
  @override
  String toString() => message;
}
