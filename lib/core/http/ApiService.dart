import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ztech_mobile_application/core/http/ApiConfig.dart';
import 'dart:isolate'; // Importa Isolate

class ApiService {
  final String baseUrl = ApiConfig.baseUrl;

  // Método GET para obtener una lista de elementos
  Future<List<dynamic>> get(String endpoint) async {
    final response = await http.get(
      Uri.parse(baseUrl + endpoint),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // ✅ Decodifica correctamente con UTF-8
      final decoded = utf8.decode(response.bodyBytes);
      return json.decode(decoded); // Ya sin problemas con la ñ o tildes
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  // Nuevo método GET para obtener un solo elemento por ID
  Future<Map<String, dynamic>> getById(String endpoint) async {
  final response = await http.get(
    Uri.parse(baseUrl + endpoint),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final decoded = utf8.decode(response.bodyBytes);
    final jsonData = json.decode(decoded);

    if (jsonData is List && jsonData.isNotEmpty) {
      return jsonData[0];  // Retorna el primer objeto si es lista
    } else if (jsonData is Map<String, dynamic>) {
      return jsonData;     // Ya es un objeto
    } else {
      throw Exception('Formato de datos inesperado');
    }
  } else {
    throw Exception('Failed to fetch data');
  }
}


  // Método POST para enviar datos
  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to send data');
    }
  }

  // Método DELETE para eliminar un servicio social
  Future<void> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse(baseUrl + endpoint),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 204) {
      print(response.statusCode);
      throw Exception('Failed to delete data');
    }
  }

Future<Map<String, dynamic>> putById(String endpoint, Map<String, dynamic> data) async {
  final response = await http.put(
    Uri.parse(baseUrl + endpoint),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(data),
  );

  if (response.statusCode == 200) {
    final decoded = utf8.decode(response.bodyBytes);
    return json.decode(decoded);
  } else {
    throw Exception('Failed to update data');
  }
}

}
