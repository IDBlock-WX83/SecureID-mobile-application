import 'dart:convert'; // Importa para decodificar el JSON
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../api_client/baseClient/base_client.dart';
import '../../api_client/models/identification.dart'; // Importa para cargar el archivo JSON

class IdentityScreen extends StatefulWidget {
  @override
  _IdentityScreenState createState() => _IdentityScreenState();
}

class _IdentityScreenState extends State<IdentityScreen> {
  Identification? userData; // Variable para guardar el objeto del usuario
  final BaseClient _client = BaseClient(); // Instancia del cliente HTTP

  @override
  void initState() {
    super.initState();
    // Llama a loadUserData con el ID necesario
    loadUserData('1');
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
      body: userData == null
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
                backgroundImage: NetworkImage(userData!.fotoPerfil ?? ""), // Imagen desde el JSON
              ),
            ),
            SizedBox(height: 10), // Espacio debajo de la imagen
            Text('DNI: ${userData!.idDigital ?? ""}', style: TextStyle(fontSize: 18)), // Ejemplo de DNI
            Divider(thickness: 1), // Línea de separación

            // Información personal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Primer nombre', style: TextStyle(fontSize: 16)),
                    Text(userData!.preNombres ?? "", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Primer apellido', style: TextStyle(fontSize: 16)),
                    Text(userData!.apellidoPaterno ?? "", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Segundo apellido', style: TextStyle(fontSize: 16)),
                    Text(userData!.apellidoMaterno ?? "", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                    Text(userData!.fechaNacimiento ?? "", style: TextStyle(fontSize: 20)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sexo', style: TextStyle(fontSize: 16)),
                    Text(userData!.sexo ?? "", style: TextStyle(fontSize: 20)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(' ', style: TextStyle(fontSize: 16)),
                    Text( "", style: TextStyle(fontSize: 20)),
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
                    Text(userData!.region ?? "", style: TextStyle(fontSize: 20)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Provincia', style: TextStyle(fontSize: 16)),
                    Text(userData!.provincia ?? "", style: TextStyle(fontSize: 20)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Distrito', style: TextStyle(fontSize: 16)),
                    Text(userData!.distrito ?? "", style: TextStyle(fontSize: 20)),
                  ],
                ),
              ],
            ),
            Divider(thickness: 1), // Línea de separación

            // Dirección
            Text('Dirección:', style: TextStyle(fontSize: 16)),
            Text(userData!.direccion ?? "", style: TextStyle(fontSize: 20)), // Dirección desde el JSON
            Divider(thickness: 1), // Línea de separación

            // Espacio para la firma digital
            Text('Firma Digital:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10), // Espacio entre texto y firma
            Container(
              width: MediaQuery.of(context).size.width , // Ancho del 80% del ancho de la pantalla
      height: MediaQuery.of(context).size.height * 0.15, // Alto del 15% de la altura de la pantalla
      decoration: BoxDecoration(
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // Bordes redondeados para la imagen
                child: Image.network(
                  userData!.firma ?? "", // Firma digital desde el JSON
                  fit: BoxFit.contain, // Ajustar la imagen para que cubra
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
