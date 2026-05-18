import 'package:flutter/material.dart';
import 'package:todo_clean_bloc/core/theme/app_pallate.dart';

class DashboardMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const DashboardMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => debugPrint('Tapped: $label'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppPalette.whiteColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppPalette.blackColor.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 28, color: AppPalette.blackColor),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppPalette.blackColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
