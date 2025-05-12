import 'package:ztech_mobile_application/core/http/ApiService .dart';
import 'package:ztech_mobile_application/services/social_service.dart';

class SocialServicesService {
  final ApiService apiService;

  SocialServicesService({required this.apiService});
  // Obtener todos los servicios sociales (retorna lista)
  Future<List<SocialService>> getAllSocialServices() async {
    final response = await apiService.get('/social-services');
    return response.map<SocialService>((json) => SocialService.fromJson(json)).toList();
  }


  // Crear un nuevo servicio social
  Future<Map<String, dynamic>> createSocialService(Map<String, dynamic> socialServiceData) async {
    return await apiService.post('/social-services', socialServiceData); // Usamos el endpoint específico
  }
}