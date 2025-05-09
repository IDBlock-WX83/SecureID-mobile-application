import 'package:flutter/material.dart';

class HealthServiceListScreen extends StatelessWidget {
  const HealthServiceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00747C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
                              Navigator.pushNamed(context, 'servicios_administrador');

          },
        ),
        title: const Text(
          'Servicio: Salud',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFC7C7CC),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          ServiceListItem(
            title: 'Atención para adultos mayores',
            location: 'Posta médica de Madre De Dios'  ,
            schedule: '10 PM',
            dueDate: '09/05/2025',
            description:
                'Este servicio de atención para adultos mayores ofrece consultas médicas y apoyo en salud general.',
            image: 'assets/service_adultos_mayores.jpg',
            onEdit: () {
              Navigator.pushNamed(context, 'healthedit');
            },
            onDelete: () {
              Navigator.pushNamed(context, 'servicio_eliminar_general');
            },
          ),
          ServiceListItem(
            title: 'Vacunación contra la fiebre amarilla',
            location: 'Plaza principal',
            schedule: 'Sábados 8 AM',
            dueDate: '05/10/2024',
            description:
                'Vacunación para prevenir la fiebre amarilla en zonas de alto riesgo.',
            image: 'assets/service_vacunacion.jpg',
            onEdit: () {
              Navigator.pushNamed(context, 'healthedit');
            },
            onDelete: () {
              Navigator.pushNamed(context, 'servicio_eliminar_general');
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
  final String description;
  final String image;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  ServiceListItem({
    required this.title,
    required this.location,
    required this.schedule,
    required this.dueDate,
    required this.description,
    required this.image,
    required this.onEdit,
    required this.onDelete,
  });

  @override
Widget build(BuildContext context) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: const Color(0xFF00BBC9),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título centrado
          Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Imagen con ancho completo
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              image,
              width: double.infinity,  // Hacer que la imagen ocupe todo el ancho disponible
              height: 150,             // Ajusta la altura según sea necesario
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),

          // Lugar
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              'Lugar: $location',
style: const TextStyle(
  color: Colors.black,
  fontSize: 16, // Ajusta este valor para cambiar el tamaño del texto
),            ),
          ),

          // Row con la fecha y hora, alineando cada uno a los lados
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Hora alineada a la izquierda
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Hora: $schedule',
style: const TextStyle(
  color: Colors.black,
  fontSize: 16, // Ajusta este valor para cambiar el tamaño del texto
),                 ),
              ),
              // Fecha alineada a la derecha
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Fecha: $dueDate',
style: const TextStyle(
  color: Colors.black,
  fontSize: 16, // Ajusta este valor para cambiar el tamaño del texto
),                 ),
              ),
            ],
          ),

          // Descripción
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              'Descripción: $description',
style: const TextStyle(
  color: Colors.black,
  fontSize: 16, // Ajusta este valor para cambiar el tamaño del texto
),             ),
          ),
          const SizedBox(height: 10),

          // Botones Eliminar y Editar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: onDelete,
                child: const Text(
                  'Eliminar',
style: const TextStyle(
    fontWeight: FontWeight.bold,

  color: Colors.white,
  fontSize: 15, // Ajusta este valor para cambiar el tamaño del texto
),                    ),
              ),
              const VerticalDivider(color: Colors.white),
              TextButton(
                onPressed: onEdit,
                child: const Text(
                  'Editar',
style: const TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.white,
  fontSize: 15, // Ajusta este valor para cambiar el tamaño del texto
),                 ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

}
