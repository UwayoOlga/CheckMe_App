import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

enum AppTheme { light, dark, system }

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme.system);

  void toggleTheme(AppTheme theme) {
    state = theme;
  }

  ThemeData get themeData {
    switch (state) {
      case AppTheme.light:
        return ThemeData.light();
      case AppTheme.dark:
        return ThemeData.dark();
      case AppTheme.system:
      default:
        return ThemeData.fallback();
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppTheme>((ref) {
  return ThemeNotifier();
});
