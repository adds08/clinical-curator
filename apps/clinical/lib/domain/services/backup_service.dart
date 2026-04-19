import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as gauth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/fhir_resource_collection.dart';

import 'audit_logger.dart';

/// Schema version for the JSON backup envelope. Bump on breaking changes.
const String kBackupSchemaVersion = '1.0.0';

/// Google OAuth Client ID, provided at build time via:
///   `--dart-define=GOOGLE_CLIENT_ID=<client-id>.apps.googleusercontent.com`
const String kGoogleClientId =
    String.fromEnvironment('GOOGLE_CLIENT_ID', defaultValue: '');

bool get isDriveBackupConfigured => kGoogleClientId.isNotEmpty;

class ImportReport {
  final int upserted;
  final int conflicts;
  final int skipped;
  final Duration elapsed;

  const ImportReport({
    this.upserted = 0,
    this.conflicts = 0,
    this.skipped = 0,
    this.elapsed = Duration.zero,
  });

  int get total => upserted + conflicts + skipped;
}

class DriveBackupFile {
  final String id;
  final String name;
  final DateTime? createdTime;
  final int? size;

  const DriveBackupFile({
    required this.id,
    required this.name,
    this.createdTime,
    this.size,
  });
}

/// Hive-first backup service.
///
/// Scope: every FhirResource row in the `fhir_resources` box — this covers
/// vitals (Observation), labs (DiagnosticReport/Observation), medications
/// (MedicationRequest), allergies (AllergyIntolerance), immunizations
/// (Immunization), encounters (Encounter), consents (Consent), conditions
/// (Condition), and diagnostic reports (DiagnosticReport).
class BackupService {
  BackupService({
    this.userId,
    this.agentEmail,
    this.agentName,
    this.env = 'mock',
  });

  final String? userId;
  final String? agentEmail;
  final String? agentName;
  final String env;

  /// Build an in-memory JSON envelope of all FhirResource rows.
  Map<String, dynamic> _buildEnvelope() {
    final box = DatabaseService.fhirResources;
    final rows = box.values
        .map((r) => {
              'fhirId': r.fhirId,
              'resourceType': r.resourceType,
              'jsonData': r.jsonData,
              'patientReference': r.patientReference,
              'practitionerReference': r.practitionerReference,
              'category': r.category,
              'lastUpdated': r.lastUpdated.toIso8601String(),
              'createdAt': r.createdAt?.toIso8601String(),
            })
        .toList();
    return {
      'schemaVersion': kBackupSchemaVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'userId': userId,
      'env': env,
      'resourceCount': rows.length,
      'resources': rows,
    };
  }

  /// Exports all FHIR resources to a JSON file in the app documents directory.
  /// Returns the written file.
  Future<File> exportLocal() async {
    final envelope = _buildEnvelope();
    final dir = await getApplicationDocumentsDirectory();
    final ts = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file = File('${dir.path}/clinical_curator_backup_$ts.json');
    await file.writeAsString(jsonEncode(envelope));
    await AuditLogger.dataExported(
      agentRef: 'User/${agentEmail ?? 'unknown'}',
      agentName: agentName ?? agentEmail ?? 'unknown',
      destination: 'local-json',
      resourceCount: envelope['resourceCount'] as int,
      filePath: file.path,
    );
    return file;
  }

