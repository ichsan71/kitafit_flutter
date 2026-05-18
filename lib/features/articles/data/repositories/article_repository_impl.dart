import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/exception.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/network/exception_mapper.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/core/utils/app_logger.dart';
import 'package:todo_clean_bloc/features/articles/data/datasources/article_remote_data_source.dart';
import 'package:todo_clean_bloc/features/articles/domain/entities/article.dart';
import 'package:todo_clean_bloc/features/articles/domain/repository/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  static final _log = AppLogger('articles');

  final ArticleRemoteDataSource remoteDataSource;
  ArticleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Paginated<Article>>> getArticles({
    String? search,
    String? categorySlug,
    int page = 1,
    int perPage = 15,
  }) async {
    _log.info(
      'getArticles(search: $search, category: $categorySlug, page: $page)',
    );
    try {
      final result = await remoteDataSource.getArticles(
        search: search,
        categorySlug: categorySlug,
        page: page,
        perPage: perPage,
      );
      _log.info(
        'getArticles ✓ total=${result.total} page=${result.currentPage}/${result.lastPage}',
      );
      return Right(_cast(result));
    } on AppException catch (e) {
      _log.error('getArticles ✗ ${e.runtimeType}: ${e.message}', error: e);
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error('getArticles ✗ unexpected: $e', error: e, stackTrace: st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Article>> getArticleDetail(String slug) async {
    _log.info('getArticleDetail(slug: $slug)');
    try {
      final article = await remoteDataSource.getArticleDetail(slug);
      _log.info('getArticleDetail ✓ slug=$slug');
      return Right(article);
    } on AppException catch (e) {
      _log.error('getArticleDetail ✗ ${e.runtimeType}: ${e.message}', error: e);
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error('getArticleDetail ✗ unexpected: $e', error: e, stackTrace: st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Paginated<Article> _cast(Paginated<dynamic> raw) => Paginated<Article>(
    items: raw.items.cast<Article>(),
    currentPage: raw.currentPage,
    lastPage: raw.lastPage,
    perPage: raw.perPage,
    total: raw.total,
  );
}
