import 'package:flutter/material.dart';

class HealthCampaignEditScreen extends StatelessWidget {
  // Ruta de la imagen en assets
  final String imagePath = 'assets/service_adultos_mayores.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salud'),
        backgroundColor: Color(0xFF008080),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de campaña
            const Text(
              'Título de campaña',
              style: TextStyle(color: Colors.lightBlue),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Atención para adultos mayores',
              ),
            ),
            const SizedBox(height: 16),

            // Lugar
            const Text(
              'Lugar',
              style: TextStyle(color: Colors.lightBlue),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Posta médica',
              ),
            ),
            const SizedBox(height: 16),

            // Día y hora
            const Text(
              'Día y hora',
              style: TextStyle(color: Colors.lightBlue),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Lunes 7 am a 1 pm',
              ),
            ),
            const SizedBox(height: 16),

            // Fecha de vencimiento
            const Text(
              'Fecha de vencimiento',
              style: TextStyle(color: Colors.grey),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Vence 10/12/14',
              ),
            ),
            const SizedBox(height: 16),

            // Insertar imagen usando Image.asset
            const Text(
              'Insertar imagen',
              style: TextStyle(color: Colors.lightBlue),
            ),
            Container(
              margin: EdgeInsets.only(top: 8.0, bottom: 16.0),
              height: 100,
              width: double.infinity,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),

            // Botón Guardar
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Acción de guardar
                },
                child: Text('Guardar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF008080),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
