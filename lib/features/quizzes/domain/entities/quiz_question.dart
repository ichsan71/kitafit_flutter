import 'package:equatable/equatable.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz_option.dart';

class QuizQuestion extends Equatable {
  final int id;
  final String question;
  final List<QuizOption> options;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
  });

  @override
  List<Object?> get props => [id, question, options];
}
