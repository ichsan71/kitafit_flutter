import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/common/entities/user.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/auth/domain/repository/auth_repository.dart';

class UpdateProfileParams extends Equatable {
  final String? name;
  final String? phone;
  final String? password;
  final String? passwordConfirmation;
  final String? avatarPath;

  const UpdateProfileParams({
    this.name,
    this.phone,
    this.password,
    this.passwordConfirmation,
    this.avatarPath,
  });

  @override
  List<Object?> get props => [name, phone, password, passwordConfirmation, avatarPath];
}

class UpdateProfile implements UseCase<User, UpdateProfileParams> {
  final AuthRepository repository;
  UpdateProfile({required this.repository});

  @override
  Future<Either<Failure, User>> call(UpdateProfileParams params) =>
      repository.updateProfile(
        name: params.name,
        phone: params.phone,
        password: params.password,
        passwordConfirmation: params.passwordConfirmation,
        avatarPath: params.avatarPath,
      );
}
