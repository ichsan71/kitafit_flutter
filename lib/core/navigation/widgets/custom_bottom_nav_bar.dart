import 'package:flutter/material.dart';
import 'package:todo_clean_bloc/core/theme/app_pallate.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Beranda',
              ),
              _buildNavItem(
                context: context,
                index: 1,
                icon: Icons.menu_book_outlined,
                activeIcon: Icons.menu_book,
                label: 'Mulai Literasi',
              ),
              _buildNavItem(
                context: context,
                index: 2,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Saya',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = currentIndex == index;
    final Color primaryColor = AppPalette.primary;
    final Color inactiveColor = Colors.grey.shade600;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with background for middle item (Mulai Literasi)
              if (index == 1 && isSelected)
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(activeIcon, size: 28, color: Colors.white),
                )
              else
                Icon(
                  isSelected ? activeIcon : icon,
                  size: index == 1 ? 28 : 24,
                  color: isSelected ? primaryColor : inactiveColor,
                ),
              const SizedBox(height: 4),
              // Label
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? primaryColor : inactiveColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
