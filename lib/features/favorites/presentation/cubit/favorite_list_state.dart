part of 'favorite_list_cubit.dart';

sealed class FavoriteListState extends Equatable {
  const FavoriteListState();
}

class FavoriteListInitial extends FavoriteListState {
  const FavoriteListInitial();
  @override
  List<Object?> get props => [];
}

class FavoriteListLoading extends FavoriteListState {
  const FavoriteListLoading();
  @override
  List<Object?> get props => [];
}

class FavoriteListLoaded extends FavoriteListState {
  final List<Favorite> favorites;
  final String? activeType;

  const FavoriteListLoaded(this.favorites, {this.activeType});

  @override
  List<Object?> get props => [favorites, activeType];
}

class FavoriteListFailure extends FavoriteListState {
  final String message;
  const FavoriteListFailure(this.message);

  @override
  List<Object?> get props => [message];
}
