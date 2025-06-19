import 'package:ztech_mobile_application/core/http/ApiService.dart';
import 'package:ztech_mobile_application/services/social_service.dart';
import 'package:ztech_mobile_application/services/resident_service.dart';

class SocialServicesService {
  final ApiService apiService;

  SocialServicesService({required this.apiService});
  /*// Obtener todos los servicios sociales (retorna lista)
  Future<List<SocialService>> getAllSocialServices() async {
    final response = await apiService.get('/social-services');
    return response.map<SocialService>((json) => SocialService.fromJson(json)).toList();
  }*/
Future<SocialService> getSocialServiceById(int id) async {
  final response = await apiService.getById('/social-services/id/$id');
  return SocialService.fromJson(response);
}



  // Obtener todos los servicios sociales por tipo (retorna lista)
Future<List<SocialService>> getSocialServicesByTypeAndNotExpired(String type) async {
  final response = await apiService.get('/social-services/type/$type/not-expired');
  return response.map<SocialService>((json) => SocialService.fromJson(json)).toList();
}



  // Crear un nuevo servicio social
  Future<Map<String, dynamic>> createSocialService(Map<String, dynamic> socialServiceData) async {
    return await apiService.post('/social-services', socialServiceData); // Usamos el endpoint específico
  }

   // Método DELETE para eliminar un servicio social
  Future<void> deleteSocialService(int id) async {
    await apiService.delete('/social-services/$id'); // Usamos el endpoint DELETE
  }

  // Actualizar un servicio social por ID
Future<Map<String, dynamic>> updateSocialService(int id, Map<String, dynamic> socialServiceData) async {
  return await apiService.putById('/social-services/$id', socialServiceData);
}

  // Crear un nuevo servicio social
  Future<Map<String, dynamic>> createIdentification(Map<String, dynamic> identificationData) async {
    return await apiService.post('/identification', identificationData); // Usamos el endpoint específico
  }



Future<List<Resident>> getAllSIdentifications() async {
  final response = await apiService.get('/identification');
  return response.map<Resident>((json) => Resident.fromJson(json)).toList();
}


// En tu servicio donde manejas identification, por ejemplo SocialServicesService o IdentificationService

Future<Map<String, dynamic>?> loginByIdDigital(String idDigital) async {
  try {
    final response = await apiService.post('/identification/login', {
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
  return await apiService.getById('/identification/id/$id');
}
  
}