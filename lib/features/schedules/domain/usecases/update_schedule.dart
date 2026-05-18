import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/schedules/domain/entities/literacy_schedule.dart';
import 'package:todo_clean_bloc/features/schedules/domain/repository/schedule_repository.dart';

class UpdateScheduleParams extends Equatable {
  final int id;
  final String title;
  final String scheduledDate;
  final String scheduledTime;
  final String? description;

  const UpdateScheduleParams({
    required this.id,
    required this.title,
    required this.scheduledDate,
    required this.scheduledTime,
    this.description,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    scheduledDate,
    scheduledTime,
    description,
  ];
}

class UpdateSchedule
    implements UseCase<LiteracySchedule, UpdateScheduleParams> {
  final ScheduleRepository repository;
  UpdateSchedule({required this.repository});

  @override
  Future<Either<Failure, LiteracySchedule>> call(UpdateScheduleParams params) =>
      repository.updateSchedule(
        id: params.id,
        title: params.title,
        scheduledDate: params.scheduledDate,
        scheduledTime: params.scheduledTime,
        description: params.description,
      );
}
