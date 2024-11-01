import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/firebase_options.dart';
import 'package:ztech_mobile_application/menu/identity/DNI_screen.dart';
import 'package:ztech_mobile_application/menu/menu_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/register_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/splash_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/welcome_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/upload_front_DNI_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/upload_back_DNI_screen.dart';

import 'package:ztech_mobile_application/profile/presentation/views/register2_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ztech',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),//Carga de pantalla completo
        'welcome': (context) => WelcomeScreen(),//Pantalla de bienvenida completo
        'upload_front_dni': (context) =>  UploadFrontDNIScreen(),
        'upload_back_dni': (context) =>  UploadBackDNIScreen(),
        'register': (context) => SignUpScreen(),
        'register2': (context) => SignUpScreen2(),

      },
    );
  }
}
