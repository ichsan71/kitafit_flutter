import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_clean_bloc/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:todo_clean_bloc/core/navigation/bloc/navigation_bloc.dart';
import 'package:todo_clean_bloc/core/network/api_client.dart';
import 'package:todo_clean_bloc/core/storage/token_storage.dart';
import 'package:todo_clean_bloc/features/articles/data/datasources/article_remote_data_source.dart';
import 'package:todo_clean_bloc/features/articles/data/repositories/article_repository_impl.dart';
import 'package:todo_clean_bloc/features/articles/domain/repository/article_repository.dart';
import 'package:todo_clean_bloc/features/articles/domain/usecases/get_article_detail.dart';
import 'package:todo_clean_bloc/features/articles/domain/usecases/get_articles.dart';
import 'package:todo_clean_bloc/features/articles/presentation/bloc/article_detail_cubit.dart';
import 'package:todo_clean_bloc/features/articles/presentation/bloc/article_list_bloc.dart';
import 'package:todo_clean_bloc/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:todo_clean_bloc/features/auth/data/datasources/sanctum_auth_remote_data_source.dart';
import 'package:todo_clean_bloc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:todo_clean_bloc/features/auth/domain/repository/auth_repository.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/current_user.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/exchange_sanctum_token.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/get_profile.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/update_profile.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/user_sign_in.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/user_sign_in_google.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/user_sign_out.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/user_sign_up.dart';
import 'package:todo_clean_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:todo_clean_bloc/features/wawasan/data/datasources/wawasan_remote_data_source.dart';
import 'package:todo_clean_bloc/features/wawasan/data/repositories/wawasan_repository_impl.dart';
import 'package:todo_clean_bloc/features/wawasan/domain/repository/wawasan_repository.dart';
import 'package:todo_clean_bloc/features/wawasan/domain/usecases/get_wawasan_detail.dart';
import 'package:todo_clean_bloc/features/wawasan/domain/usecases/get_wawasan_list.dart';
import 'package:todo_clean_bloc/features/wawasan/presentation/bloc/wawasan_detail_cubit.dart';
import 'package:todo_clean_bloc/features/wawasan/presentation/bloc/wawasan_list_bloc.dart';
import 'package:todo_clean_bloc/features/videos/data/datasources/video_remote_data_source.dart';
import 'package:todo_clean_bloc/features/videos/data/repositories/video_repository_impl.dart';
import 'package:todo_clean_bloc/features/videos/domain/repository/video_repository.dart';
import 'package:todo_clean_bloc/features/videos/domain/usecases/get_video_detail.dart';
import 'package:todo_clean_bloc/features/videos/domain/usecases/get_videos.dart';
import 'package:todo_clean_bloc/features/videos/presentation/bloc/video_detail_cubit.dart';
import 'package:todo_clean_bloc/features/videos/presentation/bloc/video_list_bloc.dart';
import 'package:todo_clean_bloc/features/experts/data/datasources/expert_remote_data_source.dart';
import 'package:todo_clean_bloc/features/experts/data/repositories/expert_repository_impl.dart';
import 'package:todo_clean_bloc/features/experts/domain/repository/expert_repository.dart';
import 'package:todo_clean_bloc/features/experts/domain/usecases/get_expert_detail.dart';
import 'package:todo_clean_bloc/features/experts/domain/usecases/get_experts.dart';
import 'package:todo_clean_bloc/features/experts/presentation/bloc/expert_detail_cubit.dart';
import 'package:todo_clean_bloc/features/experts/presentation/bloc/expert_list_cubit.dart';
import 'package:todo_clean_bloc/features/quizzes/data/datasources/quiz_remote_data_source.dart';
import 'package:todo_clean_bloc/features/quizzes/data/repositories/quiz_repository_impl.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/repository/quiz_repository.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/usecases/get_quiz_detail.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/usecases/get_quiz_history.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/usecases/get_quizzes.dart';
import 'package:todo_clean_bloc/features/quizzes/domain/usecases/submit_quiz.dart';
import 'package:todo_clean_bloc/features/quizzes/presentation/bloc/quiz_history_cubit.dart';
import 'package:todo_clean_bloc/features/quizzes/presentation/bloc/quiz_list_cubit.dart';
import 'package:todo_clean_bloc/features/quizzes/presentation/bloc/quiz_player_bloc.dart';
import 'package:todo_clean_bloc/features/schedules/data/datasources/schedule_remote_data_source.dart';
import 'package:todo_clean_bloc/features/schedules/data/repositories/schedule_repository_impl.dart';
import 'package:todo_clean_bloc/features/schedules/domain/repository/schedule_repository.dart';
import 'package:todo_clean_bloc/features/schedules/domain/usecases/create_schedule.dart';
import 'package:todo_clean_bloc/features/schedules/domain/usecases/delete_schedule.dart';
import 'package:todo_clean_bloc/features/schedules/domain/usecases/get_schedule_detail.dart';
import 'package:todo_clean_bloc/features/schedules/domain/usecases/get_schedules.dart';
import 'package:todo_clean_bloc/features/schedules/domain/usecases/update_schedule.dart';
import 'package:todo_clean_bloc/features/schedules/presentation/bloc/schedule_list_bloc.dart';
import 'package:todo_clean_bloc/features/schedules/presentation/cubit/schedule_form_cubit.dart';
import 'package:todo_clean_bloc/features/favorites/data/datasources/favorite_remote_data_source.dart';
import 'package:todo_clean_bloc/features/favorites/data/repositories/favorite_repository_impl.dart';
import 'package:todo_clean_bloc/features/favorites/domain/repository/favorite_repository.dart';
import 'package:todo_clean_bloc/features/favorites/domain/usecases/get_favorites.dart';
import 'package:todo_clean_bloc/features/favorites/domain/usecases/toggle_favorite.dart';
import 'package:todo_clean_bloc/features/favorites/presentation/cubit/favorite_list_cubit.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // External services
  serviceLocator.registerLazySingleton(() => FirebaseAuth.instance);
  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);
  // serverClientId = Web OAuth Client ID dari google-services.json (client_type: 3)
  serviceLocator.registerLazySingleton(
    () => GoogleSignIn(
      serverClientId:
          '633070267511-sd6d7vvs80fbvpvlpp3kam8ehh2c0fp6.apps.googleusercontent.com',
    ),
  );

  // Core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  _initCore();

  _initAuth();
  _initNavigation();
  _initArticles();
  _initWawasan();
  _initVideos();
  _initExperts();
  _initQuizzes();
  _initSchedules();
  _initFavorites();
}

