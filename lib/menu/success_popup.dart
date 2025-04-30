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
            '¡Bienvenido a SecureID!',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10), // Espacio entre los textos
          Text(
            'Parece que aún no tienes cuenta. Si deseas registrarte, por favor acércate al puesto más cercano. ¡Nuestro equipo estará encantado de ayudarte a obtener tu ID Digital de manera rápida y sencilla!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          SizedBox(height: 20), // Espacio antes del texto clickeable
          TextButton(
            onPressed: () {
              onProfileClick(); // Llama a la función proporcionada
              Navigator.of(context).pop(); // Cierra el diálogo
              {
                    Navigator.pushNamed(context, 'welcome');
                  };
            },
            child: Text(
              'Aceptar',
              style: TextStyle(color: Color(0xFF00747C),fontSize: 16), // Color del texto clickeable
            ),
          ),
        ],
      ),
    );
  }
}
