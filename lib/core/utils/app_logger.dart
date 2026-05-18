import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Logger terscope per fitur.
///
/// Gunakan sebagai static field di class repository / data source:
/// ```dart
/// static final _log = AppLogger('articles');
/// ```
///
/// Level:
///  - [info]    → level 800  (alur normal)
///  - [warning] → level 900  (kondisi tidak normal tapi ditoleransi)
///  - [error]   → level 1000 (kegagalan yang perlu perhatian)
///
/// Semua log hanya aktif saat `kDebugMode = true` (flutter run tanpa --release).
/// Tampil di Debug Console VS Code dengan tag `KitaFit/<feature>`.
class AppLogger {
  final String feature;

  const AppLogger(this.feature);

  /// Log informasi (alur normal).
  void info(String message) => _emit(message, level: 800);

  /// Log peringatan (bukan error, tapi perlu diperhatikan).
  void warning(String message) => _emit(message, level: 900);

  /// Log error beserta object exception dan stack trace opsional.
  void error(String message, {Object? error, StackTrace? stackTrace}) =>
      _emit(message, level: 1000, error: error, stackTrace: stackTrace);

  void _emit(
    String message, {
    int level = 800,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      developer.log(
        message,
        name: 'KitaFit/$feature',
        level: level,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
