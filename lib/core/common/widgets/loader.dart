import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_clean_bloc/core/theme/app_pallate.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppPalette.blackColor.withValues(alpha: 0.05), // Lebih transparan
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1), // Blur lebih ringan
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppPalette.background.withValues(
                alpha: 0.95,
              ), // Semi-transparan
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppPalette.blackColor.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/lottie/kitafit_icon.json',
                  width: 100,
                  height: 100,
                  repeat: true,
                ),
                const SizedBox(height: 12),
                Text(
                  'Memproses...',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppPalette.blackColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
