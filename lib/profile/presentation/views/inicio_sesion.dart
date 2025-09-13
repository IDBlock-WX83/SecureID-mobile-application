import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ztech_mobile_application/core/http/AutoridadService.dart';
import 'package:ztech_mobile_application/core/http/ResidenteService.dart';
import 'dart:convert';
import 'package:ztech_mobile_application/core/http/SocialServicesService.dart';
import 'package:ztech_mobile_application/core/http/ApiService.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _idController = TextEditingController();

  final residenteService = ResidenteService(apiService: ApiService());
  final autoridadService = Autoridadservice(apiService: ApiService());

  bool _isLoading = false;

  // ===== OverlayEntry: fondo gris + spinner a pantalla completa =====
  OverlayEntry? _loader;
  void _showFullScreenLoader() {
    if (_loader != null) return;
    _loader = OverlayEntry(
      builder: (_) => WillPopScope(
        onWillPop: () async => false, // bloquea back mientras carga
        child: Stack(
          children: const [
            Positioned.fill(
              child: ModalBarrier(
                dismissible: false,
                color: Colors.black45, // fondo gris oscuro
              ),
            ),
            Center(
              child: SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  color: Colors.white,
                ),
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
  // ================================================================

  @override
  void dispose() {
    _hideFullScreenLoader();
    _idController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final idDigital = _idController.text.trim();

    // Validaciones
    if (idDigital.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un ID Digital.')),
      );
      return;
    }
    if (idDigital.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El ID Digital debe tener al menos 8 dígitos.')),
      );
      return;
    }

    // Mostrar overlay y deshabilitar botón
    if (mounted) {
      setState(() => _isLoading = true);
      _showFullScreenLoader();
    }

    try {
      dynamic userData;
      if (idDigital.length == 8) {
        userData = await residenteService.loginByIdDigital(idDigital);
      } else if (idDigital.length > 8) {
        userData = await autoridadService.loginByIdDigital(idDigital);
      }

      if (userData == null || userData['idDigital'] != idDigital) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ingresa un ID Digital válido.')),
        );
        return;
      }

      // Guardar sesión
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', userData['id']);
      await prefs.setString('idDigital', userData['idDigital']);

      // Navegar según tipo
      if (!mounted) return;
      if (userData['idDigital'].length == 8) {
        Navigator.pushReplacementNamed(context, 'menu_residentes');
      } else if (userData['idDigital'].length == 10) {
        Navigator.pushReplacementNamed(context, 'menu');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión: $e')),
      );
    } finally {
      if (mounted) {
        _hideFullScreenLoader();
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00747C),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bienvenido a SecureID',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/logosecureid.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 40),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'ID Digital',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _idController,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'ID Digital',
                        hintStyle: const TextStyle(
                          color: Colors.black45,
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
                  ],
                ),

                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BBC9),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Entrar',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.pushNamed(context, 'registro_exitoso');
                        },
                  child: const Text(
                    '¿No tienes cuenta?',
                    style: TextStyle(color: Colors.white),
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
