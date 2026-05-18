import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/schedules/domain/entities/literacy_schedule.dart';
import 'package:todo_clean_bloc/features/schedules/domain/repository/schedule_repository.dart';

class GetScheduleDetail implements UseCase<LiteracySchedule, int> {
  final ScheduleRepository repository;
  GetScheduleDetail({required this.repository});

  @override
  Future<Either<Failure, LiteracySchedule>> call(int id) =>
      repository.getScheduleDetail(id);
}
