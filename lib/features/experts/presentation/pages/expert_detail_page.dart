import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/features/experts/presentation/bloc/expert_detail_cubit.dart';
import 'package:todo_clean_bloc/features/experts/presentation/widgets/expert_avatar.dart';
import 'package:todo_clean_bloc/init_dependency.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpertDetailPage extends StatelessWidget {
  final int id;
  const ExpertDetailPage({super.key, required this.id});

  Future<void> _openWhatsapp(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<ExpertDetailCubit>()..load(id),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<ExpertDetailCubit, ExpertDetailState>(
          builder: (context, state) {
            if (state.status == ExpertDetailStatus.loading ||
                state.status == ExpertDetailStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.expert == null) {
              return Center(
                child: Text(state.errorMessage ?? 'Ahli tidak ditemukan'),
              );
            }
            final e = state.expert!;
            final theme = Theme.of(context);
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ExpertAvatar(name: e.name, url: e.avatar, radius: 56),
                  const SizedBox(height: 16),
                  Text(e.name, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text(
                    e.specialization ?? '-',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () =>
                          _openWhatsapp(context, e.resolvedWhatsappUrl),
                      icon: const Icon(Icons.chat),
                      label: const Text('Chat via WhatsApp'),
                    ),
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
