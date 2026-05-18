import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/features/articles/domain/entities/article.dart';

abstract interface class ArticleRepository {
  Future<Either<Failure, Paginated<Article>>> getArticles({
    String? search,
    String? categorySlug,
    int page = 1,
    int perPage = 15,
  });

  Future<Either<Failure, Article>> getArticleDetail(String slug);
}
