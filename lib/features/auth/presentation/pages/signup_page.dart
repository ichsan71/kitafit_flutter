import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/core/common/widgets/loader.dart';
import 'package:todo_clean_bloc/core/theme/app_pallate.dart';
import 'package:todo_clean_bloc/core/utils/show_snackbar.dart';
import 'package:todo_clean_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:todo_clean_bloc/features/auth/presentation/widgets/auth_button.dart';
import 'package:todo_clean_bloc/features/auth/presentation/widgets/auth_field.dart';
import 'package:todo_clean_bloc/features/auth/presentation/pages/signin_page.dart';
import 'package:todo_clean_bloc/features/auth/presentation/widgets/auth_appbar.dart';

class SignupPage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const SignupPage());
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Signup berhasil
          debugPrint('Sign Up UI: Success state - userId: ${state.user.id}');
          showModernSnackBar(
            context,
            "Pendaftaran berhasil! Silakan masuk.",
            type: SnackBarType.success,
          );
          // Navigasi ke signin page
          Navigator.pushReplacement(context, SigninPage.route());
        } else if (state is AuthFailure) {
          // Signup gagal
          debugPrint('Sign Up UI: Failure state - ${state.errorMessage}');
          showModernSnackBar(
            context,
            state.errorMessage,
            type: SnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppPalette.background,
          appBar: AuthAppbar(),
          body: Stack(
            children: [
              // Form konten - selalu ditampilkan
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // KITA FIT Button/Header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppPalette.gradient1,
                              AppPalette.gradient2,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'KITA FIT',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppPalette.blackColor,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Input Nama
                      AuthField(
                        hintText: "Nama",
                        icon: const Icon(Icons.person_outline),
                        controller: nameController,
                      ),
                      const SizedBox(height: 16),

                      // Input Email
                      AuthField(
                        hintText: "Email",
                        icon: const Icon(Icons.email_outlined),
                        controller: emailController,
                      ),
                      const SizedBox(height: 16),

                      // Input Password
                      AuthField(
                        hintText: "Kata Sandi",
                        icon: const Icon(Icons.lock_outline),
                        controller: passwordController,
                        isPassword: true,
                      ),

                      const SizedBox(height: 16),

                      // Tombol Buat Akun
                      AuthButton(
                        text: "Buat Akun",
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            debugPrint(
                              'Signup data: email=${emailController.text}, name=${nameController.text}',
                            );
                            // Trigger signup event
                            context.read<AuthBloc>().add(
                              AuthSignup(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                name: nameController.text.trim(),
                              ),
                            );
                          } else {
                            debugPrint('Form is not valid');
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, SigninPage.route());
                        },
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Sudah punya akun? ",
                              style: Theme.of(context).textTheme.titleSmall,
                              children: [
                                TextSpan(
                                  text: "Masuk",
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        color: AppPalette.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Loader overlay - hanya tampil saat loading
              if (state is AuthLoading) const Loader(),
            ],
          ),
        );
      },
    );
  }
}
