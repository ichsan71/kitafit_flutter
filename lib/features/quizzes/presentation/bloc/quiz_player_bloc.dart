import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz_answer.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz_attempt.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/usecases/get_quiz_detail.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/usecases/submit_quiz.dart';

part 'quiz_player_event.dart';
part 'quiz_player_state.dart';

class QuizPlayerBloc extends Bloc<QuizPlayerEvent, QuizPlayerState> {
  final GetQuizDetail _getQuizDetail;
  final SubmitQuiz _submitQuiz;

  QuizPlayerBloc({
    required GetQuizDetail getQuizDetail,
    required SubmitQuiz submitQuiz,
  }) : _getQuizDetail = getQuizDetail,
       _submitQuiz = submitQuiz,
       super(const QuizPlayerState.initial()) {
    on<QuizPlayerLoadRequested>(_onLoad);
    on<QuizPlayerAnswerSelected>(_onAnswerSelected);
    on<QuizPlayerNext>(_onNext);
    on<QuizPlayerPrevious>(_onPrevious);
    on<QuizPlayerSubmitted>(_onSubmit);
  }

  Future<void> _onLoad(
    QuizPlayerLoadRequested event,
    Emitter<QuizPlayerState> emit,
  ) async {
    emit(state.copyWith(status: QuizPlayerStatus.loading));
    final res = await _getQuizDetail.call(event.slug);
    res.fold(
      (failure) => emit(
        state.copyWith(
          status: QuizPlayerStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (quiz) => emit(
        state.copyWith(
          status: QuizPlayerStatus.ready,
          quiz: quiz,
          answers: const {},
          currentIndex: 0,
        ),
      ),
    );
  }

  void _onAnswerSelected(
    QuizPlayerAnswerSelected event,
    Emitter<QuizPlayerState> emit,
  ) {
    final updated = Map<int, int>.from(state.answers);
    updated[event.questionId] = event.optionId;
    emit(state.copyWith(answers: updated));
  }

  void _onNext(QuizPlayerNext event, Emitter<QuizPlayerState> emit) {
    if (state.quiz == null) return;
    final last = state.quiz!.questions.length - 1;
    if (state.currentIndex < last) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    }
  }

  void _onPrevious(QuizPlayerPrevious event, Emitter<QuizPlayerState> emit) {
    if (state.currentIndex > 0) {
      emit(state.copyWith(currentIndex: state.currentIndex - 1));
    }
  }

  Future<void> _onSubmit(
    QuizPlayerSubmitted event,
    Emitter<QuizPlayerState> emit,
  ) async {
    final quiz = state.quiz;
    if (quiz == null) return;
    emit(state.copyWith(status: QuizPlayerStatus.submitting));
    final answers = state.answers.entries
        .map((e) => QuizAnswer(questionId: e.key, optionId: e.value))
        .toList();
    final res = await _submitQuiz.call(
      SubmitQuizParams(slug: quiz.slug, answers: answers),
    );
    res.fold(
      (failure) => emit(
        state.copyWith(
          status: QuizPlayerStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (attempt) => emit(
        state.copyWith(status: QuizPlayerStatus.completed, result: attempt),
      ),
    );
  }
}
