import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/wawasan/domain/entities/wawasan.dart';
import 'package:todo_clean_bloc/features/wawasan/domain/repository/wawasan_repository.dart';

class GetWawasanListParams extends Equatable {
  final String? search;
  final String? categorySlug;
  final int page;
  final int perPage;

  const GetWawasanListParams({
    this.search,
    this.categorySlug,
    this.page = 1,
    this.perPage = 15,
  });

  @override
  List<Object?> get props => [search, categorySlug, page, perPage];
}

class GetWawasanList implements UseCase<Paginated<Wawasan>, GetWawasanListParams> {
  final WawasanRepository repository;
  GetWawasanList({required this.repository});

  @override
  Future<Either<Failure, Paginated<Wawasan>>> call(GetWawasanListParams params) =>
      repository.getWawasanList(
        search: params.search,
        categorySlug: params.categorySlug,
        page: params.page,
        perPage: params.perPage,
      );
}
