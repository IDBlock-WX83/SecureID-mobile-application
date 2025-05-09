import 'package:flutter/material.dart';
import 'service_admin_card.dart'; // Importa la clase desde el archivo separado

class ServicesAdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: const Color(0xFF00747C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
Navigator.pushNamed(context, 'menu');
   },
        ),
        title: const Text('Servicios',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
            backgroundColor: const Color(0xFFC7C7CC),

      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8, // 80% de la altura de la pantalla
            ),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true, // Permite que el GridView se adapte al contenido
              children: [
                ServiceAdminCard(
                  icon: Icons.health_and_safety,
                  title: 'Salud',
                  color: const Color(0xFF00BBC9),
                  onViewDetails: () => Navigator.pushNamed(context, 'healthlistadmin'),
                  onAddService: () => Navigator.pushNamed(context, 'registerhealth'),
                ),
                ServiceAdminCard(
                  icon: Icons.person,
                  title: 'Social',
                  color: const Color(0xFF00BBC9),
                  onViewDetails: () => Navigator.pushNamed(context, 'energylistadmin'),
                  onAddService: () => Navigator.pushNamed(context, 'registerenergy'),
                ),
                ServiceAdminCard(
                  icon: Icons.book,
                  title: 'Educación',
                  color: const Color(0xFF00BBC9),
                  onViewDetails: () => Navigator.pushNamed(context, 'educationlistadmin'),
                  onAddService: () => Navigator.pushNamed(context, 'registereducation'),
                ),
                ServiceAdminCard(
                  icon: Icons.restaurant,
                  title: 'Alimentación',
                  color: const Color(0xFF00BBC9),
                  onViewDetails: () => Navigator.pushNamed(context, 'waterlistadmin'),
                  onAddService: () => Navigator.pushNamed(context, 'registerwater'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