void _initCore() {
  serviceLocator
    ..registerLazySingleton<TokenStorage>(() => SecureTokenStorage())
    ..registerLazySingleton<ApiClient>(
      () => ApiClient.create(tokenStorage: serviceLocator()),
    );
}

void _initNavigation() {
  serviceLocator.registerLazySingleton(() => NavigationBloc());
}

void _initArticles() {
  serviceLocator
    ..registerFactory<ArticleRemoteDataSource>(
      () => ArticleRemoteDataSourceImpl(client: serviceLocator()),
    )
    ..registerFactory<ArticleRepository>(
      () => ArticleRepositoryImpl(remoteDataSource: serviceLocator()),
    )
    ..registerFactory(() => GetArticles(repository: serviceLocator()))
    ..registerFactory(() => GetArticleDetail(repository: serviceLocator()))
    ..registerFactory(() => ArticleListBloc(getArticles: serviceLocator()))
    ..registerFactory(
      () => ArticleDetailCubit(getArticleDetail: serviceLocator()),
    );
}

void _initWawasan() {
  serviceLocator
    ..registerFactory<WawasanRemoteDataSource>(
      () => WawasanRemoteDataSourceImpl(client: serviceLocator()),
    )
    ..registerFactory<WawasanRepository>(
      () => WawasanRepositoryImpl(remoteDataSource: serviceLocator()),
    )
    ..registerFactory(() => GetWawasanList(repository: serviceLocator()))
    ..registerFactory(() => GetWawasanDetail(repository: serviceLocator()))
    ..registerFactory(() => WawasanListBloc(getWawasanList: serviceLocator()))
    ..registerFactory(
      () => WawasanDetailCubit(getWawasanDetail: serviceLocator()),
    );
}

void _initVideos() {
  serviceLocator
    ..registerFactory<VideoRemoteDataSource>(
      () => VideoRemoteDataSourceImpl(client: serviceLocator()),
    )
    ..registerFactory<VideoRepository>(
      () => VideoRepositoryImpl(remoteDataSource: serviceLocator()),
    )
    ..registerFactory(() => GetVideos(repository: serviceLocator()))
    ..registerFactory(() => GetVideoDetail(repository: serviceLocator()))
    ..registerFactory(() => VideoListBloc(getVideos: serviceLocator()))
    ..registerFactory(() => VideoDetailCubit(getVideoDetail: serviceLocator()));
}

