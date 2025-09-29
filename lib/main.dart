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

void main() {
  runApp(const ProviderScope(child: MentuApp()));
}

class MentuApp extends StatelessWidget {
  const MentuApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      textTheme: GoogleFonts.interTextTheme(),
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mentu - Organización Académica',
      theme: theme,
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/tutoring': (context) => const TutoringScreen(),
        '/tasks': (context) => const TasksScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
