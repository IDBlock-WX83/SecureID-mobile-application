import 'package:flutter/material.dart';

class EnergyServiceListScreen extends StatelessWidget {

  const EnergyServiceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Servicio: Energia'),
        backgroundColor: const Color(0xFF00747C),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          ServiceListItem(
            title: 'Atención para adultos mayores',
            location: 'Posta médica',
            schedule: 'Lunes 7 am a 1 pm',
            dueDate: '10/12/14',
            image: 'assets/service_adultos_mayores.jpg',
            onEdit: () {
              // Navegar a la pantalla de edición
              Navigator.pushNamed(context, 'energyedit');
            },
            onDelete: () {
              // Lógica para eliminar el servicio
            },
          ),
          ServiceListItem(
            title: 'Vacunación contra la fiebre amarilla',
            location: 'Plaza principal',
            schedule: 'Sábados 8 am a 1 pm',
            dueDate: '05/10/2024',
            image: 'assets/service_vacunacion.jpg',
            onEdit: () {
              // Navegar a la pantalla de edición
              Navigator.pushNamed(context, 'energyedit');
            },
            onDelete: () {
              // Lógica para eliminar el servicio
            },
          ),
          // Agrega más elementos de la lista según sea necesario
        ],
      ),
    );
  }
}

class ServiceListItem extends StatelessWidget {
  final String title;
  final String location;
  final String schedule;
  final String dueDate;
  final String image;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  ServiceListItem({
    required this.title,
    required this.location,
    required this.schedule,
    required this.dueDate,
    required this.image,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF00A7A7),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location,
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        schedule,
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Vence $dueDate',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: onDelete,
                  child: const Text(
                    'Eliminar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const VerticalDivider(color: Colors.white),
                TextButton(
                  onPressed: onEdit,
                  child: const Text(
                    'Editar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
