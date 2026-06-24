import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Single Hive cache class replacing all 27 *Local collection classes.
/// Stores FHIR resources as full JSON strings, indexed by resourceType/fhirId.
///
/// This replaces:
///   patient_collection.dart, encounter_collection.dart, observation_collection.dart,
///   medication_request_collection.dart, condition_collection.dart, etc. (27 files)
///
/// Uses filesystem JSON files instead of Hive to eliminate build_runner
/// and hive_ce_generator dependencies.

class FhirCacheEntry {
  String key; // "{resourceType}/{fhirId}" e.g. "Patient/fhir-abc123"
  String resourceJson; // Full FHIR JSON string
  String resourceType;
  String fhirId;
  DateTime lastSynced;
  String? patientRef;
  String? practitionerRef;
  String syncStatus; // 'synced' | 'pending_upload' | 'pending_delete' | 'dead_letter'
  int retryCount;

  FhirCacheEntry({
    required this.key,
    required this.resourceJson,
    required this.resourceType,
    required this.fhirId,
    required this.lastSynced,
    this.patientRef,
    this.practitionerRef,
    this.syncStatus = 'synced',
    this.retryCount = 0,
  });

  Map<String, dynamic>? get asJson => jsonDecode(resourceJson) as Map<String, dynamic>?;
}

/// File-system backed FHIR cache. No Hive, no build_runner, no code generation.
class FhirFileCache {
  static FhirFileCache? _instance;
  late final String _basePath;

  FhirFileCache._();

  static Future<FhirFileCache> init() async {
    if (_instance != null) return _instance!;
    final dir = await getApplicationDocumentsDirectory();
    final cache = FhirFileCache._();
    cache._basePath = '${dir.path}/fhir_cache';
    await Directory(cache._basePath).create(recursive: true);
    _instance = cache;
    return cache;
  }

  String _path(String resourceType, String fhirId) => '$_basePath/$resourceType/$fhirId.json';

  Future<void> put(FhirCacheEntry entry) async {
    final dir = Directory('$_basePath/${entry.resourceType}');
    await dir.create(recursive: true);
    final file = File(_path(entry.resourceType, entry.fhirId));
    await file.writeAsString(
      jsonEncode({
        'key': entry.key,
        'resourceJson': entry.resourceJson,
        'resourceType': entry.resourceType,
        'fhirId': entry.fhirId,
        'lastSynced': entry.lastSynced.toIso8601String(),
        'patientRef': entry.patientRef,
        'practitionerRef': entry.practitionerRef,
        'syncStatus': entry.syncStatus,
        'retryCount': entry.retryCount,
      }),
    );
  }

  Future<FhirCacheEntry?> get(String resourceType, String fhirId) async {
    final file = File(_path(resourceType, fhirId));
    if (!await file.exists()) return null;
    final data = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    return FhirCacheEntry(
      key: data['key'] as String,
      resourceJson: data['resourceJson'] as String,
      resourceType: data['resourceType'] as String,
      fhirId: data['fhirId'] as String,
      lastSynced: DateTime.tryParse(data['lastSynced'] as String? ?? '') ?? DateTime.now(),
      patientRef: data['patientRef'] as String?,
      practitionerRef: data['practitionerRef'] as String?,
      syncStatus: data['syncStatus'] as String? ?? 'synced',
      retryCount: data['retryCount'] as int? ?? 0,
    );
  }

  Future<List<FhirCacheEntry>> getAll(String resourceType) async {
    final dir = Directory('$_basePath/$resourceType');
    if (!await dir.exists()) return [];
    final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));
    final results = <FhirCacheEntry>[];
    for (final file in files) {
      try {
        final entry = await get(resourceType, file.uri.pathSegments.last.replaceAll('.json', ''));
        if (entry != null) results.add(entry);
      } catch (_) {}
    }
    return results;
  }

  Future<List<FhirCacheEntry>> getDirty() async {
    final baseDir = Directory(_basePath);
    if (!await baseDir.exists()) return [];
    final results = <FhirCacheEntry>[];
    final typeDirs = baseDir.listSync().whereType<Directory>();
    for (final typeDir in typeDirs) {
      final entries = await getAll(typeDir.uri.pathSegments.last);
      results.addAll(entries.where((e) => e.syncStatus != 'synced'));
    }
    return results;
  }

  Future<void> delete(String resourceType, String fhirId) async {
    final file = File(_path(resourceType, fhirId));
    if (await file.exists()) await file.delete();
  }

  Future<void> clearAll() async {
    final dir = Directory(_basePath);
    if (await dir.exists()) await dir.delete(recursive: true);
    await dir.create(recursive: true);
  }
}
