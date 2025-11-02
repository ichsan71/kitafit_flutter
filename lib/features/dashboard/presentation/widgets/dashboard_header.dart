import 'package:flutter/material.dart';
import 'package:todo_clean_bloc/core/theme/app_pallate.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key, required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppPalette.whiteColor,
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppPalette.primary,
            child: Icon(Icons.person, color: AppPalette.whiteColor, size: 28),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppPalette.blackColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
