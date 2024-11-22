import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/InAppServices/Api/Services/social_sevice_api.dart';
import 'package:ztech_mobile_application/InAppServices/Api/models/SocialServicesResponseDto.dart';
import 'package:ztech_mobile_application/services/agua_service_edit.dart';

class WaterServiceListScreen extends StatefulWidget {
  @override
  _WaterServiceListScreenState createState() => _WaterServiceListScreenState();
}

class _WaterServiceListScreenState extends State<WaterServiceListScreen> {
  late Future<List<SocialServiceResponse>> servicesFuture;

  @override
  void initState() {
    super.initState();
    servicesFuture = _fetchServices();
  }

  Future<List<SocialServiceResponse>> _fetchServices() async {
    return await SocialServiceApi().getSocialServicesByTypeAndNotExpired("water");
  }

  Future<void> _deleteService(int id) async {
    try {
      await SocialServiceApi().deleteSocialService(id);
      setState(() {
        servicesFuture = _fetchServices();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Servicio eliminado exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el servicio: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Servicio: Agua Potable'),
        backgroundColor: const Color(0xFF00747C),
        centerTitle: true,
      ),
      body: FutureBuilder<List<SocialServiceResponse>>(
        future: servicesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay servicios disponibles.'));
          } else {
            final services = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return ServiceListItem(
                  title: service.title,
                  location: service.location,
                  schedule: service.schedule,
                  dueDate: service.expirationDate.toLocal().toShortDateString(),
                  image: service.imageUrl,
                  onEdit: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WaterCampaignEditScreen(
                          id: service.id,
                          title: service.title,
                          location: service.location,
                          schedule: service.schedule,
                          dueDate: service.expirationDate.toLocal().toShortDateString(),
                          image: service.imageUrl,
                        ),
                      ),
                    );

                    if (updated != null && updated) {
                      setState(() {
                        servicesFuture = _fetchServices();
                      });
                    }
                  },
                  onDelete: () {
                    _showDeleteConfirmationDialog(service.id);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  // Mostrar el diálogo de confirmación
  Future<void> _showDeleteConfirmationDialog(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Servicio'),
          content: const Text('¿Estás seguro de que deseas eliminar este servicio?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteService(id); 
                Navigator.of(context).pop(); 
                
              },
              child: const Text('Sí'),
            ),
          ],
        );
      },
    );
  }
}

extension DateTimeExtension on DateTime {
  String toShortDateString() {
    return '${this.day}/${this.month}/${this.year}';
  }
}

class ServiceListItem extends StatelessWidget {
  final String title;
  final String location;
  final String schedule;
  final String dueDate;
  final String image;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  ServiceListItem({
    required this.title,
    required this.location,
    required this.schedule,
    required this.dueDate,
    required this.image,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF00A7A7),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Image.network(image,
                      height: 100, width: 100, fit: BoxFit.cover),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location,
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        schedule,
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Vence $dueDate',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: onDelete,
                  child: const Text(
                    'Eliminar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const VerticalDivider(color: Colors.white),
                TextButton(
                  onPressed: onEdit,
                  child: const Text(
                    'Editar',
                    style: TextStyle(color: Colors.white),
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