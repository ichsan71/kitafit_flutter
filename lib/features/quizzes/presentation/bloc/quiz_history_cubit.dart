import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz_attempt.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/usecases/get_quiz_history.dart';

enum QuizHistoryStatus { initial, loading, success, failure }

class QuizHistoryState extends Equatable {
  final QuizHistoryStatus status;
  final List<QuizAttempt> attempts;
  final String? errorMessage;

  const QuizHistoryState({
    required this.status,
    this.attempts = const [],
    this.errorMessage,
  });

  const QuizHistoryState.initial()
    : status = QuizHistoryStatus.initial,
      attempts = const [],
      errorMessage = null;

  QuizHistoryState copyWith({
    QuizHistoryStatus? status,
    List<QuizAttempt>? attempts,
    String? errorMessage,
  }) =>
      QuizHistoryState(
        status: status ?? this.status,
        attempts: attempts ?? this.attempts,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, attempts, errorMessage];
}

class QuizHistoryCubit extends Cubit<QuizHistoryState> {
  final GetQuizHistory _getQuizHistory;
  QuizHistoryCubit({required GetQuizHistory getQuizHistory})
    : _getQuizHistory = getQuizHistory,
      super(const QuizHistoryState.initial());

  Future<void> load() async {
    emit(state.copyWith(status: QuizHistoryStatus.loading));
    final res = await _getQuizHistory.call(NoParams());
    res.fold(
      (failure) => emit(
        state.copyWith(
          status: QuizHistoryStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (list) => emit(
        state.copyWith(status: QuizHistoryStatus.success, attempts: list),
      ),
    );
  }
}
