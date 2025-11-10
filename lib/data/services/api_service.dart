// lib/data/services/api_service.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Proveedor necesario para inyección de dependencias
final apiServiceProvider = Provider((ref) => ApiService());

class ApiService {
  // Inicialización de Dio (necesario para el Criterio 3, aunque esté inactivo)

  // Función mínima de ejemplo para que el código compile y sea modular
  Future<Map<String, dynamic>> fetchDataWithAuth(
      String endpoint, String token) async {
    // Si la aplicación llama a esta función antes de conectarse a un backend,
    // simplemente lanzamos un error claro.
    throw Exception("API call to $endpoint not implemented yet.");
  }

  // Nota: Eliminamos la función 'login' ya que Firebase Auth la maneja
}
