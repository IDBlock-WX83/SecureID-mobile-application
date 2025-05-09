import 'package:flutter/material.dart';


class SuccessRegisterSaludPopup extends StatelessWidget {
  final VoidCallback onProfileClick;

  const SuccessRegisterSaludPopup({Key? key, required this.onProfileClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(20.0),
      content: Column(
        mainAxisSize: MainAxisSize.min, // Tamaño mínimo para el diálogo
        children: [
          Text(
            '¡Registro exitoso!',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10), // Espacio entre los textos
          Text(
            'Difusión del servicio creada satisfactoriamente.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          SizedBox(height: 20), // Espacio antes del texto clickeable
          TextButton(
            onPressed: () {
              onProfileClick(); // Llama a la función proporcionada
              Navigator.of(context).pop(); // Cierra el diálogo
              {
                    Navigator.pushNamed(context, 'servicios_administrador');
                  };
            },
            child: Text(
              'Aceptar',
              style: TextStyle(color: Color(0xFF0C59A2),fontSize: 16), // Color del texto clickeable
            ),
          ),
        ],
      ),
    );
  }
}
