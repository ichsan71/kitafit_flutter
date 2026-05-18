import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/features/experts/domain/entities/expert.dart';

abstract interface class ExpertRepository {
  Future<Either<Failure, List<Expert>>> getExperts();
  Future<Either<Failure, Expert>> getExpertDetail(int id);
}
