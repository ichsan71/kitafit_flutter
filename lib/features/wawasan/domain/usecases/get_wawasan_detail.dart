import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/wawasan/domain/entities/wawasan.dart';
import 'package:todo_clean_bloc/features/wawasan/domain/repository/wawasan_repository.dart';

class GetWawasanDetail implements UseCase<Wawasan, String> {
  final WawasanRepository repository;
  GetWawasanDetail({required this.repository});

  @override
  Future<Either<Failure, Wawasan>> call(String slug) =>
      repository.getWawasanDetail(slug);
}
