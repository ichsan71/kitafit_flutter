part of 'wawasan_list_bloc.dart';

enum WawasanListStatus { initial, loading, loadingMore, success, failure }

class WawasanListState extends Equatable {
  final WawasanListStatus status;
  final Paginated<Wawasan> page;
  final String? search;
  final String? categorySlug;
  final String? errorMessage;

  const WawasanListState({
    required this.status,
    required this.page,
    this.search,
    this.categorySlug,
    this.errorMessage,
  });

  const WawasanListState.initial()
    : status = WawasanListStatus.initial,
      page = const Paginated<Wawasan>(
        items: [],
        currentPage: 1,
        lastPage: 1,
        perPage: 0,
        total: 0,
      ),
      search = null,
      categorySlug = null,
      errorMessage = null;

  bool get isLoading => status == WawasanListStatus.loading;
  bool get isEmpty =>
      status == WawasanListStatus.success && page.items.isEmpty;

  WawasanListState copyWith({
    WawasanListStatus? status,
    Paginated<Wawasan>? page,
    String? search,
    String? categorySlug,
    String? errorMessage,
  }) =>
      WawasanListState(
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
