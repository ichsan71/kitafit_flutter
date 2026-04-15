import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_clean_bloc/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:todo_clean_bloc/core/navigation/router/app_router.dart';
import 'package:todo_clean_bloc/core/theme/app_pallate.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppPalette.primary.withOpacity(0.1),
                ),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppPalette.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // User Name
                    BlocBuilder<AppUserCubit, AppUserState>(
                      builder: (context, state) {
                        final userName = state is AppUserLoggedIn
                            ? state.user.name
                            : 'Guest';
                        final userEmail = state is AppUserLoggedIn
                            ? state.user.email
                            : '';

                        return Column(
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppPalette.blackColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userEmail,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Menu Items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      title: 'Edit Profil',
                      onTap: () {
                        // Navigate to edit profile
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.settings_outlined,
                      title: 'Pengaturan',
                      onTap: () {
                        // Navigate to settings
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      title: 'Bantuan',
                      onTap: () {
                        // Navigate to help
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      title: 'Tentang Aplikasi',
                      onTap: () {
                        // Navigate to about
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildMenuItem(
                      icon: Icons.logout,
                      title: 'Keluar',
                      textColor: Colors.red,
                      iconColor: Colors.red,
                      onTap: () {
                        _showLogoutDialog(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? AppPalette.blackColor),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor ?? AppPalette.blackColor,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: iconColor ?? Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Logout logic here
                context.read<AppUserCubit>().updateUser(null);
                context.go(AppRouter.signin);
              },
              child: const Text('Keluar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
