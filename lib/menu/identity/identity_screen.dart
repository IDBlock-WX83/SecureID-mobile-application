import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class IdentityScreen extends StatefulWidget {
  @override
  _IdentityScreenState createState() => _IdentityScreenState();
}

class _IdentityScreenState extends State<IdentityScreen> {
  Map<String, dynamic> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        setState(() {
          userData = args;
          isLoading = false;
        });
      }
    });
  }


  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateString; // Si no se puede parsear, se muestra tal cual
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00747C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Identificación',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFC7C7CC),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 100,
                backgroundColor: Colors.grey[400],
                child: (userData['foto']!= null &&
                        userData['foto'].isNotEmpty)
                    ? ClipOval(
                        child: Image.memory(
                          base64Decode(userData['foto']), // decodificar base64 a bytes
                          fit: BoxFit.cover,
                          width: 200,
                          height: 200,
                        ),
                      )
                    : const Icon(Icons.person, size: 28, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                'ID Digital: ${userData['idDigital'] ?? '---'}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Divider(
                thickness: 2,
                color: Colors.black, // Cambiar color a negro
              ),
              _buildTripleRow(
                'Pre nombres',
                '${userData['preNombres'] ?? '---'}',
                'Primer Apellido',
                '${userData['primerApellido'] ?? '---'}',
                'Segundo Apellido',
                '${userData['segundoApellido'] ?? '---'}',
              ),
              const Divider(
                thickness: 2,
                color: Colors.black, // Cambiar color a negro
              ),
              _buildTripleRow(
                'Fecha de Nacimiento',
                formatDate('${userData['fechaNacimiento'] ?? '---'}'),
                'Sexo',
                '${userData['sexo'] ?? '---'}',
                'Estado civil',
                '${userData['estadoCivil'] ?? '---'}',
              ),
              const Divider(
                thickness: 2,
                color: Colors.black, // Cambiar color a negro
              ),
              _buildDoubleRow(
                'Fecha de Inscripción',
                formatDate('${userData['fechaInscripcion'] ?? '---'}'),
                'Dirección',
                '${userData['direccion'] ?? '---'}',
              ),
              const Divider(
                thickness: 2,
                color: Colors.black, // Cambiar color a negro
              ),
              _buildTripleRow(
                'Departamento',
                '${userData['departamento'] ?? '---'}',
                'Provincia',
                '${userData['provincia'] ?? '---'}',
                'Distrito',
                '${userData['distrito'] ?? '---'}',
              ),
              const Divider(
                thickness: 2,
                color: Colors.black, // Cambiar color a negro
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Firma', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 10),
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12), // Bordes redondeados
                ),
                child: userData['firma']!= null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                            12), // Bordes redondeados también aquí
                        child: Image.memory(
                          base64Decode(userData['firma']),
                          fit: BoxFit.fill,
                        ),
                      )
                    : const Center(child: Text('Sin firma')),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 Aquí corregimos: ahora los tres bloques se alinean arriba si un nombre es más largo
  Widget _buildTripleRow(String label1, String? value1, String label2,
      String? value2, String label3, String? value3) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildInfoColumn(label1, value1)),
          Expanded(child: _buildInfoColumn(label2, value2)),
          Expanded(child: _buildInfoColumn(label3, value3)),
        ],
      ),
    );
  }

  /// 🔥 Aquí también corregimos el doble bloque
  Widget _buildDoubleRow(
      String label1, String? value1, String label2, String? value2) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildInfoColumn(label1, value1)),
          Expanded(child: _buildInfoColumn(label2, value2)),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            value ?? '-',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
