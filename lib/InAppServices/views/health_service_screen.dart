import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/InAppServices/widget/service_card.dart';


class HealthServiceScreen extends StatelessWidget {
  const HealthServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicio: Salud'),
        centerTitle: true,
        backgroundColor: const Color(0xFF00747C),
      ),
      backgroundColor: const Color(0xFFC7C7CC),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ServiceCard(
              title: 'Atención para adultos mayores',
              imageUrl: 'https://casadereposobugambilias.com/wp-content/uploads/2019/06/enfermeria_casa_de_reposo.jpg',
              text1: 'Posta Medica',
              text2: 'Lunes 7 am a 1 pm',
              text3: 'Vence 10/12/14',
            ),
            const SizedBox(height: 20),
            ServiceCard(
              title: 'Vacunación contra la fiebre amarilla',
              imageUrl: 'https://www.clikisalud.net/wp-content/uploads/2021/10/vacuna-fiebre-amarilla-debes-saber.jpg',
              text1: 'Plaza principal',
              text2: 'Sabados 8 am  a 1 pm',
              text3: 'Vence 05/10/2024',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}