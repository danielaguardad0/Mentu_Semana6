import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../providers/tasks_provider.dart';
import '../../../domain/entities/task_entity.dart';
import '../../providers/auth_provider.dart';

const Color primaryColor = Color(0xFF4C7FFF);
const Color accentColor = Color(0xFF4CAF50);
const Color lightAccentColor = Color(0xFFC7FFCA);
const Color appBackgroundColor = Color(0xFFF0F4F8);
const Color cardBackgroundColor = Colors.white;

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  Map<DateTime, List<TaskEntity>> _getEventsMap(List<TaskEntity> tasks) {
    final Map<DateTime, List<TaskEntity>> eventMap = {};
    for (var task in tasks.where((t) => !t.isCompleted)) {
      final normalizedDate =
          DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);

      eventMap.putIfAbsent(normalizedDate, () => []);
      eventMap[normalizedDate]!.add(task);
    }
    return eventMap;
  }

  List<TaskEntity> _getUpcomingTasks(List<TaskEntity> tasks) {
    final pendingTasks = tasks.where((t) => !t.isCompleted).toList();
    return pendingTasks.take(4).toList();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<TaskEntity>> tasksAsync =
        ref.watch(tasksFutureProvider);
    final user = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: [
            _buildHeader(context, user.name),
            const SizedBox(height: 30),

            // SECCIÓN CALENDARIO
            _buildSectionTitle('Próximas Fechas'),
            const SizedBox(height: 15),

            tasksAsync.when(
                loading: () => const Center(
                    child: CircularProgressIndicator(color: primaryColor)),
                error: (err, stack) =>
                    Center(child: Text('Error al cargar calendario: $err')),
                data: (tasks) {
                  final events = _getEventsMap(tasks);

                  return _CalendarCard(
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay,
                    events: events,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                  );
                }),

            const SizedBox(height: 30),

            _buildSectionTitle('Tareas Próximas'),
            const SizedBox(height: 15),

            // TAREAS PRÓXIMAS
            tasksAsync.when(
                loading: () => const Center(
                    child: CircularProgressIndicator(color: primaryColor)),
                error: (err, stack) => Center(
                    child: Text('Error al cargar tareas próximas: $err')),
                data: (tasks) {
                  final upcomingTasks = _getUpcomingTasks(tasks);

                  if (upcomingTasks.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text("¡No tienes tareas pendientes! 🎉",
                            style: GoogleFonts.inter(
                                color: accentColor, fontSize: 16)),
                      ),
                    );
                  }

                  return Column(
                    children: upcomingTasks
                        .map((task) => _TaskEntry(
                              title: task.title,
                              subject: task.subject,
                              dueDate: task.dueDate
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0],
                              color: task.color,
                              icon: Icons.assignment_outlined,
                            ))
                        .toList(),
                  );
                }),

            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pushNamed(context, '/tasks'),
                child: Text(
                  'Ver todas las tareas',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primaryColor.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, 0),
    );
  }

  // --- Widgets Auxiliares ---
  Widget _buildHeader(BuildContext context, String userName) {
    final displayUserName = userName.split(' ').first;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: primaryColor,
              child: const Icon(Icons.person, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Bienvenida,",
                    style:
                        GoogleFonts.inter(fontSize: 14, color: Colors.black54)),
                Text(
                  displayUserName.isEmpty
                      ? "Estudiante Mentu"
                      : displayUserName,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.black54),
          onPressed: () => Navigator.pushNamed(context, '/profile'),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: primaryColor,
      ),
    );
  }
}

// -------------------------------------------------------------------
// WIDGET CALENDARIO
// -------------------------------------------------------------------
class _CalendarCard extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Map<DateTime, List<TaskEntity>> events;
  final Function(DateTime, DateTime) onDaySelected;

  const _CalendarCard({
    required this.focusedDay,
    required this.selectedDay,
    required this.events,
    required this.onDaySelected,
  });

  List<TaskEntity> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return events[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      color: cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar<TaskEntity>(
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2025, 12, 31),
          focusedDay: focusedDay,
          selectedDayPredicate: (day) => isSameDay(selectedDay, day),
          rangeSelectionMode: RangeSelectionMode.disabled,
          eventLoader: _getEventsForDay,
          onDaySelected: onDaySelected,
          onPageChanged: (focusedDay) => focusedDay = focusedDay,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle:
                GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
            leftChevronIcon: Icon(Icons.chevron_left, color: primaryColor),
            rightChevronIcon: Icon(Icons.chevron_right, color: primaryColor),
          ),
          calendarStyle: CalendarStyle(
            markerSize: 6.0,
            markersAnchor: 0.5,
            markerDecoration: BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: primaryColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// TAREA PRÓXIMA
// -------------------------------------------------------------------
class _TaskEntry extends StatelessWidget {
  final String title;
  final String subject;
  final String dueDate;
  final Color color;
  final IconData icon;

  const _TaskEntry({
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        title: Text(
          title,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          subject,
          style: GoogleFonts.inter(color: Colors.black54),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              dueDate,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Icon(icon, color: color, size: 18),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// NAVEGACIÓN INFERIOR
// -------------------------------------------------------------------
Widget _buildBottomNavigationBar(BuildContext context, int currentIndex) {
  return BottomNavigationBar(
    currentIndex: currentIndex,
    selectedItemColor: primaryColor,
    unselectedItemColor: Colors.grey.shade700,
    backgroundColor: appBackgroundColor,
    type: BottomNavigationBarType.fixed,
    showUnselectedLabels: true,
    elevation: 8,
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
  );
}
