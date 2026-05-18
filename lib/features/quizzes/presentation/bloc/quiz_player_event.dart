part of 'quiz_player_bloc.dart';

sealed class QuizPlayerEvent extends Equatable {
  const QuizPlayerEvent();
  @override
  List<Object?> get props => [];
}

class QuizPlayerLoadRequested extends QuizPlayerEvent {
  final String slug;
  const QuizPlayerLoadRequested(this.slug);
  @override
  List<Object?> get props => [slug];
}

class QuizPlayerAnswerSelected extends QuizPlayerEvent {
  final int questionId;
  final int optionId;
  const QuizPlayerAnswerSelected({
    required this.questionId,
    required this.optionId,
  });
  @override
  List<Object?> get props => [questionId, optionId];
}

class QuizPlayerNext extends QuizPlayerEvent {
  const QuizPlayerNext();
}

class QuizPlayerPrevious extends QuizPlayerEvent {
  const QuizPlayerPrevious();
}

class QuizPlayerSubmitted extends QuizPlayerEvent {
  const QuizPlayerSubmitted();
}
