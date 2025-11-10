// lib/presentation/providers/tutor_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentu_app/data/repositories/tutor_repository.dart';
import 'package:mentu_app/data/repositories/session_repository.dart'; // Importar Repositorio de Sesiones
import 'package:mentu_app/domain/entities/tutor_entity.dart';

// [Provider existente para Top Tutors (Lectura principal)]
final topTutorsProvider = FutureProvider<List<TutorEntity>>((ref) async {
  final repository = ref.read(tutorRepositoryProvider);
  return repository.getTopTutors();
});

// ✅ NUEVO PROVIDER: Carga los tutores con sesiones previas
final bookAgainTutorsProvider = FutureProvider<List<TutorEntity>>((ref) async {
  final sessionRepository = ref.read(sessionRepositoryProvider);
  ref.read(tutorRepositoryProvider);

  // 1. Obtener los IDs de tutores anteriores
  final previousTutorIds = await sessionRepository.getPreviousTutorIds();

  if (previousTutorIds.isEmpty) {
    return [];
  }

  // 2. Extender el TutorRepository con la funcionalidad de buscar por IDs (Simulación)
  // Como no podemos modificar el repositorio original, simularemos la función aquí:

  // En una app real, el TutorRepository tendría un método:
  // return tutorRepository.getTutorsByIds(previousTutorIds);

  // Por ahora, para la demo, si ya tienes el topTutorsProvider cargado,
  // solo filtramos de esa lista, si no, deberías hacer la consulta directa a Firestore.
  // La forma más segura aquí es hacer la consulta directa para demostrar la modularidad:

  // [Aquí iría la lógica Firestore: whereIn('id', previousTutorIds)]
  // Usaremos un método de Firestore para buscar por lista de IDs:

  // 3. Consulta Firestore para obtener los detalles de los tutores por ID
  final tutorsSnapshot = await FirebaseFirestore.instance
      .collection('tutors')
      .where(FieldPath.documentId, whereIn: previousTutorIds)
      .get();

  return tutorsSnapshot.docs
      .map((doc) => TutorEntity.fromFirestore(doc.data(), doc.id))
      .toList();
});
