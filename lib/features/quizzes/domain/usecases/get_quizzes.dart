import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/repository/quiz_repository.dart';

class GetQuizzesParams extends Equatable {
  final int page;
  final int perPage;
  const GetQuizzesParams({this.page = 1, this.perPage = 15});

  @override
  List<Object?> get props => [page, perPage];
}

class GetQuizzes implements UseCase<Paginated<Quiz>, GetQuizzesParams> {
  final QuizRepository repository;
  GetQuizzes({required this.repository});

  @override
  Future<Either<Failure, Paginated<Quiz>>> call(GetQuizzesParams params) =>
      repository.getQuizzes(page: params.page, perPage: params.perPage);
}
