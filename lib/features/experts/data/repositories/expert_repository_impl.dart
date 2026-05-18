import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/exception.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/network/exception_mapper.dart';
import 'package:todo_clean_bloc/core/utils/app_logger.dart';
import 'package:todo_clean_bloc/features/experts/data/datasources/expert_remote_data_source.dart';
import 'package:todo_clean_bloc/features/experts/domain/entities/expert.dart';
import 'package:todo_clean_bloc/features/experts/domain/repository/expert_repository.dart';

class ExpertRepositoryImpl implements ExpertRepository {
  static final _log = AppLogger('experts');

  final ExpertRemoteDataSource remoteDataSource;
  ExpertRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Expert>>> getExperts() async {
    _log.info('getExperts()');
    try {
      final list = await remoteDataSource.getExperts();
      _log.info('getExperts ✓ count=${list.length}');
      return Right(list);
    } on AppException catch (e) {
      _log.error('getExperts ✗ ${e.runtimeType}: ${e.message}', error: e);
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error('getExperts ✗ unexpected: $e', error: e, stackTrace: st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Expert>> getExpertDetail(int id) async {
    _log.info('getExpertDetail(id: $id)');
    try {
      final expert = await remoteDataSource.getExpertDetail(id);
      _log.info('getExpertDetail ✓ id=$id');
      return Right(expert);
    } on AppException catch (e) {
      _log.error('getExpertDetail ✗ ${e.runtimeType}: ${e.message}', error: e);
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error('getExpertDetail ✗ unexpected: $e', error: e, stackTrace: st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
