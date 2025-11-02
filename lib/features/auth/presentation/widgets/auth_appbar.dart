import 'package:flutter/material.dart';
import 'package:todo_clean_bloc/core/theme/app_pallate.dart';
import 'package:todo_clean_bloc/features/auth/presentation/pages/signin_page.dart';

class AuthAppbar extends StatelessWidget implements PreferredSizeWidget {
  const AuthAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[200],
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppPalette.blackColor,
          size: 24,
        ),
        onPressed: () {
          Navigator.pop(context, SigninPage.route());
        },
      ),
      title: const Text(
        'Daftar',
        style: TextStyle(
          color: AppPalette.blackColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
