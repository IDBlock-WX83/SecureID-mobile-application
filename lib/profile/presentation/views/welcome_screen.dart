import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ztech_mobile_application/core/http/SocialServicesService.dart';
import 'package:ztech_mobile_application/core/http/ApiService.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _idController = TextEditingController();

  final socialServicesService = SocialServicesService(apiService: ApiService());

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

                // 👇 Aquí la parte adaptada a la imagen
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'ID Digital',
                      style: TextStyle(
                        color: Colors.white, // Texto blanco como fondo azul
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _idController,
                      decoration: InputDecoration(
                        filled: true,
                        hintText:
                            'ID Digital', // 👈 Esto es el placeholder dentro
                        hintStyle: const TextStyle(
                          color: Colors.black45, // Gris como tu imagen
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
                  ],
                ),

                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    final idDigital = _idController.text.trim();

                    if (idDigital.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Por favor, ingresa un ID Digital.')),
                      );
                      return;
                    }

                    try {
                      final userData = await socialServicesService
                          .loginByIdDigital(idDigital);

                      if (userData == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Ingresa un ID Digital válido.')),
                        );
                        return;
                      }

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setInt(
                          'userId', userData['id']); // Guarda el id interno
                      await prefs.setString('idDigital',
                          userData['idDigital']); // Guarda el idDigital
                      await prefs.setBool('isAdmin',
                          userData['isAdmin'] ?? false); // Guarda el rol

                      if (userData['isAdmin'] == true) {
                        Navigator.pushReplacementNamed(
                            context, 'menu'); // Página admin
                      } else {
                        Navigator.pushReplacementNamed(
                            context, 'menu_residentes'); // Página usuario
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al iniciar sesión: $e')),
                      );
                    }
                  },

                 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BBC9),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'registro_exitoso');
                  },
                  child: const Text(
                    '¿No tienes cuenta?',
                    style: TextStyle(
                      color: Colors.white,
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
