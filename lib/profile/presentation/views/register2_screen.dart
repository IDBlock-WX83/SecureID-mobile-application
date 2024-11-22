import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesario para formatear la fecha seleccionada
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Para manejar archivos de imagen
import '../../infrastructure/BlockchainApiService.dart'; // Importar el servicio
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen2 extends StatefulWidget {
  final Map<String, dynamic> firstData; // Recibe los datos del primer registro

  const SignUpScreen2({super.key, required this.firstData});

  @override
  _SignUpScreen2State createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  final BlockchainApiService _apiService = BlockchainApiService(); // Instancia del servicio
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();

  String _gender = "M"; // Género por defecto
  File? _signatureImage; // Para almacenar la firma cargada

  @override
  void initState() {
    super.initState();
    // Prellenar datos con `firstData` si están disponibles
    if (widget.firstData.containsKey("region")) {
      _regionController.text = widget.firstData["region"] ?? "";
    }
    if (widget.firstData.containsKey("province")) {
      _provinceController.text = widget.firstData["province"] ?? "";
    }
    if (widget.firstData.containsKey("district")) {
      _districtController.text = widget.firstData["district"] ?? "";
    }
    if (widget.firstData.containsKey("gender")) {
      _gender = widget.firstData["gender"] ?? "M";
    }
  }

  @override
  void dispose() {
    _regionController.dispose();
    _provinceController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  // Método para manejar la selección de la imagen de firma
  Future<void> _pickSignature(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _signatureImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _submitForm() async {
    // Verificar si todos los campos están completos
    if (_regionController.text.isEmpty ||
        _provinceController.text.isEmpty ||
        _districtController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, complete todos los campos")),
      );
      return;
    }

    // Consolidar los datos del primer y segundo formulario
    final consolidatedData = {
      ...widget.firstData, // Datos del primer formulario
      "region": _regionController.text,
      "provincia": _provinceController.text,
      "distrito": _districtController.text,
      "sexo": _gender,
      "active": false,
    };

    // Simular envío de datos al backend
    print("Datos consolidados: $consolidatedData");

    try {
      final response = await _apiService.addIdentification(consolidatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registro exitoso: ${response['message']}")),
      );

      // Guardar datos en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('idDigital', consolidatedData["idDigital"]);

      // Redirigir al usuario a la siguiente pantalla

    } catch (error) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('idDigital', consolidatedData["idDigital"]);
      Navigator.pushNamed(context, 'user_menu');
      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al registrar: $error")),

      );*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00747C),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            const Text(
              'Registro',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _regionController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
                labelText: 'Región',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _provinceController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
                labelText: 'Provincia',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _districtController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
                labelText: 'Distrito',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Selector de género
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sexo:',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'M',
                        groupValue: _gender,
                        onChanged: (String? value) {
                          setState(() {
                            _gender = value!;
                          });
                        },
                      ),
                      const Text('M'),
                      Radio<String>(
                        value: 'F',
                        groupValue: _gender,
                        onChanged: (String? value) {
                          setState(() {
                            _gender = value!;
                          });
                        },
                      ),
                      const Text('F'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C2CB),
                padding:
                const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Continuar',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
