import 'package:flutter/material.dart';

class IdentityScreen extends StatelessWidget {
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
          'Documento de Identidad',
          style: TextStyle(color: Colors.white), // Texto en blanco
        ),
      ),
      body: Container(
        color: Colors.white, // Fondo blanco
        padding: EdgeInsets.all(20), // Espacio alrededor del contenido
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinear a la izquierda
          children: [
            // Imagen de perfil
            Center(
              child: CircleAvatar(
                radius: 50, // Tamaño de la imagen de perfil
                backgroundImage: NetworkImage('URL_IMAGEN_PERFIL'), // Cambia por la URL de la imagen
              ),
            ),
            SizedBox(height: 10), // Espacio debajo de la imagen
            Text('DNI: 12345678', style: TextStyle(fontSize: 18)), // Ejemplo de DNI
            Divider(thickness: 1), // Línea de separación

            // Información personal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Primer nombre', style: TextStyle(fontSize: 16)),
                    Text('JHON', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Primer apellido', style: TextStyle(fontSize: 16)),
                    Text('Doe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Segundo apellido', style: TextStyle(fontSize: 16)),
                    Text('Boe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            Divider(thickness: 1), // Línea de separación

            // Información adicional
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nacimiento', style: TextStyle(fontSize: 16)),
                    Text('20-02-2020', style: TextStyle(fontSize: 20)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sexo', style: TextStyle(fontSize: 16)),
                    Text('M', style: TextStyle(fontSize: 20)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estado Civil', style: TextStyle(fontSize: 16)),
                    Text('S', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ],
            ),
            Divider(thickness: 1), // Línea de separación

            // Ubicación
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Región', style: TextStyle(fontSize: 16)),
                    Text('Lima', style: TextStyle(fontSize: 20)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Provincia', style: TextStyle(fontSize: 16)),
                    Text('Lima', style: TextStyle(fontSize: 20)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Distrito', style: TextStyle(fontSize: 16)),
                    Text('Lima', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ],
            ),
            Divider(thickness: 1), // Línea de separación

            // Dirección
            Text('Dirección:', style: TextStyle(fontSize: 16)),
            Text('Av. Lima 123', style: TextStyle(fontSize: 20)), // Ejemplo de dirección
            Divider(thickness: 1), // Línea de separación

            // Espacio para la firma digital
            Text('Firma Digital:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10), // Espacio entre texto y firma
            Container(
              width: 200, // Ancho del espacio para la firma
              height: 100, // Alto del espacio para la firma
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2), // Borde alrededor del contenedor
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // Bordes redondeados para la imagen
                child: Image.network(
                  'URL_FIRMA_DIGITAL', // Cambia por la URL de la firma digital
                  fit: BoxFit.cover, // Ajustar la imagen para que cubra todo el contenedor
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
