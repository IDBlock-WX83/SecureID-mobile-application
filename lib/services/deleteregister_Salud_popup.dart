import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/services/social_service.dart';
import 'package:ztech_mobile_application/core/http/SocialServicesService.dart';

class DeleteRegisterSaludPopup extends StatelessWidget {
  final VoidCallback onProfileClick;
  final int serviceId; // ID del servicio social a eliminar
  final SocialServicesService socialServicesService;

  const DeleteRegisterSaludPopup({
    Key? key,
    required this.onProfileClick,
    required this.serviceId, // Se pasa el ID para eliminar
    required this.socialServicesService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(20.0),
      content: Column(
        mainAxisSize: MainAxisSize.min, // Tamaño mínimo para el diálogo
        children: [
          Text(
            '¿Estás seguro de eliminar esta difusión?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20), // Espacio antes del texto clickeable
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Botón Aceptar
              TextButton(
                onPressed: () async {
  // Llamar al método DELETE del servicio
  try {
    await socialServicesService.deleteSocialService(serviceId);
    onProfileClick(); // Llama a la función proporcionada
    Navigator.of(context).pop(true); // Regresa a la pantalla anterior con el valor true
  } catch (e) {
    // Manejar error
    print('Error al eliminar: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al eliminar el servicio.')),
    );
  }
},

                child: Text(
                  'Aceptar',
                  style: TextStyle(color: Color(0xFF0C59A2), fontSize: 16),
                ),
              ),
              // Botón Cancelar
              TextButton(
                onPressed: () {
                  onProfileClick(); // Llama a la función proporcionada
                  Navigator.of(context).pop(); // Cierra el diálogo

                },
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Color(0xFFA20C0C), fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
