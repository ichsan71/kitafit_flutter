import 'package:flutter/material.dart';
import 'package:todo_clean_bloc/features/dashboard/presentation/widgets/dashboard_menu_item.dart';

class DashboardMenuGrid extends StatelessWidget {
  const DashboardMenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.85,
      children: const [
        DashboardMenuItem(icon: Icons.article_outlined, label: 'Artikel'),
        DashboardMenuItem(icon: Icons.menu_book_outlined, label: 'Wawasan'),
        DashboardMenuItem(icon: Icons.quiz_outlined, label: 'Kuis'),
        DashboardMenuItem(icon: Icons.video_library_outlined, label: 'Video'),
        DashboardMenuItem(
          icon: Icons.calendar_today_outlined,
          label: 'Jadwal Literasi',
        ),
        DashboardMenuItem(icon: Icons.bookmark_outline, label: 'Favorit'),
        DashboardMenuItem(icon: Icons.chat_bubble_outline, label: 'Chat Ahli'),
        DashboardMenuItem(
          icon: Icons.library_books_outlined,
          label: 'Perpus Fit',
        ),
      ],
    );
  }
}
