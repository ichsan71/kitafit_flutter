import 'package:todo_clean_bloc/core/network/api_client.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/features/quizzes/data/models/quiz_models.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz_answer.dart';

abstract interface class QuizRemoteDataSource {
  Future<Paginated<QuizModel>> getQuizzes({int page = 1, int perPage = 15});
  Future<QuizModel> getQuizDetail(String slug);
  Future<QuizAttemptModel> submitQuiz({
    required String slug,
    required List<QuizAnswer> answers,
  });
  Future<List<QuizAttemptModel>> getQuizHistory();
}

class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final ApiClient client;
  QuizRemoteDataSourceImpl({required this.client});

  static const _basePath = '/quizzes';

  @override
  Future<Paginated<QuizModel>> getQuizzes({int page = 1, int perPage = 15}) =>
      client.getPaginated<QuizModel>(
        _basePath,
        query: {'page': page, 'per_page': perPage},
        itemFromJson: QuizModel.fromJson,
        requiresAuth: false,
      );

  @override
  Future<QuizModel> getQuizDetail(String slug) => client.get<QuizModel>(
    '$_basePath/$slug',
    parser: (raw) => QuizModel.fromJson(raw as Map<String, dynamic>),
    requiresAuth: false,
  );

  @override
  Future<QuizAttemptModel> submitQuiz({
    required String slug,
    required List<QuizAnswer> answers,
  }) =>
      client.post<QuizAttemptModel>(
        '$_basePath/$slug/submit',
        body: {'answers': answers.map((a) => a.toJson()).toList()},
        parser: (raw) => QuizAttemptModel.fromJson(raw as Map<String, dynamic>),
      );

  @override
  Future<List<QuizAttemptModel>> getQuizHistory() =>
      client.get<List<QuizAttemptModel>>(
        '/quiz-history',
        parser: (raw) {
          final list = raw is List
              ? raw
              : (raw is Map<String, dynamic> && raw['data'] is List
                    ? raw['data'] as List
                    : const []);
          return list
              .whereType<Map<String, dynamic>>()
              .map(QuizAttemptModel.fromJson)
              .toList();
        },
      );
}
