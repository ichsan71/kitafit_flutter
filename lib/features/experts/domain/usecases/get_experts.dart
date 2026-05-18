import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/experts/domain/entities/expert.dart';
import 'package:todo_clean_bloc/features/experts/domain/repository/expert_repository.dart';

class GetExperts implements UseCase<List<Expert>, NoParams> {
  final ExpertRepository repository;
  GetExperts({required this.repository});

  @override
  Future<Either<Failure, List<Expert>>> call(NoParams params) =>
      repository.getExperts();
}
