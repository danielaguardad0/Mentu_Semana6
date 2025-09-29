import 'package:flutter/material.dart';

// (Opcional) Mantengo la constante, pero ya no hardcodeamos blancos/negros.
const Color primaryColor = Color(0xFF1E88E5);

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final tasksToday = [
      {"title": "Complete Calculus Assignment", "subject": "Math 101", "due": "11:59 PM"},
      {"title": "Read Chapter 5", "subject": "History 202", "due": "08:00 PM"},
      {"title": "Lab Report", "subject": "Physics 301", "due": "05:30 PM"},
    ];

    return Scaffold(
      // AppBar toma colores del tema (surface / onSurface)
      appBar: AppBar(
        title: const Text("Tasks"),
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "October 2024",
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Icon(Icons.calendar_month, color: cs.primary),
            ],
          ),
          const SizedBox(height: 16),

          // Semana compacta
          SizedBox(
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final day = index + 21;
                final isToday = day == 24;
                return Column(
                  children: [
                    Text(
                      ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][index],
                      style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 6),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: isToday ? cs.primary : cs.surfaceVariant,
                      child: Text(
                        "$day",
                        style: TextStyle(
                          color: isToday ? cs.onPrimary : cs.onSurface,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),

          const SizedBox(height: 20),
          Text("Today", style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          // Lista de tareas
          ...tasksToday.map(
            (task) => Card(
              color: cs.surface,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
              child: ListTile(
                leading: Icon(Icons.assignment, color: cs.primary),
                title: Text(task["title"]!, style: theme.textTheme.bodyLarge),
                subtitle: Text(task["subject"]!, style: theme.textTheme.bodyMedium),
                trailing: Text(
                  task["due"]!,
                  style: theme.textTheme.bodyMedium?.copyWith(color: cs.error),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Botón Agregar
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              // Deja que el tema maneje el color; si quieres forzar:
              // backgroundColor: cs.primary,
              // foregroundColor: cs.onPrimary,
            ),
            icon: const Icon(Icons.add),
            label: const Text("Add New Task"),
          ),
        ],
      ),

      // Bottom Navigation sin blancos hardcodeados
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Tasks
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurfaceVariant,
        backgroundColor: cs.surface,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 0,
        onTap: (i) {
          if (i == 0) Navigator.pushNamed(context, '/dashboard');
          if (i == 1) return; // ya estás en Tasks
          if (i == 2) Navigator.pushNamed(context, '/tutoring');
          if (i == 3) Navigator.pushNamed(context, '/profile');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            activeIcon: Icon(Icons.people_alt),
            label: "Tutors",
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
