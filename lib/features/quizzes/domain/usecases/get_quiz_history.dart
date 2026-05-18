import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz_attempt.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/repository/quiz_repository.dart';

class GetQuizHistory implements UseCase<List<QuizAttempt>, NoParams> {
  final QuizRepository repository;
  GetQuizHistory({required this.repository});

  @override
  Future<Either<Failure, List<QuizAttempt>>> call(NoParams params) =>
      repository.getQuizHistory();
}
