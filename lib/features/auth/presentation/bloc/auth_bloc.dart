import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:todo_clean_bloc/core/common/entities/user.dart';
import 'package:todo_clean_bloc/core/error/failure.dart' as core_failure;
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/current_user.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/exchange_sanctum_token.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/get_profile.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/update_profile.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/user_sign_in.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/user_sign_in_google.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/user_sign_out.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final UserSignInGoogle _userSignInGoogle;
  final UserSignOut _userSignOut;
  final CurrentUser _currentUser;
  final ExchangeSanctumToken _exchangeSanctumToken;
  final GetProfile _getProfile;
  final UpdateProfile _updateProfile;
  final AppUserCubit appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required UserSignInGoogle userSignInGoogle,
    required UserSignOut userSignOut,
    required CurrentUser currentUser,
    required ExchangeSanctumToken exchangeSanctumToken,
    required GetProfile getProfile,
    required UpdateProfile updateProfile,
    required this.appUserCubit,
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _userSignInGoogle = userSignInGoogle,
        _userSignOut = userSignOut,
        _currentUser = currentUser,
        _exchangeSanctumToken = exchangeSanctumToken,
        _getProfile = getProfile,
        _updateProfile = updateProfile,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignup>(_onAuthSignup);
    on<AuthSignin>(_onAuthSignIn);
    on<AuthSignInWithGoogle>(_onAuthSignInWithGoogle);
    on<AuthSignOut>(_onAuthSignOut);
    on<AuthCheckCurrentUser>(_onCurrentUser);
    on<AuthExchangeSanctumToken>(_onExchangeSanctumToken);
    on<AuthLoadProfile>(_onLoadProfile);
    on<AuthUpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onAuthSignup(AuthSignup event, Emitter<AuthState> emit) async {
    final res = await _userSignUp.call(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );
    _foldUser(res, emit);
  }

  Future<void> _onAuthSignIn(AuthSignin event, Emitter<AuthState> emit) async {
    final res = await _userSignIn.call(
      SignInParams(email: event.email, password: event.password),
    );
    _foldUser(res, emit);
  }

  Future<void> _onAuthSignInWithGoogle(
    AuthSignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userSignInGoogle.call(NoParams());
    _foldUser(res, emit);
  }

  Future<void> _onAuthSignOut(
    AuthSignOut event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userSignOut.call(NoParams());
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) {
        appUserCubit.updateUser(null);
        emit(AuthInitial());
      },
    );
  }

  Future<void> _onCurrentUser(
    AuthCheckCurrentUser event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());
    res.fold(
      (failure) {
        debugPrint('AuthBloc.currentUser failed: ${failure.message}');
        appUserCubit.updateUser(null);
        emit(AuthInitial());
      },
      (user) {
        if (user == null) {
          appUserCubit.updateUser(null);
          emit(AuthInitial());
        } else {
          _emitSuccess(user, emit);
        }
      },
    );
  }

  Future<void> _onExchangeSanctumToken(
    AuthExchangeSanctumToken event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _exchangeSanctumToken.call(NoParams());
    _foldUser(res, emit);
  }

  Future<void> _onLoadProfile(
    AuthLoadProfile event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _getProfile.call(NoParams());
    _foldUser(res, emit);
  }

  Future<void> _onUpdateProfile(
    AuthUpdateProfile event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _updateProfile.call(
      UpdateProfileParams(
        name: event.name,
        phone: event.phone,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
        avatarPath: event.avatarPath,
      ),
    );
    _foldUser(res, emit);
  }

  void _foldUser(
    Either<core_failure.Failure, User> res,
    Emitter<AuthState> emit,
  ) {
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitSuccess(user, emit),
    );
  }

  void _emitSuccess(User user, Emitter<AuthState> emit) {
    appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
