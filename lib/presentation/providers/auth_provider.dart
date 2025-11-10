// lib/presentation/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentu_app/data/repositories/auth_repository.dart';
// 🎯 IMPORTACIÓN A UserEntity (Asumiendo que es la ruta correcta para la entidad corregida)
import 'package:mentu_app/domain/entities/user_entity.dart';

class AuthNotifier extends StateNotifier<UserEntity> {
  final AuthRepository _repository;

  // ✅ CORRECCIÓN: Ahora UserEntity.unauthenticated es una constante, eliminando el ! de ser necesario.
  AuthNotifier(this._repository) : super(UserEntity.unauthenticated);

  // Lógica para iniciar sesión
  Future<String?> login(String email, String password) async {
    try {
      final user = await _repository.login(email, password);
      state = user;
      return null;
    } catch (e) {
      // ✅ Usamos la constante no nula
      state = UserEntity.unauthenticated;
      return e.toString().contains('Exception:')
          ? e.toString().substring(10)
          : 'Error de autenticación desconocido.';
    }
  }

  // Lógica para crear una cuenta (usada por SignUpScreen)
  // ✅ CORRECCIÓN CRÍTICA: Se eliminan los parámetros posicionales duplicados.
  Future<String?> register(
      {required String email,
      required String password,
      required String name,
      required String role}) async {
    try {
      // La función register del repositorio retorna String? (el mensaje de error o null si es exitoso)
      final error = await _repository.register(name, email, password);

      if (error != null) {
        throw Exception(error);
      }

      // Si el registro fue exitoso, el usuario está logueado automáticamente
      // Actualizamos el estado para reflejar el nuevo usuario.
      final user = await _repository.login(email, password);
      state = user;

      return null;
    } catch (e) {
      // ✅ Usamos la constante no nula
      state = UserEntity.unauthenticated;
      return e.toString().contains('Exception:')
          ? e.toString().substring(10)
          : 'Error de registro desconocido.';
    }
  }

  // Lógica para cerrar sesión
  Future<void> logout() async {
    await _repository.logout();
    // ✅ Usamos la constante no nula
    state = UserEntity.unauthenticated;
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, UserEntity>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

final authCheckProvider = FutureProvider<bool>((ref) async {
  return ref.watch(authRepositoryProvider).checkAuthStatus();
});
