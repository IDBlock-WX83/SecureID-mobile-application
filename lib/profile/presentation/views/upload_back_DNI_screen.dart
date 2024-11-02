import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../menu/success_popup.dart'; // Para manejar archivos de imagen

class UploadBackDNIScreen extends StatefulWidget {
  const UploadBackDNIScreen({super.key});

  @override
  _UploadBackDNIScreenState createState() => _UploadBackDNIScreenState();
}

class _UploadBackDNIScreenState extends State<UploadBackDNIScreen> {
  File? _dniImage; // Para almacenar la imagen del DNI

  // Método para seleccionar imagen desde galería o cámara
  Future<void> _pickDniImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _dniImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00747C),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const Text(
                'Subir DNI',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              // Área para cargar o tomar la foto del DNI
              GestureDetector(
                onTap: () async {
                  // Seleccionar si es desde galería o cámara
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Wrap(
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Galería'),
                              onTap: () {
                                Navigator.of(context).pop();
                                _pickDniImage(ImageSource.gallery);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_camera),
                              title: const Text('Cámara'),
                              onTap: () {
                                Navigator.of(context).pop();
                                _pickDniImage(ImageSource.camera);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: _dniImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.camera_alt,
                                size: 60, color: Colors.black54),
                            SizedBox(height: 10),
                            Text(
                              'Parte posterior del DNI dentro del recuadro',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            _dniImage!,
                            fit: BoxFit
                                .fill, // Ajusta la imagen para que ocupe todo el contenedor
                            width: double.infinity,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Parte posterior del DNI dentro del recuadro',
                style: TextStyle(color: Colors.black, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Botón de Continuar
              ElevatedButton(
                onPressed: () {
                  if (_dniImage != null) {

                    Navigator.pushNamed(context, 'menu');
                    print("DNI Subido correctamente");
                    // Aquí puedes agregar la lógica para enviar la imagen
                  } else {
                    Navigator.pushNamed(context, 'menu');

                    print("Por favor, sube una imagen del DNI");
                  }
                },
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
      ),
    );
  }
}
