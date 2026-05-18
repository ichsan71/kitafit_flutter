import 'package:equatable/equatable.dart';

class Video extends Equatable {
  final int id;
  final String title;
  final String slug;
  final String? description;
  final String? thumbnail;
  final String videoUrl;
  final int? durationSeconds;
  final DateTime? publishedAt;

  const Video({
    required this.id,
    required this.title,
    required this.slug,
    required this.videoUrl,
    this.description,
    this.thumbnail,
    this.durationSeconds,
    this.publishedAt,
  });

  Duration? get duration =>
      durationSeconds == null ? null : Duration(seconds: durationSeconds!);

  @override
  List<Object?> get props => [
    id,
    title,
    slug,
    description,
    thumbnail,
    videoUrl,
    durationSeconds,
    publishedAt,
  ];
}
