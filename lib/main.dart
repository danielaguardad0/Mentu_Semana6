
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 


import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/splash/splash_screen.dart'; 


import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/login/login_screen.dart';
import 'presentation/screens/dashboard/dashboard_screen.dart';
import 'presentation/screens/calendar/calendar_screen.dart';
import 'presentation/screens/tutoring/tutoring_screen.dart';
import 'presentation/screens/tasks/tasks_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';
import 'presentation/screens/signup/signup_screen.dart';


void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MentuApp()));
}


class MentuApp extends ConsumerWidget {
  const MentuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ThemeData(
      textTheme: GoogleFonts.interTextTheme(),
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    );

    
    final authCheck = ref.watch(authCheckProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mentu - Organización Académica',
      theme: theme,

      
      home: authCheck.when(
        loading: () => const SplashScreen(), 
        error: (err, stack) =>
            const LoginScreen(), 
        data: (isAuthenticated) {
          if (isAuthenticated) {
            return const DashboardScreen(); 
          } else {
            return const OnboardingScreen(); 
          }
        },
      ),

      
      routes: {
        
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/tutoring': (context) => const TutoringScreen(),
        '/tasks': (context) => const TasksScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/signup': (context) => const SignUpScreen(),
      },
    );
  }
}
