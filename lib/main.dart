import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/onboarding/onboarding_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/calendar/calendar_screen.dart';
import 'screens/tutoring/tutoring_screen.dart';
import 'screens/tasks/tasks_screen.dart';
import 'screens/profile/profile_screen.dart';

// === Provider único para el ThemeMode ===
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

void main() {
  runApp(const ProviderScope(child: MentuApp()));
}

class MentuApp extends ConsumerWidget {
  const MentuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    // Paleta semilla (se adapta a light/dark)
    const seed = Colors.blue;

    // ------ Tema Claro ------
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    );

    final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: lightColorScheme,
      textTheme: GoogleFonts.interTextTheme(),
      useMaterial3: true,

      // Fondo general de pantallas
      scaffoldBackgroundColor: lightColorScheme.background,

      // AppBar se pinta con surface (no blanco duro)
      appBarTheme: AppBarTheme(
        backgroundColor: lightColorScheme.surface,
        foregroundColor: lightColorScheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),

      // BottomNavigationBar (Material 2)
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightColorScheme.surface,
        selectedItemColor: lightColorScheme.primary,
        unselectedItemColor: lightColorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // NavigationBar (Material 3) por si lo usas
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: lightColorScheme.surface,
        indicatorColor: lightColorScheme.secondaryContainer,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: MaterialStateProperty.all(
          TextStyle(color: lightColorScheme.onSurfaceVariant),
        ),
      ),

      // 👇 Usa BottomAppBarThemeData (no BottomAppBarTheme)
      bottomAppBarTheme: const BottomAppBarThemeData(
        color: Colors.transparent, // o lightColorScheme.surface si prefieres sólido
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
    );

    // ------ Tema Oscuro ------
    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    );

    final ThemeData darkTheme = ThemeData(
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

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkColorScheme.surface,
        selectedItemColor: darkColorScheme.primary,
        unselectedItemColor: darkColorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkColorScheme.surface,
        indicatorColor: darkColorScheme.secondaryContainer,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: MaterialStateProperty.all(
          TextStyle(color: darkColorScheme.onSurfaceVariant),
        ),
      ),

      // 👇 Usa BottomAppBarThemeData (no BottomAppBarTheme)
      bottomAppBarTheme: const BottomAppBarThemeData(
        color: Colors.transparent, // o darkColorScheme.surface si prefieres sólido
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mentu - Organización Académica',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/tutoring': (context) => TutoringScreen(),
        '/tasks': (context) => const TasksScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
