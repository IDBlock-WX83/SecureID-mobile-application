class Sexo {
  final int id;
  final String sexo;

  Sexo({required this.id, required this.sexo});

  factory Sexo.fromJson(Map<String, dynamic> json) {
    return Sexo(
      id: json['id'],
      sexo: json['sexo'],
    );
  }
}
