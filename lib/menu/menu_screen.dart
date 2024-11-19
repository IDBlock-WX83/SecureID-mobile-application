import 'dart:convert'; // Para convertir JSON
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // Para cargar el archivo JSON
import 'package:ztech_mobile_application/InAppServices/views/services_screen.dart';
import 'package:ztech_mobile_application/menu/identity/face_capture_screen.dart';
import 'package:ztech_mobile_application/menu/identity/identity_screen.dart';
import '../api_client/baseClient/base_client.dart';
import '../api_client/models/identification.dart';
import 'identity/DNI_screen.dart';
import 'success_popup.dart'; // Asegúrate de importar tu nuevo archivo

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Identification? userData; // Variable para guardar el objeto del usuario
  final BaseClient _client = BaseClient(); // Instancia del cliente HTTP

  @override
  void initState() {
    super.initState();
    loadUserData("1");
  }

  Future<void> loadUserData(id) async {
    try {
      final identification = await _client.getIdentification(id); // Usa el id que necesitas
      setState(() {
        userData = identification; // Asigna el objeto Identification al estado
      });
    } catch (e) {
      print("Error al cargar los datos del usuario: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00747C), // Color primario
        title: _buildAppBarContent(),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white), // Ícono para salir
            onPressed: () {
              // Lógica para salir del menú o de la aplicación
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MenuButton(
            text: 'Identificación',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IdentityScreen()), // Navegar al screen Identity
              );
            },
          ),
          MenuButton(
            text: 'DNI',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DNIScreen()), // Navegar al screen DNI
              );
            },
          ),
          MenuButton(
            text: 'Servicios',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ServicesScreen()),
              );
            },
          ),
          MenuButton(
            text: 'Historial de transacciones',
            onPressed: () {
              Navigator.pushNamed(context, 'record_screen');

            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20, // Radio del círculo para la foto de perfil
          backgroundImage: NetworkImage(userData!.fotoPerfil ?? "")
        ),
        SizedBox(width: 10), // Espacio entre la foto de perfil y el texto
        Text(
          'MENÚ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), // Texto en blanco
        ),
      ],
    );
  }
}

class MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MenuButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50), backgroundColor: Color(0xFF00747C), // Color del botón
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(color: Colors.white), // Texto en blanco
            ),
            Icon(Icons.arrow_forward, color: Colors.white), // Flecha en blanco
          ],
        ),
      ),
    );
  }
}
