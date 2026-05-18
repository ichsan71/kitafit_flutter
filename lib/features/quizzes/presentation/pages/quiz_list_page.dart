import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_clean_bloc/features/quizzes/presentation/bloc/quiz_list_cubit.dart';
import 'package:todo_clean_bloc/init_dependency.dart';

class QuizListPage extends StatelessWidget {
  const QuizListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<QuizListCubit>()..load(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kuis'),
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: 'Riwayat Kuis',
              onPressed: () => context.push('/quiz-history'),
            ),
          ],
        ),
        body: BlocBuilder<QuizListCubit, QuizListState>(
          builder: (context, state) {
            if (state.status == QuizListStatus.loading ||
                state.status == QuizListStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == QuizListStatus.failure) {
              return Center(
                child: Text(state.errorMessage ?? 'Gagal memuat kuis'),
              );
            }
            if (state.quizzes.isEmpty) {
              return const Center(child: Text('Belum ada kuis tersedia'));
            }
            final theme = Theme.of(context);
            return RefreshIndicator(
              onRefresh: () => context.read<QuizListCubit>().load(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.quizzes.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final q = state.quizzes[index];
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(
                          Icons.quiz_outlined,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      title: Text(q.title),
                      subtitle: Text(
                        q.description ??
                            '${q.questionsCount ?? '-'} pertanyaan',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/quizzes/${q.slug}'),
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
