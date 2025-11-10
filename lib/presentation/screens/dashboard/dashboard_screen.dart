import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/tasks_provider.dart';
import '../../../domain/entities/task_entity.dart';
import '../../providers/auth_provider.dart';

const Color primaryColor = Color(0xFF4C7FFF); // Azul Principal
const Color accentColor = Color(0xFF4CAF50); // Verde Acento
const Color lightAccentColor = Color(0xFFC7FFCA); // Verde muy claro
const Color appBackgroundColor = Color(0xFFF0F4F8); // Gris Azulado muy claro
const Color cardBackgroundColor = Colors.white;

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedPeriod = 1;

  Map<String, int> _calculateProgress(List<TaskEntity> tasks) {
    if (tasks.isEmpty) return {};

    final Map<String, int> completedCounts = {};
    final Map<String, int> totalCounts = {};
    final Map<String, int> progressPercentages = {};

    for (var task in tasks) {
      totalCounts.update(task.subject, (count) => count + 1, ifAbsent: () => 1);
      if (task.isCompleted) {
        completedCounts.update(task.subject, (count) => count + 1,
            ifAbsent: () => 1);
      }
    }

    totalCounts.forEach((subject, total) {
      final completed = completedCounts[subject] ?? 0;
      final progress = (completed * 100) ~/ total;
      progressPercentages[subject] = progress.clamp(0, 100);
    });

    return progressPercentages;
  }

  List<TaskEntity> _getUpcomingTasks(List<TaskEntity> tasks) {
    final pendingTasks = tasks.where((t) => !t.isCompleted).toList();
    return pendingTasks.take(4).toList();
  }

  BarChartGroupData _makeBarData(int x, int baseValue, int period) {
    int adjustedValue = baseValue;

    if (period == 0) {
      adjustedValue = (baseValue + (x % 2 == 0 ? 5 : -5)).clamp(10, 100);
    } else if (period == 2) {
      adjustedValue = (baseValue + 5).clamp(10, 100);
    }

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: adjustedValue.toDouble(),
          color: accentColor,
          width: 15,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: lightAccentColor.withOpacity(0.5),
          ),
        ),
      ],
      showingTooltipIndicators: const [0],
    );
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<TaskEntity>> tasksAsync =
        ref.watch(tasksFutureProvider);
    final user = ref.watch(authNotifierProvider);

    final List<BarChartGroupData> barGroups = [];
    final List<String> subjectAbbreviations = [];

    tasksAsync.whenData((tasks) {
      final progressMap = _calculateProgress(tasks);

      progressMap.entries.toList().asMap().entries.forEach((entry) {
        final int index = entry.key;
        final String subject = entry.value.key;
        final int progressValue = entry.value.value;

        subjectAbbreviations
            .add(subject.substring(0, subject.length > 4 ? 4 : subject.length));

        barGroups.add(_makeBarData(index, progressValue, _selectedPeriod));
      });
    });

    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: [
            _buildHeader(context, user.name),
            const SizedBox(height: 30),
            _buildSectionTitle('Progreso'),
            const SizedBox(height: 15),
            tasksAsync.when(
                loading: () => const Center(
                    child: CircularProgressIndicator(color: primaryColor)),
                error: (err, stack) =>
                    Center(child: Text('Error al cargar progreso: $err')),
                data: (_) {
                  return _ProgressCard(
                    barGroups: barGroups,
                    selectedPeriod: _selectedPeriod,
                    subjectAbbreviations: subjectAbbreviations,
                    onPeriodChanged: (int newPeriod) {
                      setState(() {
                        _selectedPeriod = newPeriod;
                      });
                    },
                  );
                }),
            const SizedBox(height: 30),
            _buildSectionTitle('Tareas Próximas'),
            const SizedBox(height: 15),
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
                              dueDate: task.dueDate,
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
                Text(
                  "Bienvenida,",
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.black54),
                ),
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
// PROGRESS CARD (Corregido el error de tooltipBgColor)
// -------------------------------------------------------------------
class _ProgressCard extends StatelessWidget {
  final List<BarChartGroupData> barGroups;
  final int selectedPeriod;
  final List<String> subjectAbbreviations;
  final ValueChanged<int> onPeriodChanged;

  const _ProgressCard({
    required this.barGroups,
    required this.selectedPeriod,
    required this.subjectAbbreviations,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (barGroups.isEmpty) {
      return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: cardBackgroundColor,
        child: const Padding(
            padding: EdgeInsets.all(40),
            child: Center(
                child: Text(
                    "¡Completa tus primeras tareas para ver tu progreso!"))),
      );
    }

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TimePeriodSelector(
              selectedPeriod: selectedPeriod,
              onPeriodChanged: onPeriodChanged,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  maxY: 100,
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final List<String> titles = subjectAbbreviations;

                          if (value.toInt() < titles.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                titles[value.toInt()],
                                style: GoogleFonts.inter(
                                    fontSize: 10, color: Colors.black54),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          if (value == 0 || value == 50 || value == 100) {
                            return Text(
                              '${value.toInt()}%',
                              style: GoogleFonts.inter(
                                  fontSize: 10, color: Colors.black54),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (double value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      // ✅ CORRECCIÓN FINAL: Eliminada la línea problemática
                      // tooltipBackgroundColor: primaryColor.withOpacity(0.8),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toInt()}%',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// SELECTOR DE TIEMPO
// -------------------------------------------------------------------
class _TimePeriodSelector extends StatelessWidget {
  final int? selectedPeriod;
  final ValueChanged<int>? onPeriodChanged;

  const _TimePeriodSelector({
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> buttons = ['DIARIO', 'SEMANAL', 'MENSUAL'];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: appBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(buttons.length, (index) {
          final bool isSelected = index == selectedPeriod;
          return Expanded(
            child: GestureDetector(
              onTap: onPeriodChanged != null
                  ? () => onPeriodChanged!(index)
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    buttons[index],
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? cardBackgroundColor : Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
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
// NAVEGACIÓN INFERIOR (Mantenida)
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
