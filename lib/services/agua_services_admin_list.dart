import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/core/http/ApiService .dart'; // Importa ApiService
import 'package:ztech_mobile_application/core/http/SocialServicesService.dart'; // Importa SocialServicesService
import 'dart:async'; // Importa para usar TimeoutException
import 'package:ztech_mobile_application/services/social_service.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data'; // Para manejar los datos binarios
import 'dart:convert'; // Para la conversión base64

class WaterServiceListScreen extends StatefulWidget {
  const WaterServiceListScreen({Key? key}) : super(key: key);

  @override
  _WaterServiceListScreenState createState() => _WaterServiceListScreenState();
}

class _WaterServiceListScreenState extends State<WaterServiceListScreen> {
  final ApiService apiService = ApiService();
  late SocialServicesService socialServicesService;
  late Future<List<SocialService>> _futureServicios;

  @override
  void initState() {
    super.initState();
    socialServicesService = SocialServicesService(apiService: apiService);
    _futureServicios = _fetchServicios();
  }

  Future<List<SocialService>> _fetchServicios() async {
    try {
      final servicios = await socialServicesService.getSocialServicesByTypeAndNotExpired('ALIMENTACION');
      return servicios;
    } catch (e) {
      throw Exception('Error al cargar servicios: $e');
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
            Navigator.pushNamed(context, 'servicios_administrador');
          },
        ),
        title: const Text(
          'Servicio: Alimentación',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFC7C7CC),
      body: FutureBuilder<List<SocialService>>(
        future: _futureServicios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay servicios disponibles.'));
          } else {
            final servicios = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: servicios.length,
              itemBuilder: (context, index) {
                final service = servicios[index];
                return ServiceListItem(
                  id:service.id,
                  title: service.resumen,
                  location: service.lugar,
                  schedule: service.hora,
                  dueDate: service.fecha,
                  description: service.descripcion,
                  imageBase64: service.imagen,  // Pasar imagen base64
                  onEdit: () {
                    Navigator.pushNamed(
                      context,
                      'healthedit',
                      arguments: service.id,
                    ).then((value) {
                      if (value == true) {
                        // Si hubo cambio, recarga la lista
                        setState(() {
                          _futureServicios = _fetchServicios();
                        });
                      }
                    });
                  },
                  onDelete: () {
  // Imprimir el serviceId en consola
  print("Eliminando servicio con ID: ${service.id}");

  // Navegar a la pantalla de eliminación y esperar un resultado
  Navigator.pushNamed(
    context,
    'servicio_eliminar_general',
    arguments: service.id, // Pasar el serviceId como argumento
  ).then((value) {
    // Comprobar si se ha confirmado la eliminación
    if (value != null && value == true) {
      // Recargar la lista de servicios si se eliminó el servicio
      setState(() {
        _futureServicios = _fetchServicios();
      });
    }
  });
},
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ServiceListItem extends StatelessWidget {
  final int id;
  final String title;
  final String location;
  final String schedule;
  final String dueDate;
  final String description;
  final String? imageBase64;  // Recibimos la imagen en base64
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  ServiceListItem({
    required this.id,
    required this.title,
    required this.location,
    required this.schedule,
    required this.dueDate,
    required this.description,
    required this.onEdit,
    required this.onDelete,
    this.imageBase64,  // Recibimos la imagen en base64
  });

  @override
  Widget build(BuildContext context) {
    // Formateo de fecha y hora
    String fechaFormateada;
    String horaFormateada;

    try {
      final fecha = DateTime.parse(dueDate); // yyyy-MM-dd
      fechaFormateada = DateFormat('dd/MM/yyyy').format(fecha);
    } catch (e) {
      fechaFormateada = dueDate;
    }

    try {
      final hora = DateFormat('HH:mm').parse(schedule); // HH:mm
      horaFormateada = DateFormat('hh:mm a').format(hora); // 12:00 AM
    } catch (e) {
      horaFormateada = schedule;
    }

    // Decodificar la imagen base64 a bytes
    Uint8List? imageBytes;
    if (imageBase64 != null) {
      imageBytes = base64Decode(imageBase64!);
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF00BBC9),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Lugar: $location',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Hora: $horaFormateada',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Fecha: $fechaFormateada',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Descripción: $description',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (imageBytes != null) 
  ClipRRect(
    borderRadius: BorderRadius.circular(12.0),  // Establecer el radio de los bordes
    child: Image.memory(
      imageBytes,
      height: 150,
      width: double.infinity,  // Asegura que la imagen ocupe todo el ancho
      fit: BoxFit.cover,  // Ajusta la imagen para cubrir todo el espacio sin distorsionarla
    ),
  ),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: onDelete,
                  child: const Text(
                    'Eliminar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                const VerticalDivider(color: Colors.white),
                TextButton(
                  onPressed: onEdit,
                  child: const Text(
                    'Editar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

