import 'package:todo_clean_bloc/core/network/api_client.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/features/videos/data/models/video_model.dart';

abstract interface class VideoRemoteDataSource {
  Future<Paginated<VideoModel>> getVideos({
    String? search,
    int page = 1,
    int perPage = 15,
  });
  Future<VideoModel> getVideoDetail(String slug);
}

class VideoRemoteDataSourceImpl implements VideoRemoteDataSource {
  final ApiClient client;
  VideoRemoteDataSourceImpl({required this.client});

  static const _basePath = '/videos';

  @override
  Future<Paginated<VideoModel>> getVideos({
    String? search,
    int page = 1,
    int perPage = 15,
  }) =>
      client.getPaginated<VideoModel>(
        _basePath,
        query: {
          if (search != null && search.isNotEmpty) 'search': search,
          'page': page,
          'per_page': perPage,
        },
        itemFromJson: VideoModel.fromJson,
        requiresAuth: false,
      );

  @override
  Future<VideoModel> getVideoDetail(String slug) => client.get<VideoModel>(
    '$_basePath/$slug',
    parser: (raw) => VideoModel.fromJson(raw as Map<String, dynamic>),
    requiresAuth: false,
  );
}
