import 'package:flutter/material.dart';
import 'package:todo_clean_bloc/core/theme/app_pallate.dart';

void showModernSnackBar(
  BuildContext context,
  String message, {
  SnackBarType type = SnackBarType.info,
}) {
  // Cek apakah widget masih mounted
  if (!context.mounted) return;

  final snackBar = SnackBar(
    content: Row(
      children: [
        // Icon berdasarkan tipe
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppPalette.background.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(_getIcon(type), color: AppPalette.background, size: 24),
        ),
        const SizedBox(width: 12),
        // Message
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppPalette.background,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: _getColor(type),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    duration: const Duration(seconds: 3),
    elevation: 6,
  );

  // Gunakan try-catch untuk menangani error
  try {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  } catch (e) {
    // Jika error, coba dengan SchedulerBinding
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    });
  }
}

// Enum untuk tipe SnackBar
enum SnackBarType { success, error, warning, info }

// Helper function untuk icon
IconData _getIcon(SnackBarType type) {
  switch (type) {
    case SnackBarType.success:
      return Icons.check_circle;
    case SnackBarType.error:
      return Icons.error;
    case SnackBarType.warning:
      return Icons.warning;
    case SnackBarType.info:
      return Icons.info;
  }
}

// Helper function untuk warna
Color _getColor(SnackBarType type) {
  switch (type) {
    case SnackBarType.success:
      return AppPalette.onSuccess; // Green
    case SnackBarType.error:
      return AppPalette.onError; // Red
    case SnackBarType.warning:
      return AppPalette.onWarning; // Orange
    case SnackBarType.info:
      return AppPalette.onInfo; // Blue
  }
}
