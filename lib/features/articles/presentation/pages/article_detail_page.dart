import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_clean_bloc/features/articles/presentation/bloc/article_detail_cubit.dart';
import 'package:todo_clean_bloc/init_dependency.dart';

class ArticleDetailPage extends StatelessWidget {
  final String slug;
  const ArticleDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<ArticleDetailCubit>()..load(slug),
      child: const _ArticleDetailView(),
    );
  }
}

class _ArticleDetailView extends StatelessWidget {
  const _ArticleDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<ArticleDetailCubit, ArticleDetailState>(
        builder: (context, state) {
          if (state.status == ArticleDetailStatus.loading ||
              state.status == ArticleDetailStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ArticleDetailStatus.failure ||
              state.article == null) {
            return Center(
              child: Text(state.errorMessage ?? 'Artikel tidak ditemukan'),
            );
          }
          final a = state.article!;
          final theme = Theme.of(context);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (a.thumbnail != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: a.thumbnail!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 16),
                if (a.category != null)
                  Text(
                    a.category!.name,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(a.title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (a.author != null) ...[
                      const Icon(Icons.person_outline, size: 16),
                      const SizedBox(width: 4),
                      Text(a.author!.name, style: theme.textTheme.bodySmall),
                    ],
                    if (a.publishedAt != null) ...[
                      const SizedBox(width: 12),
                      const Icon(Icons.calendar_today_outlined, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd MMM yyyy').format(a.publishedAt!),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
                const Divider(height: 32),
                Text(a.content ?? '', style: theme.textTheme.bodyLarge),
              ],
            ),
          );
        },
      ),
    );
  }
}
