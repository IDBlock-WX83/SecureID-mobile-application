import 'package:ztech_mobile_application/core/http/ApiService.dart'; // Reemplazar con tu ruta correcta
import 'dart:convert';

class SexoService {
  final ApiService apiService;

  SexoService({required this.apiService});

  // Obtener todos los estados civil
  Future<List<Map<String, dynamic>>> getSexos() async {
    final response = await apiService.get('/sexos');
    return List<Map<String, dynamic>>.from(response); // Aseguramos que sea una lista de Map
  }

  
}