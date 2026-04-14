import 'package:flutter_test/flutter_test.dart';
import 'package:cc_data/network/api_client.dart';

void main() {
  group('ApiConfig', () {
    test('has correct default base URL', () {
      expect(ApiConfig.defaultBaseUrl, 'https://hapi.fhir.org/baseR4');
    });

    test('has 30 second connect timeout', () {
      expect(ApiConfig.connectTimeout, const Duration(seconds: 30));
    });

    test('has 30 second receive timeout', () {
      expect(ApiConfig.receiveTimeout, const Duration(seconds: 30));
    });
  });

  group('ApiClient', () {
    test('creates with default base URL', () {
      final client = ApiClient();
      expect(client.dio.options.baseUrl, ApiConfig.defaultBaseUrl);
    });

    test('creates with custom base URL', () {
      final client = ApiClient(baseUrl: 'https://custom.fhir.org/baseR4');
      expect(client.dio.options.baseUrl, 'https://custom.fhir.org/baseR4');
    });

    test('sets FHIR content type headers', () {
      final client = ApiClient();
      expect(
        client.dio.options.headers['Content-Type'],
        'application/fhir+json',
      );
      expect(
        client.dio.options.headers['Accept'],
        'application/fhir+json',
      );
    });

    test('has interceptors configured', () {
      final client = ApiClient();
      expect(client.dio.interceptors.length, greaterThanOrEqualTo(3));
    });
  });
}
