import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/exception.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/network/exception_mapper.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/core/utils/app_logger.dart';
import 'package:todo_clean_bloc/features/quizzes/data/datasources/quiz_remote_data_source.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz_answer.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz_attempt.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/repository/quiz_repository.dart';

class QuizRepositoryImpl implements QuizRepository {
  static final _log = AppLogger('quizzes');

  final QuizRemoteDataSource remoteDataSource;
  QuizRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Paginated<Quiz>>> getQuizzes({
    int page = 1,
    int perPage = 15,
  }) async {
    _log.info('getQuizzes(page: $page)');
    try {
      final result = await remoteDataSource.getQuizzes(
        page: page,
        perPage: perPage,
      );
      _log.info(
        'getQuizzes ✓ total=${result.total} page=${result.currentPage}/${result.lastPage}',
      );
      return Right(
        Paginated<Quiz>(
          items: result.items.cast<Quiz>(),
          currentPage: result.currentPage,
          lastPage: result.lastPage,
          perPage: result.perPage,
          total: result.total,
        ),
      );
    } on AppException catch (e) {
      _log.error('getQuizzes ✗ ${e.runtimeType}: ${e.message}', error: e);
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error('getQuizzes ✗ unexpected: $e', error: e, stackTrace: st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Quiz>> getQuizDetail(String slug) async {
    _log.info('getQuizDetail(slug: $slug)');
    try {
      final quiz = await remoteDataSource.getQuizDetail(slug);
      _log.info('getQuizDetail ✓ slug=$slug');
      return Right(quiz);
    } on AppException catch (e) {
      _log.error('getQuizDetail ✗ ${e.runtimeType}: ${e.message}', error: e);
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error('getQuizDetail ✗ unexpected: $e', error: e, stackTrace: st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, QuizAttempt>> submitQuiz({
    required String slug,
    required List<QuizAnswer> answers,
  }) async {
    _log.info('submitQuiz(slug: $slug, answers: ${answers.length})');
    try {
      final attempt = await remoteDataSource.submitQuiz(
        slug: slug,
        answers: answers,
      );
      _log.info('submitQuiz ✓ slug=$slug');
      return Right(attempt);
    } on AppException catch (e) {
      _log.error('submitQuiz ✗ ${e.runtimeType}: ${e.message}', error: e);
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error('submitQuiz ✗ unexpected: $e', error: e, stackTrace: st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<QuizAttempt>>> getQuizHistory() async {
    _log.info('getQuizHistory()');
    try {
      final list = await remoteDataSource.getQuizHistory();
      _log.info('getQuizHistory ✓ count=${list.length}');
      return Right(list);
    } on AppException catch (e) {
      _log.error('getQuizHistory ✗ ${e.runtimeType}: ${e.message}', error: e);
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error('getQuizHistory ✗ unexpected: $e', error: e, stackTrace: st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
