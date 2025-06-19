import 'package:ztech_mobile_application/core/http/ApiService.dart'; // Reemplazar con tu ruta correcta
import 'dart:convert';

class LocationService {
  final ApiService apiService;

  LocationService({required this.apiService});

  // Obtener todos los departamentos
  Future<List<Map<String, dynamic>>> getDepartments() async {
    final response = await apiService.get('/departamentos');
    return List<Map<String, dynamic>>.from(response); // Aseguramos que sea una lista de Map
  }

  // Obtener provincias por departamento
  Future<List<Map<String, dynamic>>> getProvincesByDepartment(int departmentId) async {
    final response = await apiService.get('/departamentos/$departmentId/provincias');
    return List<Map<String, dynamic>>.from(response);
  }

  // Obtener distritos por provincia
  Future<List<Map<String, dynamic>>> getDistrictsByProvince(int provinceId) async {
    final response = await apiService.get('/provincias/$provinceId/distritos');
    return List<Map<String, dynamic>>.from(response);
  }
}
