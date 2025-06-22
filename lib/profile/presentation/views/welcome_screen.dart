import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ztech_mobile_application/core/http/AutoridadService.dart';
import 'package:ztech_mobile_application/core/http/ResidenteService.dart';
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

  final residenteService = ResidenteService(apiService: ApiService());
  final autoridadService = Autoridadservice(apiService: ApiService());

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

                    // Validación de si el ID Digital está vacío
                    if (idDigital.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Por favor, ingresa un ID Digital.')),
                      );
                      return;
                    }

                    // Validación de si el ID Digital tiene una longitud menor a 8
                    if (idDigital.length < 8) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'El ID Digital debe tener al menos 8 dígitos.')),
                      );
                      return;
                    }

                    try {
                      // Lógica para determinar si es residente o autoridad
                      var userData;

                      if (idDigital.length == 8) {
                        // Si tiene exactamente 8 dígitos, consulta la API para residentes
                        userData = await residenteService
                            .loginByIdDigital(idDigital);
                      } else if (idDigital.length > 8) {
                        // Si tiene más de 8 dígitos, consulta la API para autoridades
                        userData =
                            await autoridadService.loginByIdDigital(idDigital);
                      }

                      if (userData == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Ingresa un ID Digital válido.')),
                        );
                        return;
                      }

                      // Guardar los datos en SharedPreferences
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setInt(
                          'userId', userData['id']); // Guarda el id interno
                      await prefs.setString('idDigital',
                          userData['idDigital']); // Guarda el idDigital

                      // Redirigir dependiendo de la longitud del ID Digital
                      if (userData['idDigital'].length == 8) {
                        Navigator.pushReplacementNamed(
                            context, 'menu_residentes'); // Página de residentes
                      } else if (userData['idDigital'].length == 10) {
                        Navigator.pushReplacementNamed(
                            context, 'menu'); // Página de autoridades
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
