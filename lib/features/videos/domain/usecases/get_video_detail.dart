import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/videos/domain/entities/video.dart';
import 'package:todo_clean_bloc/features/videos/domain/repository/video_repository.dart';

class GetVideoDetail implements UseCase<Video, String> {
  final VideoRepository repository;
  GetVideoDetail({required this.repository});

  @override
  Future<Either<Failure, Video>> call(String slug) =>
      repository.getVideoDetail(slug);
}
