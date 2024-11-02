import 'dart:convert'; // Importa para decodificar el JSON
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importa para cargar el archivo JSON

class IdentityScreen extends StatefulWidget {
  @override
  _IdentityScreenState createState() => _IdentityScreenState();
}

class _IdentityScreenState extends State<IdentityScreen> {
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    // Cargar el archivo JSON
    final String response = await rootBundle.loadString('assets/user.json');
    final data = await json.decode(response);
    setState(() {
      userData = data;
    });
  }

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
      body: userData.isEmpty
          ? Center(child: CircularProgressIndicator()) // Mostrar un indicador de carga mientras se cargan los datos
          : Container(
        color: Colors.white, // Fondo blanco
        padding: EdgeInsets.all(20), // Espacio alrededor del contenido
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinear a la izquierda
          children: [
            // Imagen de perfil
            Center(
              child: CircleAvatar(
                radius: 50, // Tamaño de la imagen de perfil
                backgroundImage: NetworkImage(userData['profile_image']), // Imagen desde el JSON
              ),
            ),
            SizedBox(height: 10), // Espacio debajo de la imagen
            Text('DNI: ${userData['dni']}', style: TextStyle(fontSize: 18)), // Ejemplo de DNI
            Divider(thickness: 1), // Línea de separación

            // Información personal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Primer nombre', style: TextStyle(fontSize: 16)),
                    Text(userData['first_name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Primer apellido', style: TextStyle(fontSize: 16)),
                    Text(userData['last_name_1'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Segundo apellido', style: TextStyle(fontSize: 16)),
                    Text(userData['last_name_2'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                    Text(userData['birth_date'], style: TextStyle(fontSize: 20)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sexo', style: TextStyle(fontSize: 16)),
                    Text(userData['gender'], style: TextStyle(fontSize: 20)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estado Civil', style: TextStyle(fontSize: 16)),
                    Text(userData['civil_status'], style: TextStyle(fontSize: 20)),
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
                    Text(userData['region'], style: TextStyle(fontSize: 20)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Provincia', style: TextStyle(fontSize: 16)),
                    Text(userData['province'], style: TextStyle(fontSize: 20)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Distrito', style: TextStyle(fontSize: 16)),
                    Text(userData['district'], style: TextStyle(fontSize: 20)),
                  ],
                ),
              ],
            ),
            Divider(thickness: 1), // Línea de separación

            // Dirección
            Text('Dirección:', style: TextStyle(fontSize: 16)),
            Text(userData['address'], style: TextStyle(fontSize: 20)), // Dirección desde el JSON
            Divider(thickness: 1), // Línea de separación

            // Espacio para la firma digital
            Text('Firma Digital:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10), // Espacio entre texto y firma
            Container(
              width: MediaQuery.of(context).size.width , // Ancho del 80% del ancho de la pantalla
      height: MediaQuery.of(context).size.height * 0.15, // Alto del 15% de la altura de la pantalla
      decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2), // Borde alrededor del contenedor
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // Bordes redondeados para la imagen
                child: Image.network(
                  userData['digital_signature'], // Firma digital desde el JSON
                  fit: BoxFit.contain, // Ajustar la imagen para que cubra todo el contenedor
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
