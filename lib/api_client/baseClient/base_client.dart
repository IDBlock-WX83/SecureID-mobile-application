
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/identification.dart';

const String baseUrl = 'http://10.0.2.2:8080/api/blockchain';

class BaseClient {
  var client = http.Client();

  // Metodo genérico para GET
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? params}) async {
    var url = Uri.parse(baseUrl + endpoint);

    // Agrega parámetros de consulta si existen
    if (params != null) {
      url = url.replace(queryParameters: params);
    }

    var response = await client.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error: ${response.statusCode}, ${response.reasonPhrase}');
    }
  }

  // Metodo específico para /getIdentification/{id}
  Future<dynamic> getIdentification(String id) async {
    final response = await get('/getIdentification/$id');
    final jsonData = json.decode(response);
    print(jsonData);
    return Identification.fromJson(jsonData);
  }
}