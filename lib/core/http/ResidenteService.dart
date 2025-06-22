import 'package:ztech_mobile_application/core/http/ApiService.dart';
import 'package:ztech_mobile_application/services/social_service.dart';
import 'package:ztech_mobile_application/services/resident_service.dart';

class ResidenteService {
  final ApiService apiService;

  ResidenteService({required this.apiService});
  /*// Obtener todos los servicios sociales (retorna lista)
  Future<List<SocialService>> getAllSocialServices() async {
    final response = await apiService.get('/social-services');
    return response.map<SocialService>((json) => SocialService.fromJson(json)).toList();
  }*/

  // Crear un nuevo servicio social
  Future<Map<String, dynamic>> createIdentification(Map<String, dynamic> identificationData) async {
    return await apiService.post('/residente', identificationData); // Usamos el endpoint específico
  }



Future<List<Resident>> getAllSIdentifications() async {
  final response = await apiService.get('/residente');
  return response.map<Resident>((json) => Resident.fromJson(json)).toList();
}


// En tu servicio donde manejas identification, por ejemplo SocialServicesService o IdentificationService

Future<Map<String, dynamic>?> loginByIdDigital(String idDigital) async {
  try {
    final response = await apiService.post('/residente/login', {
      'idDigital': idDigital,
    });
    return response;  // Esperamos JSON con los datos del usuario, incluyendo isAdmin
  } catch (e) {
    if (e.toString().contains('404')) {
      return null;  // No existe idDigital
    }
    rethrow;  // Otros errores
  }
}

Future<Map<String, dynamic>> getIdentificationById(int id) async {
  return await apiService.getById('/residente/id/$id');
}
  
}