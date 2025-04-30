import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesario para formatear la fecha seleccionada
import 'package:flutter/services.dart';
import 'register2_screen.dart'; // Importa la pantalla del segundo registro

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

  String _selectedSexo = ''; // Valor inicial vacío para el Dropdown de Sexo
  String _selectedEstadoCivil = ''; // Valor inicial vacío para el Dropdown de Estado Civil

  // Libera los controladores cuando ya no son necesarios
  @override
  void dispose() {
    _nameController.dispose();
    _paternalSurnameController.dispose();
    _maternalSurnameController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  // Método para mostrar el DatePicker y seleccionar la fecha
  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900), // Fecha mínima
      lastDate: DateTime.now(), // Fecha máxima
    );

    if (selectedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
      setState(() {
        _birthDateController.text =
            formattedDate; // Actualiza el TextField con la fecha seleccionada
      });
    }
  }

  void _goToSecondScreen() {
    // Verifica que todos los campos estén completos
    if (_nameController.text.trim().isEmpty ||
        _paternalSurnameController.text.trim().isEmpty ||
        _maternalSurnameController.text.trim().isEmpty ||
        _birthDateController.text.trim().isEmpty ||
        _selectedSexo.isEmpty || // Verifica que el sexo no esté vacío
        _selectedEstadoCivil.isEmpty) { // Verifica que el estado civil no esté vacío
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, complete todos los campos")),
      );
      return;
    }

    // Consolidar los datos del primer formulario
    final firstData = {
      "preNombres": _nameController.text.trim(),
      "apellidoPaterno": _paternalSurnameController.text.trim(),
      "apellidoMaterno": _maternalSurnameController.text.trim(),
      "fechaNacimiento": _birthDateController.text.trim(),
      "sexo": _selectedSexo,
      "estadoCivil": _selectedEstadoCivil,
    };

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
        title: const Text('Identificación', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Hace que el contenido sea desplazable cuando aparece el teclado
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10), // Espacio superior para asegurar que haya espacio con el teclado
            // Campo de texto: Nombre completo con labelText flotante
            Align(
              alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
              child: const Text(
                'Pre Nombres',
                style: TextStyle(
                  color: Colors.white, // Texto blanco como fondo azul
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
                hintText: 'Pre Nombres', // 👈 Esto es el placeholder dentro
                hintStyle: const TextStyle(
                  color: Colors.black45, // Gris como tu imagen
                  fontWeight: FontWeight.bold,
                ),
                fillColor: const Color(0xFFD9D9D9),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
              child: const Text(
                'Primer Apellido',
                style: TextStyle(
                  color: Colors.white, // Texto blanco como fondo azul
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
                hintText: 'Primer Apellido', // 👈 Esto es el placeholder dentro
                hintStyle: const TextStyle(
                  color: Colors.black45, // Gris como tu imagen
                  fontWeight: FontWeight.bold,
                ),
                fillColor: const Color(0xFFD9D9D9),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
              child: const Text(
                'Segundo Apellido',
                style: TextStyle(
                  color: Colors.white, // Texto blanco como fondo azul
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
                hintText: 'Segundo Apellido', // 👈 Esto es el placeholder dentro
                hintStyle: const TextStyle(
                  color: Colors.black45, // Gris como tu imagen
                  fontWeight: FontWeight.bold,
                ),
                fillColor: const Color(0xFFD9D9D9),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
              child: const Text(
                'Fecha de Nacimiento',
                style: TextStyle(
                  color: Colors.white, // Texto blanco como fondo azul
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
                        // Campo de texto con un gesto para mostrar el DatePicker
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer( // Previene la interacción directa con el campo de texto
                child: TextField(
                  controller: _birthDateController,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Fecha de Nacimiento',
                    hintStyle: const TextStyle(
                      color: Colors.black45, // Gris como tu imagen
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
            const SizedBox(height: 25),

            // Dropdown para Sexo
            Align(
              alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
              child: const Text(
                'Sexo',
                style: TextStyle(
                  color: Colors.white, // Texto blanco como fondo azul
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedSexo.isEmpty ? null : _selectedSexo, // Si está vacío, no se selecciona un valor
              hint: const Text("Seleccione Sexo"),
              items: const [
                DropdownMenuItem(
                  value: 'M',
                  child: Text('Masculino'),
                ),
                DropdownMenuItem(
                  value: 'F',
                  child: Text('Femenino'),
                ),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSexo = newValue!;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 25),
            // Dropdown para Estado Civil
            Align(
              alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
              child: const Text(
                'Estado Civil',
                style: TextStyle(
                  color: Colors.white, // Texto blanco como fondo azul
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedEstadoCivil.isEmpty ? null : _selectedEstadoCivil, // Si está vacío, no se selecciona un valor
              hint: const Text("Seleccione Estado Civil"),
              items: const [
                DropdownMenuItem(
                  value: 'Soltero',
                  child: Text('Soltero'),
                ),
                DropdownMenuItem(
                  value: 'Casado',
                  child: Text('Casado'),
                ),
                DropdownMenuItem(
                  value: 'Viudo',
                  child: Text('Viudo'),
                ),
                DropdownMenuItem(
                  value: 'Divorciado',
                  child: Text('Divorciado'),
                ),
                DropdownMenuItem(
                  value: 'Separado',
                  child: Text('Separado'),
                ),
                DropdownMenuItem(
                  value: 'Conviviente',
                  child: Text('Conviviente'),
                ),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedEstadoCivil = newValue!;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
              child: const Text(
                'Fecha de Inscripción',
                style: TextStyle(
                  color: Colors.white, // Texto blanco como fondo azul
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
                        // Campo de texto con un gesto para mostrar el DatePicker
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer( // Previene la interacción directa con el campo de texto
                child: TextField(
                  controller: _birthDateController,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Fecha de Inscripción',
                    hintStyle: const TextStyle(
                      color: Colors.black45, // Gris como tu imagen
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
            // El resto de campos...
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
