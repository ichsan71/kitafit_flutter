import 'package:todo_clean_bloc/core/network/api_client.dart';
import 'package:todo_clean_bloc/features/favorites/data/models/favorite_model.dart';

abstract interface class FavoriteRemoteDataSource {
  Future<List<FavoriteModel>> getFavorites({String? type});

  Future<bool> toggleFavorite({
    required String favoritableType,
    required int favoritableId,
  });
}

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  final ApiClient client;
  FavoriteRemoteDataSourceImpl({required this.client});

  static const _basePath = '/favorites';

  @override
  Future<List<FavoriteModel>> getFavorites({String? type}) =>
      client.get<List<FavoriteModel>>(
        _basePath,
        query: type != null ? {'type': type} : null,
        parser: (raw) {
          final list = raw as List<dynamic>? ?? [];
          return list
              .whereType<Map<String, dynamic>>()
              .map(FavoriteModel.fromJson)
              .toList();
        },
      );

  @override
  Future<bool> toggleFavorite({
    required String favoritableType,
    required int favoritableId,
  }) => client.post<bool>(
    '$_basePath/toggle',
    body: {
      'favoritable_type': favoritableType,
      'favoritable_id': favoritableId,
    },
    parser: (raw) {
      final map = raw as Map<String, dynamic>? ?? {};
      return (map['is_favorited'] as bool?) ?? false;
    },
  );
}
