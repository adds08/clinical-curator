import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  factory ApiException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          message: 'Connection timed out. Please try again.',
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'No internet connection.',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        return ApiException(
          message: _messageForStatusCode(statusCode),
          statusCode: statusCode,
          data: data,
        );
      default:
        return ApiException(
          message: e.message ?? 'An unexpected error occurred.',
        );
    }
  }

  static String _messageForStatusCode(int? code) {
    switch (code) {
      case 400:
        return 'Invalid request.';
      case 401:
        return 'Authentication required. Please log in again.';
      case 403:
        return 'You do not have permission to access this resource.';
      case 404:
        return 'Resource not found.';
      case 409:
        return 'Conflict — resource was modified by another user.';
      case 422:
        return 'The data provided is not valid.';
      case 429:
        return 'Too many requests. Please wait and try again.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'Request failed (status $code).';
    }
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
