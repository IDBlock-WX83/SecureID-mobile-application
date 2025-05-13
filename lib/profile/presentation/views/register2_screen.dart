import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesario para formatear la fecha seleccionada
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Para manejar archivos de imagen
import '../../infrastructure/BlockchainApiService.dart'; // Importar el servicio
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // Para acceder a LengthLimitingTextInputFormatter

class SignUpScreen2 extends StatefulWidget {
  final Map<String, dynamic> firstData; // Recibe los datos del primer registro

  const SignUpScreen2({super.key, required this.firstData});

  @override
  _SignUpScreen2State createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  final BlockchainApiService _apiService =
      BlockchainApiService(); // Instancia del servicio

  final TextEditingController _directionController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Variables para almacenar las imágenes seleccionadas
  File? _image1;
  File? _image2;
  final ImagePicker _picker = ImagePicker();
// Función para seleccionar o tomar una foto
  Future<void> _pickImage(int imageNumber, ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        // Asignar la imagen seleccionada a la variable correspondiente
        if (imageNumber == 1) {
          _image1 = File(pickedFile.path);
        } else if (imageNumber == 2) {
          _image2 = File(pickedFile.path);
        }
      });
    }
  }

  String _gender = "M"; // Género por defecto

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
    if (widget.firstData.containsKey("phone")) {
      _phoneController.text = widget.firstData["phone"] ?? "";
    }

    
  }

  @override
  void dispose() {
    _regionController.dispose();
    _provinceController.dispose();
    _districtController.dispose();
    _phoneController.dispose();
    _directionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    // Verificar si todos los campos están completos
    if (_regionController.text.isEmpty ||
        _provinceController.text.isEmpty ||
        _directionController.text.isEmpty ||
        _districtController.text.isEmpty ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, complete todos los campos")),
      );
      return;
    }
    Navigator.pushNamed(context, 'menu');

    // Consolidar los datos del primer y segundo formulario
    final consolidatedData = {
      ...widget.firstData, // Datos del primer formulario
      "region": _regionController.text,
      "provincia": _provinceController.text,
      "distrito": _districtController.text,
      "phone": _phoneController.text,
      "sexo": _gender,
      "active": false,
    };

    // Simular envío de datos al backend
    print("Datos consolidados: $consolidatedData");

    /*try {
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
    }*/
  }

  // Método para mostrar el DatePicker y seleccionar la fecha de inscripción

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00747C),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00747C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Registro',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Dirección',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _directionController,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Dirección',
                hintStyle: const TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
                fillColor: const Color(0xFFD9D9D9),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Departamento',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _regionController,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Departamento',
                hintStyle: const TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
                fillColor: const Color(0xFFD9D9D9),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Provincia',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _provinceController,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Provincia',
                hintStyle: const TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
                fillColor: const Color(0xFFD9D9D9),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Distrito',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _districtController,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Distrito',
                hintStyle: const TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
                fillColor: const Color(0xFFD9D9D9),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Teléfono celular (opcional)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              keyboardType:
                  TextInputType.number, // Establece el teclado numérico
              inputFormatters: [
                LengthLimitingTextInputFormatter(
                    9), // Limita el número de caracteres a 9
              ],
              decoration: InputDecoration(
                filled: true,
                hintText: 'Teléfono celular (opcional)',
                hintStyle: const TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
                fillColor: const Color(0xFFD9D9D9),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onTap: () {
                // Esto asegura que el texto inicial siempre sea '9' al tocar el campo
                if (_phoneController.text.isEmpty) {
                  _phoneController.text = '9'; // Preestablece el número 9
                  _phoneController.selection = TextSelection.collapsed(
                      offset: 1); // Mueve el cursor al final
                }
              },
            ),

            const SizedBox(height: 10),
// Botón para adjuntar una foto
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Cargar foto',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Botón para cargar o tomar una foto
            ElevatedButton(
              onPressed: () async {
                // Mostrar un diálogo para elegir entre tomar una foto o seleccionar de la galería
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Seleccionar fuente'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text('Tomar foto'),
                            onTap: () {
                              Navigator.of(context).pop();
                              _pickImage(
                                  1,
                                  ImageSource
                                      .camera); // Asignar imagen a _image1
                            },
                          ),
                          ListTile(
                            title: const Text('Seleccionar de la galería'),
                            onTap: () {
                              Navigator.of(context).pop();
                              _pickImage(
                                  1,
                                  ImageSource
                                      .gallery); // Asignar imagen a _image1
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD9D9D9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.photo, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Cargar foto', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Mostrar la imagen seleccionada (si existe)
            if (_image1 != null)
              Image.file(
                _image1!,
                height: 150,
                width: double.infinity,
                fit: BoxFit
                    .contain, // Ajusta la imagen sin recortarla, manteniendo la proporción
              ),

            const SizedBox(height: 10),
// Botón para adjuntar una foto
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Cargar firma',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Botón para cargar o tomar una foto
            ElevatedButton(
              onPressed: () async {
                // Mostrar un diálogo para elegir entre tomar una foto o seleccionar de la galería
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Seleccionar fuente'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text('Tomar foto'),
                            onTap: () {
                              Navigator.of(context).pop();
                              _pickImage(
                                  2,
                                  ImageSource
                                      .camera); // Asignar imagen a _image1
                            },
                          ),
                          ListTile(
                            title: const Text('Seleccionar de la galería'),
                            onTap: () {
                              Navigator.of(context).pop();
                              _pickImage(
                                  2,
                                  ImageSource
                                      .gallery); // Asignar imagen a _image1
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD9D9D9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.photo, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Cargar firma', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Mostrar la imagen seleccionada (si existe)
            if (_image2 != null)
              Image.file(
                _image2!,
                height: 150,
                width: double.infinity,
                fit: BoxFit
                    .contain, // Ajusta la imagen sin recortarla, manteniendo la proporción
              ),

            const SizedBox(height: 20),
            // Selector de género

            ElevatedButton(
              onPressed: (){
                 Navigator.pushNamed(context, 'registro_exitoso_adulto_mayor');
              },//_submitForm,
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
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
