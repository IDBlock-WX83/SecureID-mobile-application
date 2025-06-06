import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesario para formatear la fecha seleccionada
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Para manejar archivos de imagen
import '../../infrastructure/BlockchainApiService.dart'; // Importar el servicio
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // Para acceder a LengthLimitingTextInputFormatter
import 'dart:convert'; // Para usar base64Encode
import 'package:ztech_mobile_application/core/http/ApiService .dart';
import 'package:ztech_mobile_application/core/http/SocialServicesService.dart';

class SignUpScreen2 extends StatefulWidget {
  final Map<String, dynamic> firstData; // Recibe los datos del primer registro

  const SignUpScreen2({super.key, required this.firstData});

  @override
  _SignUpScreen2State createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  final BlockchainApiService _apiService =
      BlockchainApiService(); // Instancia del servicio

  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _departamentoController = TextEditingController();
  final TextEditingController _provinciaController = TextEditingController();
  final TextEditingController _distritoController = TextEditingController();
  final TextEditingController _telefonoCelularController = TextEditingController();


  // Inicialización para el API
  late ApiService apiService;
  late SocialServicesService socialServicesService;

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
     apiService = ApiService(); // Aquí inicializas ApiService
    socialServicesService = SocialServicesService(
        apiService: apiService); // Aquí inicializas SocialServicesService

    
  }

  @override
  void dispose() {
    _direccionController.dispose();
    _provinciaController.dispose();
    _distritoController.dispose();
    _telefonoCelularController.dispose();
    _departamentoController.dispose();
    super.dispose();
  }

 Future<void> _submitForm() async {
  // Validaciones previas
  if (_direccionController.text.trim().isEmpty ||
      _provinciaController.text.trim().isEmpty ||
      _departamentoController.text.trim().isEmpty ||
      _distritoController.text.trim().isEmpty) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Por favor, complete todos los campos")),
    );
    return;
  }

  if (_image1 == null) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Por favor, cargue una foto")),
    );
    return;
  }

  if (_image2 == null) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Por favor, cargue una firma")),
    );
    return;
  }

  // Codificar imágenes en base64
  String encodedImage1 = base64Encode(await _image1!.readAsBytes());
  String encodedImage2 = base64Encode(await _image2!.readAsBytes());

  // Validar teléfono celular
  String telefonoCelular = _telefonoCelularController.text.trim();
  if (telefonoCelular.isNotEmpty && telefonoCelular.length < 9) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("El teléfono celular debe tener 9 dígitos")),
    );
    return;
  }
  if (telefonoCelular.isEmpty) telefonoCelular = '';

  // Consolidar datos
  final consolidatedData = {
    ...widget.firstData,
    "direccion": _direccionController.text.trim(),
    "departamento": _departamentoController.text.trim(),
    "provincia": _provinciaController.text.trim(),
    "distrito": _distritoController.text.trim(),
    "telefonoCelular": telefonoCelular.isEmpty ? null : telefonoCelular,
    "foto": encodedImage1,
    "firma": encodedImage2,
    "isAdmin": false,
    //"idDigital": "09174019",
  };

  try {
    final response = await socialServicesService.createIdentification(consolidatedData);

    if (!mounted) return;

    if (response != null) {
      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registro exitoso: ${response['message']}")),
      );*/

      // Navegar a la pantalla de éxito
      Navigator.pushNamed(context, 'registro_exitoso_adulto_mayor');
    }
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error al guardar la identificación: $e")),
    );
  }
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
           onPressed: () async {
    final prefs = await SharedPreferences.getInstance();

    // Guardamos temporalmente los datos
    await prefs.setString('direccion_temp', _direccionController.text);
    await prefs.setString('departamento_temp', _departamentoController.text);
    await prefs.setString('provincia_temp', _provinciaController.text);
    await prefs.setString('distrito_temp', _distritoController.text);
    await prefs.setString('telefono_temp', _telefonoCelularController.text);

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
                '*Dirección',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _direccionController,
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
                '*Departamento',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _departamentoController,
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
                '*Provincia',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _provinciaController,
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
                '*Distrito',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _distritoController,
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
                'Teléfono celular',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _telefonoCelularController,
              keyboardType:
                  TextInputType.number, // Establece el teclado numérico
              inputFormatters: [
                LengthLimitingTextInputFormatter(
                    9), // Limita el número de caracteres a 9
              ],
              decoration: InputDecoration(
                filled: true,
                hintText: 'Teléfono celular',
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
                if (_telefonoCelularController.text.trim().isEmpty) {
                  _telefonoCelularController.text = '9'; // Preestablece el número 9
                  _telefonoCelularController.selection = TextSelection.collapsed(
                      offset: 1); // Mueve el cursor al final
                }
              },
            ),

            const SizedBox(height: 10),
// Botón para adjuntar una foto
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                '*Cargar foto',
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
if (_image1 != null)
  CircleAvatar(
    radius: 120, // radio = mitad del tamaño (150 / 2)
    backgroundImage: FileImage(_image1!),
    backgroundColor: Colors.transparent,
  ),


            const SizedBox(height: 10),
// Botón para adjuntar una foto
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                '*Cargar firma',
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
            ClipRRect(
                          borderRadius: BorderRadius.circular(
                              12.0), // Establecer el radio de los bordes
                          child: Image.file(
                            _image2!,
                            height: 100,
                            width: double
                                .infinity, // Asegura que la imagen ocupe todo el ancho
                            fit: BoxFit
                                .cover, // Mantiene la proporción sin recortar la imagen
                          ),
                        ),
              

            const SizedBox(height: 20),
            // Selector de género

            ElevatedButton(
              onPressed: _submitForm,//_submitForm,
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
