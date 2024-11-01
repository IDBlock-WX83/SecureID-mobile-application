import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/common/utils/local_persistance.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }

  Future<void> _checkUserAndNavigate() async {
    // Espera 4 segundos antes de la comprobación
    await Future.delayed(const Duration(seconds: 4));

    final localPersistance = LocalPersistance();
    final user = await localPersistance.getUser();

    // Navegar según la existencia del usuario
    if (user != null && user.isNotEmpty) {
      Navigator.of(context).pushReplacementNamed("flowerpots");
    } else {
      Navigator.of(context).pushReplacementNamed("welcome");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00747C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logosecureid.png',
              width: 300,
              height: 300,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
