import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ztech_mobile_application/InAppServices/Api/models/ScoialServicesUpdateDto.dart';
import 'package:ztech_mobile_application/InAppServices/Api/models/SocialServicesCreateDto.dart';
import 'package:ztech_mobile_application/InAppServices/Api/models/SocialServicesResponseDto.dart';

class SocialServiceApi {
  //final String baseUrl = 'http://10.0.2.2:8080/api/social-services';
  final String baseUrl = 'https://secure-id.azurewebsites.net/api/social-services';

  Future<List<SocialServiceResponse>> getSocialServicesByTypeAndNotExpired(
      String type) async {
    final response =
        await http.get(Uri.parse('$baseUrl/type/$type/not-expired'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => SocialServiceResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load services by type and not expired');
    }
  }

  Future<void> createSocialService(SocialServiceCreate service) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(service.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create social service');
    }
  }

  Future<http.Response> updateSocialService(
      int id, SocialServiceUpdate service) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(service.toJson()),
    );

    return response;
  }

  Future<void> deleteSocialService(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete social service');
    }
  }
}
