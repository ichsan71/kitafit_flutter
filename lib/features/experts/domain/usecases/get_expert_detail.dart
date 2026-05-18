import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/experts/domain/entities/expert.dart';
import 'package:todo_clean_bloc/features/experts/domain/repository/expert_repository.dart';

class GetExpertDetail implements UseCase<Expert, int> {
  final ExpertRepository repository;
  GetExpertDetail({required this.repository});

  @override
  Future<Either<Failure, Expert>> call(int id) =>
      repository.getExpertDetail(id);
}
