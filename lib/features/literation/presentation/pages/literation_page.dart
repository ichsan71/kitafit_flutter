import 'package:flutter/material.dart';
import 'package:todo_clean_bloc/core/theme/app_pallate.dart';

class LiterationPage extends StatelessWidget {
  const LiterationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mulai Literasi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppPalette.blackColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tingkatkan pengetahuan finansial Anda',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.menu_book,
                        size: 80,
                        color: AppPalette.primary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Konten literasi segera hadir',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
