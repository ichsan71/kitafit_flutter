import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/features/dashboard/data/list_card.dart';
import 'package:todo_clean_bloc/features/dashboard/presentation/widgets/dashboard_banner.dart';
import 'package:todo_clean_bloc/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:todo_clean_bloc/core/theme/app_pallate.dart';
import 'package:todo_clean_bloc/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:todo_clean_bloc/features/dashboard/presentation/widgets/dashboard_menu_grid.dart';
import 'package:todo_clean_bloc/core/common/widgets/section_title.dart';
import 'package:todo_clean_bloc/features/dashboard/presentation/widgets/dashboard_list_card.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.background,
      body: SafeArea(
        child: Column(
          children: [
            // get user name from AppUserCubit
            BlocBuilder<AppUserCubit, AppUserState>(
              builder: (context, state) {
                final userName = state is AppUserLoggedIn
                    ? state.user.name
                    : 'Guest';

                debugPrint('DashboardPage: userName = $userName');
                return DashboardHeader(userName: userName);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DashboardBanner(),
                    SizedBox(height: 16),
                    DashboardMenuGrid(),
                    SizedBox(height: 24),
                    SectionTitle(title: 'Kita Fit Info'),
                    SizedBox(height: 12),
                    // list card info
                    DashboardListCard(cards: listCard),
                    SizedBox(height: 24),
                    SectionTitle(title: 'Informasi Fitur'),
                    SizedBox(height: 12),
                    DashboardListCard(cards: listCard),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

// make list card that can be reused with title and list of cards
