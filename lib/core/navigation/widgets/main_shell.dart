import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_clean_bloc/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:todo_clean_bloc/core/common/widgets/login_prompt_sheet.dart';
import 'package:todo_clean_bloc/core/navigation/bloc/navigation_bloc.dart';
import 'package:todo_clean_bloc/core/navigation/bloc/navigation_event.dart';
import 'package:todo_clean_bloc/core/navigation/bloc/navigation_state.dart';
import 'package:todo_clean_bloc/core/navigation/router/app_router.dart';
import 'package:todo_clean_bloc/core/navigation/widgets/custom_bottom_nav_bar.dart';

// Index tab yang memerlukan login
const _protectedTabs = {2}; // profile

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  void _onItemTapped(BuildContext context, int index) {
    final isLoggedIn =
        context.read<AppUserCubit>().state is AppUserLoggedIn;

    if (_protectedTabs.contains(index) && !isLoggedIn) {
      showLoginPromptSheet(context, featureName: 'halaman profil');
      return;
    }

    context.read<NavigationBloc>().add(NavigationTabChanged(index));

    switch (index) {
      case 0:
        context.go(AppRouter.dashboard);
        break;
      case 1:
        context.go(AppRouter.literation);
        break;
      case 2:
        context.go(AppRouter.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return CustomBottomNavBar(
            currentIndex: state.selectedIndex,
            onTap: (index) => _onItemTapped(context, index),
          );
        },
      ),
    );
  }
}
