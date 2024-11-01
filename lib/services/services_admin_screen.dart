import 'package:flutter/material.dart';
import 'service_admin_card.dart'; // Importa la clase desde el archivo separado

class ServicesAdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Servicios'),
        backgroundColor: Color(0xFF008080),
        centerTitle: true,
      ),
      body: Center( // Centra el GridView en la pantalla
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          padding: EdgeInsets.all(16.0),  // Solo si quieres un poco de espacio en los bordes
          children: [
            ServiceAdminCard(
              icon: Icons.favorite_border,
              title: 'Salud',
              color: Colors.teal,
              onViewDetails: () => Navigator.pushNamed(context, 'healthlistadmin'),
              onAddService: () => Navigator.pushNamed(context, 'registerhealth'),
            ),
            ServiceAdminCard(
              icon: Icons.bolt_outlined,
              title: 'Energía',
              color: Colors.teal,
              onViewDetails: () => Navigator.pushNamed(context, 'energylistadmin'),
              onAddService: () => Navigator.pushNamed(context, 'registerenergy'),
            ),
            ServiceAdminCard(
              icon: Icons.book_outlined,
              title: 'Educación',
              color: Colors.teal,
              onViewDetails: () => Navigator.pushNamed(context, 'educationlistadmin'),
              onAddService: () => Navigator.pushNamed(context, 'registereducation'),
            ),
            ServiceAdminCard(
              icon: Icons.opacity,
              title: 'Agua potable',
              color: Colors.teal,
              onViewDetails: () => Navigator.pushNamed(context, 'waterlistadmin'),
              onAddService: () => Navigator.pushNamed(context, 'registerwater'),
            ),
          ],
        ),
      ),
    );
  }
}
