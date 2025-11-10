

import 'package:flutter_riverpod/flutter_riverpod.dart';


final apiServiceProvider = Provider((ref) => ApiService());

class ApiService {
  

  
  Future<Map<String, dynamic>> fetchDataWithAuth(
      String endpoint, String token) async {
    
    throw Exception("API call to $endpoint not implemented yet.");
  }

  
}
