import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/schedules/domain/entities/literacy_schedule.dart';
import 'package:todo_clean_bloc/features/schedules/domain/repository/schedule_repository.dart';

class CreateScheduleParams extends Equatable {
  final String title;
  final String scheduledDate;
  final String scheduledTime;
  final String? description;

  const CreateScheduleParams({
    required this.title,
    required this.scheduledDate,
    required this.scheduledTime,
    this.description,
  });

  @override
  List<Object?> get props => [title, scheduledDate, scheduledTime, description];
}

class CreateSchedule
    implements UseCase<LiteracySchedule, CreateScheduleParams> {
  final ScheduleRepository repository;
  CreateSchedule({required this.repository});

  @override
  Future<Either<Failure, LiteracySchedule>> call(CreateScheduleParams params) =>
      repository.createSchedule(
        title: params.title,
        scheduledDate: params.scheduledDate,
        scheduledTime: params.scheduledTime,
        description: params.description,
      );
}
