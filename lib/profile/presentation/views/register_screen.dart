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

  // Libera los controladores cuando ya no son necesarios
  @override
  void dispose() {
    _nameController.dispose();
    _paternalSurnameController.dispose();
    _maternalSurnameController.dispose();
    _idDigitalController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
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
        _idDigitalController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _birthDateController.text.trim().isEmpty) {
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
      "idDigital": _idDigitalController.text.trim(),
      "fechaNacimiento": _birthDateController.text.trim(),
      "direccion": _addressController.text.trim(),
      "telefono": _phoneController.text.trim(),
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
      resizeToAvoidBottomInset:
          true, // Permite que el contenido se ajuste cuando aparece el teclado
      body: SingleChildScrollView(
        // Hace que el contenido sea desplazable cuando aparece el teclado
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
                height:
                    50), // Espacio superior para asegurar que haya espacio con el teclado
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
            // Campo de texto: Nombre completo con labelText flotante
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
                labelText: 'Nombres',
                labelStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _paternalSurnameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
                labelText: 'Apellido Paterno',
                labelStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _maternalSurnameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
                labelText: 'Apellido Materno',
                labelStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _idDigitalController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
                labelText: 'ID Digital',
                labelStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
                labelText: 'Dirección',
                labelStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(9),
              ],
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
                labelText: 'Teléfono',
                labelStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: _birthDateController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFD9D9D9),
                    labelText: 'Fecha de Nacimiento',
                    labelStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    suffixIcon: Icon(Icons.calendar_today,
                        color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _goToSecondScreen,
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
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
