import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_clean_bloc/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:todo_clean_bloc/core/navigation/bloc/navigation_bloc.dart';
import 'package:todo_clean_bloc/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:todo_clean_bloc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:todo_clean_bloc/features/auth/domain/repository/auth_repository.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/current_user.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/user_sign_in.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/user_sign_in_google.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/user_sign_up.dart';
import 'package:todo_clean_bloc/features/auth/presentation/bloc/auth_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // External services
  serviceLocator.registerLazySingleton(() => FirebaseAuth.instance);
  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);
  // serverClientId = Web OAuth Client ID dari google-services.json (client_type: 3)
  // Ganti nilai ini setelah menambahkan SHA-1 di Firebase Console dan download ulang google-services.json
  serviceLocator.registerLazySingleton(
    () => GoogleSignIn(
      serverClientId:
          '633070267511-sd6d7vvs80fbvpvlpp3kam8ehh2c0fp6.apps.googleusercontent.com',
    ),
  );

  // Core
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  _initAuth();
  _initNavigation();
}

void _initNavigation() {
  serviceLocator.registerLazySingleton(() => NavigationBloc());
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
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: serviceLocator()),
    )
    ..registerFactory(() => UserSignUp(repository: serviceLocator()))
    ..registerFactory(() => UserSignIn(repository: serviceLocator()))
    ..registerFactory(() => UserSignInGoogle(repository: serviceLocator()))
    ..registerFactory(() => CurrentUser(repository: serviceLocator()))
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userSignIn: serviceLocator(),
        userSignInGoogle: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}
