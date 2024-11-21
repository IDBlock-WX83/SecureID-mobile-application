import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _idController = TextEditingController();

  // Método para guardar el ID Digital en SharedPreferences
  Future<void> _saveIdDigital(String idDigital) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('idDigital', idDigital);
    print('ID Digital guardado: $idDigital');
  }

  // Método para validar si el ID Digital existe en la base de datos
  Future<bool> _validateIdDigital(String idDigital) async {
    final String url = "http://10.0.2.2:8080/api/blockchain/identification/exists/$idDigital";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result == true;
      } else {
        print("Error al validar ID Digital: ${response.statusCode}");
        return false;
      }
    } catch (error) {
      print("Error al conectar con la API: $error");
      return false;
    }
  }

  // Método para obtener los detalles de la identificación
  Future<Map<String, dynamic>?> _getIdentificationDetails(String idDigital) async {
    final String url = "http://10.0.2.2:8080/api/blockchain/identification/$idDigital";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error al obtener los detalles de la identificación: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      print("Error al conectar con la API: $error");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00747C),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bienvenido a SecureID',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/logosecureid.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'ID Digital',
                    labelStyle: const TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    fillColor: const Color(0xFFD9D9D9),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    final idDigital = _idController.text.trim();

                    if (idDigital.isNotEmpty) {
                      // Validar si el ID Digital existe
                      bool isValid = await _validateIdDigital(idDigital);

                      if (isValid) {
                        // Guardar el ID Digital en SharedPreferences
                        await _saveIdDigital(idDigital);

                        // Obtener los detalles de la identificación
                        final details = await _getIdentificationDetails(idDigital);

                        if (details != null) {
                          // Verificar el atributo "active"
                          if (details['active'] == true) {
                            Navigator.pushNamed(context, 'menu');
                          } else {
                            Navigator.pushNamed(context, 'user_menu');
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error al obtener detalles de la identificación.')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('ID Digital no existe.')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor, ingresa un ID Digital.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BBC9),
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'register');
                  },
                  child: const Text(
                    '¿No tienes cuenta?',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
