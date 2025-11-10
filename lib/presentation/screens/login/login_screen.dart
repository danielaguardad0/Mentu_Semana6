import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentu_app/presentation/providers/auth_provider.dart';

// Pantalla de inicio de sesión (Login)
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false; // Controla el estado de carga
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Inicio de sesión
  void _handleLogin() async {
    if (_isLoading) return;

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ingrese su correo y contraseña.'),
          backgroundColor: Colors.orange));
      return;
    }

    setState(() => _isLoading = true);

    // Llamada al provider de autenticación
    final error = await ref.read(authNotifierProvider.notifier).login(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

    if (mounted) setState(() => _isLoading = false);

    // Autenticación
    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Sesión iniciada correctamente.'),
        backgroundColor: Colors.green,
      ));

      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard', (Route<dynamic> route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.blue;
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
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration(
                      'Correo electrónico', Icons.email_outlined, primaryColor),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: _inputDecoration(
                      'Contraseña', Icons.lock_outline, primaryColor),
                  onFieldSubmitted: (_) => _isLoading ? null : _handleLogin(),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
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

  InputDecoration _inputDecoration(String label, IconData icon, Color color) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: color),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
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
