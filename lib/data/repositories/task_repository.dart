

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
      'due_date': task.dueDate,
      'is_completed': task.isCompleted,
      
      'color': task.color.value, 
      'userId': uid, 
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  
  TaskEntity _fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) throw Exception("Task data is null");

    return TaskEntity(
      id: doc.id, 
      title: data['title'] as String,
      subject: data['subject'] as String,
      dueTime: data['due_time'] as String,
      dueDate: data['due_date'] as String,
      isCompleted: data['is_completed'] as bool,
      color: Color(data['color'] as int),
    );
  }

  
  Future<List<TaskEntity>> getTasks() async {
    final uid = currentUserId;
    if (uid == null) return []; 

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
      'due_date': updatedTask.dueDate,
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
