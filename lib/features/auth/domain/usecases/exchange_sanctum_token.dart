import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/common/entities/user.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/auth/domain/repository/auth_repository.dart';

class ExchangeSanctumToken implements UseCase<User, NoParams> {
  final AuthRepository repository;
  ExchangeSanctumToken({required this.repository});

  @override
  Future<Either<Failure, User>> call(NoParams params) =>
      repository.exchangeFirebaseSession();
}
