import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor Dio yang mencatat semua HTTP request/response/error.
///
/// Setiap request dicatat dengan timestamp awal sehingga durasi (ms) tampil
/// di log response maupun error — berguna untuk mendiagnosis timeout.
///
/// Tag log: `API/HTTP` — terlihat di Debug Console VS Code.
class LoggingInterceptor extends Interceptor {
  static const _tag = 'API/HTTP';
  static const _startKey = '_reqStartUs';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      options.extra[_startKey] = DateTime.now().microsecondsSinceEpoch;
      final query = options.queryParameters.isNotEmpty
          ? '\n  query : ${options.queryParameters}'
          : '';
      developer.log('→ ${options.method} ${options.uri}$query', name: _tag);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final ms = _elapsedMs(response.requestOptions);
      developer.log(
        '← ${response.statusCode} ${response.requestOptions.uri} [${ms}ms]',
        name: _tag,
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final ms = _elapsedMs(err.requestOptions);
      final label = _typeLabel(err.type);
      developer.log(
        '✗ [$label] ${err.requestOptions.method} ${err.requestOptions.uri} [${ms}ms]'
        '\n  status  : ${err.response?.statusCode ?? 'no-response'}'
        '\n  message : ${err.message}',
        name: _tag,
        level: 1000,
        error: err,
      );
    }
    handler.next(err);
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  int _elapsedMs(RequestOptions options) {
    final start = options.extra[_startKey] as int?;
    if (start == null) return -1;
    return (DateTime.now().microsecondsSinceEpoch - start) ~/ 1000;
  }

  String _typeLabel(DioExceptionType type) => switch (type) {
    DioExceptionType.connectionTimeout => 'CONNECTION_TIMEOUT',
    DioExceptionType.sendTimeout => 'SEND_TIMEOUT',
    DioExceptionType.receiveTimeout => 'RECEIVE_TIMEOUT',
    DioExceptionType.connectionError => 'CONNECTION_ERROR',
    DioExceptionType.badResponse => 'BAD_RESPONSE',
    DioExceptionType.cancel => 'CANCELLED',
    DioExceptionType.badCertificate => 'BAD_CERTIFICATE',
    DioExceptionType.unknown => 'UNKNOWN',
  };
}
