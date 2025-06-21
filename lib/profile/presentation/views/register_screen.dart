import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesario para formatear la fecha seleccionada
import 'package:flutter/services.dart';
import 'package:ztech_mobile_application/core/http/EstadoCivilService.dart';
import 'package:ztech_mobile_application/core/http/SexoService.dart';
import 'register2_screen.dart'; // Importa la pantalla del segundo registro
import 'package:ztech_mobile_application/core/http/ApiService.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _paternalSurnameController =
      TextEditingController();
  final TextEditingController _maternalSurnameController =
      TextEditingController();
  final TextEditingController _idDigitalController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _inscriptionDateController = TextEditingController();

  String _selectedSexo = ''; // Valor inicial vacío para el Dropdown de Sexo
  String _selectedEstadoCivil = ''; // Valor inicial vacío para el Dropdown de Estado Civil



 // Inicialización para el API
  late ApiService apiService;
  late EstadoCivilService estadoCivilService;
  late SexoService sexoService;

 @override
  void initState() {
    super.initState();
    apiService = ApiService(); // Aquí inicializas ApiService
   
estadoCivilService = EstadoCivilService(apiService: apiService);
sexoService = SexoService(apiService: apiService);

  _fetchEstadosCivil();
    _fetchSexos();

  }

    List<Map<String, dynamic>> estadosCivil = [];
List<Map<String, dynamic>> sexos = [];

  // Variables de selección
 String? _selectedEstadoCivilId;
String? _selectedEstadoCivilName;

  // Variables de selección
 String? _selectedSexosId;
String? _selectedSexosName;

// Cargar todos los departamentos
  _fetchEstadosCivil() async {
    try {
      var data = await estadoCivilService.getEstadosCivil();
      setState(() {
        estadosCivil = data;
      });
    } catch (e) {
      print("Error al cargar los estados civil: $e");
    }
  }

    _fetchSexos() async {
    try {
      var data = await sexoService.getSexos();
      setState(() {
        sexos = data;
      });
    } catch (e) {
      print("Error al cargar los sexos: $e");
    }
  }



  // Libera los controladores cuando ya no son necesarios
  @override
  void dispose() {
    _nameController.dispose();
    _paternalSurnameController.dispose();
    _maternalSurnameController.dispose();
    _birthDateController.dispose();
    _inscriptionDateController.dispose();
    super.dispose();
  }

  // Agrega estas variables para guardar las fechas en formato yyyy-MM-dd
String? _birthDateIso;
String? _inscriptionDateIso;

// Método para seleccionar la fecha de nacimiento
Future<void> _selectBirthDate(BuildContext context) async {
  DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  );

  if (selectedDate != null) {
    setState(() {
      _birthDateIso = DateFormat('yyyy-MM-dd').format(selectedDate); // formato correcto para guardar
      _birthDateController.text = DateFormat('dd/MM/yyyy').format(selectedDate); // visual
    });
  }
}

// Método para seleccionar la fecha de inscripción
Future<void> _selectInscriptionDate(BuildContext context) async {
  DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  );

  if (selectedDate != null) {
    setState(() {
      _inscriptionDateIso = DateFormat('yyyy-MM-dd').format(selectedDate); // formato correcto para guardar
      _inscriptionDateController.text = DateFormat('dd/MM/yyyy').format(selectedDate); // visual
    });
  }
}





  void _goToSecondScreen() {
    // Verifica que todos los campos estén completos
    if (_nameController.text.trim().isEmpty ||
        _paternalSurnameController.text.trim().isEmpty ||
        _maternalSurnameController.text.trim().isEmpty ||
        _birthDateController.text.trim().isEmpty ||
        _inscriptionDateController.text.trim().isEmpty ||
        
        _selectedEstadoCivilId == null|| // Verifica que el sexo no esté vacío
        _selectedSexosId == null) { // Verifica que el estado civil no esté vacío
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, complete todos los campos")),
      );
      return;
    }

    // Consolidar los datos del primer formulario
    final firstData = {
      "preNombres": _nameController.text.trim(),
      "primerApellido": _paternalSurnameController.text.trim(),
      "segundoApellido": _maternalSurnameController.text.trim(),
  "fechaNacimiento": _birthDateIso ?? '',
      "sexo":{
        "id": _selectedSexosId
       
    },
      "estadoCivil": {
        "id": _selectedEstadoCivilId
       
    },
  "fechaInscripcion": _inscriptionDateIso ?? '',
    };


  print(firstData);
    // Navegar al segundo formulario enviando los datos
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpScreen2(firstData: firstData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00747C),
      resizeToAvoidBottomInset: true, // Permite que el contenido se ajuste cuando aparece el teclado
      appBar: AppBar(
        backgroundColor: const Color(0xFF00747C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Registro', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Hace que el contenido sea desplazable cuando aparece el teclado
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            // Campo de texto: Nombre completo con labelText flotante
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                '*Pre Nombres',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Pre Nombres',
                hintStyle: const TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
                fillColor: const Color(0xFFD9D9D9),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Primer Apellido
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                '*Primer Apellido',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _paternalSurnameController,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Primer Apellido',
                hintStyle: const TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
                fillColor: const Color(0xFFD9D9D9),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Segundo Apellido
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                '*Segundo Apellido',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _maternalSurnameController,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Segundo Apellido',
                hintStyle: const TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
                fillColor: const Color(0xFFD9D9D9),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Fecha de Nacimiento
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                '*Fecha de Nacimiento',
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
                  controller: _birthDateController,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Fecha de Nacimiento',
                    hintStyle: const TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                    ),
                    suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                    fillColor: const Color(0xFFD9D9D9),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Sexo Dropdown
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                '*Sexo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedSexo.isEmpty ? null : _selectedSexo,
              hint: const Text("Seleccione Sexo"),
              items: sexos.map((department) {
    return DropdownMenuItem<String>(
      value: department['id'].toString(),
      child: Text(department['sexo']),
    );
  }).toList(),
  onChanged: (String? newValue) {
    setState(() {
      _selectedSexosId = newValue;
      _selectedSexosName = estadosCivil
          .firstWhere((element) => element['id'].toString() == newValue)
          ['sexo'];
 
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
            ),
            const SizedBox(height: 10),
            // Estado Civil Dropdown
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                '*Estado Civil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedEstadoCivil.isEmpty ? null : _selectedEstadoCivil,
              hint: const Text("Seleccione Estado Civil"),
              items: estadosCivil.map((department) {
    return DropdownMenuItem<String>(
      value: department['id'].toString(),
      child: Text(department['estadoCivil']),
    );
  }).toList(),
  onChanged: (String? newValue) {
    setState(() {
      _selectedEstadoCivilId = newValue;
      _selectedEstadoCivilName = estadosCivil
          .firstWhere((element) => element['id'].toString() == newValue)
          ['estado_civil'];
 
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
            ),
            const SizedBox(height: 10),
            // Fecha de Inscripción
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                '*Fecha de Inscripción',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectInscriptionDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: _inscriptionDateController,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Fecha de Inscripción',
                    hintStyle: const TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                    ),
                    suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                    fillColor: const Color(0xFFD9D9D9),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // El botón continuar
            ElevatedButton(
              onPressed: _goToSecondScreen,
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
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
