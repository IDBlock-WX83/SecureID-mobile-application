import 'package:ztech_mobile_application/core/http/ApiService.dart';
import 'package:ztech_mobile_application/services/autoridad_service.dart';

class Autoridadservice {
  final ApiService apiService;

  Autoridadservice({required this.apiService});
  /*// Obtener todos los servicios sociales (retorna lista)
  Future<List<SocialService>> getAllSocialServices() async {
    final response = await apiService.get('/social-services');
    return response.map<SocialService>((json) => SocialService.fromJson(json)).toList();
  }*/

  // Crear un nuevo servicio social
  Future<Map<String, dynamic>> createAutoridad(Map<String, dynamic> autoridadData) async {
    return await apiService.post('/autoridad', autoridadData); // Usamos el endpoint específico
  }



Future<List<Autoridad>> getAllSAutoridades() async {
  final response = await apiService.get('/autoridad');
  return response.map<Autoridad>((json) => Autoridad.fromJson(json)).toList();
}


// En tu servicio donde manejas identification, por ejemplo SocialServicesService o IdentificationService

Future<Map<String, dynamic>?> loginByIdDigital(String idDigital) async {
  try {
    final response = await apiService.post('/autoridad/login', {
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

  
}