import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';

const Color primaryColor = Color(0xFF1E88E5);
const Color sectionHeaderColor = Color(0xFF616161);
const Color iconBackgroundColor = Color(0xFFE3F2FD);
const Color dividerColor = Color(0xFFEEEEEE);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool isLastItem = false,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primaryColor),
          ),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing:
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          onTap: onTap,
        ),
        if (!isLastItem)
          const Divider(
            height: 1,
            indent: 72,
            endIndent: 16,
            color: dividerColor,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchar al usuario actual logueado
    final user = ref.watch(authNotifierProvider);

    // Función para manejar el cierre de sesión
    void _handleLogout() async {
      // Llama al Notifier para cerrar la sesión de Firebase
      await ref.read(authNotifierProvider.notifier).logout();

      // Navegar de vuelta al Onboarding, limpiando el historial
      Navigator.pushNamedAndRemoveUntil(
          context, '/onboarding', (route) => false);
    }

    // Lógica para obtener las iniciales del avatar
    String getInitials(String name) {
      if (name.isEmpty) return '??';
      List<String> parts = name.split(' ');
      if (parts.length >= 2) {
        return parts[0][0] + parts[1][0];
      }
      return parts[0][0];
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- PROFILE HEADER ---
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: iconBackgroundColor,
                        child: Text(
                          // Muestra iniciales del usuario logueado
                          getInitials(user.name).toUpperCase(),
                          style: const TextStyle(
                              fontSize: 40, color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Muestra el nombre real del usuario de Firebase
                  Text(
                    user.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  // Muestra el email real del usuario de Firebase
                  Text(
                    user.email,
                    style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- ACCOUNT SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "ACCOUNT",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: sectionHeaderColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    child: Column(
                      children: [
                        _buildSettingItem(
                          icon: Icons.person_outline,
                          title: "Personal Information",
                          onTap: () {
                            print("Navegar a Información Personal");
                          },
                        ),
                        _buildSettingItem(
                          icon: Icons.settings_outlined,
                          title: "Preferences",
                          onTap: () {
                            print("Navegar a Preferencias");
                          },
                          isLastItem: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- LOGOUT BUTTON ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text("Cerrar Sesión",
                    style: TextStyle(color: Colors.red, fontSize: 16)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: Colors.red, width: 1.5),
                ),
                onPressed: _handleLogout,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      // --- B O T T O M N A V I G A T I O N ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 10,
        onTap: (i) {
          if (i == 0) Navigator.pushNamed(context, '/dashboard');
          if (i == 1) Navigator.pushNamed(context, '/tasks');
          if (i == 2) Navigator.pushNamed(context, '/tutoring');
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              activeIcon: Icon(Icons.list_alt),
              label: "Tasks"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined),
              activeIcon: Icon(Icons.people_alt),
              label: "Tutoring"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "Profile"),
        ],
      ),
    );
  }
}
