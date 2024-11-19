class Identification {
  final int id;
  final String? preNombres; // Hacerlo nullable
  final String? apellidoPaterno; // Hacerlo nullable
  final String? apellidoMaterno; // Hacerlo nullable
  final String? idDigital; // Hacerlo nullable
  final String? fechaNacimiento; // Hacerlo nullable
  final String? direccion; // Hacerlo nullable
  final String? telefono; // Hacerlo nullable
  final String? region; // Hacerlo nullable
  final String? provincia; // Hacerlo nullable
  final String? distrito; // Hacerlo nullable
  final String? sexo; // Hacerlo nullable
  final String? firma; // Hacerlo nullable
  final String? dniFrontal; // Hacerlo nullable
  final String? dniPosterior; // Hacerlo nullable
  final String? fotoPerfil;
  final bool active;

  Identification({
    required this.id,
    this.preNombres,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.idDigital,
    this.fechaNacimiento,
    this.direccion,
    this.telefono,
    this.region,
    this.provincia,
    this.distrito,
    this.sexo,
    this.firma,
    this.dniFrontal,
    this.dniPosterior,
    this.fotoPerfil,
    required this.active,
  });

  factory Identification.fromJson(Map<String, dynamic> json) {
    return Identification(
      id: json['id'],
      preNombres: json['preNombres'],
      apellidoPaterno: json['apellidoPaterno'],
      apellidoMaterno: json['apellidoMaterno'],
      idDigital: json['idDigital'],
      fechaNacimiento: json['fechaNacimiento'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      region: json['region'],
      provincia: json['provincia'],
      distrito: json['distrito'],
      sexo: json['sexo'],
      firma: json['firma'],
      dniFrontal: json['dniFrontal'],
      dniPosterior: json['dniPosterior'],
      fotoPerfil: json['fotoPerfil'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pre_nombres': preNombres,
      'apellido_paterno': apellidoPaterno,
      'apellido_materno': apellidoMaterno,
      'id_digital': idDigital,
      'fecha_nacimiento': fechaNacimiento,
      'direccion': direccion,
      'telefono': telefono,
      'region': region,
      'provincia': provincia,
      'distrito': distrito,
      'sexo': sexo,
      'firma': firma,
      'dni_frontal': dniFrontal,
      'dni_posterior': dniPosterior,
      'foto_perfil': fotoPerfil,
      'active': active,
    };
  }
}
