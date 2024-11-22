import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ztech_mobile_application/InAppServices/Api/Services/social_sevice_api.dart';
import 'package:ztech_mobile_application/InAppServices/Api/models/ScoialServicesUpdateDto.dart';

class WaterCampaignEditScreen extends StatefulWidget {
  final int id;
  final String title;
  final String location;
  final String schedule;
  final String dueDate;
  final String image;

  WaterCampaignEditScreen({
    required this.id,
    required this.title,
    required this.location,
    required this.schedule,
    required this.dueDate,
    required this.image,
  });

  @override
  _WaterCampaignEditScreenState createState() =>
      _WaterCampaignEditScreenState();
}

class _WaterCampaignEditScreenState extends State<WaterCampaignEditScreen> {
  late TextEditingController titleController;
  late TextEditingController locationController;
  late TextEditingController scheduleController;
  late TextEditingController dueDateController;
  late TextEditingController imageController;

  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    locationController = TextEditingController(text: widget.location);
    scheduleController = TextEditingController(text: widget.schedule);
    dueDateController = TextEditingController(text: widget.dueDate);
    imageController = TextEditingController(text: widget.image);
    imageUrl = widget.image;
  }

  Future<void> updateSocialService() async {
    try {
      DateTime expirationDate =
          DateFormat('dd/MM/yyyy').parse(dueDateController.text);

      SocialServiceUpdate serviceUpdate = SocialServiceUpdate(
        title: titleController.text,
        location: locationController.text,
        schedule: scheduleController.text,
        imageUrl: imageController.text,
        expirationDate: expirationDate,
      );

      final response = await SocialServiceApi()
          .updateSocialService(widget.id, serviceUpdate);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Servicio actualizado con éxito')),
        );

         Navigator.pop(context, true);
      } else {
        throw Exception('Error al actualizar el servicio');
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Agua Potable'),
        backgroundColor: const Color(0xFF008080),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Título de campaña',
              style: TextStyle(color: Colors.lightBlue),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Atención para adultos mayores',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Lugar',
              style: TextStyle(color: Colors.lightBlue),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                hintText: 'Posta médica',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Día y hora',
              style: TextStyle(color: Colors.lightBlue),
            ),
            TextField(
              controller: scheduleController,
              decoration: const InputDecoration(
                hintText: 'Lunes 7 am a 1 pm',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Fecha de vencimiento',
              style: TextStyle(color: Colors.grey),
            ),
            TextField(
              controller: dueDateController,
              decoration: const InputDecoration(
                hintText: 'Vence 10/12/14',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'URL de la imagen',
              style: TextStyle(color: Colors.lightBlue),
            ),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(
                hintText: 'Ingrese URL de la imagen',
              ),
              onChanged: (value) {
                setState(() {
                  imageUrl = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Imagen',
              style: TextStyle(color: Colors.lightBlue),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              height: 100,
              width: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text(
                      'URL no válida',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: updateSocialService,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008080),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    scheduleController.dispose();
    dueDateController.dispose();
    imageController.dispose();
    super.dispose();
  }
}
