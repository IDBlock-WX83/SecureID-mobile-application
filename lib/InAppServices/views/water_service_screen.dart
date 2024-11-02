import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/InAppServices/widget/service_card.dart';

class WaterServiceScreen extends StatelessWidget {
  const WaterServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicio: Agua'),
        centerTitle: true,
        backgroundColor: const Color(0xFF00747C),
      ),
      backgroundColor: const Color(0xFFC7C7CC),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ServiceCard(
              title: 'Distribución de agua potable',
              imageUrl:
                  'https://cdn.www.gob.pe/uploads/document/file/5659583/892193-1.jpeg',
              text1: 'Planta de Tratamiento Los Pinos',
              text2: 'Lunes a Viernes 6 am a 8 pm',
              text3: 'Vence 31/12/2024',
            ),
            const SizedBox(height: 20),
            ServiceCard(
              title: 'Reparación de tuberías principales',
              imageUrl: 'https://example.com/reparacion_tuberias.jpg',
              text1: 'Colonia El Sol',
              text2: 'Miércoles 8 am a 6 pm',
              text3: 'Vence 15/11/2024',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
