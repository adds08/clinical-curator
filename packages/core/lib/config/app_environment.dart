import 'app_config.dart';

/// Compile-time / runtime environment configuration.
///
/// Reads `ENV` from `.env` (via [AppConfig]) first, then falls back to
/// `--dart-define=ENV=dev|staging|prod`. Both Flutter apps load the same
/// `.env` at startup so this returns the same value in clinical + admin.
enum Environment { dev, staging, prod }

class AppEnvironment {
  AppEnvironment._();

  static Environment get current => switch (AppConfig.env) {
        'staging' => Environment.staging,
        'prod' => Environment.prod,
        _ => Environment.dev,
      };

  /// Serverpod API base URL — delegates to [AppConfig.serverpodUrl] so
  /// the clinical and admin apps always agree on the backend.
  /// Returns a URL WITHOUT a trailing slash for callers that append
  /// their own path segment. Use [AppConfig.serverpodUrl] when you
  /// need the trailing-slash form Serverpod `Client(...)` expects.
  static String get apiBaseUrl {
    final url = AppConfig.serverpodUrl;
    return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  /// FHIR R4 endpoint (dev uses public HAPI server).
  static String get fhirBaseUrl => switch (current) {
        Environment.dev => 'https://hapi.fhir.org/baseR4',
        Environment.staging => 'https://api-staging.clinicalcurator.com/fhir',
        Environment.prod => 'https://api.clinicalcurator.com/fhir',
      };

  static bool get isDev => current == Environment.dev;
  static bool get isStaging => current == Environment.staging;
  static bool get isProd => current == Environment.prod;
  static bool get showDebugBanner => current != Environment.prod;

  static String get label => switch (current) {
        Environment.dev => 'DEV',
        Environment.staging => 'STAGING',
        Environment.prod => '',
      };
}
