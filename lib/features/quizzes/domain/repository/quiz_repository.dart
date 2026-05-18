import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz_answer.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz_attempt.dart';

abstract interface class QuizRepository {
  Future<Either<Failure, Paginated<Quiz>>> getQuizzes({
    int page = 1,
    int perPage = 15,
  });

  Future<Either<Failure, Quiz>> getQuizDetail(String slug);

  Future<Either<Failure, QuizAttempt>> submitQuiz({
    required String slug,
    required List<QuizAnswer> answers,
  });

  Future<Either<Failure, List<QuizAttempt>>> getQuizHistory();
}
