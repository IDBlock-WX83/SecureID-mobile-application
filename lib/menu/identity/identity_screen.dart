import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
                radius: 70,
                backgroundImage: const AssetImage('assets/user.png'),
              ),
              const SizedBox(height: 10),
              Text(
                'ID Digital: ' '12345678',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
const Divider(
  thickness: 2,
  color: Colors.black,  // Cambiar color a negro
),              _buildTripleRow(
                'Pre nombres',
                'Juan Pedro Manuel',
                'Primer Apellido',
                'Valderrama',
                'Segundo Apellido',
                'Urrastegui',
              ),
const Divider(
  thickness: 2,
  color: Colors.black,  // Cambiar color a negro
),                 _buildTripleRow(
                'Fecha de Nacimiento',
                '20/07/2000',
                'Sexo',
                'Masculino',
                'Estado civil',
                'Soltero',
              ),
const Divider(
  thickness: 2,
  color: Colors.black,  // Cambiar color a negro
),                 _buildDoubleRow(
                'Fecha de Inscripción',
                '20/07/2000',
                'Dirección',
                'Av. Javier Prado #12312',
              ),
const Divider(
  thickness: 2,
  color: Colors.black,  // Cambiar color a negro
),                 _buildTripleRow(
                'Departamento',
                'Lima',
                'Provincia',
                'Lima',
                'Distrito',
                'San Borja',
              ),
const Divider(
  thickness: 2,
  color: Colors.black,  // Cambiar color a negro
),                 const Align(
                alignment: Alignment.centerLeft,
                child: Text('Firma', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 10),
              Container(
                height: 80,
                width: double.infinity,
                color: Colors.white,
                child: userData['firma'] != null
                    ? Image.memory(base64Decode(userData['firma']))
                    : const Center(child: Text('Sin firma')),
              ),

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


//descomentar cuando tenga api:
/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final idDigital = prefs.getString('idDigital');

      if (idDigital != null) {
        final response = await http.get(
          Uri.parse("http://10.0.2.2:8080/api/blockchain/identification/$idDigital"),
          headers: {
            "Content-Type": "application/json",
          },
        );

        if (response.statusCode == 200) {
          setState(() {
            userData = json.decode(response.body);
            isLoading = false;
          });
        } else {
          throw Exception("Error ${response.statusCode}: ${response.body}");
        }
      } else {
        throw Exception("No se encontró el idDigital en SharedPreferences");
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar los datos: $error")),
      );
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
        title: const Text('Identificación', style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData.isEmpty
              ? const Center(child: Text("No se encontraron datos del usuario"))
              : SingleChildScrollView(
                  child: Container(
                    color: const Color(0xFFC7C7CC),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: const AssetImage('assets/user.png'),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'ID Digital: ${userData['idDigital'] ?? '-'}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                                                const Divider(thickness: 3),

                        _buildTripleRow(
                          'Pre nombres', userData['preNombres'],
                          'Primer Apellido', userData['apellidoPaterno'],
                          'Segundo Apellido', userData['apellidoMaterno'],
                        ),
                        const Divider(thickness: 3),
                        _buildTripleRow(
                          'Fecha de Nacimiento', userData['fechaNacimiento'],
                          'Sexo', userData['sexo'],
                          'Estado civil', userData['estadoCivil'],
                        ),
                        const Divider(thickness: 3),
                        _buildDoubleRow(
                          'Fecha de Inscripción', userData['fechaInscripcion'],
                          'Dirección', userData['direccion'],
                        ),
                        const Divider(thickness: 3),
                        _buildTripleRow(
                          'Departamento', userData['region'],
                          'Provincia', userData['provincia'],
                          'Distrito', userData['distrito'],
                        ),
                        const Divider(thickness: 3),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Firma', style: TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 80,
                          width: double.infinity,
                          color: Colors.white,
                          child: userData['firma'] != null
                              ? Image.memory(base64Decode(userData['firma']))
                              : const Center(child: Text('Sin firma')),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  /// 🔥 Aquí corregimos: ahora los tres bloques se alinean arriba si un nombre es más largo
  Widget _buildTripleRow(String label1, String? value1, String label2, String? value2, String label3, String? value3) {
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
  Widget _buildDoubleRow(String label1, String? value1, String label2, String? value2) {
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

 */