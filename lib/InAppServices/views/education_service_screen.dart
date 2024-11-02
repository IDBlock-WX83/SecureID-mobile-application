import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/InAppServices/widget/service_card.dart';

class EducationServiceScreen extends StatelessWidget {
  const EducationServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicio: Educación'),
        centerTitle: true,
        backgroundColor: const Color(0xFF00747C),
      ),
      backgroundColor: const Color(0xFFC7C7CC),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ServiceCard(
              title: 'Curso de inglés básico',
              imageUrl:
                  'https://aprendergratis.es/wp-content/uploads/2022/11/aprender-ingles-basico-1024x614.jpg',
              text1: 'Instituto Cultural',
              text2: 'Martes y Jueves 6 pm a 8 pm',
              text3: 'Vence 22/02/2025',
            ),
            const SizedBox(height: 20),
            ServiceCard(
              title: 'Preparación para exámenes de ingreso',
              imageUrl: 'https://englishtools.net/wp-content/uploads/elementor/thumbs/curso-de-preparacion-examen-fce-1-q2jrgven56lko2wa5bvtc7cyge1aja3ft618rkzrnw.webp',
              text1: 'Biblioteca Central',
              text2: 'Lunes a Viernes 4 pm a 6 pm',
              text3: 'Vence 10/05/2025',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
