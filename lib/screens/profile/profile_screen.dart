import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../main.dart'; // themeModeProvider

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final themeMode = ref.watch(themeModeProvider);

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
              child: const _ProfileIdentityCard(
                name: 'Sophia Clark',
                email: 'sophia.clark@email.com',
              ),
            ),
          ),

          // ======= INFORMACIÓN PERSONAL =======
          SliverToBoxAdapter(
            child: _Section(
              title: 'Información personal',
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const _KVRow(label: 'Nombre', value: 'Sophia Clark'),
                    const Divider(height: 1),
                    const _KVRow(
                        label: 'Correo', value: 'sophia.clark@email.com'),
                    const Divider(height: 1),
                    const _KVRow(label: 'Teléfono', value: '+503 7777 0000'),
                    const Divider(height: 1),
                    const _KVRow(
                        label: 'Programa', value: 'Ingeniería en Sistemas'),
                    const Divider(height: 1),
                    const _KVRow(
                        label: 'Universidad', value: 'Universidad Mentu'),
                    const Divider(height: 1),
                    const _KVRow(
                        label: 'Hobbies',
                        value: 'Lectura, música, senderismo'),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.edit_outlined),
                      title: const Text('Editar información'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _openEditProfile(context),
                    ),
                  ],
                ),
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
                      value: themeMode == ThemeMode.dark,
                      onChanged: (isDark) {
                        ref.read(themeModeProvider.notifier).state =
                            isDark ? ThemeMode.dark : ThemeMode.light;
                      },
                      title: const Text('Modo oscuro'),
                      subtitle: const Text(
                          'Ajusta la apariencia de la aplicación'),
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

          // ======= CUENTA / SEGURIDAD =======
          SliverToBoxAdapter(
            child: _Section(
              title: 'Cuenta',
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.lock_outline),
                      title: const Text('Seguridad'),
                      subtitle: const Text('Contraseña y dispositivos'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _openSecurity(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Cerrar sesión'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _confirmLogout(context),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ======= SOPORTE =======
          SliverToBoxAdapter(
            child: _Section(
              title: 'Soporte',
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.help_outline),
                      title: const Text('Centro de ayuda'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _openGenericDialog(
                        context,
                        title: 'Centro de ayuda',
                        message:
                            'Aquí encontrarás guías rápidas y respuestas a preguntas frecuentes.',
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: const Text('Términos y condiciones'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _openGenericDialog(
                        context,
                        title: 'Términos y condiciones',
                        message:
                            'Consulta los términos que rigen el uso de la app.',
                      ),
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

  /* ======= acciones ======= */

  void _mailto(BuildContext context, String email) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Contacto'),
        content: Text('Desde aquí podremos ponernos en contacto con $email.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar')),
        ],
      ),
    );
  }

  void _openSecurity(BuildContext context) {
    _openGenericDialog(
      context,
      title: 'Seguridad',
      message:
          'Desde aquí podremos cambiar tu contraseña, revisar inicios de sesión recientes y administrar los dispositivos conectados.',
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que quieres salir de tu cuenta?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          FilledButton.tonal(
            onPressed: () {
              Navigator.pop(context);
              context.go('/login'); // ✅ GoRouter
            },
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }

  void _chooseLanguage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => const _LanguageSheet(),
    );
  }

  void _openNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _NotificationsSheet(),
    );
  }

  void _openEditProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _EditProfileSheet(),
    );
  }

  void _openGenericDialog(BuildContext context,
      {required String title, required String message}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar')),
        ],
      ),
    );
  }

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
                onTap: () {}),
            ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Elegir de la galería'),
                onTap: () {}),
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
              colors: [cs.primary.withOpacity(.35), cs.secondary.withOpacity(.25)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
          ),
        ),
        CustomPaint(painter: _PatternPainter(color: cs.onPrimary.withOpacity(.06))),
        Align(
          alignment: const Alignment(0, 1.15),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: cs.surfaceContainerHighest,
                child: Text('SC',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              ),
              Positioned(
                right: -2, bottom: -2,
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

class _PatternPainter extends CustomPainter {
  final Color color;
  _PatternPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x + 40, size.height), p);
    }
  }
  @override
  bool shouldRepaint(covariant _PatternPainter old) => old.color != color;
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
                  Text(name, style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(email, style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KVRow extends StatelessWidget {
  final String label;
  final String value;
  const _KVRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return ListTile(
      title: Text(label, style: text.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
      subtitle: Text(value, style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
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
              Text(title, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
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

/* ============================
 * Sheets / Modales
 * ============================ */

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet();

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  final _nameCtrl = TextEditingController(text: 'Sophia Clark');
  final _emailCtrl = TextEditingController(text: 'sophia.clark@email.com');
  final _phoneCtrl = TextEditingController(text: '+503 7777 0000');
  final _programCtrl = TextEditingController(text: 'Ingeniería en Sistemas');
  final _universityCtrl = TextEditingController(text: 'Universidad Mentu');
  final _hobbiesCtrl = TextEditingController(text: 'Lectura, música, senderismo');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _programCtrl.dispose();
    _universityCtrl.dispose();
    _hobbiesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16, right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 8,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.badge_outlined),
              title: Text('Editar información'),
              subtitle: Text('Actualiza tus datos personales y académicos'),
            ),
            const SizedBox(height: 8),
            TextField(controller: _nameCtrl,       decoration: const InputDecoration(labelText: 'Nombre completo')),
            const SizedBox(height: 8),
            TextField(controller: _emailCtrl,      decoration: const InputDecoration(labelText: 'Correo'), keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 8),
            TextField(controller: _phoneCtrl,      decoration: const InputDecoration(labelText: 'Teléfono'), keyboardType: TextInputType.phone),
            const SizedBox(height: 8),
            TextField(controller: _programCtrl,    decoration: const InputDecoration(labelText: 'Programa/Especialidad')),
            const SizedBox(height: 8),
            TextField(controller: _universityCtrl, decoration: const InputDecoration(labelText: 'Universidad/Institución')),
            const SizedBox(height: 8),
            TextField(controller: _hobbiesCtrl,    decoration: const InputDecoration(labelText: 'Hobbies')),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar'))),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      // TODO: guardar cambios en provider/backend
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (_) => const AlertDialog(
                          title: Text('Información actualizada'),
                          content: Text('Desde aquí podremos mantener tus datos al día para personalizar tu experiencia.'),
                        ),
                      );
                    },
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsSheet extends StatefulWidget {
  const _NotificationsSheet();

  @override
  State<_NotificationsSheet> createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<_NotificationsSheet> {
  bool pushEnabled = true;
  bool emailEnabled = true;
  bool remindDayBefore = true;
  bool remind3HoursBefore = false;
  TimeOfDay summaryTime = const TimeOfDay(hour: 19, minute: 0);
  TimeOfDay quietFrom = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay quietTo = const TimeOfDay(hour: 7, minute: 0);

  Future<void> _pickTime(BuildContext context, TimeOfDay initial, ValueChanged<TimeOfDay> onPicked) async {
    final result = await showTimePicker(context: context, initialTime: initial);
    if (result != null) setState(() => onPicked(result));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16, right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 8,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.notifications_active_outlined),
              title: Text('Notificaciones'),
              subtitle: Text('Desde aquí podremos activar recordatorios y tu resumen diario.'),
            ),
            SwitchListTile(
              value: pushEnabled,
              onChanged: (v) => setState(() => pushEnabled = v),
              title: const Text('Notificaciones push'),
              subtitle: const Text('Alertas en tiempo real'),
              secondary: const Icon(Icons.phone_android_outlined),
            ),
            const Divider(height: 1),
            SwitchListTile(
              value: emailEnabled,
              onChanged: (v) => setState(() => emailEnabled = v),
              title: const Text('Notificaciones por correo'),
              subtitle: const Text('Resumen y recordatorios a tu email'),
              secondary: const Icon(Icons.alternate_email_outlined),
            ),
            const Divider(height: 1),
            SwitchListTile(
              value: remindDayBefore,
              onChanged: (v) => setState(() => remindDayBefore = v),
              title: const Text('Recordatorio 1 día antes'),
              secondary: const Icon(Icons.event_note_outlined),
            ),
            SwitchListTile(
              value: remind3HoursBefore,
              onChanged: (v) => setState(() => remind3HoursBefore = v),
              title: const Text('Recordatorio 3 horas antes'),
              secondary: const Icon(Icons.timer_outlined),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.av_timer_outlined),
              title: const Text('Resumen diario'),
              subtitle: Text('Hora: ${summaryTime.format(context)}'),
              trailing: OutlinedButton(
                onPressed: () => _pickTime(context, summaryTime, (t) => summaryTime = t),
                child: const Text('Cambiar'),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.notifications_off_outlined),
              title: const Text('Horas de silencio'),
              subtitle: Text('De ${quietFrom.format(context)} a ${quietTo.format(context)}'),
              trailing: Wrap(
                spacing: 8,
                children: [
                  OutlinedButton(
                    onPressed: () => _pickTime(context, quietFrom, (t) => quietFrom = t),
                    child: const Text('Desde'),
                  ),
                  OutlinedButton(
                    onPressed: () => _pickTime(context, quietTo, (t) => quietTo = t),
                    child: const Text('Hasta'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (_) => const AlertDialog(
                          title: Text('Preferencias guardadas'),
                          content: Text('Desde aquí podremos mantener tus notificaciones ajustadas a tu ritmo.'),
                        ),
                      );
                    },
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageSheet extends StatelessWidget {
  const _LanguageSheet();

  @override
  Widget build(BuildContext context) {
    final langs = const ['Español', 'English', 'Français', 'Deutsch', 'Português'];
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: langs
            .map(
              (l) => ListTile(
                leading: const Icon(Icons.language_outlined),
                title: Text(l),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Idioma actualizado'),
                      content: Text('Desde aquí podremos mostrarte la app en $l.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
                      ],
                    ),
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
