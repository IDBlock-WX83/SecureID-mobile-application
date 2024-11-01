import 'dart:convert';
import 'package:crypto/crypto.dart';

class Block {
  final int index; // Posición del bloque en la cadena
  final String timestamp; // Fecha de la transacción
  final String data; // Datos de la transacción
  final String prevHash; // Hash del bloque anterior
  late final String hash; // Hash de este bloque

  Block({
    required this.index,
    required this.timestamp,
    required this.data,
    required this.prevHash,
  }) {
    hash = _calculateHash();
  }

  // Genera el hash del bloque usando SHA-256
  String _calculateHash() {
    final content = '$index$timestamp$data$prevHash';
    return sha256.convert(utf8.encode(content)).toString();
  }
}

class Blockchain {
  final List<Block> _chain = [];

  Blockchain() {
    // Inicializa la cadena con un bloque génesis
    _chain.add(_createGenesisBlock());
  }

  Block _createGenesisBlock() {
    return Block(
      index: 0,
      timestamp: DateTime.now().toString(),
      data: 'Genesis Block',
      prevHash: '0',
    );
  }

  Block get latestBlock => _chain.last;

  // Agrega un nuevo bloque a la cadena
  void addBlock(String data) {
    final newBlock = Block(
      index: _chain.length,
      timestamp: DateTime.now().toString(),
      data: data,
      prevHash: latestBlock.hash,
    );
    _chain.add(newBlock);
  }

  // Obtiene la lista de bloques
  List<Block> get chain => List.unmodifiable(_chain);

  // Verifica la integridad de la cadena
  bool isChainValid() {
    for (int i = 1; i < _chain.length; i++) {
      final currentBlock = _chain[i];
      final previousBlock = _chain[i - 1];

      if (currentBlock.hash != currentBlock._calculateHash()) {
        return false;
      }
      if (currentBlock.prevHash != previousBlock.hash) {
        return false;
      }
    }
    return true;
  }
}
