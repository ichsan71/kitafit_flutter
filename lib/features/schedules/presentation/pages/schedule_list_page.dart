import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:todo_clean_bloc/core/navigation/router/app_router.dart';
import 'package:todo_clean_bloc/core/utils/show_snackbar.dart';
import 'package:todo_clean_bloc/features/schedules/domain/entities/literacy_schedule.dart';
import 'package:todo_clean_bloc/features/schedules/presentation/bloc/schedule_list_bloc.dart';
import 'package:todo_clean_bloc/init_dependency.dart';

class ScheduleListPage extends StatelessWidget {
  const ScheduleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<ScheduleListBloc>()
            ..add(const ScheduleListRequested()),
      child: const _ScheduleListView(),
    );
  }
}

class _ScheduleListView extends StatefulWidget {
  const _ScheduleListView();

  @override
  State<_ScheduleListView> createState() => _ScheduleListViewState();
}

class _ScheduleListViewState extends State<_ScheduleListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ScheduleListBloc>().add(const ScheduleListLoadMore());
    }
  }

  Future<void> _pickDateFilter() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && mounted) {
      final formatted = DateFormat('yyyy-MM-dd').format(picked);
      context.read<ScheduleListBloc>().add(
        ScheduleListFilterChanged(date: formatted),
      );
    }
  }

  void _clearFilter() {
    context.read<ScheduleListBloc>().add(const ScheduleListFilterChanged());
  }

  void _deleteSchedule(BuildContext ctx, int id) {
    ctx.read<ScheduleListBloc>().add(ScheduleListItemDeleted(id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScheduleListBloc, ScheduleListState>(
      listener: (context, state) {
        if (state.status == ScheduleListStatus.failure &&
            state.errorMessage != null) {
          showModernSnackBar(context, state.errorMessage!);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Jadwal Literasi'),
          actions: [
            BlocBuilder<ScheduleListBloc, ScheduleListState>(
              builder: (context, state) {
                return Row(
                  children: [
                    if (state.dateFilter != null)
                      TextButton.icon(
                        icon: const Icon(Icons.clear, size: 16),
                        label: Text(state.dateFilter!),
                        onPressed: _clearFilter,
                      ),
                    IconButton(
                      icon: const Icon(Icons.filter_alt_outlined),
                      tooltip: 'Filter tanggal',
                      onPressed: _pickDateFilter,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await context.push<bool>(AppRouter.scheduleCreate);
            if (result == true && context.mounted) {
              context.read<ScheduleListBloc>().add(
                const ScheduleListRequested(),
              );
            }
          },
          tooltip: 'Tambah jadwal',
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<ScheduleListBloc, ScheduleListState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == ScheduleListStatus.failure &&
                state.page.items.isEmpty) {
              return _ErrorView(
                message: state.errorMessage ?? 'Gagal memuat jadwal',
                onRetry: () => context.read<ScheduleListBloc>().add(
                  const ScheduleListRequested(),
                ),
              );
            }
            if (state.isEmpty) {
              return const Center(child: Text('Belum ada jadwal literasi'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ScheduleListBloc>().add(
                  const ScheduleListRequested(),
                );
              },
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                itemCount:
                    state.page.items.length + (state.page.hasMore ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  if (index >= state.page.items.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final schedule = state.page.items[index];
                  return _ScheduleCard(
                    schedule: schedule,
                    onEdit: () async {
                      final result = await context.push<bool>(
                        AppRouter.scheduleEdit(schedule.id),
                        extra: schedule,
                      );
                      if (result == true && context.mounted) {
                        context.read<ScheduleListBloc>().add(
                          const ScheduleListRequested(),
                        );
                      }
                    },
                    onDelete: () => _deleteSchedule(context, schedule.id),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final LiteracySchedule schedule;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ScheduleCard({
    required this.schedule,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat(
      'EEEE, d MMMM yyyy',
      'id_ID',
    ).format(schedule.scheduledDate);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                Icons.calendar_today,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$dateStr  •  ${schedule.scheduledTime}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  if (schedule.description != null &&
                      schedule.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        schedule.description!,
                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Hapus Jadwal'),
                      content: const Text('Yakin ingin menghapus jadwal ini?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            onDelete();
                          },
                          child: const Text(
                            'Hapus',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Hapus', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
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
