import 'package:ztech_mobile_application/services/distrito.dart';
import 'package:ztech_mobile_application/services/estado_civil.dart.dart';
import 'package:ztech_mobile_application/services/sexo.dart';

class Resident {
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
  final String firmaHash;
  final String idDigital;
  final String fotoHash;
  final String txHash;

  Resident({
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
    required this.firmaHash,
    required this.idDigital,
    required this.fotoHash,
    required this.txHash,
  });

  factory Resident.fromJson(Map<String, dynamic> json) {
    return Resident(
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
      idDigital: json['idDigital'],
      telefonoCelular: json['telefonoCelular'] ?? '',
      fotoHash: json['fotoHash'] ?? '',
      firmaHash: json['firmaHash'] ?? '',
      txHash: json['txHash']?? '',

    );
  }
}
