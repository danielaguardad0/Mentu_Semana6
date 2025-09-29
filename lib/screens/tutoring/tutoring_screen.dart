import 'package:flutter/material.dart';

// --- T E M A / C O L O R E S ---
const Color primaryColor = Color(0xFF1E88E5); // Azul vibrante

class TutoringScreen extends StatelessWidget {
  const TutoringScreen({super.key});

  final List<Map<String, String>> featuredTutors = const [
    {
      "name": "Sarah M.",
      "subject": "Math Tutor",
      "reviews": "4.9 (120 reviews)",
      "image": "assets/sarah.png",
    },
    {
      "name": "David L.",
      "subject": "Science Tutor",
      "reviews": "4.8 (85 reviews)",
      "image": "assets/david.png",
    },
  ];

  final List<Map<String, String>> allTutors = const [
    {
      "name": "Sarah M.",
      "subject": "Math Tutor",
      "rating": "4.9",
      "image": "assets/sarah_icon.png",
    },
    {
      "name": "David L.",
      "subject": "Science Tutor",
      "rating": "4.8",
      "image": "assets/david_icon.png",
    },
  ];

  Widget _buildSubjectChip(
      BuildContext context, String label, bool isSelected) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? colors.onPrimary : colors.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        backgroundColor: isSelected ? primaryColor : colors.surfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      ),
    );
  }

  Widget _buildFeaturedTutorCard(
      BuildContext context, Map<String, String> tutor) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Center(
              child: Text(
                "Image Placeholder",
                style: TextStyle(color: colors.onSecondaryContainer),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tutor["name"]!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  tutor["subject"]!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      tutor["reviews"]!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllTutorItem(BuildContext context, Map<String, String> tutor) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: colors.secondaryContainer,
          child: Icon(Icons.person, color: colors.onSecondaryContainer),
        ),
        title: Text(
          tutor["name"]!,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tutor["subject"]!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(
                  tutor["rating"]!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: primaryColor),
        onTap: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Find a Tutor",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: false,
        backgroundColor: colors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search by subject or tutor name",
                    hintStyle: TextStyle(color: colors.onSurfaceVariant),
                    prefixIcon: Icon(Icons.search,
                        color: colors.onSurfaceVariant),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  children: [
                    _buildSubjectChip(context, "All", true),
                    _buildSubjectChip(context, "Math", false),
                    _buildSubjectChip(context, "Science", false),
                    _buildSubjectChip(context, "English", false),
                    _buildSubjectChip(context, "History", false),
                    _buildSubjectChip(context, "Physics", false),
                  ],
                ),
              ),
              Text("Featured Tutors",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 15),
              SizedBox(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...featuredTutors
                        .map((tutor) => _buildFeaturedTutorCard(context, tutor)),
                    const SizedBox(width: 15),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text("All Tutors",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 15),
              Column(
                children: allTutors
                    .map((tutor) => _buildAllTutorItem(context, tutor))
                    .toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Tutors
        selectedItemColor: primaryColor,
        unselectedItemColor: colors.onSurfaceVariant,
        backgroundColor: colors.surface,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 10,
        onTap: (i) {
          if (i == 0) Navigator.pushNamed(context, '/dashboard');
          if (i == 1) Navigator.pushNamed(context, '/tasks');
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
            icon: Icon(Icons.list_alt),
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
