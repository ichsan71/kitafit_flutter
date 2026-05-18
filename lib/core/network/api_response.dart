import 'package:todo_clean_bloc/core/error/exception.dart';

typedef JsonMap = Map<String, dynamic>;
typedef Parser<T> = T Function(dynamic data);

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(JsonMap json, Parser<T> parser) {
    final success = json['success'] as bool? ?? false;
    final message = json['message'] as String? ?? '';
    final raw = json['data'];

    if (!success) {
      throw ServerException(message.isEmpty ? 'Permintaan gagal' : message);
    }

    return ApiResponse<T>(
      success: success,
      message: message,
      data: raw == null ? null : parser(raw),
    );
  }
}

T identityParser<T>(dynamic data) => data as T;
