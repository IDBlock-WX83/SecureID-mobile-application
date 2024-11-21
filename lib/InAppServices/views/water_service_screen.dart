import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/InAppServices/Api/Services/social_sevice_api.dart';
import 'package:ztech_mobile_application/InAppServices/Api/models/SocialServicesResponseDto.dart';
import 'package:ztech_mobile_application/InAppServices/widget/service_card.dart';

class WaterServiceScreen extends StatefulWidget {
  const WaterServiceScreen({Key? key}) : super(key: key);

  @override
  _WaterServiceScreenState createState() => _WaterServiceScreenState();
}

class _WaterServiceScreenState extends State<WaterServiceScreen> {
  late Future<List<SocialServiceResponse>> _waterServices;

  @override
  void initState() {
    super.initState();
    _waterServices = SocialServiceApi().getSocialServicesByTypeAndNotExpired('WATER');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicio: Agua'),
        centerTitle: true,
        backgroundColor: const Color(0xFF00747C),
      ),
      backgroundColor: const Color(0xFFC7C7CC),
      body: FutureBuilder<List<SocialServiceResponse>>(
        future: _waterServices,
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
