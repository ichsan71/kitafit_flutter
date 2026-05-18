import 'package:todo_clean_bloc/core/network/api_client.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/features/articles/data/models/article_model.dart';

abstract interface class ArticleRemoteDataSource {
  Future<Paginated<ArticleModel>> getArticles({
    String? search,
    String? categorySlug,
    int page = 1,
    int perPage = 15,
  });

  Future<ArticleModel> getArticleDetail(String slug);
}

class ArticleRemoteDataSourceImpl implements ArticleRemoteDataSource {
  final ApiClient client;
  ArticleRemoteDataSourceImpl({required this.client});

  static const _basePath = '/articles';

  @override
  Future<Paginated<ArticleModel>> getArticles({
    String? search,
    String? categorySlug,
    int page = 1,
    int perPage = 15,
  }) =>
      client.getPaginated<ArticleModel>(
        _basePath,
        query: {
          if (search != null && search.isNotEmpty) 'search': search,
          if (categorySlug != null && categorySlug.isNotEmpty)
            'category': categorySlug,
          'page': page,
          'per_page': perPage,
        },
        itemFromJson: ArticleModel.fromJson,
        requiresAuth: false,
      );

  @override
  Future<ArticleModel> getArticleDetail(String slug) => client.get<ArticleModel>(
    '$_basePath/$slug',
    parser: (raw) => ArticleModel.fromJson(raw as Map<String, dynamic>),
    requiresAuth: false,
  );
}
