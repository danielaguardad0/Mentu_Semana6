import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart'; // 👈 importa el provider que definimos en main.dart

// Definimos los colores para mantener la consistencia del diseño.
const Color primaryColor = Color(0xFF1E88E5); // Azul principal
const Color sectionHeaderColor =
    Color(0xFF616161); // Gris oscuro para los títulos de sección
const Color iconBackgroundColor =
    Color(0xFFE3F2FD); // Azul muy claro para el fondo de los íconos
const Color dividerColor =
    Color(0xFFEEEEEE); // Gris muy claro para los divisores

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  // Widget auxiliar para construir un ítem de configuración
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

  // Widget auxiliar para construir un bloque de soporte con cards
  Widget _buildSupportSectionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool isFirstItem = false,
    bool isLastItem = false,
  }) {
    BorderRadiusGeometry borderRadius = BorderRadius.zero;
    if (isFirstItem && isLastItem) {
      borderRadius = BorderRadius.circular(12);
    } else if (isFirstItem) {
      borderRadius = const BorderRadius.vertical(top: Radius.circular(12));
    } else if (isLastItem) {
      borderRadius = const BorderRadius.vertical(bottom: Radius.circular(12));
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Material(
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: onTap,
          child: Column(
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
                trailing: const Icon(Icons.arrow_forward_ios,
                    size: 18, color: Colors.grey),
              ),
              if (!isLastItem)
                const Divider(
                  height: 1,
                  indent: 72,
                  endIndent: 16,
                  color: dividerColor,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- PROFILE HEADER ---
            Container(
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundColor: iconBackgroundColor,
                        child: Text(
                          "JC",
                          style: TextStyle(fontSize: 40, color: primaryColor),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: primaryColor,
                          child: IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.white, size: 20),
                            onPressed: () {
                              print("Editar perfil");
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Sophia Clark",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "sophia.clark@email.com",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
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
                          icon: Icons.notifications_none,
                          title: "Notifications",
                          onTap: () {
                            print("Navegar a Notificaciones");
                          },
                        ),
                        // 🔥 Interruptor para modo oscuro
                        SwitchListTile(
                          secondary: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: iconBackgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.dark_mode,
                                color: primaryColor),
                          ),
                          title: const Text("Dark Mode",
                              style: TextStyle(fontSize: 16)),
                          value: themeMode == ThemeMode.dark,
                          onChanged: (isDark) {
                            ref.read(themeModeProvider.notifier).state =
                                isDark ? ThemeMode.dark : ThemeMode.light;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- SUPPORT SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "SUPPORT",
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
                        _buildSupportSectionItem(
                          context,
                          icon: Icons.help_outline,
                          title: "Help Center",
                          onTap: () {
                            print("Navegar a Centro de Ayuda");
                          },
                          isFirstItem: true,
                        ),
                        _buildSupportSectionItem(
                          context,
                          icon: Icons.mail_outline,
                          title: "Contact Us",
                          onTap: () {
                            print("Navegar a Contacto");
                          },
                        ),
                        _buildSupportSectionItem(
                          context,
                          icon: Icons.description_outlined,
                          title: "Terms of Service",
                          onTap: () {
                            print("Navegar a Términos de Servicio");
                          },
                        ),
                        _buildSupportSectionItem(
                          context,
                          icon: Icons.shield_outlined,
                          title: "Privacy Policy",
                          onTap: () {
                            print("Navegar a Política de Privacidad");
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
          ],
        ),
      ),

      // --- BOTTOM NAVIGATION ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3, // 'Profile' es la cuarta sección
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Theme.of(context).colorScheme.surface, // ✅ corregido
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 10,
        onTap: (i) {
          if (i == 0) Navigator.pushNamed(context, '/dashboard');
          if (i == 1) Navigator.pushNamed(context, '/tasks');
          if (i == 2) Navigator.pushNamed(context, '/tutoring');
          // currentIndex 3 es Profile, no necesita navegación
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            activeIcon: Icon(Icons.people_alt),
            label: "Tutoring",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
