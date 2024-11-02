import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/InAppServices/views/services_screen.dart';
import 'package:ztech_mobile_application/menu/identity/face_capture_screen.dart';
import 'package:ztech_mobile_application/menu/identity/identity_screen.dart';
import 'identity/DNI_screen.dart';
import 'success_popup.dart'; // Asegúrate de importar tu nuevo archivo

class MenuScreen extends StatelessWidget {
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
                MaterialPageRoute(builder: (context) => IdentityScreen()), // Navegar al screen DNI
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
          backgroundImage: NetworkImage('URL_DE_LA_IMAGEN'),
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
