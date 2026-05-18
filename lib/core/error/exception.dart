abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  const AppException(this.message, {this.statusCode});

  @override
  String toString() => '$runtimeType($statusCode): $message';
}

class ServerException extends AppException {
  const ServerException([
    super.message = 'Terjadi kesalahan pada server',
    int? statusCode,
  ]) : super(statusCode: statusCode);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Sesi anda telah berakhir, silakan login kembali',
  ]) : super(statusCode: 401);
}

class ForbiddenException extends AppException {
  const ForbiddenException([
    super.message = 'Anda tidak memiliki akses ke resource ini',
  ]) : super(statusCode: 403);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Data tidak ditemukan'])
    : super(statusCode: 404);
}

class ValidationException extends AppException {
  final Map<String, List<String>> errors;
  const ValidationException(
    super.message, {
    this.errors = const {},
  }) : super(statusCode: 422);
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Tidak ada koneksi internet']);
}

class ParseException extends AppException {
  const ParseException([super.message = 'Gagal memproses data dari server']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Gagal membaca data lokal']);
}
