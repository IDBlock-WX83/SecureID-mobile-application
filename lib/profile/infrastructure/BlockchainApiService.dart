import 'dart:convert'; // Para codificar y decodificar JSON
import 'package:http/http.dart' as http;

class BlockchainApiService {
  // Define la URL base de tu API
  final String _baseUrl = "https://secure-id.azurewebsites.net/api/blockchain"; // Cambia a la IP correcta si es necesario

  // Método para añadir una identificación
  Future<Map<String, dynamic>> addIdentification(Map<String, dynamic> identificationData) async {
    final String url = "$_baseUrl/addIdentification";

    try {
      // Realiza la solicitud POST a la API
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json", // Asegúrate de enviar JSON
        },
        body: jsonEncode(identificationData), // Convierte el cuerpo a JSON
      );

      print('Respuesta de la API: ${response.body}'); // Imprimir la respuesta para depuración

      // Maneja la respuesta
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          return jsonDecode(response.body); // Decodifica la respuesta JSON
        } else {
          throw Exception("Respuesta vacía de la API");
        }
      } else {
        throw Exception("Error ${response.statusCode}: ${response.body}");
      }
    } catch (error) {
      throw Exception("Error al conectarse a la API: $error");
    }
  }

  Future<Map<String, dynamic>> getIdentification(String idDigital) async {
    final String url = "$_baseUrl/identification/$idDigital";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Error ${response.statusCode}: ${response.body}");
      }
    } catch (error) {
      throw Exception("Error al obtener identificación: $error");
    }
  }
}
