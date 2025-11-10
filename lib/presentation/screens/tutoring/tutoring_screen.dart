

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:mentu_app/domain/entities/tutor_entity.dart';
import 'package:mentu_app/presentation/providers/tutor_provider.dart';

const Color primaryColor = Colors.blue;
const Color accentColor = Color(0xFF4CAF50);
const Color backgroundColor = Color(0xFFD2EBE8);
const Color cardBackgroundColor = Colors.white;
const Color starColor = Colors.amber;

class TutoringScreen extends ConsumerStatefulWidget {
  const TutoringScreen({super.key});

  @override
  ConsumerState<TutoringScreen> createState() => _TutoringScreenState();
}

class _TutoringScreenState extends ConsumerState<TutoringScreen> {
  int _selectedTab = 0;
  String _searchText = "";
  String? _selectedCategory;

  List<TutorEntity> _filterTutors(List<TutorEntity> tutors) {
    var filteredTutors = tutors;

    if (_searchText.isNotEmpty) {
      filteredTutors = filteredTutors
          .where((tutor) =>
              tutor.name.toLowerCase().contains(_searchText.toLowerCase()) ||
              tutor.subject.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    }

    if (_selectedCategory != null) {
      filteredTutors = filteredTutors
          .where((tutor) => tutor.subject == _selectedCategory)
          .toList();
    }

    return filteredTutors;
  }

  void _resetFilters() {
    setState(() {
      _searchText = "";
      _selectedCategory = null;
    });
  }

  List<String> _getUniqueSubjects(List<TutorEntity> tutors) {
    return tutors.map((t) => t.subject).toSet().toList();
  }

  

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

        
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          margin: const EdgeInsets.only(bottom: 20),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor.withAlpha(127),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                  _selectedCategory = null;
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

  Widget _buildCategoriesSection(List<TutorEntity> tutors) {
    final dynamicCategories = _getUniqueSubjects(tutors);

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

        
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: dynamicCategories.length,
            itemBuilder: (context, index) {
              final subject = dynamicCategories[index];
              final isSelected = subject == _selectedCategory;

              return _CategoryCard(
                  label: subject,
                  icon: _getIconForSubject(subject),
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedCategory = isSelected ? null : subject;
                      _searchText = "";
                    });
                  });
            },
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildTopTutorsSection(List<TutorEntity> tutors) {
    final filteredTutors = _filterTutors(tutors);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Top Tutors",
              style:
                  GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          if (filteredTutors.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: Text(
                  _searchText.isEmpty && _selectedCategory != null
                      ? "No hay tutores disponibles en $_selectedCategory."
                      : "No tutors found matching '$_searchText'",
                  style: GoogleFonts.inter(color: Colors.grey),
                ),
              ),
            )
          else
            ...filteredTutors.map((tutor) => _TopTutorItem(tutor: tutor)),
          const SizedBox(height: 25),
          InkWell(
            onTap: _resetFilters,
            child: Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
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

  
  Widget _buildBookAgainSection() {
    final tutorsAsync =
        ref.watch(bookAgainTutorsProvider); 

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
                onTap: () {},
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

        
        tutorsAsync.when(
          loading: () => const Center(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: CircularProgressIndicator(
                      color: primaryColor, strokeWidth: 2))),
          error: (err, stack) => Center(
              child: Text('Error loading sessions: $err',
                  style: TextStyle(color: Colors.red))),
          data: (bookAgainTutors) {
            if (bookAgainTutors.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                    child: Text("No has completado tutorías previamente.",
                        style: GoogleFonts.inter(color: Colors.grey))),
              );
            }

            return SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: bookAgainTutors.length,
                itemBuilder: (context, index) {
                  return _BookAgainCard(tutor: bookAgainTutors[index]);
                },
              ),
            );
          },
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
    final tutorsAsync = ref.watch(topTutorsProvider);

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
              tutorsAsync.when(
                  loading: () => const Center(
                      child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: CircularProgressIndicator(
                              color: primaryColor, strokeWidth: 3))),
                  error: (err, stack) => Center(
                      child: Text('Error loading data: $err',
                          style: GoogleFonts.inter(color: Colors.red))),
                  data: (tutors) {
                    return Column(children: [
                      _buildCategoriesSection(tutors),
                      _buildTopTutorsSection(tutors),
                    ]);
                  }),
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


class _CategoryCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isSelected;

  const _CategoryCard(
      {required this.label,
      required this.icon,
      required this.onTap,
      this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              isSelected ? primaryColor.withOpacity(0.1) : cardBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: isSelected ? primaryColor : Colors.grey.shade300,
              width: isSelected ? 2 : 1),
          boxShadow: [
            BoxShadow(
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : primaryColor.withAlpha(25),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(isSelected ? "SELECTED" : "Top Rated",
                  style: GoogleFonts.inter(
                      color: isSelected ? Colors.white : primaryColor,
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
  final TutorEntity tutor;

  const _TopTutorItem({required this.tutor});

  @override
  Widget build(BuildContext context) {
    final bool hasImage = tutor.profileImageUrl.isNotEmpty &&
        tutor.profileImageUrl != 'https://via.placeholder.com/200';

    return InkWell(
      onTap: () {
        print("Navigating to tutor profile: ${tutor.name}");
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: hasImage
                  ? NetworkImage(tutor.profileImageUrl) as ImageProvider
                  : null,
              child: !hasImage
                  ? const Icon(Icons.person, color: primaryColor)
                  : null,
            ),
            const SizedBox(width: 15),
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
  final TutorEntity tutor;

  const _BookAgainCard({required this.tutor});

  @override
  Widget build(BuildContext context) {
    final bool hasImage = tutor.profileImageUrl.isNotEmpty &&
        tutor.profileImageUrl != 'https://via.placeholder.com/200';

    return InkWell(
      onTap: () {
        print("Re-booking session with tutor: ${tutor.name}");
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: backgroundColor.withAlpha(127),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                image: hasImage
                    ? DecorationImage(
                        image: NetworkImage(tutor.profileImageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: Colors.grey.shade300,
              ),
              child: !hasImage
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
