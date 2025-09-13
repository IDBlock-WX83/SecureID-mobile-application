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

class SignUpScreen2 extends StatefulWidget {
  final Map<String, dynamic> firstData;

  const SignUpScreen2({super.key, required this.firstData});

  @override
  _SignUpScreen2State createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
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

  bool _isLoading = false;

  // ===== OverlayEntry para cubrir TODO (AppBar incluido) =====
  OverlayEntry? _loader;
  void _showFullScreenLoader() {
    if (_loader != null) return;
    _loader = OverlayEntry(
      builder: (_) => WillPopScope(
        onWillPop: () async => false, // bloquear back
        child: Stack(
          children: const [
            // Capa oscura que cubre absolutamente toda la pantalla
            Positioned.fill(
              child: ModalBarrier(
                dismissible: false,
                color: Colors.black45,
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 64, height: 64,
                    child: CircularProgressIndicator(strokeWidth: 5, color: Colors.white),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Registrando…',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_loader!);
  }

  void _hideFullScreenLoader() {
    try {
      _loader?.remove();
    } catch (_) {}
    _loader = null;
  }
  // ===========================================================

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
    _hideFullScreenLoader();
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, complete todos los campos")),
      );
      return;
    }

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

    String encodedImage1 = base64Encode(await _image1!.readAsBytes());
    String encodedImage2 = base64Encode(await _image2!.readAsBytes());

    String telefonoCelular = _telefonoCelularController.text.trim();
    if (telefonoCelular.isNotEmpty && telefonoCelular.length < 9) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("El teléfono celular debe tener 9 dígitos")),
      );
      return;
    }
    if (telefonoCelular.isEmpty) telefonoCelular = '';

    final consolidatedData = {
      ...widget.firstData,
      "direccion": _direccionController.text.trim(),
      "distrito": {"id": _selectedDistritoId},
      "telefonoCelular": telefonoCelular.isEmpty ? null : telefonoCelular,
      "fotoHash": "",
      "firmaHash": "",
    };

    // Mostrar overlay + deshabilitar botón
    if (mounted) {
      setState(() => _isLoading = true);
      _showFullScreenLoader();
    }

    try {
      final response = await residenteService.createIdentification(consolidatedData);

      String idDigital = response['idDigital'];

      final consolidatedSaveImages = {
        "fotoHash": encodedImage1,
        "firmaHash": encodedImage2,
        "idDigital": idDigital,
      };

      await residenteService.saveImages(consolidatedSaveImages);

      if (!mounted) return;

      if (response != null) {
        Navigator.pushNamed(context, 'registro_exitoso_adulto_mayor');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al guardar la identificación: $e")),
      );
    } finally {
      if (mounted) {
        _hideFullScreenLoader();
        setState(() => _isLoading = false);
      }
    }
  }

  // Variables de selección
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF00747C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            if (_isLoading) return; // no permitir volver mientras carga
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('direccion_temp', _direccionController.text);
            await prefs.setString('departamento_temp', _departamentoController.text);
            await prefs.setString('provincia_temp', _provinciaController.text);
            await prefs.setString('distrito_temp', _distritoController.text);
            await prefs.setString('telefono_temp', _telefonoCelularController.text);
            if (mounted) Navigator.of(context).pop();
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
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '*Dirección',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _direccionController,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Dirección',
                hintStyle: const TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
                fillColor: const Color(0xFFD9D9D9),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '*Departamento',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
                    (e) => e['id'].toString() == newValue,
                  )['departamento'];
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
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '*Provincia',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
                  _selectedProvinciaName = provincias.firstWhere(
                    (e) => e['id'].toString() == newValue,
                  )['provincia'];
                  _selectedDistritoId = null;
                });
                if (newValue != null) {
                  _fetchDistricts(int.parse(newValue));
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
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '*Distrito',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
                  _selectedDistritoName = distritos.firstWhere(
                    (e) => e['id'].toString() == newValue,
                  )['distrito'];
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
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Teléfono celular',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _telefonoCelularController,
              keyboardType: TextInputType.number,
              inputFormatters: [LengthLimitingTextInputFormatter(9)],
              decoration: InputDecoration(
                filled: true,
                hintText: 'Teléfono celular',
                hintStyle: const TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
                fillColor: const Color(0xFFD9D9D9),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onTap: () {
                if (_telefonoCelularController.text.trim().isEmpty) {
                  _telefonoCelularController.text = '9';
                  _telefonoCelularController.selection =
                      const TextSelection.collapsed(offset: 1);
                }
              },
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '*Cargar foto',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
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
                              _pickImage(1, ImageSource.camera);
                            },
                          ),
                          ListTile(
                            title: const Text('Seleccionar de la galería'),
                            onTap: () {
                              Navigator.of(context).pop();
                              _pickImage(1, ImageSource.gallery);
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo, color: Colors.black),
                  SizedBox(width: 10),
                  Text('Cargar foto', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (_image1 != null)
              CircleAvatar(
                radius: 100,
                backgroundColor: Colors.grey[400],
                child: ClipOval(
                  child: Image.memory(
                    _image1!.readAsBytesSync(),
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '*Cargar firma',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
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
                              _pickImage(2, ImageSource.camera);
                            },
                          ),
                          ListTile(
                            title: const Text('Seleccionar de la galería'),
                            onTap: () {
                              Navigator.of(context).pop();
                              _pickImage(2, ImageSource.gallery);
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo, color: Colors.black),
                  SizedBox(width: 10),
                  Text('Cargar firma', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (_image2 != null)
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    _image2!.readAsBytesSync(),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C2CB),
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: _isLoading
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Continuar', style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
