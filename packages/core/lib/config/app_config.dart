import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Runtime-configurable app settings, sourced from `.env` (via
/// [flutter_dotenv]) with a fallback to compile-time `--dart-define`
/// values. Both the clinical and admin apps read from the SAME `.env`
/// at the repo root so they never drift onto different backends.
///
/// Load [dotenv] in `main.dart` before `runApp`:
/// ```dart
/// await dotenv.load(fileName: '.env');
/// ```
///
/// All getters are safe to call before `dotenv.load()` — if the env
/// hasn't been loaded yet they fall back to `--dart-define` or the
/// hard-coded default.
class AppConfig {
  AppConfig._();

  static String _read(String key, {String fallback = ''}) {
    // dotenv.env is an empty map until loaded — guard against throws.
    try {
      final v = dotenv.env[key];
      if (v != null && v.trim().isNotEmpty) return v.trim();
    } catch (_) {
      // dotenv not initialised — fall through.
    }
    return fallback;
  }

  /// ENV ∈ {mock, dev, staging, prod}. Prefers `.env`, falls back to
  /// `--dart-define=ENV=...`, then defaults to `dev`.
  static String get env {
    final fromDotenv = _read('ENV');
    if (fromDotenv.isNotEmpty) return fromDotenv;
    const fromDefine = String.fromEnvironment('ENV', defaultValue: '');
    if (fromDefine.isNotEmpty) return fromDefine;
    return 'dev';
  }

  /// Serverpod base URL. Always ends with a trailing slash (Serverpod
  /// `Client(...)` requires it).
  static String get serverpodUrl {
    var url = _read('SERVERPOD_URL', fallback: _defaultServerpodUrl);
    if (!url.endsWith('/')) url = '$url/';
    return url;
  }

  static String get serverpodHost =>
      _read('SERVERPOD_HOST', fallback: 'localhost');

  static int get serverpodPort {
    final v = _read('SERVERPOD_PORT', fallback: '8080');
    return int.tryParse(v) ?? 8080;
  }

  static String get googleClientId {
    final fromDotenv = _read('GOOGLE_CLIENT_ID');
    if (fromDotenv.isNotEmpty) return fromDotenv;
    return const String.fromEnvironment('GOOGLE_CLIENT_ID',
        defaultValue: '');
  }

  static String get khaltiPublicKey => _read('KHALTI_PUBLIC_KEY');
  static String get esewaPublicKey => _read('ESEWA_PUBLIC_KEY');

  static bool get isDev => env == 'dev' || env == 'mock';
  static bool get isStaging => env == 'staging';
  static bool get isProd => env == 'prod';

  static String get _defaultServerpodUrl {
    return switch (env) {
      'staging' => 'https://api-staging.clinicalcurator.com/',
      'prod' => 'https://api.clinicalcurator.com/',
      _ => 'http://localhost:8080/',
    };
  }
}
