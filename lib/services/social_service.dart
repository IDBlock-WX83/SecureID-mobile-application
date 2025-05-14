import 'dart:ffi';

class SocialService {
  final int id;
  final String resumen;
  final String lugar;
  final String hora;
  final String fecha;
  final String descripcion;
  final String? imagen;  // Nuevo campo para la imagen (en formato base64 o URL)

  SocialService({
        required this.id,

    required this.resumen,
    required this.lugar,
    required this.hora,
    required this.fecha,
    required this.descripcion,
    this.imagen,  // El campo imagen es opcional
  });

  factory SocialService.fromJson(Map<String, dynamic> json) {
    return SocialService(
            id: json['id'],
      resumen: json['resumen'],
      lugar: json['lugar'],
      hora: json['hora'],
      fecha: json['fecha'],
      descripcion: json['descripcion'],
      imagen: json['imagen'],  // Asegúrate de que el campo 'imagen' esté presente en el JSON
    );
  }
}
