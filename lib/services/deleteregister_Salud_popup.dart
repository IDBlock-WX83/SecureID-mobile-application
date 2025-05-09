import 'package:flutter/material.dart';

class DeleteRegisterSaludPopup extends StatelessWidget {
  final VoidCallback onProfileClick;

  const DeleteRegisterSaludPopup({Key? key, required this.onProfileClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(20.0),
      content: Column(
        mainAxisSize: MainAxisSize.min, // Tamaño mínimo para el diálogo
        children: [
          Text(
            '¿Estás seguro de eliminar esta difusión?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20), // Espacio antes del texto clickeable

          // Row para alinear los botones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Botón Aceptar
              TextButton(
                onPressed: () {
                  onProfileClick(); // Llama a la función proporcionada
                  Navigator.of(context).pop(); // Cierra el diálogo
                  Navigator.pushNamed(context, 'healthlistadmin');
                },
                child: Text(
                  'Aceptar',
                  style: TextStyle(color: Color(0xFF0C59A2), fontSize: 16), // Color del texto clickeable
                ),
              ),

              // Botón Eliminar al costado de "Aceptar"
              TextButton(
                onPressed: () {
                  onProfileClick(); // Llama a la función proporcionada
                  Navigator.of(context).pop(); // Cierra el diálogo
                  Navigator.pushNamed(context, 'healthlistadmin');
                },
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Color(0xFFA20C0C), fontSize: 16), // Color rojo para "Eliminar"
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
