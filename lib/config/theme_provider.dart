// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// Clase que define los temas claro y oscuro
class AppTheme {
  final bool isDarkMode;

  AppTheme({this.isDarkMode = false});

  ThemeData getTheme() {
    final seed = Colors.blue;

    if (isDarkMode) {
      // ------ Tema Oscuro ------
      final darkColorScheme = ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
      );

      return ThemeData(
        brightness: Brightness.dark,
        colorScheme: darkColorScheme,
        textTheme: GoogleFonts.interTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: darkColorScheme.background,
        appBarTheme: AppBarTheme(
          backgroundColor: darkColorScheme.surface,
          foregroundColor: darkColorScheme.onSurface,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
        ),
      );
    } else {
      // ------ Tema Claro ------
      final lightColorScheme = ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.light,
      );

      return ThemeData(
        brightness: Brightness.light,
        colorScheme: lightColorScheme,
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
        scaffoldBackgroundColor: lightColorScheme.background,
        appBarTheme: AppBarTheme(
          backgroundColor: lightColorScheme.surface,
          foregroundColor: lightColorScheme.onSurface,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
        ),
      );
    }
  }

  AppTheme copyWith({bool? isDarkMode}) {
    return AppTheme(isDarkMode: isDarkMode ?? this.isDarkMode);
  }
}

/// StateNotifier que administra el estado del tema
class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme(isDarkMode: false));

  void toggleTheme() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }
}

/// Provider global para acceder al ThemeNotifier
final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, AppTheme>((ref) {
  return ThemeNotifier();
});
