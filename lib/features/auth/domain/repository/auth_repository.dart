import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/common/entities/user.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signInWithGoogle();

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, User?>> getCurrentUserData();

  /// Exchange Firebase ID token (current Firebase session) → Sanctum token.
  /// Token disimpan di [TokenStorage] dan user terbaru dikembalikan.
  Future<Either<Failure, User>> exchangeFirebaseSession();

  /// Ambil profil dari backend Laravel via Sanctum.
  Future<Either<Failure, User>> getProfile();

  /// Update profil (multipart) dan refresh user.
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? phone,
    String? password,
    String? passwordConfirmation,
    String? avatarPath,
  });
}
