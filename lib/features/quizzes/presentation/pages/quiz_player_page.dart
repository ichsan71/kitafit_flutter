import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz_question.dart';
import 'package:todo_clean_bloc/features/quizzes/presentation/bloc/quiz_player_bloc.dart';
import 'package:todo_clean_bloc/init_dependency.dart';

class QuizPlayerPage extends StatelessWidget {
  final String slug;
  const QuizPlayerPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<QuizPlayerBloc>()
            ..add(QuizPlayerLoadRequested(slug)),
      child: const _QuizPlayerView(),
    );
  }
}

class _QuizPlayerView extends StatelessWidget {
  const _QuizPlayerView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizPlayerBloc, QuizPlayerState>(
      listener: (context, state) {
        if (state.status == QuizPlayerStatus.completed && state.result != null) {
          context.pushReplacement(
            '/quiz-result',
            extra: state.result,
          );
        }
        if (state.status == QuizPlayerStatus.failure &&
            state.errorMessage != null &&
            state.quiz != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        final scaffold = Scaffold(
          appBar: AppBar(
            title: Text(state.quiz?.title ?? 'Kuis'),
          ),
          body: _buildBody(context, state),
        );
        return scaffold;
      },
    );
  }

  Widget _buildBody(BuildContext context, QuizPlayerState state) {
    if (state.status == QuizPlayerStatus.loading ||
        state.status == QuizPlayerStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.quiz == null) {
      return Center(child: Text(state.errorMessage ?? 'Kuis tidak ditemukan'));
    }
    if (state.quiz!.questions.isEmpty) {
      return const Center(child: Text('Kuis belum memiliki pertanyaan'));
    }
    final question = state.quiz!.questions[state.currentIndex];
    final selectedOption = state.answers[question.id];
    final theme = Theme.of(context);

    return Column(
      children: [
        LinearProgressIndicator(
          value: (state.currentIndex + 1) / state.totalQuestions,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pertanyaan ${state.currentIndex + 1} / ${state.totalQuestions}',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(question.question, style: theme.textTheme.titleLarge),
                const SizedBox(height: 24),
                ..._buildOptions(context, question, selectedOption),
              ],
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (!state.isFirstQuestion)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.read<QuizPlayerBloc>().add(
                        const QuizPlayerPrevious(),
                      ),
                      child: const Text('Sebelumnya'),
                    ),
                  ),
                if (!state.isFirstQuestion) const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: state.status == QuizPlayerStatus.submitting
                        ? null
                        : () => _onPrimaryAction(context, state),
                    child: state.status == QuizPlayerStatus.submitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(state.isLastQuestion ? 'Submit' : 'Selanjutnya'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onPrimaryAction(BuildContext context, QuizPlayerState state) {
    if (state.isLastQuestion) {
      if (!state.allAnswered) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan jawab semua pertanyaan')),
        );
        return;
      }
      context.read<QuizPlayerBloc>().add(const QuizPlayerSubmitted());
    } else {
      context.read<QuizPlayerBloc>().add(const QuizPlayerNext());
    }
  }

  List<Widget> _buildOptions(
    BuildContext context,
    QuizQuestion question,
    int? selectedOption,
  ) {
    return question.options.map((opt) {
      final selected = selectedOption == opt.id;
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.read<QuizPlayerBloc>().add(
            QuizPlayerAnswerSelected(
              questionId: question.id,
              optionId: opt.id,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outlineVariant,
                width: selected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: selected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(opt.optionText)),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}
