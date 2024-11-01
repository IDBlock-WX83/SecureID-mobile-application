import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesario para formatear la fecha seleccionada
import 'package:flutter/services.dart';

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
                labelText: 'Nombres', // Label flotante
                labelStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold), // Ajuste de estilo
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: 20), // Ajuste de padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Campo de texto: Apellido Paterno con labelText flotante
            TextField(
              controller: _paternalSurnameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
                labelText: 'Apellido Paterno', // Label flotante
                labelStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold), // Ajuste de estilo
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: 20), // Ajuste de padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Campo de texto: Apellido Paterno con labelText flotante
            TextField(
              controller: _maternalSurnameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
                labelText: 'Apellido Materno', // Label flotante
                labelStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold), // Ajuste de estilo
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: 20), // Ajuste de padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Campo de texto: ID Digital con labelText flotante
            TextField(
              controller: _idDigitalController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
                labelText: 'ID Digital', // Label flotante
                labelStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold), // Ajuste de estilo
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: 20), // Ajuste de padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Campo de texto: Dirección con labelText flotante
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
                labelText: 'Dirección', // Label flotante
                labelStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold), // Ajuste de estilo
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: 20), // Ajuste de padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Campo de texto: Teléfono con labelText flotante
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone, // Muestra el teclado numérico
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Permite solo números
                LengthLimitingTextInputFormatter(
                    9), // Limita la entrada a 9 caracteres
              ],
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
                labelText: 'Teléfono', // Label flotante
                labelStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold), // Ajuste de estilo
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: 20), // Ajuste de padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Campo de texto: Fecha de Nacimiento con ícono de calendario y labelText flotante
            GestureDetector(
              onTap: () {
                _selectDate(context); // Abre el DatePicker al hacer clic
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: _birthDateController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFD9D9D9),
                    labelText: 'Fecha de Nacimiento', // Label flotante
                    labelStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold), // Ajuste de estilo
                    suffixIcon: Icon(Icons.calendar_today,
                        color: Colors.grey), // Ícono de calendario
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20), // Ajuste de padding
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Botón de Continuar
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'register2');
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
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
