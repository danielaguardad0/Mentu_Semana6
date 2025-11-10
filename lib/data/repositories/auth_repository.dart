

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mentu_app/domain/entities/user_entity.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository();
});


class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  
  AuthRepository();

  Future<UserEntity> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user!;

      
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
      
      throw Exception(errorMessage);
    }
  }

  
  Future<String?> register(String name, String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user!;

      
      await firebaseUser.updateDisplayName(name);

      return null; 
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Error desconocido al registrar.';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'El correo ya está registrado.';
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      return errorMessage; 
    }
  }

  
  Future<bool> checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return _auth.currentUser != null;
  }

  
  Future<void> logout() async {
    await _auth.signOut();
  }
}

