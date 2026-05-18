import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/exception.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/network/exception_mapper.dart';
import 'package:todo_clean_bloc/core/utils/app_logger.dart';
import 'package:todo_clean_bloc/features/favorites/data/datasources/favorite_remote_data_source.dart';
import 'package:todo_clean_bloc/features/favorites/domain/entities/favorite.dart';
import 'package:todo_clean_bloc/features/favorites/domain/repository/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  static final _log = AppLogger('favorites');

  final FavoriteRemoteDataSource remoteDataSource;
  FavoriteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Favorite>>> getFavorites({String? type}) async {
    _log.info('getFavorites(type: $type)');
    try {
      final result = await remoteDataSource.getFavorites(type: type);
      _log.info('getFavorites ✓ count=${result.length}');
      return Right(result.cast<Favorite>());
    } on AppException catch (e) {
      _log.error('getFavorites ✗ ${e.runtimeType}: ${e.message}', error: e);
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error('getFavorites ✗ unexpected: $e', error: e, stackTrace: st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite({
    required String favoritableType,
    required int favoritableId,
  }) async {
    _log.info('toggleFavorite(type: $favoritableType, id: $favoritableId)');
    try {
      final result = await remoteDataSource.toggleFavorite(
        favoritableType: favoritableType,
        favoritableId: favoritableId,
      );
      _log.info('toggleFavorite ✓ isFavorited=$result');
      return Right(result);
    } on AppException catch (e) {
      _log.error('toggleFavorite ✗ ${e.runtimeType}: ${e.message}', error: e);
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error('toggleFavorite ✗ unexpected: $e', error: e, stackTrace: st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
