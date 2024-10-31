import 'package:flutter/material.dart';

class FaceCaptureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00747C), // Color primario
      appBar: AppBar(
        backgroundColor: Color(0xFF00747C), // Fondo del AppBar
        elevation: 0, // Eliminar sombra del AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Flecha de retroceso
          onPressed: () {
            Navigator.pop(context); // Acción para retroceder
          },
        ),
      ),
      body: Center( // Centrar todo el contenido en el medio de la pantalla
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
          crossAxisAlignment: CrossAxisAlignment.center, // Centrar horizontalmente
          children: [
            // Texto superior
            Text(
              'Capturar rostro',
              style: TextStyle(
                color: Colors.white, // Texto en blanco
                fontSize: 24, // Tamaño del texto
                fontWeight: FontWeight.bold, // Texto en negrita
              ),
            ),
            SizedBox(height: 20), // Espacio debajo del texto

            // Círculo donde se capturará el rostro
            Container(
              width: 200, // Ancho del círculo
              height: 200, // Alto del círculo
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Hacer el contenedor circular
                color: Colors.grey[300], // Color de fondo del círculo
              ),
              child: Center(
                child: Text(
                  'Imagen aquí', // Texto de ejemplo, que luego puede ser reemplazado por la imagen del rostro
                  style: TextStyle(color: Colors.black), // Texto dentro del círculo
                ),
              ),
            ),
            SizedBox(height: 10), // Espacio debajo del círculo

            // Texto secundario
            Text(
              'Enfoque su rostro dentro del círculo',
              style: TextStyle(
                color: Colors.white, // Texto en blanco
                fontSize: 16, // Tamaño del texto
              ),
              textAlign: TextAlign.center, // Alinear el texto al centro
            ),
            SizedBox(height: 30), // Espacio antes del botón

            // Botón para capturar
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFF00747C), backgroundColor: Colors.white, // Color del texto del botón
                minimumSize: Size(150, 50), // Tamaño mínimo del botón
              ),
              onPressed: () {
                // Lógica para capturar la imagen
              },
              child: Text(
                'Capturar',
                style: TextStyle(fontSize: 18), // Tamaño del texto del botón
              ),
            ),
          ],
        ),
      ),
    );
  }
}
