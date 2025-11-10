// lib/domain/entities/tutor_entity.dart

class TutorEntity {
  final String id;
  final String name;
  final String subject;
  final double rating;
  final int reviews;
  final String profileImageUrl;

  const TutorEntity({
    required this.id,
    required this.name,
    required this.subject,
    required this.rating,
    this.reviews = 0,
    this.profileImageUrl = 'https://via.placeholder.com/200', // Default image
  });

  // Utility para convertir un DocumentSnapshot de Firestore a TutorEntity
  factory TutorEntity.fromFirestore(Map<String, dynamic> data, String id) {
    return TutorEntity(
      id: id,
      name: data['name'] as String? ?? 'N/A',
      subject: data['subject'] as String? ?? 'Unknown',
      // Firestore puede almacenar numbers como int o double, usamos num?.toDouble() para seguridad
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: data['reviews'] as int? ?? 0,
      profileImageUrl: data['profileImageUrl'] as String? ??
          'https://via.placeholder.com/200',
    );
  }
}
