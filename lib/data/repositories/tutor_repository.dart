

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentu_app/domain/entities/tutor_entity.dart';


final tutorRepositoryProvider = Provider((ref) => TutorRepository());

class TutorRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  
  Future<List<TutorEntity>> getTopTutors() async {
    try {
      
      final snapshot = await _db
          .collection('tutors')
          .orderBy('rating', descending: true) 
          .limit(20) 
          .get();

      return snapshot.docs.map((doc) {
        return TutorEntity.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      
      return [];
    }
  }

  
}
