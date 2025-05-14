import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesario para formatear la fecha seleccionada
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Para manejar archivos de imagen
import 'package:ztech_mobile_application/core/http/ApiService .dart';
import 'package:ztech_mobile_application/core/http/SocialServicesService.dart';
import 'dart:convert'; // Necesario para la codificación en Base64
import 'dart:typed_data'; // <-- Importa para Uint8List

class EducationCampaignEditScreen extends StatefulWidget {
  const EducationCampaignEditScreen({Key? key}) : super(key: key);

  @override
  _EducationCampaignEditScreenState createState() =>
      _EducationCampaignEditScreenState();
}

class _EducationCampaignEditScreenState extends State<EducationCampaignEditScreen> {
  final TextEditingController _titulocamapaniaController =
      TextEditingController();
  final TextEditingController _lugarcamapaniaController =
      TextEditingController();
  final TextEditingController _descripcioncamapaniaController =
      TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  late ApiService apiService;
  late SocialServicesService socialServicesService;

  File? _image;
  Uint8List? _imageBytes;

  int? _serviceId;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    socialServicesService = SocialServicesService(apiService: apiService);
    // NO acceder a ModalRoute.of(context) aquí
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isLoaded) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is int) {
        _serviceId = args;
        _loadServiceData(_serviceId!);
        _isLoaded = true;
      }
    }
  }

  // Función para cargar los datos del servicio
  Future<void> _loadServiceData(int serviceId) async {
    try {
      final service =
          await socialServicesService.getSocialServiceById(serviceId);
      // Imprimir los datos para verlos en consola
      print('Resumen: ${service.resumen}');
      print('Lugar: ${service.lugar}');
      print('Descripción: ${service.descripcion}');
      print('Fecha: ${service.fecha}');
      print('Hora: ${service.hora}');
      print('Imagen path: ${service.imagen}');
      setState(() {
        _titulocamapaniaController.text = service.resumen;
        _lugarcamapaniaController.text = service.lugar;
        _descripcioncamapaniaController.text = service.descripcion;
        // Fecha formateada
        if (service.fecha != null && service.fecha!.isNotEmpty) {
          DateTime fechaParseada = DateTime.parse(service.fecha!);
          _fechaController.text =
              DateFormat('dd/MM/yyyy').format(fechaParseada);
        } else {
          _fechaController.text = '';
        }
// Hora formateada a hh:mm AM/PM
        if (service.hora != null && service.hora!.isNotEmpty) {
          DateTime horaParseada = DateFormat('HH:mm:ss').parse(service.hora!);
          _timeController.text = DateFormat('hh:mm a').format(horaParseada);
        } else {
          _timeController.text = '';
        }
// Decodificar base64 si existe imagen
        if (service.imagen != null && service.imagen!.isNotEmpty) {
          try {
            _imageBytes = base64Decode(service.imagen!);
          } catch (e) {
            print('Error decodificando imagen base64: $e');
            _imageBytes = null;
          }
        } else {
          _imageBytes = null;
        }

        _image = null; // Limpio la imagen local porque ahora se muestra base64
      });
    } catch (e) {
      print('Error al cargar los datos del servicio: $e');
    }
  }

  // Función para seleccionar la hora
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final now = DateTime.now();
      final formattedTime = DateFormat.jm().format(
        DateTime(now.year, now.month, now.day, picked.hour, picked.minute),
      );

      setState(() {
        _timeController.text = formattedTime;
      });
    }
  }

  // Método para mostrar el DatePicker y seleccionar la fecha
  Future<void> _selectBirthDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(9999),
    );

    if (selectedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
      setState(() {
        _fechaController.text = formattedDate;
      });
    }
  }

  // Dentro de tu clase _HealthCampaignEditScreenState:

  Future<void> _updateService() async {
    if (_serviceId == null) return;

    // Validar campos obligatorios
    if (_titulocamapaniaController.text.trim().isEmpty ||
        _fechaController.text.trim().isEmpty ||
        _timeController.text.trim().isEmpty ||
        _lugarcamapaniaController.text.trim().isEmpty ||
        _descripcioncamapaniaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, complete todos los campos.")),
      );
      return;
    }

    // Formatear fecha a yyyy-MM-dd
    DateTime fechaSeleccionada =
        DateFormat('dd/MM/yyyy').parse(_fechaController.text.trim());
    String formattedFecha = DateFormat('yyyy-MM-dd').format(fechaSeleccionada);

    // Formatear hora a HH:mm:ss (24h)
    String hora = _timeController.text.trim();
    DateFormat inputFormat = DateFormat('hh:mm a'); // Porque lo muestras así
    DateFormat outputFormat = DateFormat("HH:mm:ss");
    DateTime parsedTime = inputFormat.parse(hora);
    String formattedHora = outputFormat.format(parsedTime);

    // Convertir imagen a base64 si hay imagen nueva cargada
    String? encodedImage;
    if (_image != null) {
      List<int> imageBytes = await _image!.readAsBytes();
      encodedImage = base64Encode(imageBytes);
    }

    // Crear JSON con datos para actualizar
    final socialServiceData = {
      "resumen": _titulocamapaniaController.text.trim(),
      "lugar": _lugarcamapaniaController.text.trim(),
      "fecha": formattedFecha,
      "hora": formattedHora,
      "descripcion": _descripcioncamapaniaController.text.trim(),
      "socialServicesType": 'EDUCACION',
      "imagen": encodedImage,
    };

    try {
      final response = await socialServicesService.updateSocialService(
          _serviceId!, socialServiceData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Servicio actualizado exitosamente")),
      );
      Navigator.pop(context, true); // Cierra la pantalla y retorna true
    } catch (e) {
      print('Error al actualizar el servicio: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al actualizar el servicio")),
      );
    }
  }

  // Función para enviar los datos del formulario al backend
  Future<void> _submitForm() async {
    if (_titulocamapaniaController.text.trim().isEmpty ||
        _fechaController.text.trim().isEmpty ||
        _timeController.text.trim().isEmpty ||
        _lugarcamapaniaController.text.trim().isEmpty ||
        _descripcioncamapaniaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, complete todos los campos.")),
      );
      return;
    }

    // Formatear la fecha y la hora
    DateTime fechaSeleccionada =
        DateFormat('dd/MM/yyyy').parse(_fechaController.text.trim());
    String formattedFecha = DateFormat('yyyy-MM-dd').format(fechaSeleccionada);

    String hora = _timeController.text.trim();
    DateFormat inputFormat = DateFormat.jm();
    DateFormat outputFormat = DateFormat("HH:mm:ss");
    DateTime parsedTime = inputFormat.parse(hora);
    String formattedHora = outputFormat.format(parsedTime);

    // Convertir la imagen a base64
    String? encodedImage;
    if (_image != null) {
      List<int> imageBytes = await _image!.readAsBytes();
      encodedImage = base64Encode(imageBytes);
    }

    // Crear los datos para enviar al backend
    final socialServiceData = {
      "resumen": _titulocamapaniaController.text.trim(),
      "lugar": _lugarcamapaniaController.text.trim(),
      "fecha": formattedFecha,
      "hora": formattedHora,
      "descripcion": _descripcioncamapaniaController.text.trim(),
      "socialServicesType": 'EDUCACION',
      "imagen": encodedImage,
    };

    /*try {
      // Llamar al servicio para actualizar el servicio
      final response = await socialServicesService.updateSocialService(serviceId, socialServiceData);
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Servicio actualizado exitosamente")),
        );
        Navigator.pop(context, true); // Regresar a la pantalla anterior
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al actualizar el servicio: $e")),
      );
    }*/
  }

  // Variables para seleccionar una imagen
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
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
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? pickedFile =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _image = File(pickedFile.path);
                      _imageBytes =
                          null; // Si carga una nueva, limpia la anterior
                    });
                  }
                },
              ),
              ListTile(
                title: const Text('Seleccionar de la galería'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _image = File(pickedFile.path);
                      _imageBytes =
                          null; // Si carga una nueva, limpia la anterior
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00747C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Educación',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFC7C7CC),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0), // Ajuste de padding

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16), // espacio arriba

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
                          '*Título de campaña',
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
                          '*Lugar',
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
                          '*Fecha',
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
                          '*Hora',
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
                          '*Descripción',
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
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.photo, color: Colors.black),
                              SizedBox(width: 10),
                              Text('Cargar imagen',
                                  style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      if (_image != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.file(
                            _image!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      else if (_imageBytes != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.memory(
                            _imageBytes!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _updateService,
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
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
