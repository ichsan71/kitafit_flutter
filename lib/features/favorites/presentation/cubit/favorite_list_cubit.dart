import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/features/favorites/domain/entities/favorite.dart';
import 'package:todo_clean_bloc/features/favorites/domain/usecases/get_favorites.dart';
import 'package:todo_clean_bloc/features/favorites/domain/usecases/toggle_favorite.dart';

part 'favorite_list_state.dart';

class FavoriteListCubit extends Cubit<FavoriteListState> {
  final GetFavorites _getFavorites;
  final ToggleFavorite _toggleFavorite;

  FavoriteListCubit({
    required GetFavorites getFavorites,
    required ToggleFavorite toggleFavorite,
  }) : _getFavorites = getFavorites,
       _toggleFavorite = toggleFavorite,
       super(const FavoriteListInitial());

  Future<void> load({String? type}) async {
    emit(const FavoriteListLoading());
    final result = await _getFavorites(GetFavoritesParams(type: type));
    result.fold(
      (failure) => emit(FavoriteListFailure(failure.message)),
      (favorites) => emit(FavoriteListLoaded(favorites, activeType: type)),
    );
  }

  Future<void> toggle({
    required String favoritableType,
    required int favoritableId,
  }) async {
    final result = await _toggleFavorite(
      ToggleFavoriteParams(
        favoritableType: favoritableType,
        favoritableId: favoritableId,
      ),
    );
    result.fold((failure) => emit(FavoriteListFailure(failure.message)), (
      isFavorited,
    ) {
      if (state is FavoriteListLoaded) {
        final current = (state as FavoriteListLoaded);
        final updated = isFavorited
            ? current
                  .favorites // server will return updated list on next load
            : current.favorites
                  .where(
                    (f) =>
                        !(f.favoritableType == favoritableType &&
                            f.favoritableId == favoritableId),
                  )
                  .toList();
        emit(FavoriteListLoaded(updated, activeType: current.activeType));
      }
    });
  }
}
