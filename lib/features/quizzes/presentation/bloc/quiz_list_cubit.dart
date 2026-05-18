import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/usecases/get_quizzes.dart';

enum QuizListStatus { initial, loading, success, failure }

class QuizListState extends Equatable {
  final QuizListStatus status;
  final List<Quiz> quizzes;
  final String? errorMessage;

  const QuizListState({
    required this.status,
    this.quizzes = const [],
    this.errorMessage,
  });

  const QuizListState.initial()
    : status = QuizListStatus.initial,
      quizzes = const [],
      errorMessage = null;

  QuizListState copyWith({
    QuizListStatus? status,
    List<Quiz>? quizzes,
    String? errorMessage,
  }) =>
      QuizListState(
        status: status ?? this.status,
        quizzes: quizzes ?? this.quizzes,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, quizzes, errorMessage];
}

class QuizListCubit extends Cubit<QuizListState> {
  final GetQuizzes _getQuizzes;
  QuizListCubit({required GetQuizzes getQuizzes})
    : _getQuizzes = getQuizzes,
      super(const QuizListState.initial());

  Future<void> load() async {
    emit(state.copyWith(status: QuizListStatus.loading));
    final res = await _getQuizzes.call(const GetQuizzesParams());
    res.fold(
      (failure) => emit(
        state.copyWith(
          status: QuizListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (page) => emit(
        state.copyWith(status: QuizListStatus.success, quizzes: page.items),
      ),
    );
  }
}
