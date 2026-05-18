import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:todo_clean_bloc/core/common/widgets/login_prompt_sheet.dart';
import 'package:todo_clean_bloc/features/dashboard/presentation/widgets/dashboard_menu_item.dart';

class DashboardMenuGrid extends StatelessWidget {
  const DashboardMenuGrid({super.key});

  static const _menuItems = [
    (icon: Icons.article_outlined, label: 'Artikel', requiresAuth: true),
    (icon: Icons.menu_book_outlined, label: 'Wawasan', requiresAuth: true),
    (icon: Icons.quiz_outlined, label: 'Kuis', requiresAuth: true),
    (icon: Icons.video_library_outlined, label: 'Video', requiresAuth: true),
    (icon: Icons.calendar_today_outlined, label: 'Jadwal Literasi', requiresAuth: true),
    (icon: Icons.bookmark_outline, label: 'Favorit', requiresAuth: true),
    (icon: Icons.chat_bubble_outline, label: 'Chat Ahli', requiresAuth: true),
    (icon: Icons.library_books_outlined, label: 'Perpus Fit', requiresAuth: true),
  ];

  @override
  Widget build(BuildContext context) {
    final isLoggedIn =
        context.watch<AppUserCubit>().state is AppUserLoggedIn;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.85,
      children: _menuItems.map((item) {
        final onTap = item.requiresAuth && !isLoggedIn
            ? () => showLoginPromptSheet(context, featureName: item.label)
            : () => debugPrint('Tapped: ${item.label}');

        return DashboardMenuItem(
          icon: item.icon,
          label: item.label,
          onTap: onTap,
        );
      }).toList(),
    );
  }
}
