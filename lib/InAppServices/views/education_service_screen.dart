import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/InAppServices/Api/Services/social_sevice_api.dart';
import 'package:ztech_mobile_application/InAppServices/widget/service_card.dart';
import 'package:ztech_mobile_application/InAppServices/Api/models/SocialServicesResponseDto.dart';

class EducationServiceScreen extends StatefulWidget {
  const EducationServiceScreen({Key? key}) : super(key: key);

  @override
  _EducationServiceScreenState createState() => _EducationServiceScreenState();
}

class _EducationServiceScreenState extends State<EducationServiceScreen> {
  late Future<List<SocialServiceResponse>> _educationServices;

  @override
  void initState() {
    super.initState();
    _educationServices = SocialServiceApi().getSocialServicesByTypeAndNotExpired('education');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Servicio: Educación', style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500)),
                 centerTitle: true,
        backgroundColor: const Color(0xFF00747C),
      ),
      backgroundColor: const Color(0xFFC7C7CC),
      body: FutureBuilder<List<SocialServiceResponse>>(
        future: _educationServices,
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
              padding: const EdgeInsets.all(20),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return Column(
                  children: [
                    ServiceCard(
                      title: service.title,
                      imageUrl: service.imageUrl,
                      text1: service.location,
                      text2: service.schedule,
                      text3: 'Vence ${service.expirationDate.toLocal().toShortDateString()}',
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  String toShortDateString() {
    return '${this.day}/${this.month}/${this.year}';
  }
}