class EstadoCivil {
  final int id;
  final String estadoCivil;

  EstadoCivil({required this.id, required this.estadoCivil});

  factory EstadoCivil.fromJson(Map<String, dynamic> json) {
    return EstadoCivil(
      id: json['id'],
      estadoCivil: json['estadoCivil'],
    );
  }
}
