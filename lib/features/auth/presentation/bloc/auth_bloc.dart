import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/core/common/entities/user.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/current_user.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/user_sign_in.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CurrentUser _currentUser;
  final AppUserCubit appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required CurrentUser currentUser,
    required this.appUserCubit,
  }) : _userSignUp = userSignUp,
       _userSignIn = userSignIn,
       _currentUser = currentUser,
       super(AuthInitial()) {
    // Initial state handler
    on<AuthEvent>((_, emit) => emit(AuthLoading()));

    // Handler untuk SignUp
    on<AuthSignup>(_onAuthSignup);

    // Handler untuk SignIn
    on<AuthSignin>(_onAuthSignIn);

    // Handler untuk memeriksa user saat ini
    on<AuthCheckCurrentUser>(_getCurrentUser);
  }

  // Method untuk handle SignUp
  Future<void> _onAuthSignup(AuthSignup event, Emitter<AuthState> emit) async {
    debugPrint('AuthBloc: AuthSignup event received');

    final res = await _userSignUp.call(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    res.fold(
      (failure) {
        debugPrint('AuthBloc: Signup failed - ${failure.message}');
        emit(AuthFailure(failure.message));
      },
      (user) {
        debugPrint('AuthBloc: Signup success - userId: ${user.id}');
        emitAuthSuccess(user, emit);
      },
    );
  }

  // Method untuk handle SignIn
  Future<void> _onAuthSignIn(AuthSignin event, Emitter<AuthState> emit) async {
    debugPrint('AuthBloc: AuthSignIn event received');

    final res = await _userSignIn.call(
      SignInParams(email: event.email, password: event.password),
    );

    res.fold(
      (failure) {
        debugPrint('AuthBloc: SignIn failed - ${failure.message}');
        emit(AuthFailure(failure.message));
      },
      (user) {
        debugPrint('AuthBloc: SignIn success - userId: ${user.id}');
        emitAuthSuccess(user, emit);
      },
    );
  }

  // Method untuk mendapatkan data user saat ini
  Future<void> _getCurrentUser(
    AuthCheckCurrentUser event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    res.fold(
      (l) {
        debugPrint('AuthBloc: Failed to fetch current user - ${l.message}');
        emit(AuthFailure(l.message));
      },
      (r) {
        debugPrint('AuthBloc: Current user fetched - userId: ${r?.email}');
        emitAuthSuccess(r!, emit);
      },
    );
  }

  void emitAuthSuccess(User user, Emitter<AuthState> emit) {
    appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
