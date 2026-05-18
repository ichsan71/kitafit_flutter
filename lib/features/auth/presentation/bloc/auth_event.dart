part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignup extends AuthEvent {
  final String email;
  final String password;
  final String name;

  AuthSignup({required this.email, required this.password, required this.name});
}

final class AuthSignin extends AuthEvent {
  final String email;
  final String password;

  AuthSignin({required this.email, required this.password});
}

final class AuthSignOut extends AuthEvent {}

final class AuthSignInWithGoogle extends AuthEvent {}

final class AuthCheckCurrentUser extends AuthEvent {}

final class AuthExchangeSanctumToken extends AuthEvent {}

final class AuthLoadProfile extends AuthEvent {}

final class AuthUpdateProfile extends AuthEvent {
  final String? name;
  final String? phone;
  final String? password;
  final String? passwordConfirmation;
  final String? avatarPath;

  AuthUpdateProfile({
    this.name,
    this.phone,
    this.password,
    this.passwordConfirmation,
    this.avatarPath,
  });
}
