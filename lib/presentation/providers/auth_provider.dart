import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentu_app/data/repositories/auth_repository.dart';

import 'package:mentu_app/domain/entities/user_entity.dart';

// Logica de autenticación
class AuthNotifier extends StateNotifier<UserEntity> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(UserEntity.unauthenticated);

  Future<String?> login(String email, String password) async {
    try {
      final user = await _repository.login(email, password);
      state = user;
      return null;
    } catch (e) {
      state = UserEntity.unauthenticated;
      return e.toString().contains('Exception:')
          ? e.toString().substring(10)
          : 'Error de autenticación desconocido.';
    }
  }

  Future<String?> register(
      {required String email,
      required String password,
      required String name,
      required String role}) async {
    try {
      final error = await _repository.register(name, email, password);

      if (error != null) {
        throw Exception(error);
      }

      final user = await _repository.login(email, password);
      state = user;

      return null;
    } catch (e) {
      state = UserEntity.unauthenticated;
      return e.toString().contains('Exception:')
          ? e.toString().substring(10)
          : 'Error de registro desconocido.';
    }
  }

  Future<void> logout() async {
    await _repository.logout();

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
