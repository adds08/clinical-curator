import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_environment.dart';
import 'api_interceptors.dart';

class ApiConfig {
  static String get defaultBaseUrl => AppEnvironment.fhirBaseUrl;
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

class ApiClient {
  final Dio _dio;

  ApiClient({String? baseUrl})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ?? ApiConfig.defaultBaseUrl,
            connectTimeout: ApiConfig.connectTimeout,
            receiveTimeout: ApiConfig.receiveTimeout,
            headers: {
              'Content-Type': 'application/fhir+json',
              'Accept': 'application/fhir+json',
            },
          ),
        ) {
    _dio.interceptors.addAll([
      AuthInterceptor(),
      ConnectivityInterceptor(),
      LoggingInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    CancelToken? cancelToken,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    CancelToken? cancelToken,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    CancelToken? cancelToken,
  }) {
    return _dio.delete<T>(
      path,
      cancelToken: cancelToken,
    );
  }
}

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});
