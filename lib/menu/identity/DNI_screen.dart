import 'dart:convert'; // Importa para decodificar el JSON
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../api_client/baseClient/base_client.dart';
import '../../api_client/models/identification.dart'; // Importa para cargar el archivo JSON

class DNIScreen extends StatefulWidget {
  @override
  _DNIScreenState createState() => _DNIScreenState();
}

class _DNIScreenState extends State<DNIScreen> {
  Identification? userData; // Variable para guardar el objeto del usuario
  final BaseClient _client = BaseClient(); // Instancia del cliente HTTP

  @override
  void initState() {
    super.initState();
    loadUserData("1");
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
          'Imagen de Documentos',
          style: TextStyle(color: Colors.white), // Texto en blanco
        ),
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator()) // Mostrar indicador de carga
          : Container(
        color: Colors.white, // Fondo blanco
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Usar tamaño mínimo para la columna
            children: [
              SizedBox(height: 20), // Espacio en la parte superior
              _buildIDImage(userData!.dniFrontal ?? ""), // Imagen frontal desde JSON
              SizedBox(height: 20), // Espacio entre imágenes
              _buildIDImage(userData!.dniPosterior ?? ""), // Imagen trasera desde JSON
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
          fit: BoxFit.cover, // Ajustar la imagen para que cubra
        ),
      ),
    );
  }
}
