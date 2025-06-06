import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ztech_mobile_application/core/http/ApiService .dart';
import 'package:ztech_mobile_application/core/http/SocialServicesService.dart';
import 'dart:convert'; // Para base64Decode

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId != null) {
      try {
        final service = SocialServicesService(apiService: ApiService());
        final data = await service.getIdentificationById(userId);
        setState(() {
          userData = data;
          isLoading = false;
        });
      } catch (e) {
        print('Error al cargar datos del usuario: $e');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      // No hay sesión válida, redirige
      Navigator.pushReplacementNamed(context, 'welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF00747C),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF00747C),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF00747C),
        elevation: 0,
        title: Text(
          'Menú',
          style: const TextStyle(
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
      Navigator.pushNamed(context, 'identificacion');
    },
    child: CircleAvatar(
      radius: 20,
      backgroundColor: Colors.white,
      backgroundImage: (userData != null &&
              userData!['foto'] != null &&
              userData!['foto'].toString().isNotEmpty)
          ? MemoryImage(base64Decode(userData!['foto']))
          : null,
      child: (userData == null ||
              userData!['foto'] == null ||
              userData!['foto'].toString().isEmpty)
          ? const Icon(Icons.person, color: Colors.black)
          : null,
    ),
  ),
),

        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white, size: 30),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear(); // Cierra sesión
              Navigator.pushNamedAndRemoveUntil(
                  context, 'welcome', (route) => false);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            _buildMenuOption(
              title: 'Identificación',
              onTap: () {
Navigator.pushNamed(
  context,
  'identificacion',
  arguments: userData,
);
              },
            ),
            _buildMenuOption(
              title: 'Servicios',
              onTap: () {
                Navigator.pushNamed(context, 'servicios_residentes');
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
