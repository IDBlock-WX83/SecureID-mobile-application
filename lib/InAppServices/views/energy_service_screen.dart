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
              title: 'Instalación de Paneles Solares para Hogares',
              imageUrl: 'https://postgradoingenieria.com/wp-content/uploads/mantenimiento-de-sistemas-de-energia.jpg',
              text1: 'Sector Las Lomas',
              text2: 'Martes y Jueves 9 am a 4 pm',
              text3: 'Vence 20/12/2024',
            ),
            const SizedBox(height: 20),
            ServiceCard(
              title: 'Capacitación en Eficiencia Energética',
              imageUrl: 'https://i0.wp.com/www.ing.una.py/wp-content/uploads/2022/09/Curso_capacitacion_eficiencia_energetica_ch.jpeg?fit=497%2C509&ssl=1',
              text1: 'Colegio Fe y Alegría, Pueblo Joven Santa Rosa',
              text2: '10 am a 12 pm',
              text3: 'Hasta el 20/09/2024',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}