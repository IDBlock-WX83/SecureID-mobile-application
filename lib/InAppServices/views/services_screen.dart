import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/InAppServices/views/education_service_screen.dart';
import 'package:ztech_mobile_application/InAppServices/views/energy_service_screen.dart';
import 'package:ztech_mobile_application/InAppServices/views/health_service_screen.dart';
import 'package:ztech_mobile_application/InAppServices/views/water_service_screen.dart';
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
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HealthServiceScreen()),
                );
              },
            ),
            ServiceButton(
              icon: Icons.battery_full, 
              label: 'Energía',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EnergyServiceScreen()),
                );
              },
            ),
            ServiceButton(
              icon: Icons.book,
              label: 'Educación',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EducationServiceScreen()),
                );
              },
            ),
            ServiceButton(
              icon: Icons.water,
              label: 'Agua',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WaterServiceScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}