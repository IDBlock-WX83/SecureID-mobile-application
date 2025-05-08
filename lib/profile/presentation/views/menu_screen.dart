import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/common/utils/blockchain_record.dart';
import 'package:ztech_mobile_application/profile/presentation/views/transaction_history_screen.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreenAutoridades extends StatefulWidget {
  final Blockchain blockchain; // Propiedad para almacenar la instancia de Blockchain

  MenuScreenAutoridades({required this.blockchain}); // Modificar el constructor

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreenAutoridades> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00747C),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF00747C),
        elevation: 0,
        title: const Text(
          'Menú',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              print('Avatar presionado');
              Navigator.pushNamed(context, 'identificacion');
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: Icon(Icons.person, color: Colors.black),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
              size: 30,
            ),
            onPressed: ()  {
              Navigator.pushNamed(context, 'welcome');
            },
            /*async {
              // Limpiar el ID Digital de SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('idDigital');
              print('ID Digital eliminado');
              SystemNavigator.pop(); // Lógica para salir del menú o de la aplicación
            },*/
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            _buildMenuOption(
              title: 'Registro',
              onTap: () {
                Navigator.pushNamed(context, 'register');
                print('Registro');
              },
            ),
            _buildMenuOption(
              title: 'Residentes',
              onTap: () {
                Navigator.pushNamed(context, 'servicesAdmin');
                print('Residentes');
              },
            ),
            _buildMenuOption(
              title: 'Servicios',
              onTap: () {
                Navigator.pushNamed(context, 'servicios_administrador');

                print('Servicios');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Material(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: onTap,
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.black),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
