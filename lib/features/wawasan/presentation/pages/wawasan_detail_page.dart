import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_clean_bloc/features/wawasan/presentation/bloc/wawasan_detail_cubit.dart';
import 'package:todo_clean_bloc/init_dependency.dart';

class WawasanDetailPage extends StatelessWidget {
  final String slug;
  const WawasanDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<WawasanDetailCubit>()..load(slug),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<WawasanDetailCubit, WawasanDetailState>(
          builder: (context, state) {
            if (state.status == WawasanDetailStatus.loading ||
                state.status == WawasanDetailStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.wawasan == null) {
              return Center(
                child: Text(state.errorMessage ?? 'Tidak ditemukan'),
              );
            }
            final w = state.wawasan!;
            final theme = Theme.of(context);
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (w.thumbnail != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: w.thumbnail!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (w.category != null)
                    Text(
                      w.category!.name,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  Text(w.title, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  if (w.publishedAt != null)
                    Text(
                      DateFormat('dd MMM yyyy').format(w.publishedAt!),
                      style: theme.textTheme.bodySmall,
                    ),
                  const Divider(height: 32),
                  Text(w.content ?? '', style: theme.textTheme.bodyLarge),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
