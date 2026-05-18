import 'package:todo_clean_bloc/core/network/api_client.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/features/wawasan/data/models/wawasan_model.dart';

abstract interface class WawasanRemoteDataSource {
  Future<Paginated<WawasanModel>> getWawasanList({
    String? search,
    String? categorySlug,
    int page = 1,
    int perPage = 15,
  });

  Future<WawasanModel> getWawasanDetail(String slug);
}

class WawasanRemoteDataSourceImpl implements WawasanRemoteDataSource {
  final ApiClient client;
  WawasanRemoteDataSourceImpl({required this.client});

  static const _basePath = '/wawasan';

  @override
  Future<Paginated<WawasanModel>> getWawasanList({
    String? search,
    String? categorySlug,
    int page = 1,
    int perPage = 15,
  }) =>
      client.getPaginated<WawasanModel>(
        _basePath,
        query: {
          if (search != null && search.isNotEmpty) 'search': search,
          if (categorySlug != null && categorySlug.isNotEmpty)
            'category': categorySlug,
          'page': page,
          'per_page': perPage,
        },
        itemFromJson: WawasanModel.fromJson,
        requiresAuth: false,
      );

  @override
  Future<WawasanModel> getWawasanDetail(String slug) =>
      client.get<WawasanModel>(
        '$_basePath/$slug',
        parser: (raw) => WawasanModel.fromJson(raw as Map<String, dynamic>),
        requiresAuth: false,
      );
}
