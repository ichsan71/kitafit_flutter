part of 'wawasan_list_bloc.dart';

sealed class WawasanListEvent extends Equatable {
  const WawasanListEvent();
  @override
  List<Object?> get props => [];
}

class WawasanListRequested extends WawasanListEvent {
  final String? search;
  final String? categorySlug;
  const WawasanListRequested({this.search, this.categorySlug});

  @override
  List<Object?> get props => [search, categorySlug];
}

class WawasanListLoadMore extends WawasanListEvent {
  const WawasanListLoadMore();
}

class WawasanListFilterChanged extends WawasanListEvent {
  final String? search;
  final String? categorySlug;
  const WawasanListFilterChanged({this.search, this.categorySlug});

  @override
  List<Object?> get props => [search, categorySlug];
}
