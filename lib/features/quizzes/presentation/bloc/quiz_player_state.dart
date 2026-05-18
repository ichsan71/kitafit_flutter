part of 'quiz_player_bloc.dart';

enum QuizPlayerStatus { initial, loading, ready, submitting, completed, failure }

class QuizPlayerState extends Equatable {
  final QuizPlayerStatus status;
  final Quiz? quiz;
  final Map<int, int> answers;
  final int currentIndex;
  final QuizAttempt? result;
  final String? errorMessage;

  const QuizPlayerState({
    required this.status,
    this.quiz,
    this.answers = const {},
    this.currentIndex = 0,
    this.result,
    this.errorMessage,
  });

  const QuizPlayerState.initial()
    : status = QuizPlayerStatus.initial,
      quiz = null,
      answers = const {},
      currentIndex = 0,
      result = null,
      errorMessage = null;

  bool get isFirstQuestion => currentIndex == 0;
  bool get isLastQuestion =>
      quiz != null && currentIndex == quiz!.questions.length - 1;
  int get totalQuestions => quiz?.questions.length ?? 0;
  bool get allAnswered =>
      quiz != null && answers.length == quiz!.questions.length;

  QuizPlayerState copyWith({
    QuizPlayerStatus? status,
    Quiz? quiz,
    Map<int, int>? answers,
    int? currentIndex,
    QuizAttempt? result,
    String? errorMessage,
  }) =>
      QuizPlayerState(
        status: status ?? this.status,
        quiz: quiz ?? this.quiz,
        answers: answers ?? this.answers,
        currentIndex: currentIndex ?? this.currentIndex,
        result: result ?? this.result,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [
    status,
    quiz,
    answers,
    currentIndex,
    result,
    errorMessage,
  ];
}
