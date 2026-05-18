import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz_attempt.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz_option.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz_question.dart';

class QuizOptionModel extends QuizOption {
  const QuizOptionModel({
    required super.id,
    required super.optionText,
    super.isCorrect,
  });

  factory QuizOptionModel.fromJson(Map<String, dynamic> json) =>
      QuizOptionModel(
        id: (json['id'] as num).toInt(),
        optionText: (json['option_text'] ?? '').toString(),
        isCorrect: json['is_correct'] as bool?,
      );
}

class QuizQuestionModel extends QuizQuestion {
  const QuizQuestionModel({
    required super.id,
    required super.question,
    required super.options,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) =>
      QuizQuestionModel(
        id: (json['id'] as num).toInt(),
        question: (json['question'] ?? '').toString(),
        options: (json['options'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(QuizOptionModel.fromJson)
            .toList(),
      );
}

class QuizModel extends Quiz {
  const QuizModel({
    required super.id,
    required super.title,
    required super.slug,
    super.description,
    super.questionsCount,
    super.questions,
    super.publishedAt,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
    id: (json['id'] as num).toInt(),
    title: (json['title'] ?? '').toString(),
    slug: (json['slug'] ?? '').toString(),
    description: json['description']?.toString(),
    questionsCount: (json['questions_count'] as num?)?.toInt(),
    questions: (json['questions'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(QuizQuestionModel.fromJson)
        .toList(),
    publishedAt: json['published_at'] != null
        ? DateTime.tryParse(json['published_at'].toString())
        : null,
  );
}

class QuizAttemptSummaryModel extends QuizAttemptSummary {
  const QuizAttemptSummaryModel({
    required super.id,
    required super.title,
    super.slug,
  });

  factory QuizAttemptSummaryModel.fromJson(Map<String, dynamic> json) =>
      QuizAttemptSummaryModel(
        id: (json['id'] as num).toInt(),
        title: (json['title'] ?? '').toString(),
        slug: json['slug']?.toString(),
      );
}

class QuizAttemptModel extends QuizAttempt {
  const QuizAttemptModel({
    required super.id,
    required super.quiz,
    required super.score,
    required super.totalQuestions,
    super.completedAt,
  });

  factory QuizAttemptModel.fromJson(Map<String, dynamic> json) {
    final quizRaw = json['quiz'];
    final summary = quizRaw is Map<String, dynamic>
        ? QuizAttemptSummaryModel.fromJson(quizRaw)
        : const QuizAttemptSummaryModel(id: 0, title: '');
    return QuizAttemptModel(
      id: (json['id'] as num).toInt(),
      quiz: summary,
      score: (json['score'] as num?)?.toInt() ?? 0,
      totalQuestions: (json['total_questions'] as num?)?.toInt() ?? 0,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'].toString())
          : null,
    );
  }
}
