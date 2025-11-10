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

// ✅ CORRECCIÓN CLAVE: El FutureProvider debe observar el Notifier,
// no intentar manejar la lógica de carga, que ya está en el Notifier.
final tasksFutureProvider = FutureProvider<List<TaskEntity>>((ref) async {
  // 💡 Hacemos que el FutureProvider observe el StateNotifier.
  // Esto asegura que cualquier actualización en el StateNotifier (como crear una tarea)
  // también notifique al FutureProvider, que a su vez refresca el Dashboard.
  return ref.watch(tasksNotifierProvider);
});

class TasksNotifier extends StateNotifier<List<TaskEntity>> {
  final TaskRepository _repository;
  // ✅ Nuevo: Almacena el Future de carga inicial
  late final Future<void> initialLoadFuture;

  TasksNotifier(this._repository) : super([]) {
    // ✅ Se asigna el Future de carga al iniciar el Notifier
    initialLoadFuture = _loadInitialTasks();
  }

  // Función para manejar el Future de carga inicial
  Future<void> _loadInitialTasks() async {
    try {
      final tasks = await _repository.getTasks();
      state = tasks; // Actualiza el estado principal
    } catch (e) {
      print('Error loading tasks: $e');
      state = [];
    }
  }

  // 🛑 Se mantiene el método loadTasks, pero se asegura que la carga ocurra al inicio
  Future<void> loadTasks() => initialLoadFuture;

  // CREATE: Lógica para crear una tarea
  Future<void> createTask(
      String title, String subject, String dueTime, String dueDate) async {
    // 💡 Asegurarse de esperar la carga inicial antes de intentar crear
    await initialLoadFuture;

    final tempTask = TaskEntity(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        subject: subject,
        dueTime: dueTime,
        dueDate: dueDate,
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
    }
  }

  // UPDATE: Lógica para editar campos de una tarea (UPDATE completo)
  Future<void> updateTask(TaskEntity updatedTask) async {
    final taskIndex = state.indexWhere((t) => t.id == updatedTask.id);
    if (taskIndex == -1) return;

    final originalTask = state[taskIndex];

    // Optimistic UI Update
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
      throw Exception('Failed to update task details.');
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
