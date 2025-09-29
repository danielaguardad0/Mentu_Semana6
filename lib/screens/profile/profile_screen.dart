import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ======= PORTADA + AVATAR =======
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
            backgroundColor: cs.surface,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsetsDirectional.only(start: 16, bottom: 12),
              title: Row(
                children: [
                  const CircleAvatar(radius: 10),
                  const SizedBox(width: 8),
                  Text('Perfil',
                      style: text.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
              background: _HeaderCover(
                onEditPhoto: () => _showImageSourceSheet(context),
              ),
            ),
          ),

          // ======= IDENTIDAD =======
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: _ProfileIdentityCard(
                name: 'Sophia Clark',
                email: 'sophia.clark@email.com',
              ),
            ),
          ),

          // ======= PREFERENCIAS =======
          SliverToBoxAdapter(
            child: _Section(
              title: 'Preferencias',
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: appTheme.isDarkMode,
                      onChanged: (_) {
                        ref
                            .read(themeNotifierProvider.notifier)
                            .toggleTheme();
                      },
                      title: const Text('Modo oscuro'),
                      subtitle:
                          const Text('Ajusta la apariencia de la aplicación'),
                      secondary: const Icon(Icons.dark_mode_outlined),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.notifications_active_outlined),
                      title: const Text('Notificaciones'),
                      subtitle: const Text(
                          'Recordatorios, resumen diario y horas de silencio'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _openNotifications(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.language_outlined),
                      title: const Text('Idioma'),
                      subtitle: const Text('Español'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _chooseLanguage(context),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),

      // ======= NAV INFERIOR =======
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurfaceVariant,
        backgroundColor: cs.surface,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 0,
        onTap: (i) {
          if (i == 0) context.go('/dashboard');
          if (i == 1) context.go('/tasks');
          if (i == 2) context.go('/tutoring');
          if (i == 3) context.go('/profile');
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              activeIcon: Icon(Icons.list_alt),
              label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined),
              activeIcon: Icon(Icons.people_alt),
              label: 'Tutoring'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile'),
        ],
      ),
    );
  }

  // ===== Métodos auxiliares =====
  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Tomar foto'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Elegir de la galería'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _openNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text('Notificaciones'),
        content: Text(
            'Aquí podrás configurar recordatorios, resúmenes diarios y horas de silencio.'),
      ),
    );
  }

  void _chooseLanguage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            ListTile(
              leading: Icon(Icons.language_outlined),
              title: Text('Español'),
            ),
            ListTile(
              leading: Icon(Icons.language_outlined),
              title: Text('English'),
            ),
          ],
        ),
      ),
    );
  }
}

/* ============================
 * Partes visuales
 * ============================ */

class _HeaderCover extends StatelessWidget {
  final VoidCallback onEditPhoto;
  const _HeaderCover({required this.onEditPhoto});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                cs.primary.withOpacity(.35),
                cs.secondary.withOpacity(.25)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0, 1.15),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: cs.surface,
                child: Text(
                  'SC',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              Positioned(
                right: -2,
                bottom: -2,
                child: Material(
                  shape: const CircleBorder(),
                  color: cs.primary,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onEditPhoto,
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.edit, size: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileIdentityCard extends StatelessWidget {
  final String name;
  final String email;
  const _ProfileIdentityCard({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: text.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(email,
                      style: text.bodyMedium
                          ?.copyWith(color: cs.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              Text(title,
                  style:
                      text.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const Spacer(),
              Icon(Icons.more_horiz, color: cs.onSurfaceVariant),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
