import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.blue;

    return Scaffold(
      backgroundColor: const Color(0xFFD2EBE8), // Fondo Azul muy claro
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),

                // 🔹 Logo
                Hero(
                  tag: 'mentu_logo',
                  child: Image.asset(
                    'assets/images/mentu_logo3.png',
                    height: 260,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.school,
                      size: 120,
                      color: primaryColor,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // 🔹 Eslógan M O V I D O: Ahora justo después del logo
                Text(
                  "Tu camino hacia el éxito académico 💡",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lobster(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 50), // Espacio entre eslogan y botones

                // 🔹 Botón Login
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shadowColor: primaryColor.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: GoogleFonts.lobster(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Iniciar Sesión'),
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 Botón Sign Up
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 55),
                        foregroundColor: primaryColor,
                        side: const BorderSide(color: primaryColor, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: GoogleFonts.lobster(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Crear Cuenta'),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
