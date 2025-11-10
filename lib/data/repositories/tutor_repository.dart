// lib/data/repositories/tutor_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentu_app/domain/entities/tutor_entity.dart';

// Proveedor de Riverpod para inyección
final tutorRepositoryProvider = Provider((ref) => TutorRepository());

class TutorRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // READ: Obtener todos los tutores (Top Tutors)
  Future<List<TutorEntity>> getTopTutors() async {
    try {
      // ✅ Conexión a la colección 'tutors'
      final snapshot = await _db
          .collection('tutors')
          .orderBy('rating', descending: true) // Ordenar por rating
          .limit(20) // Limitar la cantidad de tutores
          .get();

      return snapshot.docs.map((doc) {
        return TutorEntity.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      // Es crucial devolver una lista vacía para que la UI no falle
      return [];
    }
  }

  // Las tareas de 'Book Again' requerirían obtener las sesiones previas del usuario,
  // pero por ahora, nos enfocamos solo en el READ principal.
}
