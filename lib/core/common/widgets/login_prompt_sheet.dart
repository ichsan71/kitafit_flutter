import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_clean_bloc/core/navigation/router/app_router.dart';
import 'package:todo_clean_bloc/core/theme/app_pallate.dart';

/// Tampilkan bottom sheet login prompt dari mana saja.
/// [featureName] digunakan untuk pesan kontekstual, misal "profil" atau "fitur ini".
void showLoginPromptSheet(BuildContext context, {String featureName = 'fitur ini'}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _LoginPromptSheet(featureName: featureName),
  );
}

class _LoginPromptSheet extends StatelessWidget {
  final String featureName;

  const _LoginPromptSheet({required this.featureName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppPalette.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              size: 36,
              color: AppPalette.primary,
            ),
          ),
          const SizedBox(height: 20),

          // Title
          const Text(
            'Masuk untuk Melanjutkan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppPalette.blackColor,
            ),
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            'Anda perlu login untuk mengakses $featureName.\nDaftar gratis dan nikmati semua fitur KitaFit.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
          ),
          const SizedBox(height: 28),

          // Masuk button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go(AppRouter.signin);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Masuk',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Daftar button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go(AppRouter.signup);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppPalette.primary,
                side: const BorderSide(color: AppPalette.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Buat Akun Baru',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Dismiss
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Nanti saja',
              style: TextStyle(fontSize: 14, color: Colors.black45),
            ),
          ),
        ],
      ),
    );
  }
}
