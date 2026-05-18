part of 'article_list_bloc.dart';

enum ArticleListStatus { initial, loading, loadingMore, success, failure }

class ArticleListState extends Equatable {
  final ArticleListStatus status;
  final Paginated<Article> page;
  final String? search;
  final String? categorySlug;
  final String? errorMessage;

  const ArticleListState({
    required this.status,
    required this.page,
    this.search,
    this.categorySlug,
    this.errorMessage,
  });

  const ArticleListState.initial()
    : status = ArticleListStatus.initial,
      page = const Paginated<Article>(
        items: [],
        currentPage: 1,
        lastPage: 1,
        perPage: 0,
        total: 0,
      ),
      search = null,
      categorySlug = null,
      errorMessage = null;

  bool get isLoading => status == ArticleListStatus.loading;
  bool get isLoadingMore => status == ArticleListStatus.loadingMore;
  bool get isEmpty =>
      status == ArticleListStatus.success && page.items.isEmpty;

  ArticleListState copyWith({
    ArticleListStatus? status,
    Paginated<Article>? page,
    String? search,
    String? categorySlug,
    String? errorMessage,
  }) =>
      ArticleListState(
        status: status ?? this.status,
        page: page ?? this.page,
        search: search ?? this.search,
        categorySlug: categorySlug ?? this.categorySlug,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [
    status,
    page,
    search,
    categorySlug,
    errorMessage,
  ];
}
