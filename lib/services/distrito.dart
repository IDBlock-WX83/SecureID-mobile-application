import 'package:ztech_mobile_application/services/provincia.dart';

class Distrito {
  final int id;
  final String distrito;
  final Provincia provincia;

  Distrito({required this.id, required this.distrito, required this.provincia});

  factory Distrito.fromJson(Map<String, dynamic> json) {
    return Distrito(
      id: json['id'],
      distrito: json['distrito'],
      provincia: Provincia.fromJson(json['provincia']),  // Parseo de la provincia
    );
  }
}
