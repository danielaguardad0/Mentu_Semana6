import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Colors.blue;
const Color accentColor = Color(0xFF4CAF50);
const Color backgroundColor = Color(0xFFD2EBE8);
const Color cardBackgroundColor = Colors.white;
const Color starColor = Colors.amber;

// MODIFICACIÓN 1: Agregar profileImageUrl al modelo Tutor
class Tutor {
  final String name;
  final String subject;
  final double rating;
  final int reviews;
  final String? profileImageUrl; // NUEVA PROPIEDAD

  Tutor({
    required this.name,
    required this.subject,
    required this.rating,
    this.reviews = 0,
    this.profileImageUrl, // AGREGAR AL CONSTRUCTOR
  });
}

class TutoringScreen extends StatefulWidget {
  const TutoringScreen({super.key});

  @override
  State<TutoringScreen> createState() => _TutoringScreenState();
}

class _TutoringScreenState extends State<TutoringScreen> {
  int _selectedTab = 0;
  String _searchText = "";

  final List<String> categories = const [
    "Science",
    "Math",
    "Languages",
    "History",
    "Art"
  ];

  // MODIFICACIÓN 2: Asignar URLs de imagen (usando picsum.photos para mayor compatibilidad)
  final List<Tutor> allTopTutors = [
    Tutor(
        name: "Mary Smith",
        subject: "Mathematics",
        rating: 4.9,
        reviews: 150,
        profileImageUrl: "https://picsum.photos/id/11/200/200"),
    Tutor(
        name: "John Doe",
        subject: "Science",
        rating: 4.7,
        reviews: 92,
        profileImageUrl: "https://picsum.photos/id/20/200/200"),
    Tutor(
        name: "Elisa R.",
        subject: "History",
        rating: 4.8,
        reviews: 55,
        profileImageUrl: "https://picsum.photos/id/26/200/200"),
    Tutor(
        name: "Ana P.",
        subject: "Physics",
        rating: 4.5,
        reviews: 70,
        profileImageUrl: "https://picsum.photos/id/35/200/200"),
    Tutor(
        name: "Carlos M.",
        subject: "Calculus",
        rating: 5.0,
        reviews: 200,
        profileImageUrl: "https://picsum.photos/id/40/200/200"),
  ];

  final List<Tutor> bookAgainTutors = [
    Tutor(
        name: "Robert J.",
        subject: "Physics",
        rating: 4.5,
        profileImageUrl: "https://picsum.photos/id/51/200/200"),
    Tutor(
        name: "Laura K.",
        subject: "English",
        rating: 5.0,
        profileImageUrl: "https://picsum.photos/id/55/200/200"),
    Tutor(
        name: "Peter P.",
        subject: "Chemistry",
        rating: 4.6,
        profileImageUrl: "https://picsum.photos/id/60/200/200"),
  ];

