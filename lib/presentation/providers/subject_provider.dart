// lib/presentation/providers/subject_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Proveedor de la lista de materias únicas (solo nombres, ej: ['Cálculo', 'Diseño Web'])
final subjectNotifierProvider =
    StateNotifierProvider<SubjectNotifier, List<String>>((ref) {
  return SubjectNotifier();
});

class SubjectNotifier extends StateNotifier<List<String>> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SubjectNotifier() : super([]) {
    // Escucha los cambios en Firestore para mantener la lista actualizada
    _listenToSubjects();
  }

  String? get _currentUserId => _auth.currentUser?.uid;
  CollectionReference get _subjectsCollection => _db.collection('subjects');

  // ✅ READ: Escuchar los cambios en tiempo real
  void _listenToSubjects() {
    final uid = _currentUserId;
    if (uid == null) return;

    // Filtra las materias por el usuario actual
    _subjectsCollection
        .where('userId', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
      final List<String> subjects = [];
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        subjects.add(data['name'] as String);
      }
      state =
          subjects.toSet().toList(); // Asegura unicidad y actualiza el estado
    });
  }

  // ✅ CREATE: Añadir una nueva materia
  Future<void> addSubject(String name) async {
    final uid = _currentUserId;
    if (uid == null || state.contains(name)) return;

    // Optimistic UI Update (opcional aquí, ya que el listener de Firestore actualizará)

    try {
      await _subjectsCollection.add({
        'name': name,
        'userId': uid,
      });
      // El listener actualizará el estado
    } catch (e) {
      print('Error adding subject: $e');
    }
  }

  // ✅ DELETE: Eliminar una materia
  Future<void> removeSubject(String name) async {
    final uid = _currentUserId;
    if (uid == null) return;

    // 🛑 IMPORTANTE: Solo se debe permitir borrar una materia si no está asignada a NINGUNA TAREA activa.

    try {
      // 1. Encontrar el documento de la materia
      final snapshot = await _subjectsCollection
          .where('userId', isEqualTo: uid)
          .where('name', isEqualTo: name)
          .get();

      // 2. Eliminar el primer documento encontrado (debería ser único)
      if (snapshot.docs.isNotEmpty) {
        await _subjectsCollection.doc(snapshot.docs.first.id).delete();
      }
      // El listener actualizará el estado
    } catch (e) {
      print('Error removing subject: $e');
    }
  }
}
