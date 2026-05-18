part of 'schedule_list_bloc.dart';

enum ScheduleListStatus { initial, loading, loadingMore, success, failure }

class ScheduleListState extends Equatable {
  final ScheduleListStatus status;
  final Paginated<LiteracySchedule> page;
  final String? errorMessage;
  final String? dateFilter;
  final bool upcomingFilter;

  const ScheduleListState({
    this.status = ScheduleListStatus.initial,
    this.page = const Paginated<LiteracySchedule>(
      items: [],
      currentPage: 1,
      lastPage: 1,
      perPage: 0,
      total: 0,
    ),
    this.errorMessage,
    this.dateFilter,
    this.upcomingFilter = false,
  });

  const ScheduleListState.initial()
    : status = ScheduleListStatus.initial,
      page = const Paginated<LiteracySchedule>(
        items: [],
        currentPage: 1,
        lastPage: 1,
        perPage: 0,
        total: 0,
      ),
      errorMessage = null,
      dateFilter = null,
      upcomingFilter = false;

  bool get isLoading =>
      status == ScheduleListStatus.loading && page.items.isEmpty;
  bool get isEmpty =>
      status == ScheduleListStatus.success && page.items.isEmpty;

  ScheduleListState copyWith({
    ScheduleListStatus? status,
    Paginated<LiteracySchedule>? page,
    String? errorMessage,
    Object? dateFilter = _keepValue,
    bool? upcomingFilter,
  }) => ScheduleListState(
    status: status ?? this.status,
    page: page ?? this.page,
    errorMessage: errorMessage,
    dateFilter: dateFilter == _keepValue
        ? this.dateFilter
        : dateFilter as String?,
    upcomingFilter: upcomingFilter ?? this.upcomingFilter,
  );

  static const Object _keepValue = Object();

  @override
  List<Object?> get props => [
    status,
    page,
    errorMessage,
    dateFilter,
    upcomingFilter,
  ];
}
