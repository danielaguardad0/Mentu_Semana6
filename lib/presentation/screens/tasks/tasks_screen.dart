import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentu_app/presentation/providers/tasks_provider.dart';
import 'package:mentu_app/domain/entities/task_entity.dart';
import 'package:mentu_app/presentation/screens/tasks/task_form_screen.dart';
import 'package:intl/intl.dart'; // ✅ Importar para formateo de fechas

const Color primaryColor = Colors.blue;
const Color accentColor = Color(0xFF4CAF50);
const Color backgroundColor = Color(0xFFD2EBE8);
const Color cardBackgroundColor = Colors.white;

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  // 💡 Función auxiliar para mostrar errores
  void _showErrorSnackbar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              "Error: ${error.contains('Exception:') ? error.split(':').last : error}"),
          backgroundColor: Colors.red),
    );
  }

  // ✅ CORRECCIÓN: Manejar errores asíncronos
  void _toggleTaskStatus(TaskEntity task) async {
    try {
      await ref.read(tasksNotifierProvider.notifier).toggleStatus(task.id);
    } catch (e) {
      _showErrorSnackbar(e.toString());
    }
  }

  void _editTask(TaskEntity task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(taskToEdit: task),
      ),
    );
  }

  // ✅ CORRECCIÓN: Manejar errores asíncronos
  void _deleteTask(TaskEntity task) async {
    try {
      await ref.read(tasksNotifierProvider.notifier).deleteTask(task.id);
    } catch (e) {
      _showErrorSnackbar(e.toString());
    }
  }

  void _handleNewTask() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TaskFormScreen(),
      ),
    );
  }

  List<TaskEntity> _getFilteredTasks(int index, List<TaskEntity> allTasks) {
    if (index == 2) {
      return allTasks.where((task) => task.isCompleted).toList();
    } else {
      return allTasks.where((task) => !task.isCompleted).toList();
    }
  }

  // ✅ CORRECCIÓN CRÍTICA: Agrupar por fecha formateada (String)
  Map<String, List<TaskEntity>> _groupTasksByDate(List<TaskEntity> tasks) {
    final Map<String, List<TaskEntity>> grouped = {};
    // Usar el formateador de fechas
    final DateFormat formatter = DateFormat('EEEE, MMMM d');

    for (var task in tasks) {
      // Formatear el DateTime a String para usarlo como clave
      final key =
          task.isCompleted ? 'Completed' : formatter.format(task.dueDate);

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(task);
    }
    return grouped;
  }

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
            indicatorColor: Colors.transparent,
            indicatorWeight: 0,
            dividerColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            splashFactory: NoSplash.splashFactory,
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

  @override
  Widget build(BuildContext context) {
    // ✅ CORRECCIÓN: Observar el FutureProvider para manejar el estado asíncrono
    final tasksAsync = ref.watch(tasksFutureProvider);

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            // ✅ CORRECCIÓN: Usar .when() para manejar Loading/Error/Data
            child: tasksAsync.when(
                loading: () => const Center(
                    child: CircularProgressIndicator(color: primaryColor)),
                error: (err, stack) => Center(
                    child: Text('Error al cargar tareas: $err',
                        style: TextStyle(color: Colors.red))),
                data: (allTasks) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTaskList(_getFilteredTasks(0, allTasks)), // To Do
                      _buildTaskList(
                          _getFilteredTasks(1, allTasks)), // In Progress
                      _buildTaskList(
                          _getFilteredTasks(2, allTasks)), // Completed
                    ],
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleNewTask,
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

  Widget _buildTaskList(List<TaskEntity> tasks) {
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
}

class _TaskCard extends StatelessWidget {
  final TaskEntity task;
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
                // ✅ CORRECCIÓN: Usar el formato de hora correcto
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
