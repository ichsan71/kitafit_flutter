import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/exception.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/network/exception_mapper.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/core/utils/app_logger.dart';
import 'package:todo_clean_bloc/features/videos/data/datasources/video_remote_data_source.dart';
import 'package:todo_clean_bloc/features/videos/domain/entities/video.dart';
import 'package:todo_clean_bloc/features/videos/domain/repository/video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  static final _log = AppLogger('videos');

  final VideoRemoteDataSource remoteDataSource;
  VideoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Paginated<Video>>> getVideos({
    String? search,
    int page = 1,
    int perPage = 15,
  }) async {
    _log.info('getVideos(search: $search, page: $page)');
    try {
      final result = await remoteDataSource.getVideos(
        search: search,
        page: page,
        perPage: perPage,
      );
      _log.info(
        'getVideos ✓ total=${result.total} page=${result.currentPage}/${result.lastPage}',
      );
      return Right(
        Paginated<Video>(
          items: result.items.cast<Video>(),
          currentPage: result.currentPage,
          lastPage: result.lastPage,
          perPage: result.perPage,
          total: result.total,
        ),
      );
    } on AppException catch (e) {
      _log.error('getVideos ✗ ${e.runtimeType}: ${e.message}', error: e);
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error('getVideos ✗ unexpected: $e', error: e, stackTrace: st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Video>> getVideoDetail(String slug) async {
    _log.info('getVideoDetail(slug: $slug)');
    try {
      final video = await remoteDataSource.getVideoDetail(slug);
      _log.info('getVideoDetail ✓ slug=$slug');
      return Right(video);
    } on AppException catch (e) {
      _log.error('getVideoDetail ✗ ${e.runtimeType}: ${e.message}', error: e);
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error('getVideoDetail ✗ unexpected: $e', error: e, stackTrace: st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
