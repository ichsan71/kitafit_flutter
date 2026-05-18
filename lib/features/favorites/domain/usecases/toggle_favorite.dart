import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/favorites/domain/repository/favorite_repository.dart';

class ToggleFavoriteParams {
  final String favoritableType;
  final int favoritableId;
  const ToggleFavoriteParams({
    required this.favoritableType,
    required this.favoritableId,
  });
}

/// Returns true when the item is now favorited, false when unfavorited.
class ToggleFavorite implements UseCase<bool, ToggleFavoriteParams> {
  final FavoriteRepository repository;
  ToggleFavorite({required this.repository});

  @override
  Future<Either<Failure, bool>> call(ToggleFavoriteParams params) =>
      repository.toggleFavorite(
        favoritableType: params.favoritableType,
        favoritableId: params.favoritableId,
      );
}
