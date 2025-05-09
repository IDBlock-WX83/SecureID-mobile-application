import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesario para formatear la fecha seleccionada
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Para manejar archivos de imagen

class EnergyServiceRegistrationScreen extends StatefulWidget {
  const EnergyServiceRegistrationScreen({Key? key}) : super(key: key);

  @override
  _EnergyServiceRegistrationScreenState createState() =>
      _EnergyServiceRegistrationScreenState();
}

class _EnergyServiceRegistrationScreenState
    extends State<EnergyServiceRegistrationScreen> {
  // Usando StatefulWidget, ahora puedes manejar el TextEditingController
  final TextEditingController _titulocamapaniaController =
      TextEditingController();

  final TextEditingController _lugarcamapaniaController =
      TextEditingController();

  final TextEditingController _descripcioncamapaniaController =
      TextEditingController();

  final TextEditingController _fechaController = TextEditingController();

  final TextEditingController _timeController = TextEditingController();

  // Función para seleccionar la hora
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), // Hora inicial
    );

    if (picked != null) {
      // Formatea la hora a AM/PM
      final now = DateTime.now();
      final formattedTime = DateFormat.jm().format(
        DateTime(now.year, now.month, now.day, picked.hour, picked.minute),
      );

      // Actualiza el controlador con la hora formateada
      setState(() {
        _timeController.text = formattedTime;
      });
    }
  }

  @override
  void dispose() {
    // Limpiamos el controlador cuando el widget sea destruido
    _titulocamapaniaController.dispose();
    _fechaController.dispose();
    _lugarcamapaniaController.dispose();
    _descripcioncamapaniaController.dispose();

    super.dispose();
  }

  // Método para mostrar el DatePicker y seleccionar la fecha de nacimiento
  Future<void> _selectBirthDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900), // Fecha mínima
      lastDate: DateTime.now(), // Fecha máxima
    );

    if (selectedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
      setState(() {
        _fechaController.text =
            formattedDate; // Actualiza el TextField con la fecha seleccionada
      });
    }
  }

  void _goToSecondScreen() {
    // Verifica que todos los campos estén completos
    if (_titulocamapaniaController.text.trim().isEmpty ||
        _fechaController.text.trim().isEmpty ||
        _timeController.text.trim().isEmpty ||
        _lugarcamapaniaController.text.trim().isEmpty ||
        _descripcioncamapaniaController.text.trim().isEmpty) {
      // Verifica que el estado civil no esté vacío
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, complete todos los campos")),
      );
      return;
    }

    // Consolidar los datos del primer formulario
    /*final firstData = {
      "preNombres": _nameController.text.trim(),
      "apellidoPaterno": _paternalSurnameController.text.trim(),
      "apellidoMaterno": _maternalSurnameController.text.trim(),
      "fechaNacimiento": _birthDateController.text.trim(),
      "fechaInscripcion": _inscriptionDateController.text.trim(),
      "sexo": _selectedSexo,
      "estadoCivil": _selectedEstadoCivil,
    };*/

    // Navegar al segundo formulario enviando los datos
    Navigator.pushNamed(context, 'servicio_creado_general');
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00747C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Social',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFC7C7CC),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Ajuste de padding

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00747C),
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Título de campaña',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller:
                            _titulocamapaniaController, // Usamos el controlador aquí
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Título de campaña',
                          hintStyle: const TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                          ),
                          fillColor: const Color(0xFFD9D9D9),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
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
                          'Lugar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller:
                            _lugarcamapaniaController, // Usamos el controlador aquí
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Lugar',
                          hintStyle: const TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                          ),
                          fillColor: const Color(0xFFD9D9D9),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
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
                          'Fecha',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => _selectBirthDate(context),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: _fechaController,
                            decoration: InputDecoration(
                              filled: true,
                              hintText: 'Fecha',
                              hintStyle: const TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                              ),
                              suffixIcon: const Icon(Icons.calendar_today,
                                  color: Colors.grey),
                              fillColor: const Color(0xFFD9D9D9),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Hora',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller:
                            _timeController, // Usamos el controlador aquí
                        readOnly: true, // Hace el TextField solo lectura
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Hora',
                          hintStyle: const TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                          ),
                          fillColor: const Color(0xFFD9D9D9),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onTap: () {
                          _selectTime(
                              context); // Llama a la función cuando el TextField es tocado
                        },
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Descripción',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller:
                            _descripcioncamapaniaController, // Usamos el controlador aquí
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Descripción',
                          hintStyle: const TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                          ),
                          fillColor: const Color(0xFFD9D9D9),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
// Botón para adjuntar una foto
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Cargar imagen',
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
                    Text('Cargar imagen', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ),const SizedBox(height: 10),

            // Mostrar la imagen seleccionada (si existe)
            if (_image2 != null)
              Image.file(
                _image2!,
                height: 150,
                width: double.infinity,
                fit: BoxFit
                    .contain, // Ajusta la imagen sin recortarla, manteniendo la proporción
              ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _goToSecondScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BBC9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: Text(
                      'Guardar',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
