// lib/data/repositories/session_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final sessionRepositoryProvider = Provider((ref) => SessionRepository());

class SessionRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // READ: Obtener IDs únicos de tutores con sesiones completadas
  Future<List<String>> getPreviousTutorIds() async {
    final uid = currentUserId;
    if (uid == null) return [];

    try {
      // 1. Consulta las sesiones completadas por el usuario actual
      final snapshot = await _db
          .collection('sessions')
          .where('studentId', isEqualTo: uid)
          .orderBy('endTime', descending: true)
          .get();

      // 2. Extrae los IDs de tutor únicos
      final uniqueTutorIds = snapshot.docs
          .map((doc) => doc.data()['tutorId'] as String)
          .toSet()
          .toList();

      return uniqueTutorIds;
    } catch (e) {
      return [];
    }
  }
}
