import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_clean_bloc/core/navigation/router/app_router.dart';
import 'package:todo_clean_bloc/core/utils/show_snackbar.dart';
import 'package:todo_clean_bloc/features/favorites/domain/entities/favorite.dart';
import 'package:todo_clean_bloc/features/favorites/presentation/cubit/favorite_list_cubit.dart';
import 'package:todo_clean_bloc/init_dependency.dart';

class FavoriteListPage extends StatelessWidget {
  const FavoriteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<FavoriteListCubit>()..load(),
      child: const _FavoriteListView(),
    );
  }
}

class _FavoriteListView extends StatefulWidget {
  const _FavoriteListView();

  @override
  State<_FavoriteListView> createState() => _FavoriteListViewState();
}

class _FavoriteListViewState extends State<_FavoriteListView> {
  static const _filterOptions = [
    (label: 'Semua', value: null),
    (label: 'Artikel', value: 'article'),
    (label: 'Wawasan', value: 'wawasan'),
    (label: 'Video', value: 'video'),
    (label: 'Kuis', value: 'quiz'),
  ];

  String? _activeType;

  void _applyFilter(String? type) {
    setState(() => _activeType = type);
    context.read<FavoriteListCubit>().load(type: type);
  }

  void _unfavorite(Favorite fav) {
    context.read<FavoriteListCubit>().toggle(
      favoritableType: fav.favoritableType,
      favoritableId: fav.favoritableId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoriteListCubit, FavoriteListState>(
      listener: (context, state) {
        if (state is FavoriteListFailure) {
          showModernSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Favorit')),
        body: Column(
          children: [
            // Filter chips
            SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _filterOptions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final option = _filterOptions[index];
                  final isSelected = _activeType == option.value;
                  return FilterChip(
                    label: Text(option.label),
                    selected: isSelected,
                    onSelected: (_) => _applyFilter(option.value),
                  );
                },
              ),
            ),
            // List
            Expanded(
              child: BlocBuilder<FavoriteListCubit, FavoriteListState>(
                builder: (context, state) {
                  if (state is FavoriteListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is FavoriteListFailure) {
                    return _ErrorView(
                      message: state.message,
                      onRetry: () => _applyFilter(_activeType),
                    );
                  }
                  if (state is FavoriteListLoaded) {
                    if (state.favorites.isEmpty) {
                      return const Center(
                        child: Text('Belum ada item favorit'),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async => _applyFilter(_activeType),
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        itemCount: state.favorites.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          return _FavoriteCard(
                            favorite: state.favorites[index],
                            onNavigate: () => _navigateToDetail(
                              context,
                              state.favorites[index],
                            ),
                            onUnfavorite: () =>
                                _unfavorite(state.favorites[index]),
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, Favorite fav) {
    final data = fav.favoritableData ?? {};
    final slug = data['slug']?.toString();

    switch (fav.favoritableType) {
      case 'article':
        if (slug != null) context.push(AppRouter.articleDetail(slug));
      case 'wawasan':
        if (slug != null) context.push(AppRouter.wawasanDetail(slug));
      case 'video':
        if (slug != null) context.push(AppRouter.videoDetail(slug));
      case 'quiz':
        if (slug != null) context.push(AppRouter.quizPlayer(slug));
      default:
        break;
    }
  }
}

class _FavoriteCard extends StatelessWidget {
  final Favorite favorite;
  final VoidCallback onNavigate;
  final VoidCallback onUnfavorite;

  const _FavoriteCard({
    required this.favorite,
    required this.onNavigate,
    required this.onUnfavorite,
  });

  IconData get _icon {
    return switch (favorite.favoritableType) {
      'article' => Icons.article_outlined,
      'wawasan' => Icons.menu_book_outlined,
      'video' => Icons.video_library_outlined,
      'quiz' => Icons.quiz_outlined,
      _ => Icons.bookmark_outline,
    };
  }

  String get _typeLabel {
    return switch (favorite.favoritableType) {
      'article' => 'Artikel',
      'wawasan' => 'Wawasan',
      'video' => 'Video',
      'quiz' => 'Kuis',
      _ => favorite.favoritableType,
    };
  }

  @override
  Widget build(BuildContext context) {
    final data = favorite.favoritableData ?? {};
    final title =
        data['title']?.toString() ?? 'Item #${favorite.favoritableId}';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onNavigate,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _icon,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _typeLabel,
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.bookmark, color: Colors.amber),
                tooltip: 'Hapus dari favorit',
                onPressed: onUnfavorite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}
