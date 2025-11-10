
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
    this.profileImageUrl = 'https://via.placeholder.com/200', 
  });

  
  factory TutorEntity.fromFirestore(Map<String, dynamic> data, String id) {
    return TutorEntity(
      id: id,
      name: data['name'] as String? ?? 'N/A',
      subject: data['subject'] as String? ?? 'Unknown',
      
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: data['reviews'] as int? ?? 0,
      profileImageUrl: data['profileImageUrl'] as String? ??
          'https://via.placeholder.com/200',
    );
  }
}
