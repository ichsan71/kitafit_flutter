part of 'video_list_bloc.dart';

enum VideoListStatus { initial, loading, loadingMore, success, failure }

class VideoListState extends Equatable {
  final VideoListStatus status;
  final Paginated<Video> page;
  final String? search;
  final String? errorMessage;

  const VideoListState({
    required this.status,
    required this.page,
    this.search,
    this.errorMessage,
  });

  const VideoListState.initial()
    : status = VideoListStatus.initial,
      page = const Paginated<Video>(
        items: [],
        currentPage: 1,
        lastPage: 1,
        perPage: 0,
        total: 0,
      ),
      search = null,
      errorMessage = null;

  bool get isLoading => status == VideoListStatus.loading;
  bool get isEmpty =>
      status == VideoListStatus.success && page.items.isEmpty;

  VideoListState copyWith({
    VideoListStatus? status,
    Paginated<Video>? page,
    String? search,
    String? errorMessage,
  }) =>
      VideoListState(
        status: status ?? this.status,
        page: page ?? this.page,
        search: search ?? this.search,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, page, search, errorMessage];
}
