import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// (Opcional) Mantengo la constante, pero ya no hardcodeamos blancos/negros.
const Color primaryColor = Color(0xFF1E88E5);

class Task {
  final String id;
  final String title;
  final String subject;
  final String dueTime;
  final String dueDate;
  final Color color;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueTime,
    required this.dueDate,
    this.color = primaryColor,
    this.isCompleted = false,
  });
}

class TasksScreen extends StatefulWidget {
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

class _TasksScreenState extends State<TasksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Task> allTasks = [
    Task(
        id: '1',
        title: "Crear una historia emocional única",
        subject: "Literatura",
        dueTime: "11:30 AM",
        dueDate: "Today, Monday 17",
        color: Colors.pinkAccent),
    Task(
        id: '2',
        title: "Resumen de la Parábola de la Cueva",
        subject: "Filosofía",
        dueTime: "2:00 PM",
        dueDate: "Today, Monday 17",
        color: primaryColor),
    Task(
        id: '3',
        title: "Problemas de integración y derivadas",
        subject: "Cálculo",
        dueTime: "11:30 AM",
        dueDate: "Thursday 18",
        color: accentColor),
    Task(
        id: '4',
        title: "Investigación sobre Genética",
        subject: "Biología",
        dueTime: "4:00 PM",
        dueDate: "Friday 19",
        color: Colors.orange),
    Task(
        id: '5',
        title: "Ensayo sobre la Primera Guerra Mundial",
        subject: "Historia",
        dueTime: "2:00 PM",
        dueDate: "Completed",
        color: Colors.purple,
        isCompleted: true),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleTaskStatus(Task task) {
    setState(() {
      final index = allTasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        allTasks[index].isCompleted = !allTasks[index].isCompleted;
      }
    });
  }

  void _editTask(Task task) {
    print('Editing task: ${task.title}');
  }

  void _deleteTask(Task task) {
    setState(() {
      allTasks.removeWhere((t) => t.id == task.id);
    });
  }

  List<Task> _getFilteredTasks(int index) {
    if (index == 2) {
      return allTasks.where((task) => task.isCompleted).toList();
    } else {
      return allTasks.where((task) => !task.isCompleted).toList();
    }
  }

  Map<String, List<Task>> _groupTasksByDate(List<Task> tasks) {
    final Map<String, List<Task>> grouped = {};
    for (var task in tasks) {
      final key = task.isCompleted ? 'Completed' : task.dueDate;
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(task);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
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

// WIDGET Taskcard

class _TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleStatus;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TaskCard({
    required this.task,
    required this.onToggleStatus,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggleStatus,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color:
                  task.isCompleted ? accentColor : task.color.withOpacity(0.5),
              width: 1.5),
          boxShadow: [
            BoxShadow(
              color: task.color.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.subject,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        color: task.color,
                        fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.title,
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted ? Colors.grey : Colors.black87),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.black54),
                  onSelected: (String result) {
                    if (result == 'edit') {
                      onEdit();
                    } else if (result == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Editar'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Eliminar'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  task.dueTime,
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
