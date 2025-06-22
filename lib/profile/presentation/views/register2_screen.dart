import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesario para formatear la fecha seleccionada
import 'package:image_picker/image_picker.dart';
import 'package:ztech_mobile_application/core/http/ResidenteService.dart';
import 'dart:io'; // Para manejar archivos de imagen
import '../../infrastructure/BlockchainApiService.dart'; // Importar el servicio
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // Para acceder a LengthLimitingTextInputFormatter
import 'dart:convert'; // Para usar base64Encode
import 'package:ztech_mobile_application/core/http/ApiService.dart';
import 'package:ztech_mobile_application/core/http/SocialServicesService.dart';
import 'package:ztech_mobile_application/core/http/LocationService.dart';

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
  final TextEditingController _telefonoCelularController =
      TextEditingController();

  // Inicialización para el API
  late ApiService apiService;
  late ResidenteService residenteService;
  late LocationService locationService;

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
    residenteService = ResidenteService(
        apiService: apiService); // Aquí inicializas SocialServicesService
    locationService = LocationService(apiService: apiService);
    _fetchDepartments(); // Cargar departamentos al inicio
  }

// Cargar todos los departamentos
  _fetchDepartments() async {
    try {
      var data = await locationService.getDepartments();
      setState(() {
        departamentos = data;
      });
    } catch (e) {
      print("Error al cargar los departamentos: $e");
    }
  }

  // Cargar provincias según el departamento seleccionado
  _fetchProvinces(int departmentId) async {
    try {
      var data = await locationService.getProvincesByDepartment(departmentId);
      setState(() {
        provincias = data;
        distritos.clear(); // Limpiar distritos al cambiar provincia
      });
    } catch (e) {
      print("Error al cargar las provincias: $e");
    }
  }

  // Cargar distritos según la provincia seleccionada
  _fetchDistricts(int provinceId) async {
    try {
      var data = await locationService.getDistrictsByProvince(provinceId);
      setState(() {
        distritos = data;
      });
    } catch (e) {
      print("Error al cargar los distritos: $e");
    }
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

    if (_selectedDepartamentoId == null ||
        _selectedProvinciaId == null ||
        _selectedDistritoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Por favor, complete todos los campos")));
      return;
    }

    // Validar dirección
    if (_direccionController.text.trim().isEmpty) {
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
        const SnackBar(
            content: Text("El teléfono celular debe tener 9 dígitos")),
      );
      return;
    }
    if (telefonoCelular.isEmpty) telefonoCelular = '';

    // Consolidar datos
    final consolidatedData = {
      ...widget.firstData,
      "direccion": _direccionController.text.trim(),
      //"departamento": _selectedDepartamentoName,
      //"provincia": _selectedProvinciaName,
      "distrito": {
        "id": _selectedDistritoId
       
    },
      "telefonoCelular": telefonoCelular.isEmpty ? null : telefonoCelular,
      "foto": encodedImage1,
      "firma": encodedImage2,
      "isAdmin": false,
      //"idDigital": "09174019",
    };

    try {
      final response =
          await residenteService.createIdentification(consolidatedData);

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

  // Variables de selección
  String? _selectedDepartamentoId;
  String? _selectedDepartamentoName;

  String? _selectedProvinciaId;
  String? _selectedProvinciaName;

  String? _selectedDistritoId;
  String? _selectedDistritoName;

  // Listas de departamentos, provincias y distritos
  List<Map<String, dynamic>> departamentos = [];
  List<Map<String, dynamic>> provincias = [];
  List<Map<String, dynamic>> distritos = [];

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
            await prefs.setString(
                'departamento_temp', _departamentoController.text);
            await prefs.setString('provincia_temp', _provinciaController.text);
            await prefs.setString('distrito_temp', _distritoController.text);
            await prefs.setString(
                'telefono_temp', _telefonoCelularController.text);

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
            DropdownButtonFormField<String>(
              value: _selectedDepartamentoId,
              hint: const Text("Seleccione Departamento"),
              items: departamentos.map((department) {
                return DropdownMenuItem<String>(
                  value: department['id'].toString(),
                  child: Text(department['departamento']),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDepartamentoId = newValue;
                  _selectedDepartamentoName = departamentos.firstWhere(
                      (element) =>
                          element['id'].toString() == newValue)['departamento'];
                  _selectedProvinciaId = null; // Resetear provincia
                  _selectedDistritoId = null; // Resetear distrito
                });
                if (newValue != null) {
                  _fetchProvinces(int.parse(newValue)); // Cargar provincias
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            /////////////////////////////////////////

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
            DropdownButtonFormField<String>(
              value: _selectedProvinciaId,
              hint: const Text("Seleccione Provincia"),
              items: provincias.map((province) {
                return DropdownMenuItem<String>(
                  value: province['id'].toString(),
                  child: Text(province['provincia']),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedProvinciaId = newValue;
                  _selectedProvinciaName = provincias.firstWhere((element) =>
                      element['id'].toString() == newValue)['provincia'];
                  _selectedDistritoId = null; // Resetear distrito
                });
                if (newValue != null) {
                  _fetchDistricts(int.parse(newValue)); // Cargar distritos
                }
              },
              decoration: InputDecoration(
                filled: true,
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

            DropdownButtonFormField<String>(
              value: _selectedDistritoId,
              hint: const Text("Seleccione Distrito"),
              items: distritos.map((district) {
                return DropdownMenuItem<String>(
                  value: district['id'].toString(),
                  child: Text(district['distrito']),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDistritoId = newValue;
                  _selectedDistritoName = distritos.firstWhere((element) =>
                      element['id'].toString() == newValue)['distrito'];
                });
              },
              decoration: InputDecoration(
                filled: true,
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
                  _telefonoCelularController.text =
                      '9'; // Preestablece el número 9
                  _telefonoCelularController.selection =
                      TextSelection.collapsed(
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
                radius: 100,
                backgroundColor: Colors.grey[400],
                child: (_image1 != null)
                    ? ClipOval(
                        child: Image.memory(
                          _image1 != null
                              ? _image1!.readAsBytesSync()
                              : Uint8List(0),
                          fit: BoxFit.cover,
                          width: 200,
                          height: 200,
                        ),
                      )
                    : const Icon(Icons.person, size: 28, color: Colors.white),
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
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12), // Bordes redondeados
                ),
                child: _image2 != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                            12), // Bordes redondeados también aquí
                        child: Image.memory(
                          _image2 != null
                              ? _image2!.readAsBytesSync()
                              : Uint8List(0),
                          fit: BoxFit.fill,
                        ),
                      )
                    : const Center(child: Text('Sin firma')),
              ),

            const SizedBox(height: 20),
            // Selector de género

            ElevatedButton(
              onPressed: _submitForm, //_submitForm,
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
