import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_clean_bloc/features/quizzes/presentation/bloc/quiz_history_cubit.dart';
import 'package:todo_clean_bloc/init_dependency.dart';

class QuizHistoryPage extends StatelessWidget {
  const QuizHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<QuizHistoryCubit>()..load(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Riwayat Kuis')),
        body: BlocBuilder<QuizHistoryCubit, QuizHistoryState>(
          builder: (context, state) {
            if (state.status == QuizHistoryStatus.loading ||
                state.status == QuizHistoryStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == QuizHistoryStatus.failure) {
              return Center(
                child: Text(state.errorMessage ?? 'Gagal memuat riwayat'),
              );
            }
            if (state.attempts.isEmpty) {
              return const Center(child: Text('Belum ada riwayat kuis'));
            }
            return RefreshIndicator(
              onRefresh: () => context.read<QuizHistoryCubit>().load(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.attempts.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final a = state.attempts[index];
                  final theme = Theme.of(context);
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(a.quiz.title),
                      subtitle: Text(
                        a.completedAt == null
                            ? 'Selesai'
                            : DateFormat(
                                'dd MMM yyyy • HH:mm',
                              ).format(a.completedAt!.toLocal()),
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${a.score} / ${a.totalQuestions}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Text(
                            '${a.percentage.toStringAsFixed(0)}%',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
