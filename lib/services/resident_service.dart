class Resident {
  final int id;
  final String preNombres;
  final String primerApellido;
  final String segundoApellido;
  final String fechaNacimiento;
  final String sexo;
  final String estadoCivil;
  final String fechaInscripcion;
  final String direccion;
  final String departamento;
  final String provincia;
  final String distrito;
  final String telefonoCelular;
  final String firma;
  final String idDigital;
  final String foto;

  Resident({
    required this.id,
    required this.preNombres,
    required this.primerApellido,
    required this.segundoApellido,
    required this.fechaNacimiento,
    required this.sexo,
    required this.estadoCivil,
    required this.fechaInscripcion,
    required this.direccion,
    required this.departamento,
    required this.provincia,
    required this.distrito,
    required this.telefonoCelular,
    required this.firma,
    required this.idDigital,
    required this.foto,
  });

  factory Resident.fromJson(Map<String, dynamic> json) {
    return Resident(
      id: json['id'],
      preNombres: json['preNombres'],
      primerApellido: json['primerApellido'],
      segundoApellido: json['segundoApellido'],
      fechaNacimiento: json['fechaNacimiento'],
      sexo: json['sexo'],
      estadoCivil: json['estadoCivil'],
      fechaInscripcion: json['fechaInscripcion'],
      direccion: json['direccion'],
      departamento: json['departamento'],
      provincia: json['provincia'],
      distrito: json['distrito'],
      telefonoCelular: json['telefonoCelular'],
      firma: json['firma'],
      idDigital: json['idDigital'],
      foto: json['foto'],
    );
  }
}
