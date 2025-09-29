import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

const Color primaryColor = Colors.blue;
const Color accentColor = Color(0xFF4CAF50);
const Color appBackgroundColor = Color(0xFFD2EBE8);
const Color cardBackgroundColor = Colors.white;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // 0 = Diario, 1 = Semanal, 2 = Mensual
  int _selectedPeriod = 1;

  @override
  Widget build(BuildContext context) {
    final Map<String, int> baseProgress = {
      'Biología': 75,
      'Química': 85,
      'Física': 60,
      'Literatura': 90,
      'Historia': 50,
    };

    final List<BarChartGroupData> barGroups =
        baseProgress.entries.toList().asMap().entries.map((entry) {
      final int index = entry.key;
      final String subject = entry.value.key;
      final int baseValue = entry.value.value;
      return _makeBarData(index, baseValue, subject, _selectedPeriod);
    }).toList();

    return Scaffold(
      backgroundColor: appBackgroundColor, // ✅ usamos el nombre corregido
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: [
            _buildHeader(context),
            const SizedBox(height: 30),
            _buildSectionTitle('Progreso'),
            const SizedBox(height: 15),
            _ProgressCard(
              barGroups: barGroups,
              selectedPeriod: _selectedPeriod,
              onPeriodChanged: (int newPeriod) {
                setState(() {
                  _selectedPeriod = newPeriod;
                });
              },
            ),
            const SizedBox(height: 30),
            _buildSectionTitle('Tareas Próximas'),
            const SizedBox(height: 15),
            const _TaskEntry(
              title: "Informe Laboratorio 3",
              subject: "Química",
              dueDate: "Mañana",
              color: accentColor,
              icon: Icons.local_fire_department,
            ),
            const _TaskEntry(
              title: "Ensayo: Guerra Civil",
              subject: "Historia",
              dueDate: "Martes",
              color: primaryColor,
              icon: Icons.assignment_outlined,
            ),
            const _TaskEntry(
              title: "Cuestionario Cap. 5",
              subject: "Biología",
              dueDate: "Miércoles",
              color: Colors.pinkAccent,
              icon: Icons.checklist,
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pushNamed(context, '/tasks'),
                child: Text(
                  'Ver más tareas',
                  style: GoogleFonts.lobster(
                    fontSize: 18,
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: primaryColor.withOpacity(0.1),
              child: const Icon(Icons.person, color: primaryColor, size: 30),
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
                  "Marjorie",
                  style: GoogleFonts.lobster(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
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

  BarChartGroupData _makeBarData(
      int x, int baseValue, String label, int period) {
    int adjustedValue = baseValue;
    if (period == 0) {
      adjustedValue = (baseValue + (x % 2 == 0 ? 10 : -10)).clamp(10, 100);
    } else if (period == 2) {
      adjustedValue = (baseValue + 10).clamp(10, 100);
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
            color: Colors.grey.shade200,
          ),
        ),
      ],
      showingTooltipIndicators: const [0],
    );
  }
}

// -------------------------------------------------------------------
// PROGRESS CARD
// -------------------------------------------------------------------
class _ProgressCard extends StatelessWidget {
  final List<BarChartGroupData> barGroups;
  final int selectedPeriod;
  final ValueChanged<int> onPeriodChanged;

  const _ProgressCard({
    required this.barGroups,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
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
                          final List<String> titles = [
                            'Bio',
                            'Quí',
                            'Fís',
                            'Lit',
                            'Hist'
                          ];
                          if (value.toInt() < titles.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                titles[value.toInt()],
                                style: const TextStyle(
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
                              style: const TextStyle(
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
  final int selectedPeriod;
  final ValueChanged<int> onPeriodChanged;

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
              onTap: () => onPeriodChanged(index),
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
// NAVEGACIÓN INFERIOR
// -------------------------------------------------------------------
Widget _buildBottomNavigationBar(BuildContext context, int currentIndex) {
  return BottomNavigationBar(
    currentIndex: currentIndex,
    selectedItemColor: primaryColor,
    unselectedItemColor: Colors.grey.shade700,
    backgroundColor: appBackgroundColor, // ✅ Cambiado para mejor visibilidad
    type: BottomNavigationBarType.fixed,
    showUnselectedLabels: true,
    elevation: 8, // ✅ Le da relieve y sombra
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
