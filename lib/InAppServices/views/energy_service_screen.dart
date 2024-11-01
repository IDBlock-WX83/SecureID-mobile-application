import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/InAppServices/widget/service_card.dart';


class EnergyServiceScreen extends StatelessWidget {
  const EnergyServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicio: Energía'),
        centerTitle: true,
        backgroundColor: const Color(0xFF00747C),
      ),
      backgroundColor: const Color(0xFFC7C7CC),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ServiceCard(
              title: 'Servicio 1',
              imageUrl: 'https://example.com/image1.jpg',
              text1: 'Nombre 1',
              text2: '12:00 PM',
              text3: '01-01-2024',
            ),
            const SizedBox(height: 20),
            ServiceCard(
              title: 'Servicio 2',
              imageUrl: 'https://example.com/image2.jpg',
              text1: 'Nombre 2',
              text2: '01:00 PM',
              text3: '02-01-2024',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}