  List<Tutor> get _filteredTopTutors {
    if (_searchText.isEmpty) {
      return allTopTutors;
    }
    return allTopTutors
        .where((tutor) =>
            tutor.name.toLowerCase().contains(_searchText.toLowerCase()) ||
            tutor.subject.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
  }

  // --- WIDGETS DE CONSTRUCCIÓN (Categories / Book Again) ---

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                  child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 0),
                      child: _buildHeaderTab(
                          context, "Categories", _selectedTab == 0))),
              const SizedBox(width: 10),
              Expanded(
                  child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 1),
                      child: _buildHeaderTab(
                          context, "Book Again", _selectedTab == 1))),
            ],
          ),
        ),

        // Barra de búsqueda
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          margin: const EdgeInsets.only(bottom: 20),
          child: Container(
            decoration: BoxDecoration(
              // CORRECCIÓN: Reemplazo de withOpacity(0.5) por withAlpha(127)
              color: backgroundColor.withAlpha(127),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search for tutors or topics",
                hintStyle: GoogleFonts.inter(color: Colors.black54),
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.search_rounded,
                      color: Colors.white, size: 24),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget para barra superior
  Widget _buildHeaderTab(BuildContext context, String title, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? cardBackgroundColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: isSelected ? Colors.grey.shade300 : Colors.transparent),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  // CORRECCIÓN: Reemplazo de withOpacity(0.1) por withAlpha(25)
                  color: Colors.grey.withAlpha(25),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                )
              ]
            : null,
      ),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.black87 : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Categories",
                  style: GoogleFonts.inter(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () {
                  print("Navigating to all categories screen.");
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("see all",
                      style: GoogleFonts.inter(
                          color: primaryColor, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),

        // Lista Horizontal de Categorías
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return _CategoryCard(
                  label: categories[index],
                  icon: _getIconForSubject(categories[index]));
            },
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // Top Tutors
  Widget _buildTopTutorsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Top Tutors",
              style:
                  GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          if (_filteredTopTutors.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: Text(
                  "No tutors found matching '$_searchText'",
                  style: GoogleFonts.inter(color: Colors.grey),
                ),
              ),
            )
          else
            ..._filteredTopTutors.map((tutor) => _TopTutorItem(tutor: tutor)),
          const SizedBox(height: 25),
          InkWell(
            onTap: () {
              print("Navigating to full tutor list.");
            },
            child: Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    // CORRECCIÓN: Reemplazo de withOpacity(0.2) por withAlpha(51)
                    color: Colors.black.withAlpha(51),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Center(
                child: Text(
                  "View All Tutors",
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // Book Again
  Widget _buildBookAgainSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Book Again",
                  style: GoogleFonts.inter(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () {
                  print("Navigating to previous sessions list.");
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("see all",
                      style: GoogleFonts.inter(
                          color: primaryColor, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: bookAgainTutors.length,
            itemBuilder: (context, index) {
              return _BookAgainCard(tutor: bookAgainTutors[index]);
            },
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  IconData _getIconForSubject(String subject) {
    switch (subject) {
      case "Science":
        return Icons.science;
      case "Math":
        return Icons.calculate;
      case "Languages":
        return Icons.language;
      case "History":
        return Icons.museum;
      case "Art":
        return Icons.palette;
      default:
        return Icons.book;
    }
  }

  // WIDGET DE NAVEGACIÓN INFERIOR

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
          // pushReplacementNamed
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
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: AppBar(
        backgroundColor: cardBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Tutors",
          style: GoogleFonts.lobster(fontSize: 28, color: Colors.black87),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            if (_selectedTab == 0) ...[
              _buildCategoriesSection(),
              _buildTopTutorsSection(),
            ] else
              _buildBookAgainSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, 2),
    );
  }
}

// WIDGETS AUXILIARES

Widget _buildRatingStars(double rating, {bool showReviews = true}) {
  int fullStars = rating.floor();
  bool hasHalfStar =
      (rating - fullStars) >= 0.25 && (rating - fullStars) < 0.75;

  List<Widget> stars = [];
  for (int i = 0; i < 5; i++) {
    if (i < fullStars) {
      stars.add(const Icon(Icons.star, color: starColor, size: 14));
    } else if (i == fullStars && hasHalfStar) {
      stars.add(const Icon(Icons.star_half, color: starColor, size: 14));
    } else {
      stars.add(const Icon(Icons.star_border, color: starColor, size: 14));
    }
  }

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      ...stars,
      const SizedBox(width: 4),
      if (showReviews)
        Text(
          rating.toStringAsFixed(1),
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
    ],
  );
}

// Tarjeta de Categoría
class _CategoryCard extends StatelessWidget {
  final String label;
  final IconData icon;

  const _CategoryCard({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    // InkWell para efecto táctil
    return InkWell(
      onTap: () {
        print("Tapped on category: $label");
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              // CORRECCIÓN: Reemplazo de withOpacity(0.05) por withAlpha(13)
              color: Colors.grey.withAlpha(13),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Top Rated" Chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                // CORRECCIÓN: Reemplazo de withOpacity(0.1) por withAlpha(25)
                color: primaryColor.withAlpha(25),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text("Top Rated",
                  style: GoogleFonts.inter(
                      color: primaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 5),

            Icon(icon, color: primaryColor, size: 30),
            const Spacer(),

            Text(label,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _TopTutorItem extends StatelessWidget {
  final Tutor tutor;

  const _TopTutorItem({required this.tutor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("Navigating to tutor profile: ${tutor.name}");
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // MODIFICACIÓN 3A: Implementación de la imagen de perfil
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey.shade300,
              // Usa NetworkImage si hay una URL, sino es nulo.
              backgroundImage: tutor.profileImageUrl != null
                  ? NetworkImage(tutor.profileImageUrl!)
                  : null,
              // Muestra el icono de persona si no hay imagen (backgroundImage es nulo)
              child: tutor.profileImageUrl == null
                  ? const Icon(Icons.person, color: primaryColor)
                  : null,
            ),
            const SizedBox(width: 15),

            // Nombre y Materia
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tutor.name,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  Text(tutor.subject,
                      style:
                          GoogleFonts.inter(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildRatingStars(tutor.rating, showReviews: false),
                      Text(" (${tutor.reviews} reviews)",
                          style: GoogleFonts.inter(
                              color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
          ],
        ),
      ),
    );
  }
}

class _BookAgainCard extends StatelessWidget {
  final Tutor tutor;

  const _BookAgainCard({required this.tutor});

  @override
  Widget build(BuildContext context) {
    // InkWell para efecto táctil y redirección
    return InkWell(
      onTap: () {
        print("Re-booking session with tutor: ${tutor.name}");
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          // CORRECCIÓN: Reemplazo de withOpacity(0.5) por withAlpha(127)
          color: backgroundColor.withAlpha(127),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MODIFICACIÓN 3B: Implementación de la imagen en la tarjeta
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                // Si hay URL, usa la imagen de red.
                image: tutor.profileImageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(tutor.profileImageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: Colors.grey.shade300,
              ),
              child: tutor.profileImageUrl == null
                  ? Center(
                      child: Icon(Icons.person,
                          color: Colors.grey.shade600, size: 40),
                    )
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tutor.name,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  Text(tutor.subject,
                      style:
                          GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
                  _buildRatingStars(tutor.rating, showReviews: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
