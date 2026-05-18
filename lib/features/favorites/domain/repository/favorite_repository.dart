import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/features/favorites/domain/entities/favorite.dart';

abstract interface class FavoriteRepository {
  Future<Either<Failure, List<Favorite>>> getFavorites({String? type});

  Future<Either<Failure, bool>> toggleFavorite({
    required String favoritableType,
    required int favoritableId,
  });
}
