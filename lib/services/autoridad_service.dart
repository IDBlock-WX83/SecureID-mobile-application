import 'package:ztech_mobile_application/services/distrito.dart';
import 'package:ztech_mobile_application/services/estado_civil.dart.dart';
import 'package:ztech_mobile_application/services/sexo.dart';

class Autoridad {
  final int id;
  final String preNombres;
  final String primerApellido;
  final String segundoApellido;
  final String fechaNacimiento;
  final Sexo sexo;
  final EstadoCivil estadoCivil;  // Cambiar a tipo EstadoCivil
  final String fechaInscripcion;
  final String direccion;
  final Distrito distrito;
  final String telefonoCelular;
  final String idDigital;

  Autoridad({
    required this.id,
    required this.preNombres,
    required this.primerApellido,
    required this.segundoApellido,
    required this.fechaNacimiento,
    required this.sexo,
    required this.estadoCivil,  // Cambiar a tipo EstadoCivil
    required this.fechaInscripcion,
    required this.direccion,
    required this.distrito,
    required this.telefonoCelular,
    required this.idDigital,
  });

  factory Autoridad.fromJson(Map<String, dynamic> json) {
    return Autoridad(
      id: json['id'],
      preNombres: json['preNombres'],
      primerApellido: json['primerApellido'],
      segundoApellido: json['segundoApellido'],
      fechaNacimiento: json['fechaNacimiento'],
      sexo: Sexo.fromJson(json['sexo']),  
      estadoCivil: EstadoCivil.fromJson(json['estadoCivil']),  // Parseo de estadoCivil
      fechaInscripcion: json['fechaInscripcion'],
      direccion: json['direccion'],
      distrito: Distrito.fromJson(json['distrito']),  // Parseo del Distrito
      telefonoCelular: json['telefonoCelular'] ?? '',
      idDigital: json['idDigital'],
    );
  }
}
