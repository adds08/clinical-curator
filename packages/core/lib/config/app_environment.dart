/// Compile-time environment configuration.
///
/// Switch environments with: `flutter run --dart-define=ENV=dev|staging|prod`
enum Environment { dev, staging, prod }

class AppEnvironment {
  AppEnvironment._();

  static const _envStr = String.fromEnvironment('ENV', defaultValue: 'dev');

  static Environment get current => switch (_envStr) {
        'staging' => Environment.staging,
        'prod' => Environment.prod,
        _ => Environment.dev,
      };

  /// Serverpod API base URL.
  static String get apiBaseUrl => switch (current) {
        Environment.dev => 'http://localhost:8080',
        Environment.staging => 'https://api-staging.clinicalcurator.com',
        Environment.prod => 'https://api.clinicalcurator.com',
      };

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
