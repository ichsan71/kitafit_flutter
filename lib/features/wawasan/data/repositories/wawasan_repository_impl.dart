import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/exception.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/network/exception_mapper.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/core/utils/app_logger.dart';
import 'package:todo_clean_bloc/features/wawasan/data/datasources/wawasan_remote_data_source.dart';
import 'package:todo_clean_bloc/features/wawasan/domain/entities/wawasan.dart';
import 'package:todo_clean_bloc/features/wawasan/domain/repository/wawasan_repository.dart';

class WawasanRepositoryImpl implements WawasanRepository {
  static final _log = AppLogger('wawasan');

  final WawasanRemoteDataSource remoteDataSource;
  WawasanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Paginated<Wawasan>>> getWawasanList({
    String? search,
    String? categorySlug,
    int page = 1,
    int perPage = 15,
  }) async {
    _log.info(
      'getWawasanList(search: $search, category: $categorySlug, page: $page)',
    );
    try {
      final result = await remoteDataSource.getWawasanList(
        search: search,
        categorySlug: categorySlug,
        page: page,
        perPage: perPage,
      );
      _log.info(
        'getWawasanList ✓ total=${result.total} page=${result.currentPage}/${result.lastPage}',
      );
      return Right(
        Paginated<Wawasan>(
          items: result.items.cast<Wawasan>(),
          currentPage: result.currentPage,
          lastPage: result.lastPage,
          perPage: result.perPage,
          total: result.total,
        ),
      );
    } on AppException catch (e) {
      _log.error('getWawasanList ✗ ${e.runtimeType}: ${e.message}', error: e);
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error('getWawasanList ✗ unexpected: $e', error: e, stackTrace: st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Wawasan>> getWawasanDetail(String slug) async {
    _log.info('getWawasanDetail(slug: $slug)');
    try {
      final data = await remoteDataSource.getWawasanDetail(slug);
      _log.info('getWawasanDetail ✓ slug=$slug');
      return Right(data);
    } on AppException catch (e) {
      _log.error('getWawasanDetail ✗ ${e.runtimeType}: ${e.message}', error: e);
      return Left(ExceptionMapper.toFailure(e));
    } catch (e, st) {
      _log.error('getWawasanDetail ✗ unexpected: $e', error: e, stackTrace: st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
