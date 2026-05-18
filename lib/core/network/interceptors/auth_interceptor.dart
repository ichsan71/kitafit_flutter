import 'package:dio/dio.dart';
import 'package:todo_clean_bloc/core/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage tokenStorage;
  final Future<void> Function()? onUnauthorized;

  AuthInterceptor({required this.tokenStorage, this.onUnauthorized});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final requiresAuth = options.extra['requiresAuth'] as bool? ?? true;
    if (requiresAuth) {
      final token = await tokenStorage.readToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    options.headers.putIfAbsent('Accept', () => 'application/json');
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await tokenStorage.clearToken();
      if (onUnauthorized != null) {
        await onUnauthorized!();
      }
    }
    handler.next(err);
  }
}
