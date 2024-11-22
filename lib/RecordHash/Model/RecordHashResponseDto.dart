class RecordHashResponseDto {
  final int? id; // Usa int? para permitir valores nulos.
  final String hash;
  final String previousHash;

  // Constructor
  RecordHashResponseDto({
    this.id,
    required this.hash,
    required this.previousHash,
  });

  // Método para deserializar un JSON a un objeto RecordHashResponseDto.
  factory RecordHashResponseDto.fromJson(Map<String, dynamic> json) {
    return RecordHashResponseDto(
      id: json['id'] != null ? json['id'] as int : null, // Manejo de valores nulos
      hash: json['hash'] ?? '',
      previousHash: json['previousHash'] ?? '',
    );
  }

  // Método para serializar un objeto RecordHashResponseDto a JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hash': hash,
      'previousHash': previousHash,
    };
  }
}
