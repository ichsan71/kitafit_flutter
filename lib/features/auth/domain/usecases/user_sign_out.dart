import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/auth/domain/repository/auth_repository.dart';

class UserSignOut implements UseCase<void, NoParams> {
  final AuthRepository repository;
  UserSignOut({required this.repository});

  @override
  Future<Either<Failure, void>> call(NoParams params) => repository.signOut();
}
