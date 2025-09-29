import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart'; // Necesario para el BarChart

const Color primaryColor = Colors.blue;
const Color accentColor = Color(0xFF4CAF50); // Verde para progreso
const Color appBackgroundColor = Color(0xFFD2EBE8); // Fondo claro (renombrado)
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      // AppBar usa los colores de theme.appBarTheme / colorScheme.surface
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: [
            // Upcoming Section
            Text(
              "Upcoming",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildTaskCard(context, "Homework 1", "Math 101", "Due Today"),
            _buildTaskCard(context, "Lab Report", "Physics 202", "Due Tomorrow"),
            _buildTaskCard(context, "Essay Outline", "History 303", "Due in 2 days"),
            const SizedBox(height: 20),

            // Progress Section
            Text(
              "Progress",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: cs.surface,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Overall Grade", style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Text(
                      "85%",
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Last 30 Days +5%",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.tertiary, // verde temático si tu seed lo da; alterna a cs.primary
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 80,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _bar(context, 40),
                          _bar(context, 60),
                          _bar(context, 30),
                          _bar(context, 70),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Week 1", style: theme.textTheme.bodySmall),
                        Text("Week 2", style: theme.textTheme.bodySmall),
                        Text("Week 3", style: theme.textTheme.bodySmall),
                        Text("Week 4", style: theme.textTheme.bodySmall),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tutoring Section
            Text(
              "Tutoring",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card
            (
              color: cs.surface,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Math 101",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              )),
                          const SizedBox(height: 4),
                          Text(
                            "Find a Tutor",
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Get help with your upcoming exam",
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/tutoring');
                            },
                            child: const Text("Find Tutor"),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: cs.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.image_not_supported,
                        color: cs.onSurfaceVariant,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation con colores del tema (sin blancos hardcodeados)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Dashboard
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurfaceVariant,
        backgroundColor: cs.surface,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 0,
        onTap: (i) {
          if (i == 0) return; // ya estás en dashboard
          if (i == 1) Navigator.pushNamed(context, '/tasks');
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

  static Widget _buildTaskCard(
    BuildContext context,
    String title,
    String subject,
    String due,
  ) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      color: cs.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subject, style: theme.textTheme.bodyMedium),
        trailing: Text(
          due,
          style: theme.textTheme.bodyMedium?.copyWith(color: cs.primary),
        ),
      ),
    );
  }

  static Widget _bar(BuildContext context, double height) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 20,
      height: height,
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(6),
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
