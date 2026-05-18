import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/features/articles/domain/entities/article.dart';
import 'package:todo_clean_bloc/features/articles/domain/usecases/get_article_detail.dart';

enum ArticleDetailStatus { initial, loading, success, failure }

class ArticleDetailState extends Equatable {
  final ArticleDetailStatus status;
  final Article? article;
  final String? errorMessage;

  const ArticleDetailState({
    required this.status,
    this.article,
    this.errorMessage,
  });

  const ArticleDetailState.initial()
    : status = ArticleDetailStatus.initial,
      article = null,
      errorMessage = null;

  ArticleDetailState copyWith({
    ArticleDetailStatus? status,
    Article? article,
    String? errorMessage,
  }) =>
      ArticleDetailState(
        status: status ?? this.status,
        article: article ?? this.article,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, article, errorMessage];
}

class ArticleDetailCubit extends Cubit<ArticleDetailState> {
  final GetArticleDetail _getArticleDetail;

  ArticleDetailCubit({required GetArticleDetail getArticleDetail})
    : _getArticleDetail = getArticleDetail,
      super(const ArticleDetailState.initial());

  Future<void> load(String slug) async {
    emit(state.copyWith(status: ArticleDetailStatus.loading));
    final res = await _getArticleDetail.call(slug);
    res.fold(
      (failure) => emit(
        state.copyWith(
          status: ArticleDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (article) => emit(
        state.copyWith(
          status: ArticleDetailStatus.success,
          article: article,
        ),
      ),
    );
  }
}
