import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ztech_mobile_application/RecordHash/Model/RecordHashResponseDto.dart';


class RecordHashApiService {
  // Define la URL base de tu API
  final String _baseUrl = "https://secure-id.azurewebsites.net/api/blockchain";

  // Método para obtener el historial de bloques (Blockchain)
  Future<List<RecordHashResponseDto>> getBlockchain() async {
    final String url = "$_baseUrl/blocks";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        // Convierte la respuesta JSON a lista de RecordHashResponseDto
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => RecordHashResponseDto.fromJson(item)).toList();
      } else {
        throw Exception("Error ${response.statusCode}: ${response.body}");
      }
    } catch (error) {
      throw Exception("Error al conectarse a la API: $error");
    }
  }
}
