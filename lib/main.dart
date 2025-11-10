// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// 🎯 FIREBASE IMPORTS
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // CRÍTICO: Generado por flutterfire configure

// 🎯 ARQUITECTURA / PROVIDERS
import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/splash/splash_screen.dart'; // NECESARIO para el chequeo

// 🎯 RUTAS CORREGIDAS
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/login/login_screen.dart';
import 'presentation/screens/dashboard/dashboard_screen.dart';
import 'presentation/screens/calendar/calendar_screen.dart';
import 'presentation/screens/tutoring/tutoring_screen.dart';
import 'presentation/screens/tasks/tasks_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';
import 'presentation/screens/signup/signup_screen.dart';

// 1. MODIFICACIÓN CRÍTICA: Hacer main asíncrono e inicializar Firebase
void main() async {
  // Asegura que Flutter esté listo para las llamadas nativas (CRÍTICO)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializa Firebase (CRÍTICO)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MentuApp()));
}

// 3. Convertir a ConsumerWidget para escuchar el estado de autenticación
class MentuApp extends ConsumerWidget {
  const MentuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ThemeData(
      textTheme: GoogleFonts.interTextTheme(),
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    );

    // Escucha el proveedor que verifica si hay un usuario logueado (Criterio 4)
    final authCheck = ref.watch(authCheckProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mentu - Organización Académica',
      theme: theme,

      // 4. Usa 'home' para decidir la pantalla inicial basada en el estado de Firebase
      home: authCheck.when(
        loading: () => const SplashScreen(), // Mientras verifica el token
        error: (err, stack) =>
            const LoginScreen(), // Error de inicialización (podría ser OnboardingScreen)
        data: (isAuthenticated) {
          if (isAuthenticated) {
            return const DashboardScreen(); // Logueado -> Dashboard
          } else {
            return const OnboardingScreen(); // No logueado -> Onboarding
          }
        },
      ),

      // 5. Rutas nombradas para la navegación interna
      routes: {
        // 🛑 CORRECCIÓN: Se eliminó la ruta raíz '/' ya que es redundante con 'home'.
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
