class SocialService {
  final String resumen;
  final String lugar;
  final String hora;
  final String fecha;
  final String descripcion;

  SocialService({
    required this.resumen,
    required this.lugar,
    required this.hora,
    required this.fecha,
    required this.descripcion,
  });

  factory SocialService.fromJson(Map<String, dynamic> json) {
    return SocialService(
      resumen: json['resumen'],
      lugar: json['lugar'],
      hora: json['hora'],
      fecha: json['fecha'],
      descripcion: json['descripcion'],
    );
  }
}
