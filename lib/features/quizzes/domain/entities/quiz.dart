import 'package:equatable/equatable.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz_question.dart';

class Quiz extends Equatable {
  final int id;
  final String title;
  final String slug;
  final String? description;
  final int? questionsCount;
  final List<QuizQuestion> questions;
  final DateTime? publishedAt;

  const Quiz({
    required this.id,
    required this.title,
    required this.slug,
    this.description,
    this.questionsCount,
    this.questions = const [],
    this.publishedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    slug,
    description,
    questionsCount,
    questions,
    publishedAt,
  ];
}
