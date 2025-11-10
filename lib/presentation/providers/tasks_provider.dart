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

final tasksFutureProvider = FutureProvider<List<TaskEntity>>((ref) async {
  // Asegura que la carga inicial se complete antes de devolver el estado
  await ref.read(tasksNotifierProvider.notifier).loadTasks();
  // Observa el StateNotifier para devolver el estado actual
  return ref.watch(tasksNotifierProvider);
});

class TasksNotifier extends StateNotifier<List<TaskEntity>> {
  final TaskRepository _repository;

  late final Future<void> initialLoadFuture;

  TasksNotifier(this._repository) : super([]) {
    initialLoadFuture = _loadInitialTasks();
  }

  Future<void> _loadInitialTasks() async {
    try {
      final tasks = await _repository.getTasks();
      state = tasks;
    } catch (e) {
      print('Error loading tasks: $e');
      state = [];
    }
  }

  Future<void> loadTasks() => initialLoadFuture;

  // ✅ CORRECCIÓN CRÍTICA: Cambiar el tipo de dueDate a DateTime
  Future<void> createTask(
      String title, String subject, String dueTime, DateTime dueDate) async {
    // Esperar a que la carga inicial termine
    await initialLoadFuture;

    final tempTask = TaskEntity(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        subject: subject,
        dueTime: dueTime,
        dueDate: dueDate, // ✅ Ahora acepta DateTime
        color: [Colors.blue, Colors.green, Colors.pink, Colors.orange]
            .elementAt(DateTime.now().minute % 4));

    state = [...state, tempTask];

    try {
      final actualTask = await _repository.createTask(tempTask);

      state = [
        for (final task in state)
          if (task.id == tempTask.id) actualTask else task,
      ];
    } catch (e) {
      state = state.where((task) => task.id != tempTask.id).toList();
      print('Failed to create task: $e');
      throw Exception('Failed to create task in database.'); // Propagar error
    }
  }

  Future<void> updateTask(TaskEntity updatedTask) async {
    final taskIndex = state.indexWhere((t) => t.id == updatedTask.id);
    if (taskIndex == -1) return;

    final originalTask = state[taskIndex];

    state = [
      ...state.sublist(0, taskIndex),
      updatedTask,
      ...state.sublist(taskIndex + 1),
    ];

    try {
      await _repository.updateTask(updatedTask);
    } catch (e) {
      state = [
        ...state.sublist(0, taskIndex),
        originalTask,
        ...state.sublist(taskIndex + 1),
      ];
      print('Failed to update task: $e');
      throw Exception(
          'Failed to update task details in database.'); // Propagar error
    }
  }

  Future<void> toggleStatus(String taskId) async {
    final taskIndex = state.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;

    final originalTask = state[taskIndex];
    final updatedTask =
        originalTask.copyWith(isCompleted: !originalTask.isCompleted);

    state = [
      ...state.sublist(0, taskIndex),
      updatedTask,
      ...state.sublist(taskIndex + 1),
    ];

    try {
      await _repository.updateTask(updatedTask);
    } catch (e) {
      state = [
        ...state.sublist(0, taskIndex),
        originalTask,
        ...state.sublist(taskIndex + 1),
      ];
      print('Failed to update task status: $e');
      throw Exception('Failed to toggle status in database.'); // Propagar error
    }
  }

  Future<void> deleteTask(String taskId) async {
    final originalState = state;

    state = state.where((task) => task.id != taskId).toList();

    try {
      await _repository.deleteTask(taskId);
    } catch (e) {
      state = originalState;
      print('Failed to delete task: $e');
      throw Exception('Failed to delete task from database.'); // Propagar error
    }
  }
}
