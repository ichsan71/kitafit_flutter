import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/features/schedules/domain/entities/literacy_schedule.dart';
import 'package:todo_clean_bloc/features/schedules/domain/usecases/delete_schedule.dart';
import 'package:todo_clean_bloc/features/schedules/domain/usecases/get_schedules.dart';

part 'schedule_list_event.dart';
part 'schedule_list_state.dart';

class ScheduleListBloc extends Bloc<ScheduleListEvent, ScheduleListState> {
  final GetSchedules _getSchedules;
  final DeleteSchedule _deleteSchedule;

  ScheduleListBloc({
    required GetSchedules getSchedules,
    required DeleteSchedule deleteSchedule,
  }) : _getSchedules = getSchedules,
       _deleteSchedule = deleteSchedule,
       super(const ScheduleListState.initial()) {
    on<ScheduleListRequested>(_onRequested);
    on<ScheduleListLoadMore>(_onLoadMore);
    on<ScheduleListFilterChanged>(_onFilterChanged);
    on<ScheduleListItemDeleted>(_onItemDeleted);
  }

  Future<void> _onRequested(
    ScheduleListRequested event,
    Emitter<ScheduleListState> emit,
  ) async {
    emit(state.copyWith(status: ScheduleListStatus.loading));
    final result = await _getSchedules(
      GetSchedulesParams(
        page: 1,
        date: state.dateFilter,
        upcoming: state.upcomingFilter ? true : null,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ScheduleListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (page) => emit(
        state.copyWith(
          status: ScheduleListStatus.success,
          page: page,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    ScheduleListLoadMore event,
    Emitter<ScheduleListState> emit,
  ) async {
    if (!state.page.hasMore || state.status == ScheduleListStatus.loadingMore) {
      return;
    }
    emit(state.copyWith(status: ScheduleListStatus.loadingMore));
    final result = await _getSchedules(
      GetSchedulesParams(
        page: state.page.currentPage + 1,
        date: state.dateFilter,
        upcoming: state.upcomingFilter ? true : null,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ScheduleListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (nextPage) => emit(
        state.copyWith(
          status: ScheduleListStatus.success,
          page: state.page.append(nextPage),
        ),
      ),
    );
  }

  Future<void> _onFilterChanged(
    ScheduleListFilterChanged event,
    Emitter<ScheduleListState> emit,
  ) async {
    emit(
      state.copyWith(
        page: Paginated.empty<LiteracySchedule>(),
        dateFilter: event.date,
        upcomingFilter: event.upcoming ?? false,
      ),
    );
    add(const ScheduleListRequested());
  }

  Future<void> _onItemDeleted(
    ScheduleListItemDeleted event,
    Emitter<ScheduleListState> emit,
  ) async {
    final result = await _deleteSchedule(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ScheduleListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        final updatedItems = state.page.items
            .where((s) => s.id != event.id)
            .toList();
        emit(
          state.copyWith(
            status: ScheduleListStatus.success,
            page: state.page.copyWith(items: updatedItems),
          ),
        );
      },
    );
  }
}
