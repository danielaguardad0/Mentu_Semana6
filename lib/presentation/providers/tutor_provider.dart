

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentu_app/data/repositories/tutor_repository.dart';
import 'package:mentu_app/data/repositories/session_repository.dart'; 
import 'package:mentu_app/domain/entities/tutor_entity.dart';


final topTutorsProvider = FutureProvider<List<TutorEntity>>((ref) async {
  final repository = ref.read(tutorRepositoryProvider);
  return repository.getTopTutors();
});


final bookAgainTutorsProvider = FutureProvider<List<TutorEntity>>((ref) async {
  final sessionRepository = ref.read(sessionRepositoryProvider);
  ref.read(tutorRepositoryProvider);

  
  final previousTutorIds = await sessionRepository.getPreviousTutorIds();

  if (previousTutorIds.isEmpty) {
    return [];
  }

  
  final tutorsSnapshot = await FirebaseFirestore.instance
      .collection('tutors')
      .where(FieldPath.documentId, whereIn: previousTutorIds)
      .get();

  return tutorsSnapshot.docs
      .map((doc) => TutorEntity.fromFirestore(doc.data(), doc.id))
      .toList();
});
