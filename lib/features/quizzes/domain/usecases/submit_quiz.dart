import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz_answer.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz_attempt.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/repository/quiz_repository.dart';

class SubmitQuizParams extends Equatable {
  final String slug;
  final List<QuizAnswer> answers;
  const SubmitQuizParams({required this.slug, required this.answers});

  @override
  List<Object?> get props => [slug, answers];
}

class SubmitQuiz implements UseCase<QuizAttempt, SubmitQuizParams> {
  final QuizRepository repository;
  SubmitQuiz({required this.repository});

  @override
  Future<Either<Failure, QuizAttempt>> call(SubmitQuizParams params) =>
      repository.submitQuiz(slug: params.slug, answers: params.answers);
}
