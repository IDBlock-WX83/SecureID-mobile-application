import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/RecordHash/Model/RecordHashResponseDto.dart';
import 'package:ztech_mobile_application/RecordHash/Services/RecordHash_Api_Service.dart';

class TransactionHistoryScreen extends StatefulWidget {
  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late Future<List<RecordHashResponseDto>> _blockchainHistory;

  @override
  void initState() {
    super.initState();
    // Inicializa la carga del historial de bloques
    _blockchainHistory = RecordHashApiService().getBlockchain();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction History"),
        backgroundColor: Color(0xFF00747C), // Color de fondo del AppBar
      ),
      body: Container(
        color: Color(0xFF00747C), // Color de fondo de la pantalla
        child: FutureBuilder<List<RecordHashResponseDto>>(
          future: _blockchainHistory,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // Muestra cargando
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.white), // Texto de error visible
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No transactions found",
                  style: TextStyle(color: Colors.white), // Texto visible en fondo oscuro
                ),
              );
            } else {
              final blocks = snapshot.data!; // Listado de bloques

              return ListView.builder(
                itemCount: blocks.length,
                padding: EdgeInsets.all(8.0),
                itemBuilder: (context, index) {
                  final block = blocks[index];
                  return Card(
                    color: Colors.white, // Fondo del Card en blanco
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        'Blockchain ${block.id ?? ''}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Título en negrita
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hash: ${block.hash}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Subtítulo en negrita
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Previous Hash: ${block.previousHash}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Subtítulo en negrita
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
