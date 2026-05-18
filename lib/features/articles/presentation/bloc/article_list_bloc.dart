import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/features/articles/domain/entities/article.dart';
import 'package:todo_clean_bloc/features/articles/domain/usecases/get_articles.dart';

part 'article_list_event.dart';
part 'article_list_state.dart';

class ArticleListBloc extends Bloc<ArticleListEvent, ArticleListState> {
  final GetArticles _getArticles;

  ArticleListBloc({required GetArticles getArticles})
    : _getArticles = getArticles,
      super(const ArticleListState.initial()) {
    on<ArticleListRequested>(_onRequested);
    on<ArticleListLoadMore>(_onLoadMore);
    on<ArticleListFilterChanged>(_onFilterChanged);
  }

  Future<void> _onRequested(
    ArticleListRequested event,
    Emitter<ArticleListState> emit,
  ) async {
    emit(state.copyWith(status: ArticleListStatus.loading));
    final res = await _getArticles.call(
      GetArticlesParams(
        search: event.search ?? state.search,
        categorySlug: event.categorySlug ?? state.categorySlug,
      ),
    );
    res.fold(
      (failure) => emit(
        state.copyWith(
          status: ArticleListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (page) => emit(
        state.copyWith(
          status: ArticleListStatus.success,
          page: page,
          search: event.search ?? state.search,
          categorySlug: event.categorySlug ?? state.categorySlug,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    ArticleListLoadMore event,
    Emitter<ArticleListState> emit,
  ) async {
    if (!state.page.hasMore || state.status == ArticleListStatus.loadingMore) {
      return;
    }
    emit(state.copyWith(status: ArticleListStatus.loadingMore));
    final res = await _getArticles.call(
      GetArticlesParams(
        search: state.search,
        categorySlug: state.categorySlug,
        page: state.page.currentPage + 1,
      ),
    );
    res.fold(
      (failure) => emit(
        state.copyWith(
          status: ArticleListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (next) => emit(
        state.copyWith(
          status: ArticleListStatus.success,
          page: state.page.append(next),
        ),
      ),
    );
  }

  Future<void> _onFilterChanged(
    ArticleListFilterChanged event,
    Emitter<ArticleListState> emit,
  ) async {
    emit(
      state.copyWith(
        page: Paginated.empty<Article>(),
        search: event.search,
        categorySlug: event.categorySlug,
      ),
    );
    add(
      ArticleListRequested(
        search: event.search,
        categorySlug: event.categorySlug,
      ),
    );
  }
}
