import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/features/videos/domain/entities/video.dart';

abstract interface class VideoRepository {
  Future<Either<Failure, Paginated<Video>>> getVideos({
    String? search,
    int page = 1,
    int perPage = 15,
  });

  Future<Either<Failure, Video>> getVideoDetail(String slug);
}
