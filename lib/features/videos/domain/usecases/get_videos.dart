import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todo_clean_bloc/core/error/failure.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/core/usecase/usecase.dart';
import 'package:todo_clean_bloc/features/videos/domain/entities/video.dart';
import 'package:todo_clean_bloc/features/videos/domain/repository/video_repository.dart';

class GetVideosParams extends Equatable {
  final String? search;
  final int page;
  final int perPage;

  const GetVideosParams({this.search, this.page = 1, this.perPage = 15});

  @override
  List<Object?> get props => [search, page, perPage];
}

class GetVideos implements UseCase<Paginated<Video>, GetVideosParams> {
  final VideoRepository repository;
  GetVideos({required this.repository});

  @override
  Future<Either<Failure, Paginated<Video>>> call(GetVideosParams params) =>
      repository.getVideos(
        search: params.search,
        page: params.page,
        perPage: params.perPage,
      );
}
