import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/common/entities/user.dart';
import 'package:todo_clean_bloc/core/error/exception.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/network/exception_mapper.dart';
import 'package:todo_clean_bloc/core/storage/token_storage.dart';
import 'package:todo_clean_bloc/core/utils/app_logger.dart';
import 'package:todo_clean_bloc/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:todo_clean_bloc/features/auth/data/datasources/sanctum_auth_remote_data_source.dart';
import 'package:todo_clean_bloc/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  static final _log = AppLogger('auth');

  final AuthRemoteDataSource firebaseDataSource;
  final SanctumAuthRemoteDataSource sanctumDataSource;
  final TokenStorage tokenStorage;
  final fb.FirebaseAuth firebaseAuth;

  AuthRepositoryImpl({
    required this.firebaseDataSource,
    required this.sanctumDataSource,
    required this.tokenStorage,
    required this.firebaseAuth,
  });

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    _log.info('signInWithEmailAndPassword(email: $email)');
    return _firebaseThenExchange(
      () => firebaseDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) {
    _log.info('signUpWithEmailAndPassword(email: $email)');
    return _firebaseThenExchange(
      () => firebaseDataSource.signUpWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() {
    _log.info('signInWithGoogle()');
    return _firebaseThenExchange(() => firebaseDataSource.signInWithGoogle());
  }

  Future<Either<Failure, User>> _firebaseThenExchange(
    Future<User> Function() firebaseStep,
  ) async {
    try {
      final firebaseUser = await firebaseStep();
      final result = await _exchangeAndStore(firebaseUser);
      result.fold(
        (f) => _log.error('_firebaseThenExchange ✗ ${f.message}'),
        (u) => _log.info('_firebaseThenExchange ✓ uid=${u.id}'),
      );
      return result;
    } on AppException catch (e) {
      _log.error(
        '_firebaseThenExchange ✗ ${e.runtimeType}: ${e.message}',
        error: e,
      );
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error(
        '_firebaseThenExchange ✗ unexpected: $e',
        error: e,
        stackTrace: st,
      );
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<Either<Failure, User>> _exchangeAndStore(User firebaseUser) async {
    final idToken = await firebaseAuth.currentUser?.getIdToken();
    if (idToken == null) {
      return const Left(AuthFailure('Sesi Firebase tidak ditemukan'));
    }
    final exchanged = await sanctumDataSource.exchangeFirebaseToken(
      firebaseIdToken: idToken,
      name: firebaseUser.name.isEmpty ? null : firebaseUser.name,
      email: firebaseUser.email.isEmpty ? null : firebaseUser.email,
    );
    await tokenStorage.saveToken(exchanged.token);
    return Right(exchanged.user);
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    _log.info('signOut()');
    try {
      if (await tokenStorage.hasToken()) {
        try {
          await sanctumDataSource.logout();
        } on AppException {
          // Abaikan kegagalan logout backend agar client tetap bisa logout.
          _log.warning('signOut: backend logout gagal, lanjut logout lokal');
        }
      }
      await tokenStorage.clearToken();
      await firebaseDataSource.signOut();
      _log.info('signOut ✓');
      return const Right(null);
    } on ServerException catch (e) {
      _log.error('signOut ✗ ServerException: ${e.message}', error: e);
      return Left(ServerFailure(e.message));
    } catch (e, st) {
      _log.error('signOut ✗ unexpected: $e', error: e, stackTrace: st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUserData() async {
    _log.info('getCurrentUserData()');
    try {
      if (await tokenStorage.hasToken()) {
        final user = await sanctumDataSource.getProfile();
        _log.info('getCurrentUserData ✓ (sanctum) uid=${user.id}');
        return Right(user);
      }
      final user = await firebaseDataSource.getCurrentUserData();
      _log.info('getCurrentUserData ✓ (firebase) uid=${user?.id}');
      return Right(user);
    } on UnauthorizedException catch (e) {
      _log.warning('getCurrentUserData: token tidak valid, clearToken');
      await tokenStorage.clearToken();
      return Left(AuthFailure(e.message));
    } on AppException catch (e) {
      _log.error(
        'getCurrentUserData ✗ ${e.runtimeType}: ${e.message}',
        error: e,
      );
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error(
        'getCurrentUserData ✗ unexpected: $e',
        error: e,
        stackTrace: st,
      );
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> exchangeFirebaseSession() async {
    _log.info('exchangeFirebaseSession()');
    final fbUser = firebaseAuth.currentUser;
    if (fbUser == null) {
      return const Left(AuthFailure('Belum login ke Firebase'));
    }
    try {
      final user = User(
        id: fbUser.uid,
        email: fbUser.email ?? '',
        name: fbUser.displayName ?? '',
      );
      final result = await _exchangeAndStore(user);
      result.fold(
        (f) => _log.error('exchangeFirebaseSession ✗ ${f.message}'),
        (u) => _log.info('exchangeFirebaseSession ✓ uid=${u.id}'),
      );
      return result;
    } on AppException catch (e) {
      _log.error(
        'exchangeFirebaseSession ✗ ${e.runtimeType}: ${e.message}',
        error: e,
      );
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error(
        'exchangeFirebaseSession ✗ unexpected: $e',
        error: e,
        stackTrace: st,
      );
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getProfile() async {
    _log.info('getProfile()');
    try {
      final user = await sanctumDataSource.getProfile();
      _log.info('getProfile ✓ uid=${user.id}');
      return Right(user);
    } on AppException catch (e) {
      _log.error('getProfile ✗ ${e.runtimeType}: ${e.message}', error: e);
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error('getProfile ✗ unexpected: $e', error: e, stackTrace: st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? phone,
    String? password,
    String? passwordConfirmation,
    String? avatarPath,
  }) async {
    _log.info(
      'updateProfile(name: $name, phone: $phone, hasAvatar: ${avatarPath != null})',
    );
    try {
      final user = await sanctumDataSource.updateProfile(
        name: name,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
        avatarPath: avatarPath,
      );
      _log.info('updateProfile ✓ uid=${user.id}');
      return Right(user);
    } on AppException catch (e) {
      _log.error('updateProfile ✗ ${e.runtimeType}: ${e.message}', error: e);
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error('updateProfile ✗ unexpected: $e', error: e, stackTrace: st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
