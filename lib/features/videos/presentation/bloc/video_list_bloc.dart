import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/core/network/paginated.dart';
import 'package:todo_clean_bloc/features/videos/domain/entities/video.dart';
import 'package:todo_clean_bloc/features/videos/domain/usecases/get_videos.dart';

part 'video_list_event.dart';
part 'video_list_state.dart';

class VideoListBloc extends Bloc<VideoListEvent, VideoListState> {
  final GetVideos _getVideos;

  VideoListBloc({required GetVideos getVideos})
    : _getVideos = getVideos,
      super(const VideoListState.initial()) {
    on<VideoListRequested>(_onRequested);
    on<VideoListLoadMore>(_onLoadMore);
    on<VideoListSearchChanged>(_onSearchChanged);
  }

  Future<void> _onRequested(
    VideoListRequested event,
    Emitter<VideoListState> emit,
  ) async {
    emit(state.copyWith(status: VideoListStatus.loading));
    final res = await _getVideos.call(
      GetVideosParams(search: event.search ?? state.search),
    );
    res.fold(
      (failure) => emit(
        state.copyWith(
          status: VideoListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (page) => emit(
        state.copyWith(
          status: VideoListStatus.success,
          page: page,
          search: event.search ?? state.search,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    VideoListLoadMore event,
    Emitter<VideoListState> emit,
  ) async {
    if (!state.page.hasMore || state.status == VideoListStatus.loadingMore) {
      return;
    }
    emit(state.copyWith(status: VideoListStatus.loadingMore));
    final res = await _getVideos.call(
      GetVideosParams(
        search: state.search,
        page: state.page.currentPage + 1,
      ),
    );
    res.fold(
      (failure) => emit(
        state.copyWith(
          status: VideoListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (next) => emit(
        state.copyWith(
          status: VideoListStatus.success,
          page: state.page.append(next),
        ),
      ),
    );
  }

  Future<void> _onSearchChanged(
    VideoListSearchChanged event,
    Emitter<VideoListState> emit,
  ) async {
    emit(state.copyWith(page: Paginated.empty<Video>(), search: event.search));
    add(VideoListRequested(search: event.search));
  }
}
