import 'package:todo_clean_bloc/features/videos/domain/entities/video.dart';

class VideoModel extends Video {
  const VideoModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.videoUrl,
    super.description,
    super.thumbnail,
    super.durationSeconds,
    super.publishedAt,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
    id: (json['id'] as num).toInt(),
    title: (json['title'] ?? '').toString(),
    slug: (json['slug'] ?? '').toString(),
    description: json['description']?.toString(),
    thumbnail: json['thumbnail']?.toString(),
    videoUrl: (json['video_url'] ?? '').toString(),
    durationSeconds: (json['duration'] as num?)?.toInt(),
    publishedAt: json['published_at'] != null
        ? DateTime.tryParse(json['published_at'].toString())
        : null,
  );
}
