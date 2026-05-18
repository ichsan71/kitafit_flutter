part of 'schedule_form_cubit.dart';

abstract class ScheduleFormState extends Equatable {
  const ScheduleFormState();

  @override
  List<Object?> get props => [];
}

class ScheduleFormInitial extends ScheduleFormState {
  const ScheduleFormInitial();
}

class ScheduleFormLoading extends ScheduleFormState {
  const ScheduleFormLoading();
}

class ScheduleFormSuccess extends ScheduleFormState {
  final LiteracySchedule schedule;
  const ScheduleFormSuccess(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

class ScheduleFormFailure extends ScheduleFormState {
  final String message;
  const ScheduleFormFailure(this.message);

  @override
  List<Object?> get props => [message];
}
