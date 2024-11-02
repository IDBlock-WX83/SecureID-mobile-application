import 'package:flutter/material.dart';

class ServiceAdminCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onViewDetails;
  final VoidCallback onAddService;

  const ServiceAdminCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onViewDetails,
    required this.onAddService,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Expanded(
            child: InkWell(
              onTap: onViewDetails,
              child: Center(  // Centra vertical y horizontalmente
                child: Column(
                  mainAxisSize: MainAxisSize.min,  // Ajusta el tamaño solo al contenido
                  children: [
                    Icon(
                      icon,
                      size: 50,
                      color: Colors.black,
                    ),
                    SizedBox(height: 8),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: onAddService,
            child: Container(
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8),
              child: const Center(
                child: Text(
                  'Agregar',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
