import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesario para formatear la fecha seleccionada
import 'package:image_picker/image_picker.dart';
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
  late SocialServicesService socialServicesService;
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
    socialServicesService = SocialServicesService(
        apiService: apiService); // Aquí inicializas SocialServicesService
locationService = LocationService(apiService: apiService);
    _fetchDepartments();  // Cargar departamentos al inicio
  
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

  if (_selectedDepartamentoId == null || _selectedProvinciaId == null || _selectedDistritoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Por favor, complete todos los campos")));
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
      "departamento": _selectedDepartamentoName,
      "provincia": _selectedProvinciaName,
      "distrito":_selectedDistritoName,
      "telefonoCelular": telefonoCelular.isEmpty ? null : telefonoCelular,
      "foto": encodedImage1,
      "firma": encodedImage2,
      "isAdmin": false,
      //"idDigital": "09174019",
    };

    try {
      final response =
          await socialServicesService.createIdentification(consolidatedData);

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
      child: Text(department['nombre']),
    );
  }).toList(),
  onChanged: (String? newValue) {
    setState(() {
      _selectedDepartamentoId = newValue;
      _selectedDepartamentoName = departamentos
          .firstWhere((element) => element['id'].toString() == newValue)
          ['nombre'];
      _selectedProvinciaId = null;  // Resetear provincia
      _selectedDistritoId = null;   // Resetear distrito
    });
    if (newValue != null) {
      _fetchProvinces(int.parse(newValue));  // Cargar provincias
    }
  },
  decoration: InputDecoration(
    filled: true,
    fillColor: const Color(0xFFD9D9D9),
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
      child: Text(province['nombre']),
    );
  }).toList(),
  onChanged: (String? newValue) {
    setState(() {
      _selectedProvinciaId = newValue;
      _selectedProvinciaName = provincias
          .firstWhere((element) => element['id'].toString() == newValue)
          ['nombre'];
      _selectedDistritoId = null;  // Resetear distrito
    });
    if (newValue != null) {
      _fetchDistricts(int.parse(newValue));  // Cargar distritos
    }
  },
  decoration: InputDecoration(
    filled: true,
    fillColor: const Color(0xFFD9D9D9),
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
  ),
)
,

            

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
      child: Text(district['nombre']),
    );
  }).toList(),
  onChanged: (String? newValue) {
    setState(() {
      _selectedDistritoId = newValue;
      _selectedDistritoName = distritos
          .firstWhere((element) => element['id'].toString() == newValue)
          ['nombre'];
    });
  },
  decoration: InputDecoration(
    filled: true,
    fillColor: const Color(0xFFD9D9D9),
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
  ),
)
,

           
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
                child: (_image1!= null )
                    ? ClipOval(
                        child: Image.memory(
_image2 != null ? _image1!.readAsBytesSync() : Uint8List(0),
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
                child: _image2!= null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                            12), // Bordes redondeados también aquí
                        child: Image.memory(
_image2 != null ? _image2!.readAsBytesSync() : Uint8List(0),
                fit: BoxFit.contain,
                        ),
                      )
                    : const Center(child: Text('Sin firma')),
              )
              ,

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



/*
PARA DEPARTAMENTOS:

INSERT INTO secureid.departamento (nombre) VALUES
('Amazonas'),
('Ancash'),
('Apurimac'),
('Arequipa'),
('Ayacucho'),
('Cajamarca'),
('Cusco'),
('Huancavelica'),
('Huanuco'),
('Ica'),
('Junin'),
('La Libertad'),
('Lambayeque'),
('Lima'),
('Loreto'),
('Madre de Dios'),
('Moquegua'),
('Pasco'),
('Piura'),
('Puno'),
('San Martin'),
('Tacna'),
('Tumbes'),
('Callao'),
('Ucayali');
 */




/*
PARA PROVINCIAS:

AMAZONAS
INSERT INTO secureid.provincia (departamento_id, nombre) VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Amazonas'), 'Chachapoyas'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Amazonas'), 'Bagua'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Amazonas'), 'Bongara'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Amazonas'), 'Luya'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Amazonas'), 'Rodriguez de Mendoza'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Amazonas'), 'Condorcanqui'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Amazonas'), 'Utcubamba');

ANCASH
INSERT INTO secureid.provincia (departamento_id, nombre) VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Ancash'), 'Huaraz'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ancash'), 'Aija'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ancash'), 'Bolognesi'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ancash'), 'Carhuaz'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ancash'), 'Casma'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ancash'), 'Corongo'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ancash'), 'Huaylas'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ancash'), 'Huari'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ancash'), 'Mariscal Luzuriaga'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ancash'), 'Pallasca'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ancash'), 'Pomabamba'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ancash'), 'Recuay'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ancash'), 'Santa'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ancash'), 'Sihuas'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ancash'), 'Yungay'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ancash'), 'Antonio Raymondi'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ancash'), 'Carlos Fermin Fitzca'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ancash'), 'Asuncion'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ancash'), 'Huarmey'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ancash'), 'Ocros');

APURIMAC
INSERT INTO secureid.provincia (departamento_id, nombre) VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Apurimac'), 'Abancay'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Apurimac'), 'Aymaraes'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Apurimac'), 'Andahuaylas'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Apurimac'), 'Antabamba'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Apurimac'), 'Cotabambas'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Apurimac'), 'Grau'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Apurimac'), 'Chincheros');

AREQUIPA
INSERT INTO secureid.provincia (departamento_id, nombre) VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Arequipa'), 'Arequipa'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Arequipa'), 'Caylloma'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Arequipa'), 'Camana'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Arequipa'), 'Caraveli'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Arequipa'), 'Castilla'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Arequipa'), 'Condesuyos'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Arequipa'), 'Islay'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Arequipa'), 'La Union');

AYACUCHO
INSERT INTO secureid.provincia (departamento_id, nombre) VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Ayacucho'), 'Huamanga'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ayacucho'), 'Cangallo'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ayacucho'), 'Huanta'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ayacucho'), 'La Mar'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ayacucho'), 'Lucanas'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ayacucho'), 'Parinacochas'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ayacucho'), 'Victor Fajardo'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ayacucho'), 'Huanca Sancos'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ayacucho'), 'Vilcas Huaman'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ayacucho'), 'Paucar del Sara Sara'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ayacucho'), 'Sucre');

CAJAMARCA
INSERT INTO secureid.provincia (departamento_id, nombre) VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Cajamarca'), 'Cajamarca'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cajamarca'), 'Cajabamba'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cajamarca'), 'Celendin'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cajamarca'), 'Contumaza'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cajamarca'), 'Cutervo'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cajamarca'), 'Chota'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cajamarca'), 'Hualgayoc'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cajamarca'), 'Jaen'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cajamarca'), 'Santa Cruz'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cajamarca'), 'San Miguel'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cajamarca'), 'San Ignacio'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cajamarca'), 'San Marcos'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cajamarca'), 'San Pablo');

CALLAO
INSERT INTO secureid.provincia (departamento_id, nombre) VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Callao'), 'Callao');

CUSCO
INSERT INTO secureid.provincia (departamento_id, nombre) 
VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Cusco'), 'Cusco'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cusco'), 'Acomayo'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cusco'), 'Anta'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cusco'), 'Calca'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cusco'), 'Canas'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cusco'), 'Canchis'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cusco'), 'Chumbivilcas'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cusco'), 'Espinar'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cusco'), 'La Convencion'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cusco'), 'Paruro'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cusco'), 'Paucartambo'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cusco'), 'Quispicanchi'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Cusco'), 'Urubamba');

HUANCAVELICA
INSERT INTO secureid.provincia (departamento_id, nombre) 
VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Huancavelica'), 'Huancavelica'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Huancavelica'), 'Acobamba'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Huancavelica'), 'Angaraes'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Huancavelica'), 'Castrovirreyna'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Huancavelica'), 'Tayacaja'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Huancavelica'), 'Huaytara'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Huancavelica'), 'Churcampa');

HUANUCO
INSERT INTO secureid.provincia (departamento_id, nombre) 
VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Huanuco'), 'Huanuco'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Huanuco'), 'Ambo'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Huanuco'), 'Dos de Mayo'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Huanuco'), 'Huamalies'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Huanuco'), 'Marañon'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Huanuco'), 'Leoncio Prado'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Huanuco'), 'Pachitea'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Huanuco'), 'Puerto Inca'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Huanuco'), 'Huacaybamba'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Huanuco'), 'Lauricocha'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Huanuco'), 'Yarowilca');

ICA
INSERT INTO secureid.provincia (departamento_id, nombre) 
VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Ica'), 'Ica'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ica'), 'Chincha'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ica'), 'Nazca'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ica'), 'Pisco'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ica'), 'Palpa');

JUNIN
INSERT INTO secureid.provincia (departamento_id, nombre) 
VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Junin'), 'Junin'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Junin'), 'Huancayo'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Junin'), 'Concepcion'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Junin'), 'Jauja'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Junin'), 'Tarma'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Junin'), 'Yauli'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Junin'), 'Satipo'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Junin'), 'Chanchamayo'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Junin'), 'Chupaca');

LA LIBERTAD
INSERT INTO secureid.provincia (departamento_id, nombre) 
VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'La Libertad'), 'La Libertad'),
((SELECT id FROM secureid.departamento WHERE nombre = 'La Libertad'), 'Trujillo'),
((SELECT id FROM secureid.departamento WHERE nombre = 'La Libertad'), 'Bolivar'),
((SELECT id FROM secureid.departamento WHERE nombre = 'La Libertad'), 'Sanchez Carrion'),
((SELECT id FROM secureid.departamento WHERE nombre = 'La Libertad'), 'Otuzco'),
((SELECT id FROM secureid.departamento WHERE nombre = 'La Libertad'), 'Pacasmayo'),
((SELECT id FROM secureid.departamento WHERE nombre = 'La Libertad'), 'Pataz'),
((SELECT id FROM secureid.departamento WHERE nombre = 'La Libertad'), 'Santiago de Chuco'),
((SELECT id FROM secureid.departamento WHERE nombre = 'La Libertad'), 'Ascope'),
((SELECT id FROM secureid.departamento WHERE nombre = 'La Libertad'), 'Chepen'),
((SELECT id FROM secureid.departamento WHERE nombre = 'La Libertad'), 'Julcan'),
((SELECT id FROM secureid.departamento WHERE nombre = 'La Libertad'), 'Gran Chimu'),
((SELECT id FROM secureid.departamento WHERE nombre = 'La Libertad'), 'Viru');

LAMBAYEQUE
INSERT INTO secureid.provincia (departamento_id, nombre) 
VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Lambayeque'), 'Lambayeque'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Lambayeque'), 'Chiclayo'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Lambayeque'), 'Ferreñafe');

LIMA
INSERT INTO secureid.provincia (departamento_id, nombre) 
VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Lima'), 'Lima'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Lima'), 'Cajatambo'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Lima'), 'Canta'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Lima'), 'Cañete'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Lima'), 'Huaura'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Lima'), 'Huarochiri'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Lima'), 'Yauyos'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Lima'), 'Huaral'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Lima'), 'Barranca'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Lima'), 'Oyon');

LORETO
INSERT INTO secureid.provincia (departamento_id, nombre) 
VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Loreto'), 'Maynas'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Loreto'), 'Alto Amazonas'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Loreto'), 'Loreto'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Loreto'), 'Requena'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Loreto'), 'Ucayali'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Loreto'), 'Mariscal Ramon Castilla'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Loreto'), 'Datem del Marañon');

MADRE DE DIOS
INSERT INTO secureid.provincia (departamento_id, nombre) 
VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Madre de Dios'), 'Tambopata'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Madre de Dios'), 'Manu'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Madre de Dios'), 'Tahuamanu');

MOQUEGUA
INSERT INTO secureid.provincia (departamento_id, nombre) 
VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Moquegua'), 'Mariscal Nieto'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Moquegua'), 'General Sanchez Cerro'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Moquegua'), 'Ilo');

PASCO
INSERT INTO secureid.provincia (departamento_id, nombre) 
VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Pasco'), 'Pasco'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Pasco'), 'Daniel Alcides Carrion'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Pasco'), 'Oxapampa');

PIURA
INSERT INTO secureid.provincia (departamento_id, nombre) 
VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Piura'), 'Piura'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Piura'), 'Ayabaca'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Piura'), 'Huancabamba'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Piura'), 'Morropon'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Piura'), 'Paita'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Piura'), 'Sullana'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Piura'), 'Talara'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Piura'), 'Sechura');

PUNO
INSERT INTO secureid.provincia (departamento_id, nombre) 
VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Puno'), 'Puno'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Puno'), 'Azangaro'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Puno'), 'Carabaya'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Puno'), 'Chucuito'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Puno'), 'Huancane'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Puno'), 'Lampa'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Puno'), 'Melgar'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Puno'), 'Sandia'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Puno'), 'San Roman'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Puno'), 'Yunguyo'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Puno'), 'San Antonio de Putina'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Puno'), 'El Collao'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Puno'), 'Moho');

SAN MARTIN
INSERT INTO secureid.provincia (departamento_id, nombre) 
VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'San Martin'), 'Moyobamba'),
((SELECT id FROM secureid.departamento WHERE nombre = 'San Martin'), 'Huallaga'),
((SELECT id FROM secureid.departamento WHERE nombre = 'San Martin'), 'Lamas'),
((SELECT id FROM secureid.departamento WHERE nombre = 'San Martin'), 'Mariscal Caceres'),
((SELECT id FROM secureid.departamento WHERE nombre = 'San Martin'), 'Rioja'),
((SELECT id FROM secureid.departamento WHERE nombre = 'San Martin'), 'San Martin'),
((SELECT id FROM secureid.departamento WHERE nombre = 'San Martin'), 'Bellavista'),
((SELECT id FROM secureid.departamento WHERE nombre = 'San Martin'), 'Tocache'),
((SELECT id FROM secureid.departamento WHERE nombre = 'San Martin'), 'Picota'),
((SELECT id FROM secureid.departamento WHERE nombre = 'San Martin'), 'El Dorado');

TACNA
INSERT INTO secureid.provincia (departamento_id, nombre) 
VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Tacna'), 'Tacna'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Tacna'), 'Tarata'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Tacna'), 'Jorge Basadre'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Tacna'), 'Candarave');

TUMBES
INSERT INTO secureid.provincia (departamento_id, nombre) 
VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Tumbes'), 'Tumbes'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Tumbes'), 'Contralmirante Villar'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Tumbes'), 'Zarumilla');

UCAYALI
INSERT INTO secureid.provincia (departamento_id, nombre) 
VALUES
((SELECT id FROM secureid.departamento WHERE nombre = 'Ucayali'), 'Coronel Portillo'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ucayali'), 'Padre Abad'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ucayali'), 'Atalaya'),
((SELECT id FROM secureid.departamento WHERE nombre = 'Ucayali'), 'Purus');
 */




