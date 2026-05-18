import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_clean_bloc/features/experts/presentation/bloc/expert_list_cubit.dart';
import 'package:todo_clean_bloc/features/experts/presentation/widgets/expert_avatar.dart';
import 'package:todo_clean_bloc/init_dependency.dart';

class ExpertListPage extends StatelessWidget {
  const ExpertListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<ExpertListCubit>()..load(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Chat Ahli')),
        body: BlocBuilder<ExpertListCubit, ExpertListState>(
          builder: (context, state) {
            if (state.status == ExpertListStatus.loading ||
                state.status == ExpertListStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == ExpertListStatus.failure) {
              return Center(
                child: Text(state.errorMessage ?? 'Gagal memuat data'),
              );
            }
            if (state.experts.isEmpty) {
              return const Center(child: Text('Belum ada ahli tersedia'));
            }
            return RefreshIndicator(
              onRefresh: () => context.read<ExpertListCubit>().load(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.experts.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final e = state.experts[index];
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: ExpertAvatar(name: e.name, url: e.avatar),
                      title: Text(e.name),
                      subtitle: Text(e.specialization ?? '-'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/experts/${e.id}'),
                    ),
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
