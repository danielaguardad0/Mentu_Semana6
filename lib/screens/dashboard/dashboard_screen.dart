import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF1E88E5);

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
          padding: const EdgeInsets.all(16),
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
