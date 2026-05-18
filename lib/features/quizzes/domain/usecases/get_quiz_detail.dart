import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/repository/quiz_repository.dart';

class GetQuizDetail implements UseCase<Quiz, String> {
  final QuizRepository repository;
  GetQuizDetail({required this.repository});

  @override
  Future<Either<Failure, Quiz>> call(String slug) =>
      repository.getQuizDetail(slug);
}
