// lib/domain/entities/task_entity.dart

import 'package:flutter/material.dart';

class TaskEntity {
  final String id;
  final String title;
  final String subject;
  final String dueTime;
  final DateTime dueDate; // ✅ CORRECCIÓN CRÍTICA: Ahora es DateTime
  final Color color;
  final bool isCompleted;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueTime,
    required this.dueDate, // ✅ Constructor espera DateTime
    this.color = Colors.blue,
    this.isCompleted = false,
  });

  TaskEntity copyWith({
    String? id,
    String? title,
    String? subject,
    String? dueTime,
    DateTime? dueDate, // ✅ copyWith espera DateTime
    Color? color,
    bool? isCompleted,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      dueTime: dueTime ?? this.dueTime,
      dueDate: dueDate ?? this.dueDate, // ✅ Asigna DateTime
      color: color ?? this.color,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
