import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Colors.blue;
const Color accentColor = Color(0xFF4CAF50);
const Color backgroundColor = Color(0xFFD2EBE8);
const Color cardBackgroundColor = Colors.white;

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
  State<TasksScreen> createState() => _TasksScreenState();
}

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
      backgroundColor: cardBackgroundColor,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTaskList(_getFilteredTasks(0)), // To Do
                _buildTaskList(_getFilteredTasks(1)), // In Progress
                _buildTaskList(_getFilteredTasks(2)), // Completed
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add_rounded, size: 28),
        label: Text("New Task",
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: _buildBottomNavigationBar(context, 1),
    );
  }

  // WIDGETS DE CONSTRUCCIÓN

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: cardBackgroundColor,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black54),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text("Tasks",
          style: GoogleFonts.lobster(fontSize: 28, color: Colors.black87)),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: backgroundColor.withOpacity(0.5),
        elevation: 0,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          height: 48,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.transparent),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: primaryColor,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.transparent, // elimina línea
            indicatorWeight: 0, // asegura que no se dibuje
            dividerColor: Colors.transparent, // 🔥 elimina divisor por defecto
            overlayColor: WidgetStateProperty.all(
                Colors.transparent), // 🔥 elimina resaltado
            splashFactory: NoSplash.splashFactory, // 🔥 sin efecto splash
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black54,
            labelStyle:
                GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: const [
              Tab(text: "To Do"),
              Tab(text: "In Progress"),
              Tab(text: "Completed"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    if (tasks.isEmpty) {
      final String emptyMessage = _tabController.index == 2
          ? '¡Todas tus tareas están completas!'
          : 'No tienes tareas pendientes.';
      return Center(
        child: Text(
          emptyMessage,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 18, color: Colors.grey.shade500),
        ),
      );
    }

    final groupedTasks = _groupTasksByDate(tasks);
    final sortedDates = groupedTasks.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100, top: 10),
      itemCount: sortedDates.length,
      itemBuilder: (context, dateIndex) {
        final date = sortedDates[dateIndex];
        final tasksForDate = groupedTasks[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 12, bottom: 8),
              child: Text(
                date,
                style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: primaryColor.withOpacity(0.8)),
              ),
            ),
            ...tasksForDate.map((task) => _TaskCard(
                  task: task,
                  onToggleStatus: () => _toggleTaskStatus(task),
                  onEdit: () => _editTask(task),
                  onDelete: () => _deleteTask(task),
                )),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, int currentIndex) {
    return Material(
      elevation: 10,
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 0,
        onTap: (int i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/dashboard');
          if (i == 1) Navigator.pushReplacementNamed(context, '/tasks');
          if (i == 2) Navigator.pushReplacementNamed(context, '/tutoring');
          if (i == 3) Navigator.pushReplacementNamed(context, '/profile');
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
