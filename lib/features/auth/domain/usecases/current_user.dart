import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/core/common/entities/user.dart';
import 'package:todo_clean_bloc/features/auth/domain/repository/auth_repository.dart';

class CurrentUser implements UseCase<User?, NoParams> {
  final AuthRepository repository;

  CurrentUser({required this.repository});

  @override
  Future<Either<Failure, User?>> call(NoParams params) async {
    return await repository.getCurrentUserData();
  }
}
