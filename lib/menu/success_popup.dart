import 'package:flutter/material.dart';

import 'menu_screen.dart';

class SuccessPopup extends StatelessWidget {
  final VoidCallback onProfileClick;

  const SuccessPopup({Key? key, required this.onProfileClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(20.0),
      content: Column(
        mainAxisSize: MainAxisSize.min, // Tamaño mínimo para el diálogo
        children: [
          Text(
            'Registro exitoso',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10), // Espacio entre los textos
          Text(
            'La información se encriptará y almacenará de manera segura.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20), // Espacio antes del texto clickeable
          TextButton(
            onPressed: () {
              onProfileClick(); // Llama a la función proporcionada
              Navigator.of(context).pop(); // Cierra el diálogo
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuScreen()), // Navega a MenuScreen
              );
            },
            child: Text(
              'Ir a mi perfil',
              style: TextStyle(color: Color(0xFF00747C)), // Color del texto clickeable
            ),
          ),
        ],
      ),
    );
  }
}