  /// Lets the user pick a backup file and imports it into Hive.
  Future<ImportReport?> pickAndImportLocal() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return null;
    final path = result.files.single.path;
    if (path == null) return null;
    return importLocal(File(path));
  }

  /// Parses the given JSON file and upserts into Hive. Last-write-wins
  /// (file's `lastUpdated` beats older local rows).
  Future<ImportReport> importLocal(File f) async {
    final stopwatch = Stopwatch()..start();
    final text = await f.readAsString();
    final envelope = jsonDecode(text);
    if (envelope is! Map ||
        envelope['resources'] is! List) {
      throw const FormatException('Invalid backup envelope');
    }
    final schema = envelope['schemaVersion']?.toString() ?? 'unknown';
    if (schema != kBackupSchemaVersion) {
      // Forward-compat only on major match — warn via audit.
      await AuditLogger.dataConflict(
        entityRef: f.path,
        entityType: 'Bundle',
        agentRef: 'User/${agentEmail ?? 'unknown'}',
        agentName: agentName ?? agentEmail ?? 'unknown',
        detail: 'schema-mismatch current=$kBackupSchemaVersion file=$schema',
      );
    }
    final resources =
        (envelope['resources'] as List).cast<Map<String, dynamic>>();
    final box = DatabaseService.fhirResources;
    var upserted = 0;
    var conflicts = 0;
    var skipped = 0;

    for (final r in resources) {
      final fhirId = r['fhirId'] as String?;
      final resourceType = r['resourceType'] as String?;
      if (fhirId == null || resourceType == null) {
        skipped++;
        continue;
      }
      final incomingLU = DateTime.tryParse(r['lastUpdated'] as String? ?? '') ??
          DateTime.now();
      FhirResource? existing;
      for (final loc in box.values) {
        if (loc.fhirId == fhirId && loc.resourceType == resourceType) {
          existing = loc;
          break;
        }
      }
      if (existing == null) {
        final fresh = FhirResource()
          ..fhirId = fhirId
          ..resourceType = resourceType
          ..jsonData = r['jsonData'] as String? ?? '{}'
          ..patientReference = r['patientReference'] as String?
          ..practitionerReference = r['practitionerReference'] as String?
          ..category = r['category'] as String?
          ..syncStatus = 1
          ..isDownloadedOffline = true
          ..lastUpdated = incomingLU
          ..createdAt = DateTime.tryParse(r['createdAt'] as String? ?? '') ??
              incomingLU;
        await box.add(fresh);
        upserted++;
      } else if (incomingLU.isAfter(existing.lastUpdated)) {
        existing
          ..jsonData = r['jsonData'] as String? ?? existing.jsonData
          ..patientReference = r['patientReference'] as String?
          ..practitionerReference = r['practitionerReference'] as String?
          ..category = r['category'] as String?
          ..syncStatus = 1
          ..lastUpdated = incomingLU;
        await existing.save();
        upserted++;
      } else {
        conflicts++;
      }
    }

    stopwatch.stop();
    final report = ImportReport(
      upserted: upserted,
      conflicts: conflicts,
      skipped: skipped,
      elapsed: stopwatch.elapsed,
    );
    await AuditLogger.dataImported(
      agentRef: 'User/${agentEmail ?? 'unknown'}',
      agentName: agentName ?? agentEmail ?? 'unknown',
      source: 'local-json',
      resourceCount: report.total,
      conflicts: conflicts,
    );
    return report;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Google Drive (app-data folder)
  // ─────────────────────────────────────────────────────────────────────────

  Future<drive.DriveApi?> _driveApi() async {
    if (!isDriveBackupConfigured) return null;
    final signIn = GoogleSignIn(
      clientId: kGoogleClientId,
      scopes: const [drive.DriveApi.driveAppdataScope],
    );
    final account = await signIn.signIn();
    if (account == null) return null;
    final authHeaders = await account.authHeaders;
    final httpClient = _GoogleAuthClient(authHeaders);
    return drive.DriveApi(httpClient);
  }

  /// Uploads the envelope JSON to the Drive app-data folder.
  Future<String?> exportToDrive() async {
    final api = await _driveApi();
    if (api == null) return null;
    final envelope = _buildEnvelope();
    final bytes = utf8.encode(jsonEncode(envelope));
    final ts = DateTime.now().millisecondsSinceEpoch;
    final fileMeta = drive.File()
      ..name = 'clinical_curator_backup_$ts.json'
      ..parents = ['appDataFolder']
      ..mimeType = 'application/json';
    final media = drive.Media(
      Stream<List<int>>.fromIterable([bytes]),
      bytes.length,
    );
    final created = await api.files.create(fileMeta, uploadMedia: media);
    await AuditLogger.dataExported(
      agentRef: 'User/${agentEmail ?? 'unknown'}',
      agentName: agentName ?? agentEmail ?? 'unknown',
      destination: 'google-drive',
      resourceCount: envelope['resourceCount'] as int,
      filePath: created.id,
    );
    return created.id;
  }

  /// Lists all backup files in the Drive app-data folder, newest first.
  Future<List<DriveBackupFile>> listDriveBackups() async {
    final api = await _driveApi();
    if (api == null) return const [];
    final res = await api.files.list(
      spaces: 'appDataFolder',
      $fields: 'files(id,name,createdTime,size)',
      orderBy: 'createdTime desc',
      pageSize: 50,
    );
    return (res.files ?? [])
        .map((f) => DriveBackupFile(
              id: f.id!,
              name: f.name ?? f.id!,
              createdTime: f.createdTime,
              size: int.tryParse(f.size ?? ''),
            ))
        .toList();
  }

  /// Downloads the given Drive backup id and imports it into Hive.
  Future<ImportReport?> importFromDrive(String fileId) async {
    final api = await _driveApi();
    if (api == null) return null;
    final media = await api.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;
    final chunks = <int>[];
    await for (final c in media.stream) {
      chunks.addAll(c);
    }
    final text = utf8.decode(chunks);
    final dir = await getTemporaryDirectory();
    final tmp = File('${dir.path}/drive_restore_${DateTime.now().millisecondsSinceEpoch}.json');
    await tmp.writeAsString(text);
    final report = await importLocal(tmp);
    await AuditLogger.dataImported(
      agentRef: 'User/${agentEmail ?? 'unknown'}',
      agentName: agentName ?? agentEmail ?? 'unknown',
      source: 'google-drive',
      resourceCount: report.total,
      conflicts: report.conflicts,
    );
    return report;
  }
}

/// Minimal authed http client for googleapis.
class _GoogleAuthClient extends http.BaseClient {
  _GoogleAuthClient(this._headers);
  final Map<String, String> _headers;
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }
}

/// Avoids unused-import-warnings on gauth (reserved for future OAuth2 flows
/// that don't go through `google_sign_in`).
// ignore: unused_element
gauth.AccessCredentials? _kUnusedCreds;

/// Avoids unused-import-warning on foundation (retained in case platform
/// dispatcher hints are needed).
// ignore: unused_element
final _kUnusedFoundation = kIsWeb;
