import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure([
    this.message = 'Terjadi kesalahan tak terduga',
    this.statusCode,
  ]);

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Terjadi kesalahan pada server',
    super.statusCode,
  ]);
}

class AuthFailure extends Failure {
  const AuthFailure([
    String message = 'Sesi anda telah berakhir, silakan login kembali',
  ]) : super(message, 401);
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure([String message = 'Akses ditolak'])
    : super(message, 403);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Data tidak ditemukan'])
    : super(message, 404);
}

class ValidationFailure extends Failure {
  final Map<String, List<String>> errors;
  const ValidationFailure(
    String message, {
    this.errors = const {},
  }) : super(message, 422);

  @override
  List<Object?> get props => [...super.props, errors];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Tidak ada koneksi internet']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Gagal membaca data lokal']);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Terjadi kesalahan tak terduga']);
}
