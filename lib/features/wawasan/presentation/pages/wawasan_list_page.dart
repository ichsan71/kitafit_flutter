import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:todo_clean_bloc/features/wawasan/domain/entities/wawasan.dart';
import 'package:todo_clean_bloc/features/wawasan/presentation/bloc/wawasan_list_bloc.dart';
import 'package:todo_clean_bloc/init_dependency.dart';

class WawasanListPage extends StatelessWidget {
  const WawasanListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<WawasanListBloc>()
            ..add(const WawasanListRequested()),
      child: const _WawasanListView(),
    );
  }
}

class _WawasanListView extends StatefulWidget {
  const _WawasanListView();

  @override
  State<_WawasanListView> createState() => _WawasanListViewState();
}

class _WawasanListViewState extends State<_WawasanListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<WawasanListBloc>().add(const WawasanListLoadMore());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wawasan')),
      body: BlocBuilder<WawasanListBloc, WawasanListState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == WawasanListStatus.failure &&
              state.page.items.isEmpty) {
            return Center(
              child: Text(state.errorMessage ?? 'Gagal memuat wawasan'),
            );
          }
          if (state.isEmpty) {
            return const Center(child: Text('Belum ada wawasan'));
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<WawasanListBloc>().add(const WawasanListRequested());
            },
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount:
                  state.page.items.length + (state.page.hasMore ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index >= state.page.items.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return _WawasanCard(
                  item: state.page.items[index],
                  onTap: () => context.push(
                    '/wawasan/${state.page.items[index].slug}',
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _WawasanCard extends StatelessWidget {
  final Wawasan item;
  final VoidCallback? onTap;
  const _WawasanCard({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.thumbnail != null)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: item.thumbnail!,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.category != null)
                    Text(
                      item.category!.name,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium,
                  ),
                  if (item.excerpt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.excerpt!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                  if (item.publishedAt != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('dd MMM yyyy').format(item.publishedAt!),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
