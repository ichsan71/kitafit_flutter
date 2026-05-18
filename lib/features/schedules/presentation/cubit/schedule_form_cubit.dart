import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/features/schedules/domain/entities/literacy_schedule.dart';
import 'package:todo_clean_bloc/features/schedules/domain/usecases/create_schedule.dart';
import 'package:todo_clean_bloc/features/schedules/domain/usecases/update_schedule.dart';

part 'schedule_form_state.dart';

class ScheduleFormCubit extends Cubit<ScheduleFormState> {
  final CreateSchedule _createSchedule;
  final UpdateSchedule _updateSchedule;

  ScheduleFormCubit({
    required CreateSchedule createSchedule,
    required UpdateSchedule updateSchedule,
  }) : _createSchedule = createSchedule,
       _updateSchedule = updateSchedule,
       super(const ScheduleFormInitial());

  Future<void> create({
    required String title,
    required String scheduledDate,
    required String scheduledTime,
    String? description,
  }) async {
    emit(const ScheduleFormLoading());
    final result = await _createSchedule(
      CreateScheduleParams(
        title: title,
        scheduledDate: scheduledDate,
        scheduledTime: scheduledTime,
        description: description,
      ),
    );
    result.fold(
      (failure) => emit(ScheduleFormFailure(failure.message)),
      (schedule) => emit(ScheduleFormSuccess(schedule)),
    );
  }

  Future<void> update({
    required int id,
    required String title,
    required String scheduledDate,
    required String scheduledTime,
    String? description,
  }) async {
    emit(const ScheduleFormLoading());
    final result = await _updateSchedule(
      UpdateScheduleParams(
        id: id,
        title: title,
        scheduledDate: scheduledDate,
        scheduledTime: scheduledTime,
        description: description,
      ),
    );
    result.fold(
      (failure) => emit(ScheduleFormFailure(failure.message)),
      (schedule) => emit(ScheduleFormSuccess(schedule)),
    );
  }

  void reset() => emit(const ScheduleFormInitial());
}
