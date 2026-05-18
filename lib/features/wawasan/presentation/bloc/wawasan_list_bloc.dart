import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/features/wawasan/domain/entities/wawasan.dart';
import 'package:todo_clean_bloc/features/wawasan/domain/usecases/get_wawasan_list.dart';

part 'wawasan_list_event.dart';
part 'wawasan_list_state.dart';

class WawasanListBloc extends Bloc<WawasanListEvent, WawasanListState> {
  final GetWawasanList _getWawasanList;

  WawasanListBloc({required GetWawasanList getWawasanList})
    : _getWawasanList = getWawasanList,
      super(const WawasanListState.initial()) {
    on<WawasanListRequested>(_onRequested);
    on<WawasanListLoadMore>(_onLoadMore);
    on<WawasanListFilterChanged>(_onFilterChanged);
  }

  Future<void> _onRequested(
    WawasanListRequested event,
    Emitter<WawasanListState> emit,
  ) async {
    emit(state.copyWith(status: WawasanListStatus.loading));
    final res = await _getWawasanList.call(
      GetWawasanListParams(
        search: event.search ?? state.search,
        categorySlug: event.categorySlug ?? state.categorySlug,
      ),
    );
    res.fold(
      (failure) => emit(
        state.copyWith(
          status: WawasanListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (page) => emit(
        state.copyWith(
          status: WawasanListStatus.success,
          page: page,
          search: event.search ?? state.search,
          categorySlug: event.categorySlug ?? state.categorySlug,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    WawasanListLoadMore event,
    Emitter<WawasanListState> emit,
  ) async {
    if (!state.page.hasMore || state.status == WawasanListStatus.loadingMore) {
      return;
    }
    emit(state.copyWith(status: WawasanListStatus.loadingMore));
    final res = await _getWawasanList.call(
      GetWawasanListParams(
        search: state.search,
        categorySlug: state.categorySlug,
        page: state.page.currentPage + 1,
      ),
    );
    res.fold(
      (failure) => emit(
        state.copyWith(
          status: WawasanListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (next) => emit(
        state.copyWith(
          status: WawasanListStatus.success,
          page: state.page.append(next),
        ),
      ),
    );
  }

  Future<void> _onFilterChanged(
    WawasanListFilterChanged event,
    Emitter<WawasanListState> emit,
  ) async {
    emit(
      state.copyWith(
        page: Paginated.empty<Wawasan>(),
        search: event.search,
        categorySlug: event.categorySlug,
      ),
    );
    add(
      WawasanListRequested(
        search: event.search,
        categorySlug: event.categorySlug,
      ),
    );
  }
}