/*
AMAZONAS
-- Insertar distritos para la provincia de Chachapoyas
INSERT INTO secureid.distrito (provincia_id, nombre) 
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Chachapoyas'), 'Chachapoyas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chachapoyas'), 'Asuncion'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chachapoyas'), 'Balsas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chachapoyas'), 'Cheto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chachapoyas'), 'Chiliquin'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chachapoyas'), 'Chuquibamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chachapoyas'), 'Granada'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chachapoyas'), 'Huancas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chachapoyas'), 'La Jalca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chachapoyas'), 'Leimebamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chachapoyas'), 'Levanto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chachapoyas'), 'Magdalena'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chachapoyas'), 'Mariscal Castilla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chachapoyas'), 'Molinopampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chachapoyas'), 'Montevideo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chachapoyas'), 'Olleros'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chachapoyas'), 'Quinjalca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chachapoyas'), 'San Francisco de Daguas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chachapoyas'), 'San Isidro de Maino'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chachapoyas'), 'Soloco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chachapoyas'), 'Sonche'),

-- Insertar distritos para la provincia de Bagua
((SELECT id FROM secureid.provincia WHERE nombre = 'Bagua'), 'La Peca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bagua'), 'Aramango'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bagua'), 'Copallin'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bagua'), 'El Parco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bagua'), 'Bagua'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bagua'), 'Imaza'),

-- Insertar distritos para la provincia de Bongara
((SELECT id FROM secureid.provincia WHERE nombre = 'Bongara'), 'Jumbilla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bongara'), 'Corosha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bongara'), 'Cuispes'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bongara'), 'Chisquilla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bongara'), 'Churuja'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bongara'), 'Florida'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bongara'), 'Recta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bongara'), 'San Carlos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bongara'), 'Shipasbamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bongara'), 'Valera'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bongara'), 'Yambrasbamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bongara'), 'Jazan'),

-- Insertar distritos para la provincia de Luya
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'Lamud'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'Camporredondo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'Cocabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'Colcamar'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'Conila'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'Inguilpata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'Longuita'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'Lonya Chico'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'Luya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'Luya Viejo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'Maria'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'Ocalli'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'Ocumal'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'Pisuquia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'San Cristobal'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'San Francisco del Yeso'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'San Jeronimo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'San Juan de Lopecancha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'Santa Catalina'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'Santo Tomas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'Tingo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'Trita'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Luya'), 'Providencia'),

-- Insertar distritos para la provincia de Rodriguez de Mendoza
((SELECT id FROM secureid.provincia WHERE nombre = 'Rodriguez de Mendoza'), 'San Nicolas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Rodriguez de Mendoza'), 'Cochamal'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Rodriguez de Mendoza'), 'Chirimoto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Rodriguez de Mendoza'), 'Huambo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Rodriguez de Mendoza'), 'Limabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Rodriguez de Mendoza'), 'Longar'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Rodriguez de Mendoza'), 'Milpuc'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Rodriguez de Mendoza'), 'Mariscal Benavides'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Rodriguez de Mendoza'), 'Omia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Rodriguez de Mendoza'), 'Santa Rosa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Rodriguez de Mendoza'), 'Totora'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Rodriguez de Mendoza'), 'Vista Alegre'),

-- Insertar distritos para la provincia de Condorcanqui
((SELECT id FROM secureid.provincia WHERE nombre = 'Condorcanqui'), 'Nieva'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Condorcanqui'), 'Rio Santiago'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Condorcanqui'), 'El Cenepa'),

-- Insertar distritos para la provincia de Utcubamba
((SELECT id FROM secureid.provincia WHERE nombre = 'Utcubamba'), 'Bagua Grande'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Utcubamba'), 'Cajaruro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Utcubamba'), 'Cumba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Utcubamba'), 'El Milagro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Utcubamba'), 'Jamalca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Utcubamba'), 'Lonya Grande'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Utcubamba'), 'Yamon');

ANCASH
-- Insertar distritos para la provincia de Huaraz
INSERT INTO secureid.distrito (provincia_id, nombre) 
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaraz'), 'Huaraz'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaraz'), 'Independencia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaraz'), 'Cochabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaraz'), 'Colcabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaraz'), 'Huanchay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaraz'), 'Jangas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaraz'), 'La Libertad'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaraz'), 'Olleros'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaraz'), 'Pampas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaraz'), 'Pariacoto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaraz'), 'Pira'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaraz'), 'Tarica'),

-- Insertar distritos para la provincia de Aija
((SELECT id FROM secureid.provincia WHERE nombre = 'Aija'), 'Aija'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Aija'), 'Coris'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Aija'), 'Huacllan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Aija'), 'La Merced'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Aija'), 'Succha'),

-- Insertar distritos para la provincia de Bolognesi
((SELECT id FROM secureid.provincia WHERE nombre = 'Bolognesi'), 'Chiquian'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bolognesi'), 'Abelardo Pardo Lezameta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bolognesi'), 'Aquia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bolognesi'), 'Cajacay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bolognesi'), 'Huayllacayan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bolognesi'), 'Huasta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bolognesi'), 'Mangas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bolognesi'), 'Pacllon'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bolognesi'), 'San Miguel de Corpanqui'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bolognesi'), 'Ticllos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bolognesi'), 'Antonio Raymondi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bolognesi'), 'Canis'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bolognesi'), 'Colquioc'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bolognesi'), 'La Primavera'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bolognesi'), 'Huallanca'),

-- Insertar distritos para la provincia de Carhuaz
((SELECT id FROM secureid.provincia WHERE nombre = 'Carhuaz'), 'Carhuaz'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carhuaz'), 'Acopampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carhuaz'), 'Amashca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carhuaz'), 'Anta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carhuaz'), 'Ataquero'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carhuaz'), 'Marcara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carhuaz'), 'Pariahuanca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carhuaz'), 'San Miguel de Aco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carhuaz'), 'Shilla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carhuaz'), 'Tinco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carhuaz'), 'Yungar'),

-- Insertar distritos para la provincia de Casma
((SELECT id FROM secureid.provincia WHERE nombre = 'Casma'), 'Casma'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Casma'), 'Buena Vista Alta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Casma'), 'Comandante Noel'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Casma'), 'Yautan'),

-- Insertar distritos para la provincia de Corongo
((SELECT id FROM secureid.provincia WHERE nombre = 'Corongo'), 'Corongo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Corongo'), 'Aco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Corongo'), 'Bambas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Corongo'), 'Cusca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Corongo'), 'La Pampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Corongo'), 'Yanac'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Corongo'), 'Yupan'),

-- Insertar distritos para la provincia de Huaylas
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaylas'), 'Caraz'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaylas'), 'Huallanca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaylas'), 'Huata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaylas'), 'Huaylas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaylas'), 'Mato'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaylas'), 'Pamparomas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaylas'), 'Pueblo Libre'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaylas'), 'Santa Cruz'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaylas'), 'Yuracmarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaylas'), 'Santo Toribio'),

-- Insertar distritos para la provincia de Huari
((SELECT id FROM secureid.provincia WHERE nombre = 'Huari'), 'Huari'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huari'), 'Cajay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huari'), 'Chavin de Huantar'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huari'), 'Huacachi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huari'), 'Huachis'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huari'), 'Huacchis'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huari'), 'Huantar'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huari'), 'Masin'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huari'), 'Paucas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huari'), 'Ponto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huari'), 'Rahuapampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huari'), 'Rapayan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huari'), 'San Marcos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huari'), 'San Pedro de Chana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huari'), 'Uco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huari'), 'Anra'),

-- Insertar distritos para la provincia de Mariscal Luzuriaga
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Luzuriaga'), 'Piscobamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Luzuriaga'), 'Casca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Luzuriaga'), 'Lucma'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Luzuriaga'), 'Fidel Olivas Escudero'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Luzuriaga'), 'Llama'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Luzuriaga'), 'Llumpa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Luzuriaga'), 'Musga'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Luzuriaga'), 'Eleazar Guzman Barron'),

-- Insertar distritos para la provincia de Pallasca
((SELECT id FROM secureid.provincia WHERE nombre = 'Pallasca'), 'Cabana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pallasca'), 'Bolognesi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pallasca'), 'Conchucos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pallasca'), 'Huacaschuque'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pallasca'), 'Huandoval'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pallasca'), 'Lacabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pallasca'), 'Llapo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pallasca'), 'Pallasca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pallasca'), 'Pampas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pallasca'), 'Santa Rosa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pallasca'), 'Tauca'),

-- Insertar distritos para la provincia de Pomabamba
((SELECT id FROM secureid.provincia WHERE nombre = 'Pomabamba'), 'Pomabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pomabamba'), 'Huayllan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pomabamba'), 'Parobamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pomabamba'), 'Quinuabamba'),

-- Insertar distritos para la provincia de Recuay
((SELECT id FROM secureid.provincia WHERE nombre = 'Recuay'), 'Recuay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Recuay'), 'Cotaparaco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Recuay'), 'Huayllapampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Recuay'), 'Marca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Recuay'), 'Pampas Chico'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Recuay'), 'Pararin'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Recuay'), 'Tapacocha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Recuay'), 'Ticapampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Recuay'), 'Llacllin'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Recuay'), 'Catac'),

-- Insertar distritos para la provincia de Santa
((SELECT id FROM secureid.provincia WHERE nombre = 'Santa'), 'Chimbote'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santa'), 'Caceres del Peru'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santa'), 'Macate'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santa'), 'Moro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santa'), 'Nepeña'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santa'), 'Samanco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santa'), 'Santa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santa'), 'Coishco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santa'), 'Nuevo Chimbote'),

-- Insertar distritos para la provincia de Sihuas
((SELECT id FROM secureid.provincia WHERE nombre = 'Sihuas'), 'Sihuas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sihuas'), 'Alfonso Ugarte'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sihuas'), 'Chingalpo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sihuas'), 'Huayllabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sihuas'), 'Quiches'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sihuas'), 'Sicsibamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sihuas'), 'Acobamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sihuas'), 'Cashapampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sihuas'), 'Ragash'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sihuas'), 'San Juan'),

-- Insertar distritos para la provincia de Yungay
((SELECT id FROM secureid.provincia WHERE nombre = 'Yungay'), 'Yungay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yungay'), 'Cascapara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yungay'), 'Mancos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yungay'), 'Matacoto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yungay'), 'Quillo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yungay'), 'Ranrahirca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yungay'), 'Shupluy'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yungay'), 'Yanama'),

-- Insertar distritos para la provincia de Antonio Raymondi
((SELECT id FROM secureid.provincia WHERE nombre = 'Antonio Raymondi'), 'Llamellin'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Antonio Raymondi'), 'Aczo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Antonio Raymondi'), 'Chaccho'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Antonio Raymondi'), 'Chingas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Antonio Raymondi'), 'Mirgas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Antonio Raymondi'), 'San Juan de Rontoy'),

-- Insertar distritos para la provincia de Carlos Fermin Fitzca
((SELECT id FROM secureid.provincia WHERE nombre = 'Carlos Fermin Fitzca'), 'San Luis'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carlos Fermin Fitzca'), 'Yauya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carlos Fermin Fitzca'), 'San Nicolas'),

-- Insertar distritos para la provincia de Asuncion
((SELECT id FROM secureid.provincia WHERE nombre = 'Asuncion'), 'Chacas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Asuncion'), 'Acochaca'),

-- Insertar distritos para la provincia de Huarmey
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarmey'), 'Huarmey'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarmey'), 'Cochapeti'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarmey'), 'Huayan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarmey'), 'Malvas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarmey'), 'Culebras'),

-- Insertar distritos para la provincia de Ocros
((SELECT id FROM secureid.provincia WHERE nombre = 'Ocros'), 'Acas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ocros'), 'Cajamarquilla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ocros'), 'Carhuapampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ocros'), 'Cochas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ocros'), 'Congas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ocros'), 'Llipa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ocros'), 'Ocros'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ocros'), 'San Cristobal de Rajan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ocros'), 'San Pedro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ocros'), 'Santiago de Chilcas');

APURIMAC
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Abancay'), 'Abancay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Abancay'), 'Circa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Abancay'), 'Curahuasi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Abancay'), 'Chacoche'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Abancay'), 'Huanipaca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Abancay'), 'Lambrama'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Abancay'), 'Pichirhua'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Abancay'), 'San Pedro de Cachora'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Abancay'), 'Tamburco'),

-- Insertar distritos para la provincia de Aymaraes
((SELECT id FROM secureid.provincia WHERE nombre = 'Aymaraes'), 'Chalhuanca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Aymaraes'), 'Capaya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Aymaraes'), 'Caraybamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Aymaraes'), 'Colcabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Aymaraes'), 'Cotaruse'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Aymaraes'), 'Chapimarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Aymaraes'), 'Huayllo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Aymaraes'), 'Lucre'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Aymaraes'), 'Pocohuanca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Aymaraes'), 'Sañayca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Aymaraes'), 'Soraya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Aymaraes'), 'Tapairihua'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Aymaraes'), 'Tintay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Aymaraes'), 'Toraya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Aymaraes'), 'Yanaca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Aymaraes'), 'San Juan de Chacña'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Aymaraes'), 'Justo Apu Sahuaraura'),

-- Insertar distritos para la provincia de Andahuaylas
((SELECT id FROM secureid.provincia WHERE nombre = 'Andahuaylas'), 'Andahuaylas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Andahuaylas'), 'Andarapa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Andahuaylas'), 'Chiara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Andahuaylas'), 'Huancarama'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Andahuaylas'), 'Huancaray'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Andahuaylas'), 'Kishuara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Andahuaylas'), 'Pacobamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Andahuaylas'), 'Pampachiri'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Andahuaylas'), 'San Antonio de Cachi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Andahuaylas'), 'San Jeronimo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Andahuaylas'), 'Talavera'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Andahuaylas'), 'Turpo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Andahuaylas'), 'Pacucha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Andahuaylas'), 'Pomacocha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Andahuaylas'), 'Santa Maria de Chicmo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Andahuaylas'), 'Tumay Huaraca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Andahuaylas'), 'Huayana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Andahuaylas'), 'San Miguel de Chaccrampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Andahuaylas'), 'Kaquiabamba'),

-- Insertar distritos para la provincia de Antabamba
((SELECT id FROM secureid.provincia WHERE nombre = 'Antabamba'), 'Antabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Antabamba'), 'El Oro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Antabamba'), 'Huaquirca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Antabamba'), 'Juan Espinoza Medrano'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Antabamba'), 'Oropesa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Antabamba'), 'Pachaconas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Antabamba'), 'Sabaino'),

-- Insertar distritos para la provincia de Cotabambas
((SELECT id FROM secureid.provincia WHERE nombre = 'Cotabambas'), 'Tambobamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cotabambas'), 'Coyllurqui'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cotabambas'), 'Cotabambas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cotabambas'), 'Haquira'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cotabambas'), 'Mara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cotabambas'), 'Challhuahuacho'),

-- Insertar distritos para la provincia de Grau
((SELECT id FROM secureid.provincia WHERE nombre = 'Grau'), 'Chuquibambilla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Grau'), 'Curpahuasi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Grau'), 'Huayllati'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Grau'), 'Mamara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Grau'), 'Gamarra'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Grau'), 'Micaela Bastidas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Grau'), 'Progreso'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Grau'), 'Pataypampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Grau'), 'San Antonio'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Grau'), 'Turpay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Grau'), 'Vilcabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Grau'), 'Virundo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Grau'), 'Santa Rosa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Grau'), 'Curasco'),

-- Insertar distritos para la provincia de Chincheros
((SELECT id FROM secureid.provincia WHERE nombre = 'Chincheros'), 'Chincheros'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chincheros'), 'Ongoy'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chincheros'), 'Ocobamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chincheros'), 'Cocharcas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chincheros'), 'Anco_Huallo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chincheros'), 'Huaccana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chincheros'), 'Uranmarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chincheros'), 'Ranracancha');

AREQUIPA
-- Insertar distritos para la provincia de Arequipa
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Arequipa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Cayma'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Cerro Colorado'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Characato'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Chiguata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'La Joya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Miraflores'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Mollebaya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Paucarpata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Pocsi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Polobaya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Quequeña'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Sabandia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Sachaca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'San Juan de Siguas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'San Juan de Tarucani'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Santa Isabel de Siguas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Santa Rita de Siguas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Socabaya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Tiabaya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Uchumayo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Vitor'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Yanahuara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Yarabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Yura'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Mariano Melgar'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Jacobo Hunter'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Alto Selva Alegre'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Arequipa'), 'Jose Luis Bustamante y Rivero');

-- Insertar distritos para la provincia de Caylloma
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Caylloma'), 'Chivay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caylloma'), 'Achoma'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caylloma'), 'Cabanaconde'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caylloma'), 'Caylloma'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caylloma'), 'Callalli'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caylloma'), 'Coporaque'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caylloma'), 'Huambo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caylloma'), 'Huanca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caylloma'), 'Ichupampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caylloma'), 'Lari'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caylloma'), 'Lluta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caylloma'), 'Maca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caylloma'), 'Madrigal'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caylloma'), 'San Antonio de Chuca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caylloma'), 'Sibayo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caylloma'), 'Tapay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caylloma'), 'Tisco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caylloma'), 'Tuti'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caylloma'), 'Yanque'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caylloma'), 'Majes');

-- Insertar distritos para la provincia de Camana
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Camana'), 'Camana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Camana'), 'Jose Maria Quimper'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Camana'), 'Mariano Nicolas Valcarcel'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Camana'), 'Mariscal Caceres'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Camana'), 'Nicolas de Pierola'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Camana'), 'Ocoña'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Camana'), 'Quilca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Camana'), 'Samuel Pastor');

-- Insertar distritos para la provincia de Caraveli
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Caraveli'), 'Caraveli'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caraveli'), 'Acari'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caraveli'), 'Atico'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caraveli'), 'Atiquipa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caraveli'), 'Bella Union'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caraveli'), 'Cahuacho'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caraveli'), 'Chala'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caraveli'), 'Chaparra'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caraveli'), 'Huanuhuanu'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caraveli'), 'Jaqui'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caraveli'), 'Lomas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caraveli'), 'Quicacha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Caraveli'), 'Yauca'),

-- Insertar distritos para la provincia de Castilla
((SELECT id FROM secureid.provincia WHERE nombre = 'Castilla'), 'Aplao'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castilla'), 'Andagua'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castilla'), 'Ayo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castilla'), 'Chachas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castilla'), 'Chilcaymarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castilla'), 'Choco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castilla'), 'Huancarqui'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castilla'), 'Machaguay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castilla'), 'Orcopampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castilla'), 'Pampacolca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castilla'), 'Tipan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castilla'), 'Uraca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castilla'), 'Uñon'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castilla'), 'Viraco');

-- Insertar distritos para la provincia de Condesuyos
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Condesuyos'), 'Chuquibamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Condesuyos'), 'Andaray'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Condesuyos'), 'Cayarani'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Condesuyos'), 'Chichas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Condesuyos'), 'Iray'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Condesuyos'), 'Salamanca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Condesuyos'), 'Yanaquihua'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Condesuyos'), 'Rio Grande');

-- Insertar distritos para la provincia de Islay
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Islay'), 'Mollendo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Islay'), 'Cocachacra'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Islay'), 'Dean Valdivia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Islay'), 'Islay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Islay'), 'Mejia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Islay'), 'Punta de Bombon');

-- Insertar distritos para la provincia de La Union
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'La Union'), 'Cotahuasi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Union'), 'Alca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Union'), 'Charcana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Union'), 'Huaynacotas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Union'), 'Pampamarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Union'), 'Puyca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Union'), 'Quechualla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Union'), 'Sayla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Union'), 'Tauria'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Union'), 'Tomepampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Union'), 'Toro');

AYACUCHO
-- Insertar distritos para la provincia de Huamanga
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamanga'), 'Ayacucho'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamanga'), 'Acos Vinchos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamanga'), 'Carmen Alto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamanga'), 'Chiara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamanga'), 'Quinua'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamanga'), 'San Jose de Ticllas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamanga'), 'San Juan Bautista'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamanga'), 'Santiago de Pischa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamanga'), 'Vinchos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamanga'), 'Tambillo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamanga'), 'Acocro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamanga'), 'Socos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamanga'), 'Ocros'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamanga'), 'Pacaycasa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamanga'), 'Jesus Nazareno');

-- Insertar distritos para la provincia de Cangallo
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Cangallo'), 'Cangallo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cangallo'), 'Chuschi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cangallo'), 'Los Morochucos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cangallo'), 'Paras'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cangallo'), 'Totos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cangallo'), 'Maria Parado de Bellido');

-- Insertar distritos para la provincia de Huanta
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanta'), 'Huanta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanta'), 'Ayahuanco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanta'), 'Huamanguilla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanta'), 'Iguain'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanta'), 'Luricocha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanta'), 'Santillana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanta'), 'Sivia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanta'), 'Llochegua'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanta'), 'San Miguel');

-- Insertar distritos para la provincia de La Mar
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'La Mar'), 'San Miguel'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Mar'), 'Anco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Mar'), 'Ayna'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Mar'), 'Chilcas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Mar'), 'Chungui'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Mar'), 'Tambo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Mar'), 'Luis Carranza'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Mar'), 'Santa Rosa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Mar'), 'Samugari'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Mar'), 'Puquio');

-- Insertar distritos para la provincia de Lucanas
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Lucanas'), 'Puquio'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lucanas'), 'Aucara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lucanas'), 'Cabana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lucanas'), 'Carmen Salcedo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lucanas'), 'Chaviña'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lucanas'), 'Chipao'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lucanas'), 'Huac-Huas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lucanas'), 'Laramate'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lucanas'), 'Leoncio Prado'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lucanas'), 'Lucanas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lucanas'), 'Llauta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lucanas'), 'Ocaña'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lucanas'), 'Otoca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lucanas'), 'Sancos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lucanas'), 'San Juan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lucanas'), 'San Pedro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lucanas'), 'Santa Ana de Huaycahuacho'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lucanas'), 'Santa Lucia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lucanas'), 'Saisa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lucanas'), 'San Pedro de Palco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lucanas'), 'San Cristobal');

-- Insertar distritos para la provincia de Parinacochas
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Parinacochas'), 'Coracora'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Parinacochas'), 'Coronel Castañeda'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Parinacochas'), 'Chumpi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Parinacochas'), 'Pacapausa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Parinacochas'), 'Pullo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Parinacochas'), 'Puyusca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Parinacochas'), 'San Francisco de Ravacayco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Parinacochas'), 'Upahuacho');

-- Insertar distritos para la provincia de Victor Fajardo
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Victor Fajardo'), 'Huancapi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Victor Fajardo'), 'Alcamenca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Victor Fajardo'), 'Apongo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Victor Fajardo'), 'Canaria'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Victor Fajardo'), 'Cayara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Victor Fajardo'), 'Colca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Victor Fajardo'), 'Huaya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Victor Fajardo'), 'Huamanquiquia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Victor Fajardo'), 'Huancaraylla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Victor Fajardo'), 'Sarhua'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Victor Fajardo'), 'Vilcanchos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Victor Fajardo'), 'Asquipata');

-- Insertar distritos para la provincia de Huanca Sancos
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanca Sancos'), 'Sancos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanca Sancos'), 'Sacsamarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanca Sancos'), 'Santiago de Lucanamarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanca Sancos'), 'Carapo');

-- Insertar distritos para la provincia de Vilcas Huaman
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Vilcas Huaman'), 'Vilcas Huaman'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Vilcas Huaman'), 'Vischongo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Vilcas Huaman'), 'Accomarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Vilcas Huaman'), 'Carhuanca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Vilcas Huaman'), 'Concepcion'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Vilcas Huaman'), 'Huambalpa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Vilcas Huaman'), 'Saurama'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Vilcas Huaman'), 'Independencia');

-- Insertar distritos para la provincia de Paucar del Sara Sara
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Paucar del Sara Sara'), 'Pausa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paucar del Sara Sara'), 'Colta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paucar del Sara Sara'), 'Corculla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paucar del Sara Sara'), 'Lampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paucar del Sara Sara'), 'Marcabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paucar del Sara Sara'), 'Oyolo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paucar del Sara Sara'), 'Pararca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paucar del Sara Sara'), 'San Javier de Alpabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paucar del Sara Sara'), 'San Jose de Ushua'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paucar del Sara Sara'), 'Sara Sara');

-- Insertar distritos para la provincia de Sucre
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Sucre'), 'Querobamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sucre'), 'Belen'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sucre'), 'Chalcos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sucre'), 'San Salvador de Quije'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sucre'), 'Paico'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sucre'), 'Santiago de Paucaray'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sucre'), 'San Pedro de Larcay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sucre'), 'Soras'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sucre'), 'Huacaña'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sucre'), 'Chilcayoc'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sucre'), 'Morcolla');

CAJAMARCA
-- Insertar distritos para la provincia de Cajamarca
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Cajamarca'), 'Cajamarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cajamarca'), 'Asuncion'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cajamarca'), 'Cospan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cajamarca'), 'Chetilla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cajamarca'), 'Encañada'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cajamarca'), 'Jesus'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cajamarca'), 'Los Baños del Inca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cajamarca'), 'Llacanora'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cajamarca'), 'Magdalena'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cajamarca'), 'Matara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cajamarca'), 'Namora'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cajamarca'), 'San Juan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cajamarca'), 'Cajabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cajamarca'), 'Cachachi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cajamarca'), 'Condebamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cajamarca'), 'Sitacocha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Celendin'), 'Celendin'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Celendin'), 'Cortegana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Celendin'), 'Chumuch'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Celendin'), 'Huasmin'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Celendin'), 'Jorge Chavez'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Celendin'), 'Jose Galvez'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Celendin'), 'Miguel Iglesias'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Celendin'), 'Oxamarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Celendin'), 'Sorochuco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Celendin'), 'Sucre'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Celendin'), 'Utco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Celendin'), 'La Libertad de Pallan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Contumaza'), 'Contumaza'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Contumaza'), 'Chilete'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Contumaza'), 'Guzmango'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Contumaza'), 'San Benito'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Contumaza'), 'Cupisnique'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Contumaza'), 'Tantarica'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Contumaza'), 'Yonan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Contumaza'), 'Santa Cruz de Toled'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cutervo'), 'Cutervo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cutervo'), 'Callayuc'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cutervo'), 'Cujillo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cutervo'), 'Choros'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cutervo'), 'La Ramada'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cutervo'), 'Pimpingos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cutervo'), 'Querocotillo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cutervo'), 'San Andres de Cutervo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cutervo'), 'San Juan de Cutervo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cutervo'), 'San Luis de Lucma'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cutervo'), 'Santa Cruz'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cutervo'), 'Santo Domingo de La Capilla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cutervo'), 'Santo Tomas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cutervo'), 'Socota'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cutervo'), 'Toribio Casanova'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chota'), 'Chota'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chota'), 'Anguia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chota'), 'Cochabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chota'), 'Conchan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chota'), 'Chadin'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chota'), 'Chiguirip'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chota'), 'Chimban'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chota'), 'Huambos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chota'), 'Lajas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chota'), 'Llama'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chota'), 'Miracosta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chota'), 'Paccha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chota'), 'Pion'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chota'), 'Querocoto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chota'), 'Tacabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chota'), 'Tocmoche'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chota'), 'San Juan de Licupis'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chota'), 'Choropampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chota'), 'Chalamarca'),

-- Insertar distritos para la provincia de Hualgayoc, Jaen, Santa Cruz, San Miguel, San Ignacio, San Marcos
((SELECT id FROM secureid.provincia WHERE nombre = 'Hualgayoc'), 'Bambamarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Hualgayoc'), 'Chugur'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Hualgayoc'), 'Hualgayoc'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jaen'), 'Jaen'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jaen'), 'Bellavista'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jaen'), 'Colasay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jaen'), 'Chontali'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jaen'), 'Pomahuaca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jaen'), 'Pucara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jaen'), 'Sallique'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jaen'), 'San Felipe'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jaen'), 'San Jose del Alto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jaen'), 'Santa Rosa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jaen'), 'Las Pirias'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jaen'), 'Huabal'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santa Cruz'), 'Santa Cruz'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santa Cruz'), 'Catache'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santa Cruz'), 'Chancaybaños'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santa Cruz'), 'La Esperanza'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santa Cruz'), 'Ninabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santa Cruz'), 'Pulan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santa Cruz'), 'Sexi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santa Cruz'), 'Uticyacu'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santa Cruz'), 'Yauyucan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santa Cruz'), 'Andabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santa Cruz'), 'Saucepampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Miguel'), 'San Miguel'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Miguel'), 'Calquis'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Miguel'), 'La Florida'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Miguel'), 'Llapa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Miguel'), 'Nanchoc'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Miguel'), 'Niepos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Miguel'), 'San Gregorio'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Miguel'), 'San Silvestre de Cochan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Miguel'), 'El Prado'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Miguel'), 'Union Agua Blanca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Miguel'), 'Tongod'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Miguel'), 'Catilluc'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Miguel'), 'Bolivar'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Ignacio'), 'San Ignacio'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Ignacio'), 'Chirinos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Ignacio'), 'Huarango'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Ignacio'), 'Namballe'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Ignacio'), 'La Coipa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Ignacio'), 'San Jose de Lourdes'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Ignacio'), 'Tabaconas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Marcos'), 'Pedro Galvez'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Marcos'), 'Ichocan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Marcos'), 'Gregorio Pita'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Marcos'), 'Jose Manuel Quiroz'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Marcos'), 'Eduardo Villanueva'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Marcos'), 'Jose Sabogal'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Marcos'), 'Chancay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Pablo'), 'San Pablo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Pablo'), 'San Bernardino'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Pablo'), 'San Luis'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Pablo'), 'Tumbaden');

CALLAO
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Callao'), 'Callao'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Callao'), 'Bellavista'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Callao'), 'La Punta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Callao'), 'Carmen de La Legua'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Callao'), 'La Perla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Callao'), 'Ventanilla');

CUSCO
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Cusco'), 'Cusco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cusco'), 'Ccorca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cusco'), 'Poroy'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cusco'), 'San Jeronimo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cusco'), 'San Sebastian'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cusco'), 'Santiago'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cusco'), 'Saylla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cusco'), 'Wanchaq'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Acomayo'), 'Acomayo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Acomayo'), 'Acopia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Acomayo'), 'Acos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Acomayo'), 'Pomacanchi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Acomayo'), 'Rondocan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Acomayo'), 'Sangarara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Acomayo'), 'Mosoc Llacta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Anta'), 'Anta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Anta'), 'Chinchaypujio'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Anta'), 'Huarocondo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Anta'), 'Limatambo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Anta'), 'Mollepata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Anta'), 'Pucyura'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Anta'), 'Zurite'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Anta'), 'Cachimayo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Anta'), 'Ancahuasi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Calca'), 'Calca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Calca'), 'Coya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Calca'), 'Lamay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Calca'), 'Lares'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Calca'), 'Pisac'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Calca'), 'San Salvador'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Calca'), 'Taray'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Calca'), 'Yanatile'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canas'), 'Yanaoca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canas'), 'Checca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canas'), 'Kunturkanki'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canas'), 'Langui'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canas'), 'Layo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canas'), 'Pampamarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canas'), 'Quehue'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canas'), 'Tupac Amaru'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canchis'), 'Sicuani'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canchis'), 'Combapata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canchis'), 'Checacupe'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canchis'), 'Marangani'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canchis'), 'Pitumarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canchis'), 'San Pablo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canchis'), 'San Pedro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canchis'), 'Tinta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chumbivilcas'), 'Santo Tomas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chumbivilcas'), 'Capacmarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chumbivilcas'), 'Colquemarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chumbivilcas'), 'Chamaca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chumbivilcas'), 'Livitaca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chumbivilcas'), 'Llusco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chumbivilcas'), 'Quiñota'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chumbivilcas'), 'Velille'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Espinar'), 'Espinar'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Espinar'), 'Condoroma'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Espinar'), 'Coporaque'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Espinar'), 'Ocoruro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Espinar'), 'Pallpata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Espinar'), 'Pichigua'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Espinar'), 'Suyckutambo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Espinar'), 'Alto Pichigua'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Convencion'), 'Santa Ana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Convencion'), 'Echarate'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Convencion'), 'Huayopata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Convencion'), 'Maranura'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Convencion'), 'Ocobamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Convencion'), 'Santa Teresa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Convencion'), 'Vilcabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Convencion'), 'Quellouno'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Convencion'), 'Kimbiri'),
((SELECT id FROM secureid.provincia WHERE nombre = 'La Convencion'), 'Pichari'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paruro'), 'Paruro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paruro'), 'Accha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paruro'), 'Ccapi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paruro'), 'Colcha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paruro'), 'Huanoquite'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paruro'), 'Omacha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paruro'), 'Yaurisque'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paruro'), 'Paccaritambo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paruro'), 'Pillpinto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paucartambo'), 'Paucartambo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paucartambo'), 'Caicay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paucartambo'), 'Colquepata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paucartambo'), 'Challabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paucartambo'), 'Kosñipata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paucartambo'), 'Huancarani'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Quispicanchi'), 'Urcos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Quispicanchi'), 'Andahuaylillas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Quispicanchi'), 'Camanti'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Quispicanchi'), 'Ccarhuayo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Quispicanchi'), 'Ccatca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Quispicanchi'), 'Cusipata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Quispicanchi'), 'Huaro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Quispicanchi'), 'Lucre'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Quispicanchi'), 'Marcapata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Quispicanchi'), 'Ocongate'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Quispicanchi'), 'Oropesa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Quispicanchi'), 'Quiquijana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Urubamba'), 'Urubamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Urubamba'), 'Chinchero'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Urubamba'), 'Huayllabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Urubamba'), 'Machupicchu'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Urubamba'), 'Maras'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Urubamba'), 'Ollantaytambo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Urubamba'), 'Yucay');

HUANCAVELICA
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancavelica'), 'Huancavelica'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancavelica'), 'Acobambilla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancavelica'), 'Acoria'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancavelica'), 'Conayca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancavelica'), 'Cuenca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancavelica'), 'Huachocolpa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancavelica'), 'Huayllahuara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancavelica'), 'Izcuchaca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancavelica'), 'Laria'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancavelica'), 'Manta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancavelica'), 'Mariscal Caceres'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancavelica'), 'Moya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancavelica'), 'Nuevo Occoro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancavelica'), 'Palca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancavelica'), 'Pilchaca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancavelica'), 'Vilca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancavelica'), 'Yauli'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancavelica'), 'Ascension'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancavelica'), 'Huando'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Acobamba'), 'Acobamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Acobamba'), 'Anta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Acobamba'), 'Andabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Acobamba'), 'Caja'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Acobamba'), 'Marcas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Acobamba'), 'Paucara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Acobamba'), 'Pomacocha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Acobamba'), 'Rosario'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Angaraes'), 'Lircay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Angaraes'), 'Anchonga'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Angaraes'), 'Callanmarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Angaraes'), 'Congalla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Angaraes'), 'Chincho'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Angaraes'), 'Huayllay Grande'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Angaraes'), 'Huanca-Huanca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Angaraes'), 'Julcamarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Angaraes'), 'San Antonio de Antaparco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Angaraes'), 'Santo Tomas de Pata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Angaraes'), 'Secclla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Angaraes'), 'Ccochaccasa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castrovirreyna'), 'Castrovirreyna'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castrovirreyna'), 'Arma'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castrovirreyna'), 'Aurahua'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castrovirreyna'), 'Capillas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castrovirreyna'), 'Cocas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castrovirreyna'), 'Chupamarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castrovirreyna'), 'Huachos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castrovirreyna'), 'Huamatambo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castrovirreyna'), 'Mollepampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castrovirreyna'), 'San Juan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castrovirreyna'), 'Tantara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castrovirreyna'), 'Ticrapo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Castrovirreyna'), 'Santa Ana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tayacaja'), 'Pampas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tayacaja'), 'Acostambo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tayacaja'), 'Acraquia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tayacaja'), 'Ahuaycha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tayacaja'), 'Colcabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tayacaja'), 'Daniel Hernandez'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tayacaja'), 'Huachocolpa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tayacaja'), 'Huaribamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tayacaja'), 'Ñahuimpuquio'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tayacaja'), 'Pazos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tayacaja'), 'Quishuar'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tayacaja'), 'Salcabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tayacaja'), 'San Marcos de Rocchac'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tayacaja'), 'Surcubamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tayacaja'), 'Tintay Puncu'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tayacaja'), 'Salcahuasi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaytara'), 'Ayavi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaytara'), 'Cordova'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaytara'), 'Huayacundo Arma'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaytara'), 'Huaytara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaytara'), 'Laramarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaytara'), 'Ocoyo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaytara'), 'Pilpichaca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaytara'), 'Querco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaytara'), 'Quito-Arma'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaytara'), 'San Antonio de Cusicancha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaytara'), 'San Francisco de Sangayaico'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaytara'), 'San Isidro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaytara'), 'Santiago de Chocorvos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaytara'), 'Santiago de Quirahuara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaytara'), 'Santo Domingo de Capillas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaytara'), 'Tambo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Churcampa'), 'Churcampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Churcampa'), 'Anco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Churcampa'), 'Chinchihuasi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Churcampa'), 'El Carmen'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Churcampa'), 'La Merced'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Churcampa'), 'Locroja'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Churcampa'), 'Paucarbamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Churcampa'), 'San Miguel de Mayocc'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Churcampa'), 'San Pedro de Coris'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Churcampa'), 'Pachamarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Churcampa'), 'Cosme');

HUANUCO
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanuco'), 'Huanuco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanuco'), 'Chinchao'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanuco'), 'Churubamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanuco'), 'Margos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanuco'), 'Quisqui'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanuco'), 'San Francisco de Cayran'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanuco'), 'San Pedro de Chaulan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanuco'), 'Santa Maria del Valle'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanuco'), 'Yarumayo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanuco'), 'Amarilis'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanuco'), 'Pillco Marca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huanuco'), 'Yacus'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ambo'), 'Ambo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ambo'), 'Cayna'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ambo'), 'Colpas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ambo'), 'Conchamarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ambo'), 'Huacar'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ambo'), 'San Francisco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ambo'), 'San Rafael'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ambo'), 'Tomay Kichwa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Dos de Mayo'), 'La Union'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Dos de Mayo'), 'Chuquis'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Dos de Mayo'), 'Marias'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Dos de Mayo'), 'Pachas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Dos de Mayo'), 'Quivilla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Dos de Mayo'), 'Ripan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Dos de Mayo'), 'Shunqui'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Dos de Mayo'), 'Sillapata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Dos de Mayo'), 'Yanas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamalies'), 'Llata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamalies'), 'Arancay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamalies'), 'Chavin de Pariarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamalies'), 'Jacas Grande'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamalies'), 'Jircan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamalies'), 'Miraflores'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamalies'), 'Monzon'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamalies'), 'Punchao'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamalies'), 'Puños'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamalies'), 'Singa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huamalies'), 'Tantamayo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Marañon'), 'Huacrachuco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Marañon'), 'Cholon'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Marañon'), 'San Buenaventura'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Leoncio Prado'), 'Rupa-Rupa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Leoncio Prado'), 'Daniel Alomias Robles'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Leoncio Prado'), 'Hermilio Valdizan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Leoncio Prado'), 'Luyando'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Leoncio Prado'), 'Mariano Damaso Beraun'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Leoncio Prado'), 'Jose Crespo y Castillo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pachitea'), 'Panao'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pachitea'), 'Chaglla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pachitea'), 'Molino'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pachitea'), 'Umari'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Puerto Inca'), 'Honoria'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Puerto Inca'), 'Puerto Inca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Puerto Inca'), 'Codo del Pozuzo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Puerto Inca'), 'Tournavista'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Puerto Inca'), 'Yuyapichis'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huacaybamba'), 'Huacaybamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huacaybamba'), 'Pinra'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huacaybamba'), 'Canchabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huacaybamba'), 'Cochabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lauricocha'), 'Jesus'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lauricocha'), 'Baños'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lauricocha'), 'San Francisco de Asis'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lauricocha'), 'Queropalca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lauricocha'), 'San Miguel de Cauri'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lauricocha'), 'Rondos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lauricocha'), 'Jivia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yarowilca'), 'Chavinillo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yarowilca'), 'Aparicio Pomares'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yarowilca'), 'Cahuac'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yarowilca'), 'Chacabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yarowilca'), 'Jacas Chico'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yarowilca'), 'Obas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yarowilca'), 'Pampamarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yarowilca'), 'Choras');

ICA
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Ica'), 'Ica'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ica'), 'La Tinguiña'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ica'), 'Los Aquijes'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ica'), 'Parcona'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ica'), 'Pueblo Nuevo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ica'), 'Salas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ica'), 'San Jose de los Molinos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ica'), 'San Juan Bautista'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ica'), 'Santiago'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ica'), 'Subtanjalla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ica'), 'Yauca del Rosario'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ica'), 'Tate'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ica'), 'Pachacutec'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ica'), 'Ocucaje'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chincha'), 'Chincha Alta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chincha'), 'Chavin'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chincha'), 'Chincha Baja'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chincha'), 'El Carmen'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chincha'), 'Grocio Prado'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chincha'), 'San Pedro de Huacarpana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chincha'), 'Sunampe'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chincha'), 'Tambo de Mora'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chincha'), 'Alto Laran'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chincha'), 'Pueblo Nuevo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chincha'), 'San Juan de Yanac'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Nazca'), 'Nazca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Nazca'), 'Changuillo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Nazca'), 'El Ingenio'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Nazca'), 'Marcona'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Nazca'), 'Vista Alegre'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pisco'), 'Pisco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pisco'), 'Huancano'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pisco'), 'Humay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pisco'), 'Independencia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pisco'), 'Paracas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pisco'), 'San Andres'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pisco'), 'San Clemente'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pisco'), 'Tupac Amaru Inca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Palpa'), 'Palpa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Palpa'), 'Llipata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Palpa'), 'Rio Grande'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Palpa'), 'Santa Cruz'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Palpa'), 'Tibillo');

JUNIN
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Huancayo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Carhuacallanga'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Colca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Cullhuas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Chacapampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Chicche'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Chilca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Chongos Alto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Chupuro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'El Tambo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Huacrapuquio'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Hualhuas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Huancan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Huasicancha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Huayucachi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Ingenio'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Pariahuanca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Pilcomayo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Pucara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Quichuay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Quilcas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'San Agustin'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'San Jeronimo de Tunan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Santo Domingo de Acobamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Saño'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Sapallanga'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Sicaya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancayo'), 'Viques'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Concepción'), 'Concepcion'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Concepción'), 'Aco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Concepción'), 'Andamarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Concepción'), 'Comas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Concepción'), 'Cochas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Concepción'), 'Chambara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Concepción'), 'Heroinas Toledo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Concepción'), 'Manzanares'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Concepción'), 'Mariscal Castilla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Concepción'), 'Matahuasi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Concepción'), 'Mito'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Concepción'), 'Nueve de Julio'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Concepción'), 'Orcotuna'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Concepción'), 'Santa Rosa de Ocopa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Concepción'), 'San Jose de Quero'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Jauja'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Acolla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Apata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Ataura'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Canchayllo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'El Mantaro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Huamali'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Huaripampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Huertas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Janjaillo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Julcan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Leonor Ordoñez'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Llocllapampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Marco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Masma'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Molinos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Monobamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Muqui'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Muquiyauyo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Paca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Paccha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Pancan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Parco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Pomacancha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Ricran'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'San Lorenzo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'San Pedro de Chunan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Sincos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Tunan Marca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Yauli'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Curicaca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Masma Chicche'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Sausa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jauja'), 'Yauyos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Junín'), 'Junin'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Junín'), 'Carhuamayo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Junín'), 'Ondores'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Junín'), 'Ulcumayo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tarma'), 'Tarma'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tarma'), 'Acobamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tarma'), 'Huaricolca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tarma'), 'Huasahuasi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tarma'), 'La Union'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tarma'), 'Palca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tarma'), 'Palcamayo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tarma'), 'San Pedro de Cajas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tarma'), 'Tapo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauli'), 'La Oroya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauli'), 'Chacapalpa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauli'), 'Huay-Huay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauli'), 'Marcapomacocha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauli'), 'Morococha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauli'), 'Paccha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauli'), 'Santa Barbara de Carhuacayan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauli'), 'Suitucancha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauli'), 'Yauli'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauli'), 'Santa Rosa de Sacco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Satipo'), 'Satipo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Satipo'), 'Coviriali'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Satipo'), 'Llaylla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Satipo'), 'Mazamari'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Satipo'), 'Pampa Hermosa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Satipo'), 'Pangoa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Satipo'), 'Rio Negro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Satipo'), 'Rio Tambo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chanchamayo'), 'Chanchamayo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chanchamayo'), 'San Ramon'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chanchamayo'), 'Vitoc'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chanchamayo'), 'San Luis de Shuaro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chanchamayo'), 'Pichanaqui'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chanchamayo'), 'Perene'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chupaca'), 'Chupaca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chupaca'), 'Ahuac'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chupaca'), 'Chongos Bajo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chupaca'), 'Huachac'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chupaca'), 'Huamancaca Chico'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chupaca'), 'San Juan de Yscos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chupaca'), 'San Juan de Jarpa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chupaca'), 'Tres de Diciembre'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chupaca'), 'Yanacancha');

LA LIBERTAD
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Trujillo'), 'Trujillo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Trujillo'), 'Huanchaco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Trujillo'), 'Laredo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Trujillo'), 'Moche'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Trujillo'), 'Salaverry'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Trujillo'), 'Simbal'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Trujillo'), 'Victor Larco Herrera'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Trujillo'), 'Poroto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Trujillo'), 'El Porvenir'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Trujillo'), 'La Esperanza'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Trujillo'), 'Florencia de Mora'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bolivar'), 'Bolivar'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bolivar'), 'Bambamarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bolivar'), 'Condormarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bolivar'), 'Longotea'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bolivar'), 'Ucuncha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bolivar'), 'Uchumarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sanchez Carrion'), 'Huamachuco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sanchez Carrion'), 'Cochorco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sanchez Carrion'), 'Curgos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sanchez Carrion'), 'Chugay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sanchez Carrion'), 'Marcabal'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sanchez Carrion'), 'Sanagoran'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sanchez Carrion'), 'Sarin'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sanchez Carrion'), 'Sartimbamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Otuzco'), 'Otuzco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Otuzco'), 'Agallpampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Otuzco'), 'Charat'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Otuzco'), 'Huaranchal'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Otuzco'), 'La Cuesta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Otuzco'), 'Paranday'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Otuzco'), 'Salpo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Otuzco'), 'Sinsicap'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Otuzco'), 'Usquil'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Otuzco'), 'Mache'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pacasmayo'), 'San Pedro de Lloc'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pacasmayo'), 'Guadalupe'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pacasmayo'), 'Jequetepeque'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pacasmayo'), 'Pacasmayo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pacasmayo'), 'San Jose'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pataz'), 'Tayabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pataz'), 'Buldibuyo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pataz'), 'Chillia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pataz'), 'Huaylillas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pataz'), 'Huancaspata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pataz'), 'Huayo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pataz'), 'Ongon'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pataz'), 'Parcoy'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pataz'), 'Pataz'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pataz'), 'Pias'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pataz'), 'Taurija'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pataz'), 'Urpay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pataz'), 'Santiago de Challas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santiago de Chuco'), 'Santiago de Chuco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santiago de Chuco'), 'Cachicadan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santiago de Chuco'), 'Mollebamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santiago de Chuco'), 'Mollepata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santiago de Chuco'), 'Quiruvilca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santiago de Chuco'), 'Santa Cruz de Chuca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santiago de Chuco'), 'Sitabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Santiago de Chuco'), 'Angasmarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ascope'), 'Ascope'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ascope'), 'Chicama'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ascope'), 'Chocope'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ascope'), 'Santiago de Cao'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ascope'), 'Magdalena de Cao'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ascope'), 'Paijan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ascope'), 'Razuri'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ascope'), 'Casa Grande'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chepen'), 'Chepen'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chepen'), 'Pacanga'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chepen'), 'Pueblo Nuevo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Julcan'), 'Julcan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Julcan'), 'Carabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Julcan'), 'Calamarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Julcan'), 'Huaso'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Gran Chimu'), 'Casas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Gran Chimu'), 'Lucma'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Gran Chimu'), 'Marmot'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Gran Chimu'), 'Sayapullo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Viru'), 'Viru'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Viru'), 'Chao'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Viru'), 'Guadalupito');

LAMBAYEQUE
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Chiclayo'), 'Chiclayo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chiclayo'), 'Chongoyape'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chiclayo'), 'Eten'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chiclayo'), 'Eten Puerto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chiclayo'), 'Lagunas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chiclayo'), 'Monsefu'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chiclayo'), 'Nueva Arica'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chiclayo'), 'Oyotun'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chiclayo'), 'Picsi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chiclayo'), 'Pimentel'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chiclayo'), 'Reque'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chiclayo'), 'Jose Leonardo Ortiz'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chiclayo'), 'Santa Rosa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chiclayo'), 'Saña'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chiclayo'), 'La Victoria'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chiclayo'), 'Cayalti'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chiclayo'), 'Patapo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chiclayo'), 'Pomalca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chiclayo'), 'Pucala'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chiclayo'), 'Tuman'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ferreñafe'), 'Ferreñafe'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ferreñafe'), 'Incahuasi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ferreñafe'), 'Cañaris'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ferreñafe'), 'Pitipo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ferreñafe'), 'Pueblo Nuevo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ferreñafe'), 'Manuel Antonio Mesones Muro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lambayeque'), 'Lambayeque'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lambayeque'), 'Chochope'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lambayeque'), 'Illimo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lambayeque'), 'Jayanca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lambayeque'), 'Mochumi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lambayeque'), 'Morrope'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lambayeque'), 'Motupe'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lambayeque'), 'Olmos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lambayeque'), 'Pacora'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lambayeque'), 'Salas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lambayeque'), 'San Jose'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lambayeque'), 'Tucume');

LIMA
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Lima'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Ancon'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Ate'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Breña'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Carabayllo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Comas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Chaclacayo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Chorrillos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'La Victoria'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'La Molina'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Lince'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Lurigancho'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Lurin'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Magdalena del Mar'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Miraflores'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Pachacamac'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Pueblo Libre'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Pucusana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Puente Piedra'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Punta Hermosa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Punta Negra'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Rimac'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'San Bartolo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'San Isidro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Barranco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'San Martin de Porres'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'San Miguel'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Santa Maria del Mar'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Santa Rosa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Santiago de Surco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Surquillo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Villa Maria del Triunfo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Jesus Maria'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Independencia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'El Agustino'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'San Juan de Miraflores'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'San Juan de Lurigancho'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'San Luis'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Cieneguilla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'San Borja'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Villa El Salvador'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Los Olivos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lima'), 'Santa Anita'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cajatambo'), 'Cajatambo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cajatambo'), 'Copa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cajatambo'), 'Gorgor'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cajatambo'), 'Huancapon'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cajatambo'), 'Manas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canta'), 'Canta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canta'), 'Arahuay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canta'), 'Huamantanga'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canta'), 'Huaros'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canta'), 'Lachaqui'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canta'), 'San Buenaventura'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Canta'), 'Santa Rosa de Quives'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cañete'), 'San Vicente de Cañete'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cañete'), 'Calango'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cañete'), 'Cerro Azul'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cañete'), 'Coayllo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cañete'), 'Chilca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cañete'), 'Imperial'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cañete'), 'Lunahuana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cañete'), 'Mala'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cañete'), 'Nuevo Imperial'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cañete'), 'Pacaran'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cañete'), 'Quilmana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cañete'), 'San Antonio'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cañete'), 'San Luis'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cañete'), 'Santa Cruz de Flores'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cañete'), 'Zuñiga'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Cañete'), 'Asia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaura'), 'Huacho'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaura'), 'Ambar'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaura'), 'Caleta de Carquin'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaura'), 'Checras'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaura'), 'Hualmay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaura'), 'Huaura'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaura'), 'Leoncio Prado'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaura'), 'Paccho'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaura'), 'Santa Leonor'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaura'), 'Santa Maria'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaura'), 'Sayan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaura'), 'Vegueta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'Matucana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'Antioquia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'Callahuanca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'Carampoma'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'San Pedro de Casta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'Cuenca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'Chicla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'Huanza'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'Huarochiri'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'Lahuaytambo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'Langa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'Mariatana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'Ricardo Palma'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'San Andres de Tupicocha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'San Antonio'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'San Bartolome'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'San Damian'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'Sangallaya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'San Juan de Tantaranche'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'San Lorenzo de Quinti'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'San Mateo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'San Mateo de Otao'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'San Pedro de Huancayre'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'Santa Cruz de Cocachacra'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'Santa Eulalia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'Santiago de Anchucaya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'Santiago de Tuna'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'Santo Domingo de los Olleros'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'Surco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'Huachupampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'Laraos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huarochiri'), 'San Juan de Iris'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Yauyos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Alis'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Ayauca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Ayaviri'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Azangaro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Cacra'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Carania'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Cochas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Colonia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Chocos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Huampara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Huancaya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Huangascar'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Huantan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Huañec'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Laraos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Lincha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Miraflores'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Omas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Quinches'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Quinocay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'San Joaquin'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'San Pedro de Pilas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Tanta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Tauripampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Tupe'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Tomas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Viñac'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Vitis'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Hongos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Madean'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Putinza'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yauyos'), 'Catahuasi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaral'), 'Huaral'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaral'), 'Atavillos Alto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaral'), 'Atavillos Bajo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaral'), 'Aucallama'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaral'), 'Chancay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaral'), 'Ihuari'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaral'), 'Lampian'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaral'), 'Pacaraos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaral'), 'San Miguel de Acos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaral'), 'Veintisiete de Noviembre'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaral'), 'Santa Cruz de Andamarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huaral'), 'Sumbilca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Barranca'), 'Barranca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Barranca'), 'Paramonga'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Barranca'), 'Pativilca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Barranca'), 'Supe'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Barranca'), 'Supe Puerto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Oyon'), 'Oyon'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Oyon'), 'Navan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Oyon'), 'Caujul'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Oyon'), 'Andajes'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Oyon'), 'Pachangara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Oyon'), 'Cochamarca');

LORETO
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Maynas'), 'Iquitos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Maynas'), 'Alto Nanay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Maynas'), 'Fernando Lores'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Maynas'), 'Las Amazonas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Maynas'), 'Mazan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Maynas'), 'Napo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Maynas'), 'Putumayo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Maynas'), 'Torres Causana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Maynas'), 'Indiana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Maynas'), 'Punchana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Maynas'), 'Belen'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Maynas'), 'San Juan Bautista'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Maynas'), 'Teniente Manuel Clavero'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Alto Amazonas'), 'Yurimaguas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Alto Amazonas'), 'Balsapuerto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Alto Amazonas'), 'Jeberos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Alto Amazonas'), 'Lagunas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Alto Amazonas'), 'Santa Cruz'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Alto Amazonas'), 'Teniente Cesar Lopez Rojas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Loreto'), 'Nauta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Loreto'), 'Parinari'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Loreto'), 'Tigre'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Loreto'), 'Urarinas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Loreto'), 'Trompeteros'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Requena'), 'Requena'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Requena'), 'Alto Tapiche'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Requena'), 'Capelo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Requena'), 'Emilio San Martin'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Requena'), 'Maquia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Requena'), 'Puinahua'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Requena'), 'Saquena'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Requena'), 'Soplin'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Requena'), 'Tapiche'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Requena'), 'Jenaro Herrera'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Requena'), 'Yaquerana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ucayali'), 'Contamana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ucayali'), 'Vargas Guerra'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ucayali'), 'Padre Marquez'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ucayali'), 'Pampa Hermosa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ucayali'), 'Sarayacu'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ucayali'), 'Inahuaya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Ramon Castilla'), 'Ramon Castilla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Ramon Castilla'), 'Pebas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Ramon Castilla'), 'Yavari'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Ramon Castilla'), 'San Pablo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Datem del Marañon'), 'Barranca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Datem del Marañon'), 'Andoas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Datem del Marañon'), 'Cahuapanas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Datem del Marañon'), 'Manseriche'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Datem del Marañon'), 'Morona'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Datem del Marañon'), 'Pastaza');

MADRE DE DIOS
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Tambopata'), 'Tambopata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tambopata'), 'Inambari'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tambopata'), 'Las Piedras'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tambopata'), 'Laberinto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Manu'), 'Manu'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Manu'), 'Fitzcarrald'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Manu'), 'Madre de Dios'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Manu'), 'Huepetuhe'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tahuamanu'), 'Iñapari'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tahuamanu'), 'Iberia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tahuamanu'), 'Tahuamanu');

MOQUEGUA
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Nieto'), 'Mariscal Nieto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Nieto'), 'Carumas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Nieto'), 'Cuchumbaya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Nieto'), 'San Cristobal'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Nieto'), 'Torata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Nieto'), 'Samegua'),
((SELECT id FROM secureid.provincia WHERE nombre = 'General Sanchez Cerro'), 'Omate'),
((SELECT id FROM secureid.provincia WHERE nombre = 'General Sanchez Cerro'), 'Coalaque'),
((SELECT id FROM secureid.provincia WHERE nombre = 'General Sanchez Cerro'), 'Chojata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'General Sanchez Cerro'), 'Ichuña'),
((SELECT id FROM secureid.provincia WHERE nombre = 'General Sanchez Cerro'), 'La Capilla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'General Sanchez Cerro'), 'Lloque'),
((SELECT id FROM secureid.provincia WHERE nombre = 'General Sanchez Cerro'), 'Matalaque'),
((SELECT id FROM secureid.provincia WHERE nombre = 'General Sanchez Cerro'), 'Puquina'),
((SELECT id FROM secureid.provincia WHERE nombre = 'General Sanchez Cerro'), 'Quinistaquillas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'General Sanchez Cerro'), 'Ubinas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'General Sanchez Cerro'), 'Yunga'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ilo'), 'Ilo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ilo'), 'El Algarrobal'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ilo'), 'Pacocha');

PASCO
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Pasco'), 'Chaupimarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pasco'), 'Huachon'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pasco'), 'Huariaca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pasco'), 'Huayllay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pasco'), 'Ninacaca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pasco'), 'Pallanchacra'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pasco'), 'Paucartambo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pasco'), 'San Francisco de Asis de Yarusyacan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pasco'), 'Simon Bolivar'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pasco'), 'Ticlacayan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pasco'), 'Tinyahuarco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pasco'), 'Vicco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Pasco'), 'Yanacancha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Daniel Alcides Carrion'), 'Yanahuanca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Daniel Alcides Carrion'), 'Chacayan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Daniel Alcides Carrion'), 'Goyllarisquizga'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Daniel Alcides Carrion'), 'Paucar'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Daniel Alcides Carrion'), 'San Pedro de Pillao'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Daniel Alcides Carrion'), 'Santa Ana de Tusi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Daniel Alcides Carrion'), 'Tapuc'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Daniel Alcides Carrion'), 'Vilcabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Oxapampa'), 'Oxapampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Oxapampa'), 'Chontabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Oxapampa'), 'Huancabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Oxapampa'), 'Puerto Bermudez'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Oxapampa'), 'Villa Rica'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Oxapampa'), 'Pozuzo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Oxapampa'), 'Palcazu'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Oxapampa'), 'Constitución');

PIURA
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Piura'), 'Piura'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Piura'), 'Castilla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Piura'), 'Catacaos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Piura'), 'La Arena'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Piura'), 'La Union'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Piura'), 'Las Lomas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Piura'), 'Tambo Grande'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Piura'), 'Cura Mori'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Piura'), 'El Tallan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ayabaca'), 'Ayabaca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ayabaca'), 'Frias'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ayabaca'), 'Lagunas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ayabaca'), 'Montero'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ayabaca'), 'Pacaipampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ayabaca'), 'Sapillica'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ayabaca'), 'Sicchez'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ayabaca'), 'Suyo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ayabaca'), 'Jilili'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Ayabaca'), 'Paimas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancabamba'), 'Huancabamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancabamba'), 'Canchaque'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancabamba'), 'Huarmaca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancabamba'), 'Sondor'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancabamba'), 'Sondorillo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancabamba'), 'El Carmen de La Frontera'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancabamba'), 'San Miguel de El Faique'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancabamba'), 'Lalaquiz'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Morropon'), 'Chulucanas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Morropon'), 'Buenos Aires'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Morropon'), 'Chalaco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Morropon'), 'Morropon'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Morropon'), 'Salitral'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Morropon'), 'Santa Catalina de Mossa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Morropon'), 'Santo Domingo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Morropon'), 'La Matanza'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Morropon'), 'Yamango'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Morropon'), 'San Juan de Bigote'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paita'), 'Paita'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paita'), 'Amotape'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paita'), 'Arenal'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paita'), 'La Huaca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paita'), 'Colan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paita'), 'Tamarindo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Paita'), 'Vichayal'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sullana'), 'Sullana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sullana'), 'Bellavista'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sullana'), 'Lancones'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sullana'), 'Marcavelica'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sullana'), 'Miguel Checa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sullana'), 'Querecotillo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sullana'), 'Salitral'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sullana'), 'Ignacio Escudero'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Talara'), 'Pariñas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Talara'), 'El Alto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Talara'), 'La Brea'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Talara'), 'Lobitos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Talara'), 'Mancora'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Talara'), 'Los Organos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sechura'), 'Sechura'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sechura'), 'Vice'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sechura'), 'Bernal'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sechura'), 'Bellavista de La Union'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sechura'), 'Cristo Nos Valga'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sechura'), 'Rinconada Llicuar');

PUNO
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Puno'), 'Puno'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Puno'), 'Acora'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Puno'), 'Atuncolla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Puno'), 'Capachica'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Puno'), 'Coata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Puno'), 'Chucuito'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Puno'), 'Huata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Puno'), 'Mañazo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Puno'), 'Paucarcolla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Puno'), 'Pichacani'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Puno'), 'San Antonio'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Puno'), 'Tiquillaca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Puno'), 'Vilque'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Puno'), 'Plateria'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Puno'), 'Amantani'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Azangaro'), 'Azangaro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Azangaro'), 'Achaya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Azangaro'), 'Arapa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Azangaro'), 'Asillo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Azangaro'), 'Caminaca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Azangaro'), 'Chupa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Azangaro'), 'Jose Domingo Choquehuanca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Azangaro'), 'Muñani'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Azangaro'), 'Potoni'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Azangaro'), 'Saman'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Azangaro'), 'San Anton'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Azangaro'), 'San Jose'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Azangaro'), 'San Juan de Salinas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Azangaro'), 'Santiago de Pupuja'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Azangaro'), 'Tirapata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carabaya'), 'Macusani'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carabaya'), 'Ajoyani'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carabaya'), 'Ayapata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carabaya'), 'Coasa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carabaya'), 'Corani'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carabaya'), 'Crucero'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carabaya'), 'Ituata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carabaya'), 'Ollachea'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carabaya'), 'San Gaban'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Carabaya'), 'Usicayos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chucuito'), 'Juli'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chucuito'), 'Desaguadero'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chucuito'), 'Huacullani'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chucuito'), 'Pisacoma'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chucuito'), 'Pomata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chucuito'), 'Zepita'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Chucuito'), 'Kelluyo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancane'), 'Huancane'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancane'), 'Cojata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancane'), 'Inchupalla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancane'), 'Pusi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancane'), 'Rosaspata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancane'), 'Taraco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancane'), 'Vilque Chico'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huancane'), 'Huatasani'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lampa'), 'Lampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lampa'), 'Cabanilla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lampa'), 'Calapuja'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lampa'), 'Nicasio'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lampa'), 'Ocuviri'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lampa'), 'Palca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lampa'), 'Paratia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lampa'), 'Pucara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lampa'), 'Santa Lucia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lampa'), 'Vilavila'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Melgar'), 'Ayaviri'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Melgar'), 'Antauta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Melgar'), 'Cupi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Melgar'), 'Llalli'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Melgar'), 'Macari'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Melgar'), 'Nuñoa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Melgar'), 'Orurillo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Melgar'), 'Santa Rosa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Melgar'), 'Umachiri'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sandia'), 'Sandia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sandia'), 'Cuyocuyo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sandia'), 'Limbani'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sandia'), 'Phara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sandia'), 'Patambuco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sandia'), 'Quiaca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sandia'), 'San Juan del Oro'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sandia'), 'Yanahuaya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sandia'), 'Alto Inambari'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Sandia'), 'San Pedro de Putina Punco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Roman'), 'Juliaca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Roman'), 'Cabana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Roman'), 'Cabanillas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Roman'), 'Caracoto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yunguyo'), 'Yunguyo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yunguyo'), 'Unicachi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yunguyo'), 'Anapia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yunguyo'), 'Copani'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yunguyo'), 'Cuturapi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yunguyo'), 'Ollaraya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Yunguyo'), 'Tinicachi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Antonio de Putina'), 'Putina'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Antonio de Putina'), 'Pedro Vilca Apaza'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Antonio de Putina'), 'Quilcapuncu'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Antonio de Putina'), 'Ananea'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Antonio de Putina'), 'Sina'),
((SELECT id FROM secureid.provincia WHERE nombre = 'El Collao'), 'Ilave'),
((SELECT id FROM secureid.provincia WHERE nombre = 'El Collao'), 'Pilcuyo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'El Collao'), 'Santa Rosa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'El Collao'), 'Capazo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'El Collao'), 'Conduriri'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Moho'), 'Moho'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Moho'), 'Conima'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Moho'), 'Tilali'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Moho'), 'Huayrapata');

SAN MARTIN
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Moyobamba'), 'Moyobamba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Moyobamba'), 'Calzada'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Moyobamba'), 'Habana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Moyobamba'), 'Jepelacio'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Moyobamba'), 'Soritor'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Moyobamba'), 'Yantalo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huallaga'), 'Saposoa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huallaga'), 'Piscoyacu'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huallaga'), 'Sacanche'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huallaga'), 'Tingo de Saposoa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huallaga'), 'Alto Saposoa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Huallaga'), 'El Eslabon'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lamas'), 'Lamas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lamas'), 'Barranquita'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lamas'), 'Caynarachi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lamas'), 'Cuñumbuqui'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lamas'), 'Pinto Recodo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lamas'), 'Rumisapa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lamas'), 'Shanao'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lamas'), 'Tabalosos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lamas'), 'Zapatero'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lamas'), 'Alonso de Alvarado'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Lamas'), 'San Roque de Cumbaza'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Caceres'), 'Juanjui'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Caceres'), 'Campanilla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Caceres'), 'Huicungo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Caceres'), 'Pachiza'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Mariscal Caceres'), 'Pajarillo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Rioja'), 'Rioja'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Rioja'), 'Posic'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Rioja'), 'Yorongos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Rioja'), 'Yuracyacu'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Rioja'), 'Nueva Cajamarca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Rioja'), 'Elias Soplin Vargas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Rioja'), 'San Fernando'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Rioja'), 'Pardo Miguel'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Rioja'), 'Awajun'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Martin'), 'Tarapoto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Martin'), 'Alberto Leveau'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Martin'), 'Cacatachi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Martin'), 'Chazuta'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Martin'), 'Chipurana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Martin'), 'El Porvenir'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Martin'), 'Huimbayoc'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Martin'), 'Juan Guerra'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Martin'), 'Morales'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Martin'), 'Papaplaya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Martin'), 'San Antonio'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Martin'), 'Sauce'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Martin'), 'Shapaja'),
((SELECT id FROM secureid.provincia WHERE nombre = 'San Martin'), 'La Banda de Shilcayo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bellavista'), 'Bellavista'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bellavista'), 'San Rafael'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bellavista'), 'San Pablo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bellavista'), 'Alto Biavo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bellavista'), 'Huallaga'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Bellavista'), 'Bajo Biavo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tocache'), 'Tocache'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tocache'), 'Nuevo Progreso'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tocache'), 'Polvora'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tocache'), 'Shunte'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tocache'), 'Uchiza'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Picota'), 'Picota'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Picota'), 'Buenos Aires'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Picota'), 'Caspisapa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Picota'), 'Pilluana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Picota'), 'Pucacaca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Picota'), 'San Cristobal'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Picota'), 'San Hilarion'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Picota'), 'Tingo de Ponasa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Picota'), 'Tres Unidos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Picota'), 'Shamboyacu'),
((SELECT id FROM secureid.provincia WHERE nombre = 'El Dorado'), 'San Jose de Sisa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'El Dorado'), 'Agua Blanca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'El Dorado'), 'Shatoja'),
((SELECT id FROM secureid.provincia WHERE nombre = 'El Dorado'), 'San Martin'),
((SELECT id FROM secureid.provincia WHERE nombre = 'El Dorado'), 'Santa Rosa');

TACNA
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Tacna'), 'Tacna'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tacna'), 'Calana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tacna'), 'Inclan'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tacna'), 'Pachia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tacna'), 'Palca'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tacna'), 'Pocollay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tacna'), 'Sama'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tacna'), 'Alto de La Alianza'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tacna'), 'Ciudad Nueva'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tacna'), 'Coronel Gregorio Albarracin Lanchipa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tarata'), 'Tarata'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tarata'), 'Heroes Albarracin'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tarata'), 'Estique'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tarata'), 'Estique-Pampa'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tarata'), 'Sitajara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tarata'), 'Susapaya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tarata'), 'Tarucachi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tarata'), 'Ticaco'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jorge Basadre'), 'Locumba'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jorge Basadre'), 'Ite'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Jorge Basadre'), 'Ilabaya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Candarave'), 'Candarave'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Candarave'), 'Cairani'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Candarave'), 'Curibaya'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Candarave'), 'Huanuara'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Candarave'), 'Quilahuani'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Candarave'), 'Camilaca');

TUMBES
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Tumbes'), 'Tumbes'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tumbes'), 'Corrales'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tumbes'), 'La Cruz'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tumbes'), 'Pampas de Hospital'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tumbes'), 'San Jacinto'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Tumbes'), 'San Juan de La Virgen'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Contralmirante Villar'), 'Zorritos'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Contralmirante Villar'), 'Casitas'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Contralmirante Villar'), 'Canoas de Punta Sal'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Zarumilla'), 'Zarumilla'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Zarumilla'), 'Matapalo'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Zarumilla'), 'Papayal'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Zarumilla'), 'Aguas Verdes');

UCAYALI
INSERT INTO secureid.distrito (provincia_id, nombre)
VALUES
((SELECT id FROM secureid.provincia WHERE nombre = 'Coronel Portillo'), 'Calleria'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Coronel Portillo'), 'Yarinacocha'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Coronel Portillo'), 'Masisea'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Coronel Portillo'), 'Campoverde'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Coronel Portillo'), 'Iparia'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Coronel Portillo'), 'Nueva Requena'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Coronel Portillo'), 'Manantay'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Padre Abad'), 'Padre Abad'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Padre Abad'), 'Irazola'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Padre Abad'), 'Curimana'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Atalaya'), 'Raymondi'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Atalaya'), 'Tahuania'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Atalaya'), 'Yurua'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Atalaya'), 'Sepahua'),
((SELECT id FROM secureid.provincia WHERE nombre = 'Purus'), 'Purus');


 */