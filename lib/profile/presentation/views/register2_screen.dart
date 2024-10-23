import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Necesario para formatear la fecha seleccionada
import 'package:image_picker/image_picker.dart';
import 'dart:io';  // Para manejar archivos de imagen

class SignUpScreen2 extends StatefulWidget {
  const SignUpScreen2({Key? key}) : super(key: key);

  @override
  _SignUpScreen2State createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  String _gender = "M";  // Género por defecto
  File? _signatureImage; // Para almacenar la firma cargada

  // Libera los controladores cuando ya no son necesarios
  @override
  void dispose() {
    _regionController.dispose();
    _provinceController.dispose();
    _districtController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  // Método para mostrar el DatePicker y seleccionar la fecha
  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),  // Fecha mínima
      lastDate: DateTime.now(),   // Fecha máxima
    );

    if (selectedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
      setState(() {
        _birthDateController.text = formattedDate;  // Actualiza el TextField con la fecha seleccionada
      });
    }
  }

  // Método para seleccionar imagen desde galería o cámara
  Future<void> _pickSignature(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _signatureImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00747C),
      resizeToAvoidBottomInset: true,  // Permite que el contenido se ajuste cuando aparece el teclado
      body: SingleChildScrollView(  // Hace que el contenido sea desplazable cuando aparece el teclado
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),  // Espacio superior para asegurar que haya espacio con el teclado
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
              'Registro',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            // Campo de texto: Región con labelText flotante
            TextField(
              controller: _regionController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
                labelText: 'Región',  // Label flotante
                labelStyle: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold), // Ajuste de estilo
                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Ajuste de padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Campo de texto: Provincia con labelText flotante
            TextField(
              controller: _provinceController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
                labelText: 'Provincia',  // Label flotante
                labelStyle: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold), // Ajuste de estilo
                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Ajuste de padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Campo de texto: Distrito con labelText flotante
            TextField(
              controller: _districtController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
                labelText: 'Distrito',  // Label flotante
                labelStyle: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold), // Ajuste de estilo
                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Ajuste de padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Campo de selección de Sexo con estilo similar al resto
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
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
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
            // Cargar Firma
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
                              _pickSignature(ImageSource.gallery);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo_camera),
                            title: const Text('Cámara'),
                            onTap: () {
                              Navigator.of(context).pop();
                              _pickSignature(ImageSource.camera);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFD9D9D9),
                    labelText: 'Cargar Firma',
                    labelStyle: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                    suffixIcon: const Icon(Icons.attach_file, color: Colors.grey), // Ícono de carga
                    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Mostrar la firma cargada si existe
            if (_signatureImage != null)
              Image.file(
                _signatureImage!,
                height: 250,
                width: 250,   // Ajusta el ancho de la imagen
    fit: BoxFit.fill,  // Esta propiedad ajusta cómo la imagen se adapta al contenedor
                
              ),
            const SizedBox(height: 20),
            // Botón de Continuar
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'upload_front_dni');

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C2CB),
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Continuar',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
                        const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
