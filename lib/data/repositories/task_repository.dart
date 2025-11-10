// lib/data/repositories/task_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentu_app/domain/entities/task_entity.dart';
import 'package:flutter/material.dart';

final taskRepositoryProvider = Provider((ref) => TaskRepository());

class TaskRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _tasksCollection => _db.collection('tasks');

  String? get currentUserId {
    return _auth.currentUser?.uid;
  }

  Map<String, dynamic> _toJson(TaskEntity task) {
    final uid = currentUserId;
    if (uid == null) {
      throw Exception("Authentication required to save task.");
    }

    return {
      'title': task.title,
      'subject': task.subject,
      'due_time': task.dueTime,
      // ✅ Usa Timestamp para guardar el DateTime
      'due_date': Timestamp.fromDate(task.dueDate),
      'is_completed': task.isCompleted,

      'color': task.color.value,
      'userId': uid,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  TaskEntity _fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) throw Exception("Task data is null");

    // ✅ VERIFICACIÓN DE TIPO: Asegura que el dato sea un Timestamp de Firestore
    final dueDateTimestamp = data['due_date'];
    if (dueDateTimestamp is! Timestamp) {
      // Este error solo ocurriría si los datos fueron ingresados manualmente con el tipo incorrecto.
      throw Exception(
          "Invalid type for dueDate in Firestore. Expected Timestamp.");
    }

    return TaskEntity(
      id: doc.id,
      title: data['title'] as String,
      subject: data['subject'] as String,
      dueTime: data['due_time'] as String,
      // ✅ CONVERSIÓN: Timestamp a DateTime (para la Entidad)
      dueDate: dueDateTimestamp.toDate(),
      isCompleted: data['is_completed'] as bool,
      color: Color(data['color'] as int),
    );
  }

  Future<List<TaskEntity>> getTasks() async {
    final uid = currentUserId;
    if (uid == null) return [];

    try {
      final snapshot = await _tasksCollection
          .where('userId', isEqualTo: uid)
          .orderBy('createdAt', descending: false)
          .get();

      return snapshot.docs.map((doc) => _fromSnapshot(doc)).toList();
    } catch (e) {
      // Propagar error para que el Notifier pueda manejar la UI
      throw Exception('Failed to load tasks from database: ${e.toString()}');
    }
  }

  Future<TaskEntity> createTask(TaskEntity task) async {
    final data = _toJson(task);

    final docRef = await _tasksCollection.add(data);

    return task.copyWith(id: docRef.id);
  }

  Future<TaskEntity> updateTask(TaskEntity updatedTask) async {
    final uid = currentUserId;
    if (uid == null) throw Exception("Authentication required to update task.");

    final docRef = _tasksCollection.doc(updatedTask.id);

    await docRef.update({
      'title': updatedTask.title,
      'subject': updatedTask.subject,
      'due_time': updatedTask.dueTime,
      // ✅ Usa Timestamp para guardar el DateTime
      'due_date': Timestamp.fromDate(updatedTask.dueDate),
      'is_completed': updatedTask.isCompleted,
      'color': updatedTask.color.value,
    });

    return updatedTask;
  }

  Future<void> deleteTask(String taskId) async {
    final uid = currentUserId;
    if (uid == null) throw Exception("Authentication required to delete task.");

    await _tasksCollection.doc(taskId).delete();
  }
}
