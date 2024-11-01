import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/firebase_options.dart';
import 'package:ztech_mobile_application/profile/presentation/views/menu_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/register_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/resident_detail_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/search_resident_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/splash_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/transaction_history_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/welcome_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/upload_front_DNI_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/upload_back_DNI_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/register2_screen.dart';
import 'package:ztech_mobile_application/common/utils/blockchain_record.dart'; // Asegúrate de importar tu clase Blockchain

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp()); // No es necesario el 'const' aquí
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Crear la instancia de Blockchain aquí
    final blockchain = Blockchain();

    return MaterialApp(
      title: 'Ztech',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        'welcome': (context) => WelcomeScreen(),
        'upload_front_dni': (context) => UploadFrontDNIScreen(),
        'upload_back_dni': (context) => UploadBackDNIScreen(),
        'register': (context) => SignUpScreen(),
        'register2': (context) => SignUpScreen2(),
        'menu': (context) => MenuScreen(blockchain: blockchain), // Pasar la instancia de Blockchain aquí
        'resident_screen': (context) => ResidentsScreen(),
        'record_screen': (context) => TransactionHistoryScreen(blockchain: blockchain), // Pasar la instancia de Blockchain aquí
      },
    );
  }
}
