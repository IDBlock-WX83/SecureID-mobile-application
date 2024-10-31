import 'package:flutter/material.dart';

class DNIScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00747C), // Color primario
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Flecha hacia atrás
          onPressed: () {
            Navigator.of(context).pop(); // Volver a la pantalla anterior
          },
        ),
        title: Text(
          'Imagen de Documentos',
          style: TextStyle(color: Colors.white), // Texto en blanco
        ),
      ),
      body: Container(
        color: Colors.white, // Fondo blanco
        child: Center( // Centrar el contenido en el medio de la pantalla
          child: Column(
            mainAxisSize: MainAxisSize.min, // Usar tamaño mínimo para la columna
            children: [
              SizedBox(height: 20), // Espacio en la parte superior
              _buildIDImage('URL_IMAGEN_FRONTAL'), // Cambia por la URL de la imagen frontal
              SizedBox(height: 20), // Espacio entre imágenes
              _buildIDImage('URL_IMAGEN_TRASERA'), // Cambia por la URL de la imagen trasera
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIDImage(String imageUrl) {
    return Container(
      width: 300, // Ancho de la imagen
      height: 180, // Alto de la imagen
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Bordes redondeados
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Sombra
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // Posición de la sombra
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10), // Bordes redondeados para la imagen
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover, // Ajustar la imagen para que cubra todo el contenedor
        ),
      ),
    );
  }
}
