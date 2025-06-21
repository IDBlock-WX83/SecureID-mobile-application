import 'package:ztech_mobile_application/core/http/ApiService.dart'; // Reemplazar con tu ruta correcta
import 'dart:convert';

class EstadoCivilService {
  final ApiService apiService;

  EstadoCivilService({required this.apiService});

  // Obtener todos los estados civil
  Future<List<Map<String, dynamic>>> getEstadosCivil() async {
    final response = await apiService.get('/estados-civil');
    return List<Map<String, dynamic>>.from(response); // Aseguramos que sea una lista de Map
  }

  
}
