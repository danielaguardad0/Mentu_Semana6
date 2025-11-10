// lib/domain/entities/session_entity.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class SessionEntity {
  final String id;
  final String tutorId;
  final String studentId;
  final DateTime endTime;
  // Podríamos incluir más detalles como subject, rating, etc.,
  // pero solo necesitamos el tutorId para esta función.

  const SessionEntity({
    required this.id,
    required this.tutorId,
    required this.studentId,
    required this.endTime,
  });

  factory SessionEntity.fromFirestore(Map<String, dynamic> data, String id) {
    return SessionEntity(
      id: id,
      tutorId: data['tutorId'] as String,
      studentId: data['studentId'] as String,
      endTime: (data['endTime'] as Timestamp).toDate(),
    );
  }
}
