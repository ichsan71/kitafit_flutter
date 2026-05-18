import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz_attempt.dart';

class QuizResultPage extends StatelessWidget {
  final QuizAttempt attempt;
  const QuizResultPage({super.key, required this.attempt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pct = attempt.percentage.toStringAsFixed(0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Kuis'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/quizzes'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Icon(
                Icons.emoji_events,
                size: 96,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text('Skor Anda', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                '${attempt.score} / ${attempt.totalQuestions}',
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text('$pct%', style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              Text(
                attempt.quiz.title,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.push('/quiz-history'),
                  child: const Text('Lihat Riwayat'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.go('/quizzes'),
                  child: const Text('Kembali ke Daftar Kuis'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
