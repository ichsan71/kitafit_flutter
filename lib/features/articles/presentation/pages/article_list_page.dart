import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_clean_bloc/features/articles/presentation/bloc/article_list_bloc.dart';
import 'package:todo_clean_bloc/features/articles/presentation/widgets/article_card.dart';
import 'package:todo_clean_bloc/init_dependency.dart';

class ArticleListPage extends StatelessWidget {
  const ArticleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<ArticleListBloc>()
            ..add(const ArticleListRequested()),
      child: const _ArticleListView(),
    );
  }
}

class _ArticleListView extends StatefulWidget {
  const _ArticleListView();

  @override
  State<_ArticleListView> createState() => _ArticleListViewState();
}

class _ArticleListViewState extends State<_ArticleListView> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ArticleListBloc>().add(const ArticleListLoadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artikel')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari artikel...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) => context.read<ArticleListBloc>().add(
                ArticleListFilterChanged(search: value),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<ArticleListBloc, ArticleListState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == ArticleListStatus.failure &&
                    state.page.items.isEmpty) {
                  return _ErrorView(
                    message: state.errorMessage ?? 'Gagal memuat artikel',
                    onRetry: () => context.read<ArticleListBloc>().add(
                      const ArticleListRequested(),
                    ),
                  );
                }
                if (state.isEmpty) {
                  return const Center(child: Text('Belum ada artikel'));
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ArticleListBloc>().add(
                      const ArticleListRequested(),
                    );
                  },
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount:
                        state.page.items.length + (state.page.hasMore ? 1 : 0),
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index >= state.page.items.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final article = state.page.items[index];
                      return ArticleCard(
                        article: article,
                        onTap: () => context.push(
                          '/articles/${article.slug}',
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Coba Lagi')),
        ],
      ),
    ),
  );
}
