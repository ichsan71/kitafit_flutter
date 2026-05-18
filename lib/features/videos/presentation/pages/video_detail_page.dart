import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/features/videos/presentation/bloc/video_detail_cubit.dart';
import 'package:todo_clean_bloc/init_dependency.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoDetailPage extends StatelessWidget {
  final String slug;
  const VideoDetailPage({super.key, required this.slug});

  Future<void> _openVideo(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuka video: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<VideoDetailCubit>()..load(slug),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<VideoDetailCubit, VideoDetailState>(
          builder: (context, state) {
            if (state.status == VideoDetailStatus.loading ||
                state.status == VideoDetailStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.video == null) {
              return Center(
                child: Text(state.errorMessage ?? 'Video tidak ditemukan'),
              );
            }
            final v = state.video!;
            final theme = Theme.of(context);
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: v.thumbnail == null
                                ? Container(color: Colors.black12)
                                : CachedNetworkImage(
                                    imageUrl: v.thumbnail!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Center(
                            child: IconButton.filled(
                              iconSize: 48,
                              onPressed: () => _openVideo(context, v.videoUrl),
                              icon: const Icon(Icons.play_arrow),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(v.title, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  if (v.description != null)
                    Text(v.description!, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => _openVideo(context, v.videoUrl),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Tonton di aplikasi eksternal'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
