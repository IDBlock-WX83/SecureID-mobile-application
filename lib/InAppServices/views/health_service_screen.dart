import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/core/http/ApiService.dart'; // Importa ApiService
import 'package:ztech_mobile_application/core/http/SocialServicesService.dart'; // Importa SocialServicesService
import 'package:ztech_mobile_application/services/social_service.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data'; // Para manejar los datos binarios
import 'dart:convert'; // Para la conversión base64

class HealthServiceScreen extends StatefulWidget {
  const HealthServiceScreen({Key? key}) : super(key: key);

  @override
  _HealthServiceScreenState createState() => _HealthServiceScreenState();
}

class _HealthServiceScreenState extends State<HealthServiceScreen> {
  final ApiService apiService = ApiService();
  late SocialServicesService socialServicesService;

  // Aquí almacenamos la lista de servicios
  List<SocialService> _servicios = [];

  @override
  void initState() {
    super.initState();
    socialServicesService = SocialServicesService(apiService: apiService);
    _loadServicios(); // Cargar los servicios al iniciar
  }

  // Función que obtiene los servicios
  Future<void> _loadServicios() async {
    try {
      final servicios = await socialServicesService.getSocialServicesByTypeAndNotExpired('SALUD');
      setState(() {
        _servicios = servicios; // Actualizamos el estado con la lista de servicios
      });
    } catch (e) {
      print('Error al cargar servicios: $e');
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
    Navigator.of(context).pop(true); // Regresa a la pantalla anterior con el valor true
          },
        ),
        title: const Text(
          'Servicio: Salud',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFC7C7CC),
      body: _servicios.isEmpty // Si la lista está vacía, muestra un indicador de carga o un mensaje
          ? const Center(
        child: Text(
          'No hay servicios disponibles',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        ),
      )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _servicios.length,
              itemBuilder: (context, index) {
                final service = _servicios[index];
                return ServiceListItem(
                  id: service.id,
                  title: service.resumen,
                  location: service.lugar,
                  schedule: service.hora,
                  dueDate: service.fecha,
                  description: service.descripcion,
                  imageBase64: service.imagen,
                );
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
  final String? imageBase64;

  ServiceListItem({
    required this.id,
    required this.title,
    required this.location,
    required this.schedule,
    required this.dueDate,
    required this.description,
    this.imageBase64,
  });

  @override
  Widget build(BuildContext context) {
    String fechaFormateada;
    String horaFormateada;

    try {
      final fecha = DateTime.parse(dueDate); 
      fechaFormateada = DateFormat('dd/MM/yyyy').format(fecha);
    } catch (e) {
      fechaFormateada = dueDate;
    }

    try {
      final hora = DateFormat('HH:mm').parse(schedule);
      horaFormateada = DateFormat('hh:mm a').format(hora); 
    } catch (e) {
      horaFormateada = schedule;
    }

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
                borderRadius: BorderRadius.circular(12.0),
                child: Image.memory(
                  imageBytes,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
