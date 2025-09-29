import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controladores de texto
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    // Color principal
    const primaryColor = Colors.blue;
    // Color de fondo claro que has estado usando
    const screenBackgroundColor = Color(0xFFD2EBE8);

    return Scaffold(
      backgroundColor: screenBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/mentu_logo3.png',
                      height: 50,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.school,
                          size: 40,
                          color: primaryColor),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Mentu',
                      style: GoogleFonts.lobster(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // 2. Campo de Email
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration(
                      'Correo electrónico', Icons.email_outlined, primaryColor),
                  style: const TextStyle(color: Colors.black87),
                ),

                const SizedBox(height: 20),

                // 3. Campo de Contraseña
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: _inputDecoration(
                      'Contraseña', Icons.lock_outline, primaryColor),
                  style: const TextStyle(color: Colors.black87),
                ),

                const SizedBox(height: 10),

                // 4. Botón 'Olvidé mi contraseña'
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Acción para recuperar contraseña
                    },
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // 5. Botón de Login (Estilo Onboarding)
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/dashboard'),
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

                const SizedBox(height: 20),

                // Enlace para ir a Crear Cuenta (similar al OutlinedButton, pero más simple)
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: const Text(
                    '¿Aún no tienes cuenta? Regístrate',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Función para definir el estilo de los campos de texto
  InputDecoration _inputDecoration(String label, IconData icon, Color color) {
    return InputDecoration(
      labelText: label,
      labelStyle:
          TextStyle(color: color.withOpacity(0.8), fontWeight: FontWeight.w500),
      prefixIcon: Icon(icon, color: color),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            BorderSide.none, // Oculta el borde por defecto si usas fillColor
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
    );
  }
}
