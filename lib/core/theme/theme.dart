import 'package:flutter/material.dart';
import 'package:todo_clean_bloc/core/theme/app_pallate.dart';

class AppTheme {
  static OutlineInputBorder _border([Color color = AppPalette.borderColor]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color),
    );
  }

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPalette.background,
    inputDecorationTheme: InputDecorationTheme(
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppPalette.primary),
      errorBorder: _border(AppPalette.onError),
      focusedErrorBorder: _border(AppPalette.onError),
      hintStyle: const TextStyle(color: AppPalette.greyColor),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[200],
      elevation: 0,
      iconTheme: const IconThemeData(color: AppPalette.blackColor),
      titleTextStyle: const TextStyle(
        color: AppPalette.blackColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      centerTitle: true,
    ),
  );
}
