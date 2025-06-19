import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/core/http/SocialServicesService.dart';
import 'package:ztech_mobile_application/core/http/ApiService.dart';
import 'package:ztech_mobile_application/services/resident_service.dart';
import 'package:ztech_mobile_application/menu/identity/identity_admin_screen.dart';

import 'dart:convert'; // Asegúrate que esté importado también
import 'dart:typed_data';

class ResidentsScreen extends StatefulWidget {
  @override
  _ResidentsScreenState createState() => _ResidentsScreenState();
}

class _ResidentsScreenState extends State<ResidentsScreen> {
  final ApiService apiService = ApiService();
  late SocialServicesService socialServicesService;
  late Future<List<Resident>> _futureResidents;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    socialServicesService = SocialServicesService(apiService: apiService);
    _futureResidents = _fetchResidents();
  }

  Future<List<Resident>> _fetchResidents() async {
    try {
      final residents = await socialServicesService.getAllSIdentifications();
      print('📦 Datos obtenidos de la API:');
      for (var r in residents) {
        print('➡️ ${r.preNombres} - ID Digital: ${r.idDigital}');
      }
      return residents;
    } catch (e) {
      
      print('Error al cargar residentes: $e');
      throw Exception('Error al cargar residentes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00747C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Residentes',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF00747C),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300], // Fondo gris claro
                hintText: 'Buscar por nombre o ID Digital',
                hintStyle:
                    const TextStyle(color: Colors.black87), // Texto gris oscuro
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(8.0), // Bordes redondeados
                  borderSide: BorderSide.none, // Sin borde visible
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Resident>>(
              future: _futureResidents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No hay residentes disponibles.'));
                } else {
                  final residents = snapshot.data!
                      .where((r) =>
                          r.preNombres
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()) ||r.primerApellido
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()) ||r.segundoApellido
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()) ||
                          r.idDigital.contains(searchQuery))
                      .toList();

                  return ListView.builder(
                    itemCount: residents.length,
                    itemBuilder: (context, index) {
                      final resident = residents[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 6.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading: CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.grey[400],
                              child: (resident.foto != null &&
                                      resident.foto.isNotEmpty)
                                  ? ClipOval(
                                      child: Image.memory(
                                        base64Decode(resident
                                            .foto), // decodificar base64 a bytes
                                        fit: BoxFit.cover,
                                        width: 56,
                                        height: 56,
                                      ),
                                    )
                                  : const Icon(Icons.person,
                                      size: 28, color: Colors.white),
                            ),
                            title: Text(
                              'Nombre: ${resident.preNombres} ${resident.primerApellido} ${resident.segundoApellido}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'ID Digital: ${resident.idDigital}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 18),
                            onTap: () {
                              // Acción al tocar el elemento (por ejemplo, navegar a detalle)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      IdentityAdminScreen(resident: resident),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
