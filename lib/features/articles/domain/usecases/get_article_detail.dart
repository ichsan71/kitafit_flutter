import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/articles/domain/entities/article.dart';
import 'package:todo_clean_bloc/features/articles/domain/repository/article_repository.dart';

class GetArticleDetail implements UseCase<Article, String> {
  final ArticleRepository repository;
  GetArticleDetail({required this.repository});

  @override
  Future<Either<Failure, Article>> call(String slug) =>
      repository.getArticleDetail(slug);
}
