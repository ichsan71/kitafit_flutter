part of 'schedule_list_bloc.dart';

abstract class ScheduleListEvent extends Equatable {
  const ScheduleListEvent();

  @override
  List<Object?> get props => [];
}

class ScheduleListRequested extends ScheduleListEvent {
  const ScheduleListRequested();
}

class ScheduleListLoadMore extends ScheduleListEvent {
  const ScheduleListLoadMore();
}

class ScheduleListFilterChanged extends ScheduleListEvent {
  final String? date;
  final bool? upcoming;
  const ScheduleListFilterChanged({this.date, this.upcoming});

  @override
  List<Object?> get props => [date, upcoming];
}

class ScheduleListItemDeleted extends ScheduleListEvent {
  final int id;
  const ScheduleListItemDeleted(this.id);

  @override
  List<Object?> get props => [id];
}
