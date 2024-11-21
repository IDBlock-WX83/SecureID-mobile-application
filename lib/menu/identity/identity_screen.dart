import 'dart:convert'; // Para codificar y decodificar JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Para realizar solicitudes HTTP
import 'package:shared_preferences/shared_preferences.dart';

class IdentityScreen extends StatefulWidget {
  @override
  _IdentityScreenState createState() => _IdentityScreenState();
}

class _IdentityScreenState extends State<IdentityScreen> {
  Map<String, dynamic> userData = {}; // Datos del usuario
  bool isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      // Recupera el idDigital almacenado en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final idDigital = prefs.getString('idDigital');

      if (idDigital != null) {
        // Realiza la solicitud al backend para obtener los datos del usuario
        final response = await http.get(
          Uri.parse("http://10.0.2.2:8080/api/blockchain/identification/$idDigital"),
          headers: {
            "Content-Type": "application/json",
          },
        );

        if (response.statusCode == 200) {
          setState(() {
            userData = json.decode(response.body); // Decodifica los datos del usuario
            isLoading = false;
          });
        } else {
          throw Exception("Error ${response.statusCode}: ${response.body}");
        }
      } else {
        throw Exception("No se encontró el idDigital en SharedPreferences");
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // Muestra un error en pantalla
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar los datos: $error")),
      );
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
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Indicador de carga
          : userData.isEmpty
              ? Center(child: Text("No se encontraron datos del usuario"))
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
                          backgroundImage: const AssetImage('assets/user.png'), // Imagen desde el JSON
                        ),
                      ),
                      SizedBox(height: 10), // Espacio debajo de la imagen
                      Text('ID Digital: ${userData['idDigital']}', style: TextStyle(fontSize: 18)), // Ejemplo de DNI
                      Divider(thickness: 1), // Línea de separación

                      // Información personal
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Primer nombre', style: TextStyle(fontSize: 16)),
                              Text(userData['preNombres'] ?? '-', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Primer apellido', style: TextStyle(fontSize: 16)),
                              Text(userData['apellidoPaterno'] ?? '-', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Segundo apellido', style: TextStyle(fontSize: 16)),
                              Text(userData['apellidoMaterno'] ?? '-', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                              Text(userData['fechaNacimiento'] ?? '-', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Telefono', style: TextStyle(fontSize: 16)),
                              Text(userData['telefono'] ?? '-', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Sexo', style: TextStyle(fontSize: 16)),
                              Text(userData['sexo'] ?? '-', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ],
                      ),
                                            Divider(thickness: 1), // Línea de separación

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Provincia', style: TextStyle(fontSize: 16)),
                              Text(userData['provincia'] ?? '-', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Region', style: TextStyle(fontSize: 16)),
                              Text(userData['region'] ?? '-', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Distrito', style: TextStyle(fontSize: 16)),
                              Text(userData['distrito'] ?? '-', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ],
                      ),
                      Divider(thickness: 1), // Línea de separación

                      // Dirección
                      Text('Dirección:', style: TextStyle(fontSize: 16)),
                      Text(userData['direccion'] ?? '-', style: TextStyle(fontSize: 20)), // Dirección desde el JSON
                      
                      
                      Divider(thickness: 1), // Línea de separación
                    
                    
                    
                    ],
                  ),
                ),
    );
  }
}
