import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/features/wawasan/domain/entities/wawasan.dart';

abstract interface class WawasanRepository {
  Future<Either<Failure, Paginated<Wawasan>>> getWawasanList({
    String? search,
    String? categorySlug,
    int page = 1,
    int perPage = 15,
  });

  Future<Either<Failure, Wawasan>> getWawasanDetail(String slug);
}
