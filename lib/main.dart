import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:todo_clean_bloc/core/common/widgets/loader.dart';
import 'package:todo_clean_bloc/core/theme/theme.dart';
import 'package:todo_clean_bloc/features/auth/presentation/pages/signin_page.dart';
import 'package:todo_clean_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:todo_clean_bloc/init_dependency.dart';
import 'package:todo_clean_bloc/features/dashboard/presentation/pages/dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KitaFit',
      theme: AppTheme.darkThemeMode,
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          // Show loading saat checking current user
          if (authState is AuthLoading) {
            return const Scaffold(body: Center(child: Loader()));
          }

          // Gunakan BlocSelector untuk cek isLoggedIn
          return BlocSelector<AppUserCubit, AppUserState, bool>(
            selector: (state) {
              return state is AppUserLoggedIn;
            },
            builder: (context, isLoggedIn) {
              return isLoggedIn ? const DashboardPage() : const SigninPage();
            },
          );
        },
      ),
    );
  }
}
