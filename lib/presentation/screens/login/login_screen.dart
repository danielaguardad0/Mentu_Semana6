// lib/presentation/screens/login/login_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentu_app/presentation/providers/auth_provider.dart'; // RUTA ABSOLUTA

// 1. Convertir la pantalla a ConsumerStatefulWidget
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

// 2. Usar ConsumerState
class _LoginScreenState extends ConsumerState<LoginScreen> {
  // 3. Bandera local de carga para deshabilitar el botón
  bool _isLoading = false;

  // Controladores de texto
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Función que inicia el flujo de autenticación con Firebase
  void _handleLogin() async {
    if (_isLoading) return;

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ingrese su correo y contraseña.'),
          backgroundColor: Colors.orange));
      return;
    }

    // 4. INICIA CARGA: Bloquea la interfaz
    setState(() => _isLoading = true);

    // Llamada al Notifier
    final error = await ref.read(authNotifierProvider.notifier).login(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

    // 5. DETIENE CARGA: Después de la respuesta de Firebase
    if (mounted) setState(() => _isLoading = false);

    // 6. Lógica de navegación o error
    if (error == null) {
      // ✅ CORRECCIÓN CRÍTICA: Navega directamente a /dashboard y limpia el stack.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Sesión iniciada correctamente.'),
        backgroundColor: Colors.green,
      ));

      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard', (Route<dynamic> route) => false);
    } else {
      // Muestra el error de Firebase
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // El método build
  @override
  Widget build(BuildContext context) {
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

                // --- Bloque Logo ---
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
                // ------------------

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
                  onFieldSubmitted: (_) => _isLoading ? null : _handleLogin(),
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

                // 5. Botón de Login (Con manejo de estado de carga)
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
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
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 3),
                        )
                      : const Text('Iniciar Sesión'),
                ),

                const SizedBox(height: 20),

                // Enlace para ir a Crear Cuenta
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
