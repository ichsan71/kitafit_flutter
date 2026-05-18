import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/features/videos/domain/entities/video.dart';
import 'package:todo_clean_bloc/features/videos/domain/usecases/get_video_detail.dart';

enum VideoDetailStatus { initial, loading, success, failure }

class VideoDetailState extends Equatable {
  final VideoDetailStatus status;
  final Video? video;
  final String? errorMessage;

  const VideoDetailState({
    required this.status,
    this.video,
    this.errorMessage,
  });

  const VideoDetailState.initial()
    : status = VideoDetailStatus.initial,
      video = null,
      errorMessage = null;

  VideoDetailState copyWith({
    VideoDetailStatus? status,
    Video? video,
    String? errorMessage,
  }) =>
      VideoDetailState(
        status: status ?? this.status,
        video: video ?? this.video,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, video, errorMessage];
}

class VideoDetailCubit extends Cubit<VideoDetailState> {
  final GetVideoDetail _getVideoDetail;

  VideoDetailCubit({required GetVideoDetail getVideoDetail})
    : _getVideoDetail = getVideoDetail,
      super(const VideoDetailState.initial());

  Future<void> load(String slug) async {
    emit(state.copyWith(status: VideoDetailStatus.loading));
    final res = await _getVideoDetail.call(slug);
    res.fold(
      (failure) => emit(
        state.copyWith(
          status: VideoDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (video) =>
          emit(state.copyWith(status: VideoDetailStatus.success, video: video)),
    );
  }
}
