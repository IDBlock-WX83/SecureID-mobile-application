import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/InAppServices/Api/models/SocialServicesCreateDto.dart';
import '../InAppServices/Api/Services/social_sevice_api.dart';

class WaterServiceRegistrationScreen extends StatefulWidget {
  const WaterServiceRegistrationScreen({Key? key}) : super(key: key);

  @override
  _WaterServiceRegistrationScreenState createState() => _WaterServiceRegistrationScreenState();
}

class _WaterServiceRegistrationScreenState extends State<WaterServiceRegistrationScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _scheduleController = TextEditingController();
  final _expirationDateController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _api = SocialServiceApi();

  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_titleController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _scheduleController.text.isEmpty ||
        _expirationDateController.text.isEmpty ||
        _imageUrlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final service = SocialServiceCreate(
        title: _titleController.text,
        location: _locationController.text,
        schedule: _scheduleController.text,
        expirationDate: DateTime.parse(_expirationDateController.text),
        imageUrl: _imageUrlController.text,
        socialServicesType: 'Water',
      );

      await _api.createSocialService(service);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Servicio creado exitosamente')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear el servicio: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Servicio de Agua'),
        centerTitle: true,
        backgroundColor: const Color(0xFF00747C),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Título de la campaña',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    hintText: 'Lugar',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _scheduleController,
                  decoration: const InputDecoration(
                    hintText: 'Día y hora',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _expirationDateController,
                  decoration: const InputDecoration(
                    hintText: 'Fecha de vencimiento (YYYY-MM-DD)',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    hintText: 'URL de la imagen',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B0B9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                          child: Text(
                            'Guardar',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
