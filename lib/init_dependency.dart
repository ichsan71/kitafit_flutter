import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_clean_bloc/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:todo_clean_bloc/core/navigation/bloc/navigation_bloc.dart';
import 'package:todo_clean_bloc/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:todo_clean_bloc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:todo_clean_bloc/features/auth/domain/repository/auth_repository.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/current_user.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/user_sign_in.dart';
import 'package:todo_clean_bloc/features/auth/domain/usecases/user_sign_up.dart';
import 'package:todo_clean_bloc/features/auth/presentation/bloc/auth_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initNavigation();

  // Register Firebase services
  serviceLocator.registerLazySingleton(() => FirebaseAuth.instance);
  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);

  // Register AppUserCubit in core layer
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initNavigation() {
  serviceLocator.registerLazySingleton(() => NavigationBloc());
}

void _initAuth() {
  serviceLocator
    // Data source
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        firebaseAuth: serviceLocator(),
        firebaseFirestore: serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: serviceLocator()),
    )
    // Use cases
    ..registerFactory<UserSignUp>(
      () => UserSignUp(repository: serviceLocator()),
    )
    ..registerFactory<UserSignIn>(
      () => UserSignIn(repository: serviceLocator()),
    )
    ..registerFactory<CurrentUser>(
      () => CurrentUser(repository: serviceLocator()),
    )
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userSignIn: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}
