import 'package:dio/dio.dart';
import 'package:todo_clean_bloc/core/config/app_config.dart';
import 'package:todo_clean_bloc/core/error/exception.dart';
import 'package:todo_clean_bloc/core/network/api_response.dart';
import 'package:todo_clean_bloc/core/network/exception_mapper.dart';
import 'package:todo_clean_bloc/core/network/interceptors/auth_interceptor.dart';
import 'package:todo_clean_bloc/core/network/interceptors/logging_interceptor.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/core/storage/token_storage.dart';

/// Thin wrapper around Dio that:
///  - centralises base URL, timeouts, default headers
///  - converts [DioException] → typed [AppException] via [ExceptionMapper]
///  - unwraps Laravel `{success,message,data}` envelopes via [ApiResponse]
///
/// Pass `requiresAuth: false` for public endpoints.
class ApiClient {
  final Dio _dio;

  ApiClient._(this._dio);

  factory ApiClient.create({
    required TokenStorage tokenStorage,
    Future<void> Function()? onUnauthorized,
    Dio? dio,
  }) {
    final instance = dio ??
        Dio(
          BaseOptions(
            baseUrl: AppConfig.baseUrl,
            connectTimeout: AppConfig.connectTimeout,
            receiveTimeout: AppConfig.receiveTimeout,
            sendTimeout: AppConfig.sendTimeout,
            headers: const {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            responseType: ResponseType.json,
          ),
        );

    instance.interceptors.add(
      AuthInterceptor(
        tokenStorage: tokenStorage,
        onUnauthorized: onUnauthorized,
      ),
    );
    if (AppConfig.enableLogging) {
      instance.interceptors.add(LoggingInterceptor());
    }
    return ApiClient._(instance);
  }

  Dio get raw => _dio;

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Parser<T>? parser,
    bool requiresAuth = true,
  }) =>
      _send<T>(
        () => _dio.get(
          path,
          queryParameters: query,
          options: _options(requiresAuth: requiresAuth),
        ),
        parser,
      );

  Future<T> post<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    Parser<T>? parser,
    bool requiresAuth = true,
  }) =>
      _send<T>(
        () => _dio.post(
          path,
          data: body,
          queryParameters: query,
          options: _options(requiresAuth: requiresAuth),
        ),
        parser,
      );

  Future<T> put<T>(
    String path, {
    Object? body,
    Parser<T>? parser,
    bool requiresAuth = true,
  }) =>
      _send<T>(
        () => _dio.put(
          path,
          data: body,
          options: _options(requiresAuth: requiresAuth),
        ),
        parser,
      );

  Future<T> delete<T>(
    String path, {
    Object? body,
    Parser<T>? parser,
    bool requiresAuth = true,
  }) =>
      _send<T>(
        () => _dio.delete(
          path,
          data: body,
          options: _options(requiresAuth: requiresAuth),
        ),
        parser,
      );

  Future<Paginated<T>> getPaginated<T>(
    String path, {
    Map<String, dynamic>? query,
    required T Function(Map<String, dynamic>) itemFromJson,
    bool requiresAuth = true,
  }) =>
      _send<Paginated<T>>(
        () => _dio.get(
          path,
          queryParameters: query,
          options: _options(requiresAuth: requiresAuth),
        ),
        (raw) => Paginated.fromJson(raw as Map<String, dynamic>, itemFromJson),
      );

  Future<T> _send<T>(
    Future<Response<dynamic>> Function() request,
    Parser<T>? parser,
  ) async {
    try {
      final response = await request();
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        throw const ParseException();
      }
      final wrapped = ApiResponse<T>.fromJson(
        body,
        parser ?? identityParser<T>,
      );
      if (wrapped.data is! T) {
        // Tolerate void-like calls where T == dynamic
        return wrapped.data as T;
      }
      return wrapped.data as T;
    } on DioException catch (e) {
      throw ExceptionMapper.fromDio(e);
    } on AppException {
      rethrow;
    } catch (_) {
      throw const ParseException();
    }
  }

  Options _options({required bool requiresAuth}) =>
      Options(extra: {'requiresAuth': requiresAuth});
}
