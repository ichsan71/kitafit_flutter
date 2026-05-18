import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_clean_bloc/core/common/widgets/loader.dart';
import 'package:todo_clean_bloc/core/navigation/router/app_router.dart';
import 'package:todo_clean_bloc/core/theme/app_pallate.dart';
import 'package:todo_clean_bloc/core/utils/show_snackbar.dart';
import 'package:todo_clean_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:todo_clean_bloc/features/auth/presentation/widgets/auth_button.dart';
import 'package:todo_clean_bloc/features/auth/presentation/widgets/auth_field.dart';

class SigninPage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const SigninPage());
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => SigninPageState();
}

class SigninPageState extends State<SigninPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignIn() {
    if (formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthSignin(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  void _onGoogleSignIn() {
    context.read<AuthBloc>().add(AuthSignInWithGoogle());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          showModernSnackBar(context, state.errorMessage);
        } else if (state is AuthSuccess) {
          showModernSnackBar(
            context,
            'Login berhasil',
            type: SnackBarType.success,
          );
          context.go(AppRouter.dashboard);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppPalette.background,
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        Image.asset(
                          'assets/images/icon_kitafit.png',
                          height: 200,
                          width: 300,
                        ),
                        const SizedBox(height: 8),

                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppPalette.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppPalette.blackColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              AuthField(
                                hintText: 'Email',
                                icon: const Icon(Icons.person_outline),
                                controller: _emailController,
                              ),
                              const SizedBox(height: 16),

                              const Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              AuthField(
                                hintText: 'Password',
                                icon: const Icon(Icons.lock_outline),
                                controller: _passwordController,
                                isPassword: true,
                              ),
                              const SizedBox(height: 16),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Checkbox(
                                          value: _rememberMe,
                                          onChanged: (value) {
                                            setState(() {
                                              _rememberMe = value ?? false;
                                            });
                                          },
                                          activeColor: const Color(0xFF5DDCD3),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Ingat saya',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // TODO: implement forgot password
                                    },
                                    child: const Text(
                                      'Lupa kata sandi?',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              AuthButton(
                                text: 'Masuk',
                                onPressed: _onSignIn,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        GestureDetector(
                          onTap: () => context.go(AppRouter.signup),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Tidak mempunyai akun? ',
                                style: Theme.of(context).textTheme.titleSmall,
                                children: [
                                  TextSpan(
                                    text: 'Daftar',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
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
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: Container(height: 1, color: Colors.grey[400]),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Atau masuk dengan',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(height: 1, color: Colors.grey[400]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        _SocialLoginButton(
                          label: 'Masuk dengan Google',
                          iconUrl: 'https://www.google.com/favicon.ico',
                          onTap: _onGoogleSignIn,
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),

              if (state is AuthLoading) const Loader(),
            ],
          ),
        );
      },
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final String label;
  final String iconUrl;
  final VoidCallback onTap;

  const _SocialLoginButton({
    required this.label,
    required this.iconUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(iconUrl, width: 24, height: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
