part of 'video_list_bloc.dart';

sealed class VideoListEvent extends Equatable {
  const VideoListEvent();
  @override
  List<Object?> get props => [];
}

class VideoListRequested extends VideoListEvent {
  final String? search;
  const VideoListRequested({this.search});
  @override
  List<Object?> get props => [search];
}

class VideoListLoadMore extends VideoListEvent {
  const VideoListLoadMore();
}

class VideoListSearchChanged extends VideoListEvent {
  final String? search;
  const VideoListSearchChanged({this.search});
  @override
  List<Object?> get props => [search];
}
