// lib/presentation/providers/tasks_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentu_app/data/repositories/task_repository.dart';
import 'package:mentu_app/domain/entities/task_entity.dart';
import 'package:flutter/material.dart';

final tasksNotifierProvider =
    StateNotifierProvider<TasksNotifier, List<TaskEntity>>((ref) {
  final repository = ref.read(taskRepositoryProvider);
  return TasksNotifier(repository);
});

class TasksNotifier extends StateNotifier<List<TaskEntity>> {
  final TaskRepository _repository;

  TasksNotifier(this._repository) : super([]) {
    loadTasks();
  }

  // READ: Lógica para cargar las tareas
  Future<void> loadTasks() async {
    try {
      final tasks = await _repository.getTasks();
      state = tasks;
    } catch (e) {
      print('Error loading tasks: $e');
      state = [];
    }
  }

  // CREATE: Lógica para crear una tarea
  Future<void> createTask(
      String title, String subject, String dueTime, String dueDate) async {
    final tempTask = TaskEntity(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        subject: subject,
        dueTime: dueTime,
        dueDate: dueDate,
        color: [Colors.blue, Colors.green, Colors.pink, Colors.orange]
            .elementAt(DateTime.now().minute % 4));

    // Optimistic UI Update
    state = [...state, tempTask];

    try {
      final actualTask = await _repository.createTask(tempTask);

      // Reemplaza la tarea temporal con la tarea real del repositorio
      state = [
        for (final task in state)
          if (task.id == tempTask.id) actualTask else task,
      ];
    } catch (e) {
      // Revertir el estado si falla la creación
      state = state.where((task) => task.id != tempTask.id).toList();
      print('Failed to create task: $e');
    }
  }

  // ✅ NUEVO MÉTODO AGREGADO: Lógica para editar campos de una tarea (UPDATE completo)
  Future<void> updateTask(TaskEntity updatedTask) async {
    final taskIndex = state.indexWhere((t) => t.id == updatedTask.id);
    if (taskIndex == -1) return;

    final originalTask = state[taskIndex];

    // 1. Optimistic UI Update: Actualizar el estado local
    state = [
      ...state.sublist(0, taskIndex),
      updatedTask,
      ...state.sublist(taskIndex + 1),
    ];

    try {
      // 2. Enviar la actualización completa al repositorio (usa updateTask del repo)
      await _repository.updateTask(updatedTask);
    } catch (e) {
      // 3. Si falla, revertimos el estado
      state = [
        ...state.sublist(0, taskIndex),
        originalTask,
        ...state.sublist(taskIndex + 1),
      ];
      print('Failed to update task: $e');
      throw Exception('Failed to update task details.'); // Propagar error
    }
  }

  // UPDATE: Lógica para cambiar el estado (Toggle)
  Future<void> toggleStatus(String taskId) async {
    final taskIndex = state.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;

    final originalTask = state[taskIndex];
    final updatedTask =
        originalTask.copyWith(isCompleted: !originalTask.isCompleted);

    // Optimistic UI Update
    state = [
      ...state.sublist(0, taskIndex),
      updatedTask,
      ...state.sublist(taskIndex + 1),
    ];

    try {
      // Usamos el método updateTask del repositorio, ya que maneja cualquier actualización
      await _repository.updateTask(updatedTask);
    } catch (e) {
      // Revertir el estado si falla la actualización
      state = [
        ...state.sublist(0, taskIndex),
        originalTask,
        ...state.sublist(taskIndex + 1),
      ];
      print('Failed to update task status: $e');
    }
  }

  // DELETE: Lógica para eliminar una tarea
  Future<void> deleteTask(String taskId) async {
    final originalState = state;
    // Optimistic UI Update
    state = state.where((task) => task.id != taskId).toList();

    try {
      await _repository.deleteTask(taskId);
    } catch (e) {
      // Revertir el estado si falla la eliminación
      state = originalState;
      print('Failed to delete task: $e');
    }
  }
}
