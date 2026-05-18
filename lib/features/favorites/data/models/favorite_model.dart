import 'package:todo_clean_bloc/features/favorites/domain/entities/favorite.dart';

class FavoriteModel extends Favorite {
  const FavoriteModel({
    required super.id,
    required super.favoritableType,
    required super.favoritableId,
    super.favoritableData,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => FavoriteModel(
    id: (json['id'] as num).toInt(),
    favoritableType: (json['favoritable_type'] ?? '').toString(),
    favoritableId: (json['favoritable_id'] as num).toInt(),
    favoritableData: json['favoritable'] as Map<String, dynamic>?,
  );
}
