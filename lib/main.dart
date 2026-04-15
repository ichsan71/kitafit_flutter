import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_clean_bloc/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:todo_clean_bloc/core/navigation/bloc/navigation_bloc.dart';
import 'package:todo_clean_bloc/core/navigation/router/app_router.dart';
import 'package:todo_clean_bloc/core/theme/theme.dart';
import 'package:todo_clean_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:todo_clean_bloc/firebase_options.dart';
import 'package:todo_clean_bloc/init_dependency.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<NavigationBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckCurrentUser());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'KitaFit',
      theme: AppTheme.darkThemeMode,
      routerConfig: AppRouter.router,
    );
  }
}
