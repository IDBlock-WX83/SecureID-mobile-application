import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/common/utils/blockchain_record.dart'; // Asegúrate de que esta ruta es correcta

class TransactionHistoryScreen extends StatefulWidget {
  final Blockchain blockchain; // Agregar el parámetro

  TransactionHistoryScreen({required this.blockchain}); // Modificar el constructor

  @override
  _TransactionHistoryScreenState createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    // Usar la instancia de blockchain pasada
    final transactions = widget.blockchain.chain;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Transacciones Blockchain'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: transactions.isEmpty
            ? Center(child: Text('No hay transacciones registradas.'))
            : ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text('Transacción ${transaction.index}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Datos: ${transaction.data}'),
                    Text('Fecha: ${transaction.timestamp}'),
                    Text('Hash: ${transaction.hash}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para agregar una nueva transacción (ejemplo)
          final newTransactionData = 'Nueva transacción agregada';
          widget.blockchain.addBlock(newTransactionData);
          setState(() {}); // Actualiza la UI después de agregar
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
