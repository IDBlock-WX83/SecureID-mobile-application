class Departamento {
  final int id;
  final String departamento;

  Departamento({required this.id, required this.departamento});

  factory Departamento.fromJson(Map<String, dynamic> json) {
    return Departamento(
      id: json['id'],
      departamento: json['departamento'],
    );
  }
}
