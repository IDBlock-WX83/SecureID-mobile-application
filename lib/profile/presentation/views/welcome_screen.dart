import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00747C),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
              // Campo de texto para ID Digital
              // Campo de texto para ID Digital
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  labelText:
                      'ID Digital', // Esto hará que el label sea flotante
                  labelStyle: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold), // Ajuste de estilo del label
                  fillColor: Color(0xFFD9D9D9), // Color de fondo del TextField
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20), // Ajuste de padding interno
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 30),
              // Botón de Entrar
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'user_menu');
                  //cuando es autoridad comentar
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00BBC9),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
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
    );
  }
}
