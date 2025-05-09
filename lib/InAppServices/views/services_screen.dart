import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/InAppServices/views/education_service_screen.dart';
import 'package:ztech_mobile_application/InAppServices/views/energy_service_screen.dart';
import 'package:ztech_mobile_application/InAppServices/views/health_service_screen.dart';
import 'package:ztech_mobile_application/InAppServices/views/water_service_screen.dart';

// 🔥 Incluyo el ServiceButton corregido aquí
class ServiceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const ServiceButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00BBC9), // 🟦 Fondo turquesa
        foregroundColor: Colors.black,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4, // Sombra ligera
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);

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
        title: const Text('Servicios', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
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
              icon: Icons.person,
              label: 'Social',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SocialServiceScreen()),
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
              icon: Icons.restaurant,
              label: 'Alimentación',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AlimentacionServiceScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
