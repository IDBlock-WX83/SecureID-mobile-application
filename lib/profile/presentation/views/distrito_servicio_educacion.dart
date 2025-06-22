import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:image_picker/image_picker.dart';
import 'package:ztech_mobile_application/core/http/ResidenteService.dart';
import 'dart:io'; 
import '../../infrastructure/BlockchainApiService.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:flutter/services.dart'; 
import 'dart:convert'; 
import 'package:ztech_mobile_application/core/http/ApiService.dart';
import 'package:ztech_mobile_application/core/http/SocialServicesService.dart';
import 'package:ztech_mobile_application/core/http/LocationService.dart';

class DistritoServicioEducacion extends StatefulWidget {
  const DistritoServicioEducacion({super.key});

  @override
  _DistritoServicioEducacionState createState() => _DistritoServicioEducacionState();
}

class _DistritoServicioEducacionState extends State<DistritoServicioEducacion> {
  final BlockchainApiService _apiService = BlockchainApiService();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _departamentoController = TextEditingController();
  final TextEditingController _provinciaController = TextEditingController();
  final TextEditingController _distritoController = TextEditingController();
  final TextEditingController _telefonoCelularController = TextEditingController();

  late ApiService apiService;
  late ResidenteService residenteService;
  late LocationService locationService;

  File? _image1;
  File? _image2;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(int imageNumber, ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (imageNumber == 1) {
          _image1 = File(pickedFile.path);
        } else if (imageNumber == 2) {
          _image2 = File(pickedFile.path);
        }
      });
    }
  }

  String _gender = "M"; 

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    residenteService = ResidenteService(apiService: apiService);
    locationService = LocationService(apiService: apiService);
    _fetchDepartments(); 
  }

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

  _fetchProvinces(int departmentId) async {
    try {
      var data = await locationService.getProvincesByDepartment(departmentId);
      setState(() {
        provincias = data;
        distritos.clear(); 
      });
    } catch (e) {
      print("Error al cargar las provincias: $e");
    }
  }

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
    if (_selectedDepartamentoId == null ||
        _selectedProvinciaId == null ||
        _selectedDistritoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Por favor, complete todos los campos")));
      return;
    }

    

   



    final consolidatedData = {
      "distrito": {
        "id": _selectedDistritoId
      },
    };

  Navigator.pushNamed(
    context,
    'registereducation',  // La ruta de la siguiente vista
    arguments: _selectedDistritoId,    // El argumento (ID del distrito)
  );
    
  }

  String? _selectedDepartamentoId;
  String? _selectedDepartamentoName;
  String? _selectedProvinciaId;
  String? _selectedProvinciaName;
  String? _selectedDistritoId;
  String? _selectedDistritoName;

  List<Map<String, dynamic>> departamentos = [];
  List<Map<String, dynamic>> provincias = [];
  List<Map<String, dynamic>> distritos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00747C),
      resizeToAvoidBottomInset: true,
      
      body: Center( // This will center the entire body content
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // This will center the entire column vertically
            children: [
              const SizedBox(height: 40), // Space for top padding
              Row(
                mainAxisAlignment: MainAxisAlignment.start, // Keeps the back arrow on the left
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () async {
                  
                      Navigator.of(context).pop();
                    },
                  ),
                  const Expanded( // Ensures the title is centered
                    child: Center(
                      child: Text(
                        'Selecciona para que distrito',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20), // Space between title and fields

              // Department field
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
                    _selectedProvinciaId = null; 
                    _selectedDistritoId = null; 
                  });
                  if (newValue != null) {
                    _fetchProvinces(int.parse(newValue));
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

              // Province field
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
                    _selectedDistritoId = null; 
                  });
                  if (newValue != null) {
                    _fetchDistricts(int.parse(newValue));
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

              // District field
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

              ElevatedButton(
                onPressed: _submitForm,
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
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
