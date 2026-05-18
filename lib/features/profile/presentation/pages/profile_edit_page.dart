import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_clean_bloc/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:todo_clean_bloc/core/common/entities/user.dart';
import 'package:todo_clean_bloc/core/theme/app_pallate.dart';
import 'package:todo_clean_bloc/core/utils/show_snackbar.dart';
import 'package:todo_clean_bloc/features/auth/presentation/bloc/auth_bloc.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  File? _pickedAvatar;
  bool _showPasswordSection = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    final user = _currentUser();
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  User? _currentUser() {
    final appState = context.read<AppUserCubit>().state;
    return appState is AppUserLoggedIn ? appState.user : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 512,
    );
    if (picked != null) {
      setState(() => _pickedAvatar = File(picked.path));
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _showPasswordSection && _passwordController.text.isNotEmpty
        ? _passwordController.text
        : null;
    final passwordConfirm =
        _showPasswordSection && _passwordController.text.isNotEmpty
        ? _passwordConfirmController.text
        : null;

    context.read<AuthBloc>().add(
      AuthUpdateProfile(
        name: name.isNotEmpty ? name : null,
        phone: phone.isNotEmpty ? phone : null,
        password: password,
        passwordConfirmation: passwordConfirm,
        avatarPath: _pickedAvatar?.path,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          showModernSnackBar(
            context,
            'Profil berhasil diperbarui',
            type: SnackBarType.success,
          );
          Navigator.of(context).pop();
        } else if (state is AuthFailure) {
          showModernSnackBar(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final user = _currentUser();

        return Scaffold(
          backgroundColor: AppPalette.background,
          appBar: AppBar(
            backgroundColor: AppPalette.background,
            elevation: 0,
            title: const Text(
              'Edit Profil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppPalette.blackColor,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppPalette.blackColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton(
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Simpan',
                          style: TextStyle(
                            color: AppPalette.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // ── Avatar ──────────────────────────────────────────
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        _AvatarWidget(
                          avatarFile: _pickedAvatar,
                          avatarUrl: user?.avatar,
                        ),
                        GestureDetector(
                          onTap: _pickAvatar,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppPalette.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: _pickAvatar,
                      child: const Text('Ganti Foto Profil'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Nama ────────────────────────────────────────────
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (v) => (v?.trim().isEmpty ?? true)
                        ? 'Nama tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // ── Telepon ─────────────────────────────────────────
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Nomor Telepon',
                      prefixIcon: const Icon(Icons.phone_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Ubah Password ───────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      secondary: const Icon(Icons.lock_outline),
                      title: const Text(
                        'Ubah Password',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      value: _showPasswordSection,
                      activeColor: AppPalette.primary,
                      onChanged: (v) {
                        setState(() {
                          _showPasswordSection = v;
                          if (!v) {
                            _passwordController.clear();
                            _passwordConfirmController.clear();
                          }
                        });
                      },
                    ),
                  ),

                  if (_showPasswordSection) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Password Baru',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      validator: _showPasswordSection
                          ? (v) => (v?.length ?? 0) < 8
                                ? 'Minimal 8 karakter'
                                : null
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordConfirmController,
                      obscureText: _obscureConfirm,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'Konfirmasi Password',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                        ),
                      ),
                      validator: _showPasswordSection
                          ? (v) => v != _passwordController.text
                                ? 'Password tidak cocok'
                                : null
                          : null,
                    ),
                  ],

                  const SizedBox(height: 32),

                  // ── Submit ──────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: isLoading ? null : _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppPalette.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Simpan Perubahan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Avatar display widget ──────────────────────────────────────────────────

class _AvatarWidget extends StatelessWidget {
  final File? avatarFile;
  final String? avatarUrl;

  const _AvatarWidget({this.avatarFile, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    ImageProvider? provider;
    if (avatarFile != null) {
      provider = FileImage(avatarFile!);
    } else if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      provider = NetworkImage(avatarUrl!);
    }

    return CircleAvatar(
      radius: 52,
      backgroundColor: AppPalette.primary.withValues(alpha: 0.15),
      backgroundImage: provider,
      child: provider == null
          ? const Icon(Icons.person, size: 52, color: AppPalette.primary)
          : null,
    );
  }
}
