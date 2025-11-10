// lib/data/repositories/auth_repository.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// 1. ✅ CORRECCIÓN CRÍTICA: Se añade la importación de la Entidad de Usuario
import 'package:mentu_app/domain/entities/user_entity.dart';
// ⚠️ Nota: Si necesitas API Service en el futuro, se puede reintroducir. Por ahora, se omite.
// import 'package:mentu_app/data/services/api_service.dart';

// 2. ✅ CORRECCIÓN EN EL PROVEEDOR: Se elimina la dependencia de ApiService
final authRepositoryProvider = Provider((ref) {
  return AuthRepository();
});

// La clase que maneja la persistencia y la autenticación
class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 2. ✅ CORRECCIÓN EN EL CONSTRUCTOR: Se elimina el parámetro ApiService no utilizado
  AuthRepository();

  // 1. LÓGICA DE INICIO DE SESIÓN CON FIREBASE
  Future<UserEntity> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user!;

      // Retorna la Entidad de Usuario
      return UserEntity(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? email,
        name: firebaseUser.displayName ?? 'Estudiante Mentu',
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        errorMessage = 'Credenciales incorrectas o usuario no registrado.';
      } else {
        errorMessage = e.message ?? 'Error desconocido.';
      }
      // Propaga la excepción para que el Notifier la maneje
      throw Exception(errorMessage);
    }
  }

  // 2. LÓGICA DE REGISTRO DE CUENTA CON FIREBASE
  Future<String?> register(String name, String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user!;

      // Actualizar nombre de usuario
      await firebaseUser.updateDisplayName(name);

      return null; // Registro exitoso
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Error desconocido al registrar.';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'El correo ya está registrado.';
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      return errorMessage; // Devuelve el mensaje de error al Notifier
    }
  }

  // 3. VERIFICACIÓN DE ESTADO DE AUTENTICACIÓN
  Future<bool> checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Verifica si hay un usuario activo en la sesión de Firebase
    return _auth.currentUser != null;
  }

  // 4. LÓGICA DE CIERRE DE SESIÓN
  Future<void> logout() async {
    await _auth.signOut();
  }
}

// ⚠️ Se eliminó la clase UserEntity duplicada que estaba aquí. 
// Debe existir solo en lib/domain/entities/user_entity.dart