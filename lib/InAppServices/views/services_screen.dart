import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/InAppServices/widget/Service_Button.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
        centerTitle: true,
        backgroundColor: const Color(0xFF00747C),
      ),
      backgroundColor: const Color(0xFFC7C7CC),
      body: Center(
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: 20, 
          crossAxisSpacing: 20,
          padding: const EdgeInsets.all(20),
          children: [
            ServiceButton(
              icon: Icons.health_and_safety, 
              label: 'Salud',
              onPressed: () {
                // TODO: Redireccion
              },
            ),
            ServiceButton(
              icon: Icons.battery_full, 
              label: 'Energía',
              onPressed: () {
                // TODO: Redireccion
              },
            ),
            ServiceButton(
              icon: Icons.book,
              label: 'Educación',
              onPressed: () {
                // TODO: Redireccion
              },
            ),
            ServiceButton(
              icon: Icons.water,
              label: 'Agua',
              onPressed: () {
                // TODO: Redireccion
              },
            ),
          ],
        ),
      ),
    );
  }
}