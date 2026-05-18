part of 'article_list_bloc.dart';

sealed class ArticleListEvent extends Equatable {
  const ArticleListEvent();
  @override
  List<Object?> get props => [];
}

class ArticleListRequested extends ArticleListEvent {
  final String? search;
  final String? categorySlug;
  const ArticleListRequested({this.search, this.categorySlug});

  @override
  List<Object?> get props => [search, categorySlug];
}

class ArticleListLoadMore extends ArticleListEvent {
  const ArticleListLoadMore();
}

class ArticleListFilterChanged extends ArticleListEvent {
  final String? search;
  final String? categorySlug;
  const ArticleListFilterChanged({this.search, this.categorySlug});

  @override
  List<Object?> get props => [search, categorySlug];
}
