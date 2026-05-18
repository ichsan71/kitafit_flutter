import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/schedules/domain/entities/literacy_schedule.dart';
import 'package:todo_clean_bloc/features/schedules/domain/repository/schedule_repository.dart';

class GetSchedulesParams extends Equatable {
  final int page;
  final int perPage;
  final String? date;
  final bool? upcoming;

  const GetSchedulesParams({
    this.page = 1,
    this.perPage = 15,
    this.date,
    this.upcoming,
  });

  @override
  List<Object?> get props => [page, perPage, date, upcoming];
}

class GetSchedules
    implements UseCase<Paginated<LiteracySchedule>, GetSchedulesParams> {
  final ScheduleRepository repository;
  GetSchedules({required this.repository});

  @override
  Future<Either<Failure, Paginated<LiteracySchedule>>> call(
    GetSchedulesParams params,
  ) => repository.getSchedules(
    page: params.page,
    perPage: params.perPage,
    date: params.date,
    upcoming: params.upcoming,
  );
}
