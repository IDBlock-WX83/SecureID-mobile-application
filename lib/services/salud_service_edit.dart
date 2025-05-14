import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesario para formatear la fecha seleccionada
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Para manejar archivos de imagen
import 'package:ztech_mobile_application/core/http/ApiService .dart';
import 'package:ztech_mobile_application/core/http/SocialServicesService.dart';
import 'dart:convert'; // Necesario para la codificación en Base64

class HealthCampaignEditScreen extends StatefulWidget {
  const HealthCampaignEditScreen({Key? key}) : super(key: key);

  @override
  _HealthCampaignEditScreenState createState() =>
      _HealthCampaignEditScreenState();
}

class _HealthCampaignEditScreenState extends State<HealthCampaignEditScreen> {
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

  @override
  void initState() {
    super.initState();

    apiService = ApiService();
    socialServicesService = SocialServicesService(apiService: apiService);

    // Obtener el ID del servicio desde los argumentos
    final int serviceId = ModalRoute.of(context)?.settings.arguments as int;
    _loadServiceData(serviceId); // Cargar los datos del servicio
  }

  // Función para cargar los datos del servicio
  Future<void> _loadServiceData(int serviceId) async {
    try {
      final service = await socialServicesService.getSocialServiceById(serviceId);
      setState(() {
        _titulocamapaniaController.text = service.resumen;
        _lugarcamapaniaController.text = service.lugar;
        _descripcioncamapaniaController.text = service.descripcion;
        _fechaController.text = service.fecha;
        _timeController.text = service.hora;

        // Si la imagen está disponible, asignarla
        _image = service.imagen != null ? File(service.imagen!) : null;
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
    DateTime fechaSeleccionada = DateFormat('dd/MM/yyyy').parse(_fechaController.text.trim());
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
      "socialServicesType": 'SALUD',
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
                  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _image = File(pickedFile.path);
                    });
                  }
                },
              ),
              ListTile(
                title: const Text('Seleccionar de la galería'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _image = File(pickedFile.path);
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
          'Salud',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFC7C7CC),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00747C),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    children: [
                      // Resto de los campos de entrada como "Título", "Lugar", etc.
                      TextField(
                        controller: _titulocamapaniaController,
                        decoration: InputDecoration(
                          hintText: 'Título de campaña',
                          fillColor: Colors.white,
                        ),
                      ),
                      // Resto de campos como "Lugar", "Fecha", etc.
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BBC9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text(
                    'Guardar',
                    style: TextStyle(color: Colors.black, fontSize: 16),
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
