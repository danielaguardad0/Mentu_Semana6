// lib/domain/entities/user_entity.dart

class UserEntity {
  final String id;
  final String email;
  final String name;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
  });

  // ✅ CORRECCIÓN: Usar una constante estática NO nula para el estado inicial
  static const UserEntity unauthenticated =
      UserEntity(id: '', email: '', name: 'Guest');

  bool get isAuthenticated => id.isNotEmpty;
}
