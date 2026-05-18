import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/articles/domain/entities/article.dart';
import 'package:todo_clean_bloc/features/articles/domain/repository/article_repository.dart';

class GetArticlesParams extends Equatable {
  final String? search;
  final String? categorySlug;
  final int page;
  final int perPage;

  const GetArticlesParams({
    this.search,
    this.categorySlug,
    this.page = 1,
    this.perPage = 15,
  });

  @override
  List<Object?> get props => [search, categorySlug, page, perPage];
}

class GetArticles implements UseCase<Paginated<Article>, GetArticlesParams> {
  final ArticleRepository repository;
  GetArticles({required this.repository});

  @override
  Future<Either<Failure, Paginated<Article>>> call(GetArticlesParams params) =>
      repository.getArticles(
        search: params.search,
        categorySlug: params.categorySlug,
        page: params.page,
        perPage: params.perPage,
      );
}
