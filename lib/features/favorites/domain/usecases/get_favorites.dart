import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/favorites/domain/entities/favorite.dart';
import 'package:todo_clean_bloc/features/favorites/domain/repository/favorite_repository.dart';

class GetFavoritesParams {
  final String? type;
  const GetFavoritesParams({this.type});
}

class GetFavorites implements UseCase<List<Favorite>, GetFavoritesParams> {
  final FavoriteRepository repository;
  GetFavorites({required this.repository});

  @override
  Future<Either<Failure, List<Favorite>>> call(GetFavoritesParams params) =>
      repository.getFavorites(type: params.type);
}
