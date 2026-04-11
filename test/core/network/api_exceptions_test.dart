import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clinical_curator/core/network/api_exceptions.dart';

void main() {
  group('ApiException', () {
    test('creates with required message', () {
      const e = ApiException(message: 'test error');
      expect(e.message, 'test error');
      expect(e.statusCode, isNull);
      expect(e.data, isNull);
    });

    test('creates with all fields', () {
      const e = ApiException(
        message: 'not found',
        statusCode: 404,
        data: {'error': 'missing'},
      );
      expect(e.statusCode, 404);
      expect(e.data, isA<Map>());
    });

    test('toString includes status code and message', () {
      const e = ApiException(message: 'test', statusCode: 500);
      expect(e.toString(), 'ApiException(500): test');
    });

    group('fromDioException', () {
      test('handles connection timeout', () {
        final dioError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: '/test'),
        );
        final e = ApiException.fromDioException(dioError);
        expect(e.message, contains('timed out'));
      });

      test('handles send timeout', () {
        final dioError = DioException(
          type: DioExceptionType.sendTimeout,
          requestOptions: RequestOptions(path: '/test'),
        );
        final e = ApiException.fromDioException(dioError);
        expect(e.message, contains('timed out'));
      });

      test('handles receive timeout', () {
        final dioError = DioException(
          type: DioExceptionType.receiveTimeout,
          requestOptions: RequestOptions(path: '/test'),
        );
        final e = ApiException.fromDioException(dioError);
        expect(e.message, contains('timed out'));
      });

      test('handles connection error', () {
        final dioError = DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: '/test'),
        );
        final e = ApiException.fromDioException(dioError);
        expect(e.message, contains('internet'));
      });

      test('handles 400 bad response', () {
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(path: '/test'),
          ),
        );
        final e = ApiException.fromDioException(dioError);
        expect(e.statusCode, 400);
        expect(e.message, contains('Invalid'));
      });

      test('handles 401 bad response', () {
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/test'),
          ),
        );
        final e = ApiException.fromDioException(dioError);
        expect(e.statusCode, 401);
        expect(e.message, contains('Authentication'));
      });

      test('handles 403 bad response', () {
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 403,
            requestOptions: RequestOptions(path: '/test'),
          ),
        );
        final e = ApiException.fromDioException(dioError);
        expect(e.statusCode, 403);
        expect(e.message, contains('permission'));
      });

      test('handles 404 bad response', () {
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: '/test'),
          ),
        );
        final e = ApiException.fromDioException(dioError);
        expect(e.statusCode, 404);
        expect(e.message, contains('not found'));
      });

      test('handles 500 bad response', () {
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: '/test'),
          ),
        );
        final e = ApiException.fromDioException(dioError);
        expect(e.statusCode, 500);
        expect(e.message, contains('Server error'));
      });

      test('handles unknown error type', () {
        final dioError = DioException(
          type: DioExceptionType.unknown,
          requestOptions: RequestOptions(path: '/test'),
          message: 'Something broke',
        );
        final e = ApiException.fromDioException(dioError);
        expect(e.message, 'Something broke');
      });

      test('handles unknown error with null message', () {
        final dioError = DioException(
          type: DioExceptionType.unknown,
          requestOptions: RequestOptions(path: '/test'),
        );
        final e = ApiException.fromDioException(dioError);
        expect(e.message, contains('unexpected'));
      });
    });
  });
}
