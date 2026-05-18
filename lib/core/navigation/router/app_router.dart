import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_clean_bloc/core/navigation/widgets/main_shell.dart';
import 'package:todo_clean_bloc/features/articles/presentation/pages/article_detail_page.dart';
import 'package:todo_clean_bloc/features/articles/presentation/pages/article_list_page.dart';
import 'package:todo_clean_bloc/features/auth/presentation/pages/signin_page.dart';
import 'package:todo_clean_bloc/features/experts/presentation/pages/expert_detail_page.dart';
import 'package:todo_clean_bloc/features/experts/presentation/pages/expert_list_page.dart';
import 'package:todo_clean_bloc/features/videos/presentation/pages/video_detail_page.dart';
import 'package:todo_clean_bloc/features/videos/presentation/pages/video_list_page.dart';
import 'package:todo_clean_bloc/features/auth/presentation/pages/signup_page.dart';
import 'package:todo_clean_bloc/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:todo_clean_bloc/features/literation/presentation/pages/literation_page.dart';
import 'package:todo_clean_bloc/features/profile/presentation/pages/profile_edit_page.dart';
import 'package:todo_clean_bloc/features/profile/presentation/pages/profile_page.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/entities/quiz_attempt.dart';
import 'package:todo_clean_bloc/features/quizzes/presentation/pages/quiz_history_page.dart';
import 'package:todo_clean_bloc/features/quizzes/presentation/pages/quiz_list_page.dart';
import 'package:todo_clean_bloc/features/quizzes/presentation/pages/quiz_player_page.dart';
import 'package:todo_clean_bloc/features/quizzes/presentation/pages/quiz_result_page.dart';
import 'package:todo_clean_bloc/features/wawasan/presentation/pages/wawasan_detail_page.dart';
import 'package:todo_clean_bloc/features/wawasan/presentation/pages/wawasan_list_page.dart';
import 'package:todo_clean_bloc/features/schedules/domain/entities/literacy_schedule.dart';
import 'package:todo_clean_bloc/features/schedules/presentation/pages/schedule_form_page.dart';
import 'package:todo_clean_bloc/features/schedules/presentation/pages/schedule_list_page.dart';
import 'package:todo_clean_bloc/features/favorites/presentation/pages/favorite_list_page.dart';

class AppRouter {
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String dashboard = '/';
  static const String literation = '/literation';
  static const String profile = '/profile';
  static const String articles = '/articles';
  static String articleDetail(String slug) => '/articles/$slug';
  static const String wawasan = '/wawasan';
  static String wawasanDetail(String slug) => '/wawasan/$slug';
  static const String videos = '/videos';
  static String videoDetail(String slug) => '/videos/$slug';
  static const String experts = '/experts';
  static String expertDetail(int id) => '/experts/$id';
  static const String quizzes = '/quizzes';
  static String quizPlayer(String slug) => '/quizzes/$slug';
  static const String quizHistory = '/quiz-history';
  static const String quizResult = '/quiz-result';
  static const String schedules = '/schedules';
  static const String scheduleCreate = '/schedules/new';
  static String scheduleEdit(int id) => '/schedules/$id/edit';
  static const String favorites = '/favorites';
  static const String profileEdit = '/profile/edit';

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

      // Content routes (full screen, outside shell)
      GoRoute(
        path: articles,
        name: 'articles',
        builder: (context, state) => const ArticleListPage(),
        routes: [
          GoRoute(
            path: ':slug',
            name: 'article-detail',
            builder: (context, state) =>
                ArticleDetailPage(slug: state.pathParameters['slug']!),
          ),
        ],
      ),
      GoRoute(
        path: wawasan,
        name: 'wawasan',
        builder: (context, state) => const WawasanListPage(),
        routes: [
          GoRoute(
            path: ':slug',
            name: 'wawasan-detail',
            builder: (context, state) =>
                WawasanDetailPage(slug: state.pathParameters['slug']!),
          ),
        ],
      ),
      GoRoute(
        path: videos,
        name: 'videos',
        builder: (context, state) => const VideoListPage(),
        routes: [
          GoRoute(
            path: ':slug',
            name: 'video-detail',
            builder: (context, state) =>
                VideoDetailPage(slug: state.pathParameters['slug']!),
          ),
        ],
      ),
      GoRoute(
        path: AppRouter.experts,
        name: 'experts',
        builder: (context, state) => const ExpertListPage(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'expert-detail',
            builder: (context, state) =>
                ExpertDetailPage(id: int.parse(state.pathParameters['id']!)),
          ),
        ],
      ),
      GoRoute(
        path: quizzes,
        name: 'quizzes',
        builder: (context, state) => const QuizListPage(),
        routes: [
          GoRoute(
            path: ':slug',
            name: 'quiz-player',
            builder: (context, state) =>
                QuizPlayerPage(slug: state.pathParameters['slug']!),
          ),
        ],
      ),
      GoRoute(
        path: quizHistory,
        name: 'quiz-history',
        builder: (context, state) => const QuizHistoryPage(),
      ),
      GoRoute(
        path: quizResult,
        name: 'quiz-result',
        builder: (context, state) {
          final attempt = state.extra;
          if (attempt is! QuizAttempt) {
            return const Scaffold(
              body: Center(child: Text('Data hasil tidak ditemukan')),
            );
          }
          return QuizResultPage(attempt: attempt);
        },
      ),
      GoRoute(
        path: schedules,
        name: 'schedules',
        builder: (context, state) => const ScheduleListPage(),
      ),
      GoRoute(
        path: scheduleCreate,
        name: 'schedule-create',
        builder: (context, state) => const ScheduleFormPage(),
      ),
      GoRoute(
        path: '/schedules/:id/edit',
        name: 'schedule-edit',
        builder: (context, state) {
          // Schedule entity passed via extra for edit
          final schedule = state.extra;
          return ScheduleFormPage(
            schedule: schedule is LiteracySchedule ? schedule : null,
          );
        },
      ),
      GoRoute(
        path: favorites,
        name: 'favorites',
        builder: (context, state) => const FavoriteListPage(),
      ),
      GoRoute(
        path: profileEdit,
        name: 'profile-edit',
        builder: (context, state) => const ProfileEditPage(),
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
