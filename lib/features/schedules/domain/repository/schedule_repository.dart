import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/features/schedules/domain/entities/literacy_schedule.dart';

abstract interface class ScheduleRepository {
  Future<Either<Failure, Paginated<LiteracySchedule>>> getSchedules({
    int page = 1,
    int perPage = 15,
    String? date,
    bool? upcoming,
  });

  Future<Either<Failure, LiteracySchedule>> getScheduleDetail(int id);

  Future<Either<Failure, LiteracySchedule>> createSchedule({
    required String title,
    required String scheduledDate,
    required String scheduledTime,
    String? description,
  });

  Future<Either<Failure, LiteracySchedule>> updateSchedule({
    required int id,
    required String title,
    required String scheduledDate,
    required String scheduledTime,
    String? description,
  });

  Future<Either<Failure, void>> deleteSchedule(int id);
}
