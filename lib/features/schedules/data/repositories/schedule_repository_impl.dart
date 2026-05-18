import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/exception.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/network/exception_mapper.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/core/utils/app_logger.dart';
import 'package:todo_clean_bloc/features/schedules/data/datasources/schedule_remote_data_source.dart';
import 'package:todo_clean_bloc/features/schedules/domain/entities/literacy_schedule.dart';
import 'package:todo_clean_bloc/features/schedules/domain/repository/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  static final _log = AppLogger('schedules');

  final ScheduleRemoteDataSource remoteDataSource;
  ScheduleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Paginated<LiteracySchedule>>> getSchedules({
    int page = 1,
    int perPage = 15,
    String? date,
    bool? upcoming,
  }) async {
    _log.info('getSchedules(page: $page, date: $date, upcoming: $upcoming)');
    try {
      final result = await remoteDataSource.getSchedules(
        page: page,
        perPage: perPage,
        date: date,
        upcoming: upcoming,
      );
      _log.info(
        'getSchedules ✓ total=${result.total} page=${result.currentPage}/${result.lastPage}',
      );
      return Right(
        Paginated<LiteracySchedule>(
          items: result.items.cast<LiteracySchedule>(),
          currentPage: result.currentPage,
          lastPage: result.lastPage,
          perPage: result.perPage,
          total: result.total,
        ),
      );
    } on AppException catch (e) {
      _log.error('getSchedules ✗ ${e.runtimeType}: ${e.message}', error: e);
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error('getSchedules ✗ unexpected: $e', error: e, stackTrace: st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LiteracySchedule>> getScheduleDetail(int id) async {
    _log.info('getScheduleDetail(id: $id)');
    try {
      final schedule = await remoteDataSource.getScheduleDetail(id);
      _log.info('getScheduleDetail ✓ id=$id');
      return Right(schedule);
    } on AppException catch (e) {
      _log.error(
        'getScheduleDetail ✗ ${e.runtimeType}: ${e.message}',
        error: e,
      );
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error(
        'getScheduleDetail ✗ unexpected: $e',
        error: e,
        stackTrace: st,
      );
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LiteracySchedule>> createSchedule({
    required String title,
    required String scheduledDate,
    required String scheduledTime,
    String? description,
  }) async {
    _log.info('createSchedule(title: $title, date: $scheduledDate)');
    try {
      final body = <String, dynamic>{
        'title': title,
        'scheduled_date': scheduledDate,
        'scheduled_time': scheduledTime,
        if (description != null && description.isNotEmpty)
          'description': description,
      };
      final result = await remoteDataSource.createSchedule(body);
      _log.info('createSchedule ✓ id=${result.id}');
      return Right(result);
    } on AppException catch (e) {
      _log.error('createSchedule ✗ ${e.runtimeType}: ${e.message}', error: e);
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error('createSchedule ✗ unexpected: $e', error: e, stackTrace: st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LiteracySchedule>> updateSchedule({
    required int id,
    required String title,
    required String scheduledDate,
    required String scheduledTime,
    String? description,
  }) async {
    _log.info('updateSchedule(id: $id, title: $title)');
    try {
      final body = <String, dynamic>{
        'title': title,
        'scheduled_date': scheduledDate,
        'scheduled_time': scheduledTime,
        if (description != null) 'description': description,
      };
      final result = await remoteDataSource.updateSchedule(id, body);
      _log.info('updateSchedule ✓ id=$id');
      return Right(result);
    } on AppException catch (e) {
      _log.error('updateSchedule ✗ ${e.runtimeType}: ${e.message}', error: e);
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error('updateSchedule ✗ unexpected: $e', error: e, stackTrace: st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSchedule(int id) async {
    _log.info('deleteSchedule(id: $id)');
    try {
      await remoteDataSource.deleteSchedule(id);
      _log.info('deleteSchedule ✓ id=$id');
      return const Right(null);
    } on AppException catch (e) {
      _log.error('deleteSchedule ✗ ${e.runtimeType}: ${e.message}', error: e);
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error('deleteSchedule ✗ unexpected: $e', error: e, stackTrace: st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
