import 'package:go_router/go_router.dart';
import 'package:todo_clean_bloc/core/navigation/widgets/main_shell.dart';
import 'package:todo_clean_bloc/features/auth/presentation/pages/signin_page.dart';
import 'package:todo_clean_bloc/features/auth/presentation/pages/signup_page.dart';
import 'package:todo_clean_bloc/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:todo_clean_bloc/features/literation/presentation/pages/literation_page.dart';
import 'package:todo_clean_bloc/features/profile/presentation/pages/profile_page.dart';

class AppRouter {
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String dashboard = '/';
  static const String literation = '/literation';
  static const String profile = '/profile';

  static final GoRouter router = GoRouter(
    initialLocation: dashboard,
    routes: [
      // Auth routes (without shell)
      GoRoute(
        path: signin,
        name: 'signin',
        builder: (context, state) => const SigninPage(),
      ),
      GoRoute(
        path: signup,
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),

      // Main app routes with bottom navigation shell
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: dashboard,
            name: 'dashboard',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const DashboardPage(),
            ),
          ),
          GoRoute(
            path: literation,
            name: 'literation',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const LiterationPage(),
            ),
          ),
          GoRoute(
            path: profile,
            name: 'profile',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProfilePage(),
            ),
          ),
        ],
      ),
    ],
  );
}
