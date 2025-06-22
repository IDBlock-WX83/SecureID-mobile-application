import 'package:ztech_mobile_application/services/departamento.dart';

class Provincia {
  final int id;
  final String provincia;
  final Departamento departamento;

  Provincia({required this.id, required this.provincia, required this.departamento});

  factory Provincia.fromJson(Map<String, dynamic> json) {
    return Provincia(
      id: json['id'],
      provincia: json['provincia'],
      departamento: Departamento.fromJson(json['departamento']),  // Parseo del Departamento
    );
  }
}
