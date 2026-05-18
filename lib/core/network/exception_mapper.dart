import 'dart:io';

import 'package:dio/dio.dart';
import 'package:todo_clean_bloc/core/error/exception.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';

class ExceptionMapper {
  const ExceptionMapper._();

  static AppException fromDio(DioException error) {
    final response = error.response;
    final status = response?.statusCode;
    final data = response?.data;
    final message = _extractMessage(data) ?? error.message ?? 'Permintaan gagal';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('Koneksi timeout, coba lagi');
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.cancel:
        return const ServerException('Permintaan dibatalkan');
      case DioExceptionType.badCertificate:
        return const ServerException('Sertifikat server tidak valid');
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return const NetworkException();
        }
        break;
      case DioExceptionType.badResponse:
        break;
    }

    switch (status) {
      case 401:
        return UnauthorizedException(message);
      case 403:
        return ForbiddenException(message);
      case 404:
        return NotFoundException(message);
      case 422:
        return ValidationException(
          message,
          errors: _extractValidationErrors(data),
        );
      default:
        if (status != null && status >= 500) {
          return ServerException(message, status);
        }
        return ServerException(message, status);
    }
  }

  static Failure toFailure(AppException exception) {
    if (exception is UnauthorizedException) {
      return AuthFailure(exception.message);
    }
    if (exception is ForbiddenException) {
      return ForbiddenFailure(exception.message);
    }
    if (exception is NotFoundException) {
      return NotFoundFailure(exception.message);
    }
    if (exception is ValidationException) {
      return ValidationFailure(exception.message, errors: exception.errors);
    }
    if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    }
    if (exception is CacheException) {
      return CacheFailure(exception.message);
    }
    if (exception is ServerException) {
      return ServerFailure(exception.message, exception.statusCode);
    }
    return UnexpectedFailure(exception.message);
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return null;
  }

  static Map<String, List<String>> _extractValidationErrors(dynamic data) {
    if (data is! Map) return const {};
    final errors = data['errors'];
    if (errors is! Map) return const {};
    return errors.map<String, List<String>>((key, value) {
      final list = value is List
          ? value.map((e) => e.toString()).toList()
          : <String>[value.toString()];
      return MapEntry(key.toString(), list);
    });
  }
}
