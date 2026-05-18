import 'package:equatable/equatable.dart';

class QuizAttemptSummary extends Equatable {
  final int id;
  final String title;
  final String? slug;

  const QuizAttemptSummary({required this.id, required this.title, this.slug});

  @override
  List<Object?> get props => [id, title, slug];
}

class QuizAttempt extends Equatable {
  final int id;
  final QuizAttemptSummary quiz;
  final int score;
  final int totalQuestions;
  final DateTime? completedAt;

  const QuizAttempt({
    required this.id,
    required this.quiz,
    required this.score,
    required this.totalQuestions,
    this.completedAt,
  });

  double get percentage =>
      totalQuestions == 0 ? 0 : (score / totalQuestions) * 100;

  @override
  List<Object?> get props => [id, quiz, score, totalQuestions, completedAt];
}