void _initExperts() {
  serviceLocator
    ..registerFactory<ExpertRemoteDataSource>(
      () => ExpertRemoteDataSourceImpl(client: serviceLocator()),
    )
    ..registerFactory<ExpertRepository>(
      () => ExpertRepositoryImpl(remoteDataSource: serviceLocator()),
    )
    ..registerFactory(() => GetExperts(repository: serviceLocator()))
    ..registerFactory(() => GetExpertDetail(repository: serviceLocator()))
    ..registerFactory(() => ExpertListCubit(getExperts: serviceLocator()))
    ..registerFactory(
      () => ExpertDetailCubit(getExpertDetail: serviceLocator()),
    );
}

void _initQuizzes() {
  serviceLocator
    ..registerFactory<QuizRemoteDataSource>(
      () => QuizRemoteDataSourceImpl(client: serviceLocator()),
    )
    ..registerFactory<QuizRepository>(
      () => QuizRepositoryImpl(remoteDataSource: serviceLocator()),
    )
    ..registerFactory(() => GetQuizzes(repository: serviceLocator()))
    ..registerFactory(() => GetQuizDetail(repository: serviceLocator()))
    ..registerFactory(() => SubmitQuiz(repository: serviceLocator()))
    ..registerFactory(() => GetQuizHistory(repository: serviceLocator()))
    ..registerFactory(() => QuizListCubit(getQuizzes: serviceLocator()))
    ..registerFactory(
      () => QuizPlayerBloc(
        getQuizDetail: serviceLocator(),
        submitQuiz: serviceLocator(),
      ),
    )
    ..registerFactory(() => QuizHistoryCubit(getQuizHistory: serviceLocator()));
}

void _initSchedules() {
  serviceLocator
    ..registerFactory<ScheduleRemoteDataSource>(
      () => ScheduleRemoteDataSourceImpl(client: serviceLocator()),
    )
    ..registerFactory<ScheduleRepository>(
      () => ScheduleRepositoryImpl(remoteDataSource: serviceLocator()),
    )
    ..registerFactory(() => GetSchedules(repository: serviceLocator()))
    ..registerFactory(() => GetScheduleDetail(repository: serviceLocator()))
    ..registerFactory(() => CreateSchedule(repository: serviceLocator()))
    ..registerFactory(() => UpdateSchedule(repository: serviceLocator()))
    ..registerFactory(() => DeleteSchedule(repository: serviceLocator()))
    ..registerFactory(
      () => ScheduleListBloc(
        getSchedules: serviceLocator(),
        deleteSchedule: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => ScheduleFormCubit(
        createSchedule: serviceLocator(),
        updateSchedule: serviceLocator(),
      ),
    );
}

void _initFavorites() {
  serviceLocator
    ..registerFactory<FavoriteRemoteDataSource>(
      () => FavoriteRemoteDataSourceImpl(client: serviceLocator()),
    )
    ..registerFactory<FavoriteRepository>(
      () => FavoriteRepositoryImpl(remoteDataSource: serviceLocator()),
    )
    ..registerFactory(() => GetFavorites(repository: serviceLocator()))
    ..registerFactory(() => ToggleFavorite(repository: serviceLocator()))
    ..registerFactory(
      () => FavoriteListCubit(
        getFavorites: serviceLocator(),
        toggleFavorite: serviceLocator(),
      ),
    );
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        firebaseAuth: serviceLocator(),
        firebaseFirestore: serviceLocator(),
        googleSignIn: serviceLocator(),
      ),
    )
    ..registerFactory<SanctumAuthRemoteDataSource>(
      () => SanctumAuthRemoteDataSourceImpl(client: serviceLocator()),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        firebaseDataSource: serviceLocator(),
        sanctumDataSource: serviceLocator(),
        tokenStorage: serviceLocator(),
        firebaseAuth: serviceLocator(),
      ),
    )
    ..registerFactory(() => UserSignUp(repository: serviceLocator()))
    ..registerFactory(() => UserSignIn(repository: serviceLocator()))
    ..registerFactory(() => UserSignInGoogle(repository: serviceLocator()))
    ..registerFactory(() => UserSignOut(repository: serviceLocator()))
    ..registerFactory(() => CurrentUser(repository: serviceLocator()))
    ..registerFactory(() => ExchangeSanctumToken(repository: serviceLocator()))
    ..registerFactory(() => GetProfile(repository: serviceLocator()))
    ..registerFactory(() => UpdateProfile(repository: serviceLocator()))
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userSignIn: serviceLocator(),
        userSignInGoogle: serviceLocator(),
        userSignOut: serviceLocator(),
        currentUser: serviceLocator(),
        exchangeSanctumToken: serviceLocator(),
        getProfile: serviceLocator(),
        updateProfile: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}
