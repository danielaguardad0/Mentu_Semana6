// lib/data/repositories/task_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ Necesario para obtener el UID
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Necesario para Firestore
import 'package:mentu_app/domain/entities/task_entity.dart';
import 'package:flutter/material.dart';

// Proveedor de Riverpod
final taskRepositoryProvider = Provider((ref) => TaskRepository());

class TaskRepository {
  // Instancias de Firebase
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Colección principal para tareas
  CollectionReference get _tasksCollection => _db.collection('tasks');

  // Utility: Obtener el ID del usuario logueado (Versión Robusta)
  String? get currentUserId {
    return _auth.currentUser?.uid;
  }

  // Utility para convertir TaskEntity a Map (para Firestore)
  Map<String, dynamic> _toJson(TaskEntity task) {
    final uid = currentUserId;
    if (uid == null) {
      // Lanzar una excepción si no hay usuario, esto será capturado por el Notifier
      throw Exception("Authentication required to save task.");
    }

    return {
      'title': task.title,
      'subject': task.subject,
      'due_time': task.dueTime,
      'due_date': task.dueDate,
      'is_completed': task.isCompleted,
      // ignore: deprecated_member_use
      'color': task.color.value, // Guardar el color como entero
      'userId': uid, // CRÍTICO: Asignar la tarea al usuario
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Utility para convertir DocumentSnapshot de Firestore a TaskEntity
  TaskEntity _fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) throw Exception("Task data is null");

    return TaskEntity(
      id: doc.id, // Usar el ID de Firestore
      title: data['title'] as String,
      subject: data['subject'] as String,
      dueTime: data['due_time'] as String,
      dueDate: data['due_date'] as String,
      isCompleted: data['is_completed'] as bool,
      color: Color(data['color'] as int),
    );
  }

  // 1. READ: Obtener todas las tareas del usuario logueado
  Future<List<TaskEntity>> getTasks() async {
    final uid = currentUserId;
    if (uid == null) return []; // Devuelve lista vacía si no hay UID

    try {
      final snapshot = await _tasksCollection
          .where('userId', isEqualTo: uid) // ✅ Filtra por usuario
          .orderBy('createdAt', descending: false)
          .get();

      return snapshot.docs.map((doc) => _fromSnapshot(doc)).toList();
    } catch (e) {
      throw Exception('Failed to load tasks from database.');
    }
  }

  // 2. CREATE: Agregar una nueva tarea
  Future<TaskEntity> createTask(TaskEntity task) async {
    // Esto lanzará una excepción si currentUserId es nulo
    final data = _toJson(task);

    final docRef = await _tasksCollection.add(data);

    // Devolver la tarea con el ID generado por Firestore
    return task.copyWith(id: docRef.id);
  }

  // 3. UPDATE: Editar o cambiar el estado de una tarea
  Future<TaskEntity> updateTask(TaskEntity updatedTask) async {
    final uid = currentUserId;
    if (uid == null) throw Exception("Authentication required to update task.");

    final docRef = _tasksCollection.doc(updatedTask.id);

    // Solo actualizamos los campos modificables
    await docRef.update({
      'title': updatedTask.title,
      'subject': updatedTask.subject,
      'due_time': updatedTask.dueTime,
      'due_date': updatedTask.dueDate,
      'is_completed': updatedTask.isCompleted,
      // ignore: deprecated_member_use
      'color': updatedTask.color.value,
    });

    return updatedTask;
  }

  // 4. DELETE: Eliminar una tarea
  Future<void> deleteTask(String taskId) async {
    final uid = currentUserId;
    if (uid == null) throw Exception("Authentication required to delete task.");

    await _tasksCollection.doc(taskId).delete();
  }
}
