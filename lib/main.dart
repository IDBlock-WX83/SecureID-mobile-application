import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/firebase_options.dart';
import 'package:ztech_mobile_application/profile/presentation/views/menu_screen.dart';
import 'package:ztech_mobile_application/menu/identity/DNI_screen.dart';
import 'package:ztech_mobile_application/menu/identity/face_capture_screen.dart';
import 'package:ztech_mobile_application/menu/identity/identity_screen.dart';
import 'package:ztech_mobile_application/menu/menu_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/register_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/resident_detail_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/search_resident_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/splash_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/transaction_history_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/welcome_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/upload_front_DNI_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/upload_back_DNI_screen.dart';

import 'package:ztech_mobile_application/services/agua_service_edit.dart';
import 'package:ztech_mobile_application/services/agua_service_registration_screen.dart';
import 'package:ztech_mobile_application/services/agua_services_admin_list.dart';
import 'package:ztech_mobile_application/services/educacion%20_service_edit.dart';
import 'package:ztech_mobile_application/services/educacion_service_registration_screen.dart';
import 'package:ztech_mobile_application/services/educacion_services_admin_list.dart';
import 'package:ztech_mobile_application/services/energia_service_edit.dart';
import 'package:ztech_mobile_application/services/energia_service_registration_screen.dart';
import 'package:ztech_mobile_application/services/energia_services_admin_list.dart';
import 'package:ztech_mobile_application/services/salud_service_edit.dart';
import 'package:ztech_mobile_application/services/salud_service_registration_screen.dart';
import 'package:ztech_mobile_application/services/salud_services_admin_list.dart';
import 'services/services_admin_screen.dart';
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
        '/': (context) => const SplashScreen(),//Carga de pantalla completo
        'welcome': (context) => WelcomeScreen(),//Pantalla de bienvenida completo
        'upload_front_dni': (context) =>  UploadFrontDNIScreen(),
        'upload_back_dni': (context) =>  UploadBackDNIScreen(),
        'register': (context) => SignUpScreen(),
        'register2': (context) => SignUpScreen2(),
        'servicesAdmin': (context) => ServicesAdminScreen(),// services para editores
        'registerhealth': (context) => SaludServiceRegistrationScreen(),
        'registerenergy': (context) => EnergyServiceRegistrationScreen(),
        'registereducation': (context) => EducationServiceRegistrationScreen(),
        'registerwater': (context) => WaterServiceRegistrationScreen(),
        'healthlistadmin': (context) => HealthServiceListScreen(),
        'energylistadmin': (context) => EnergyServiceListScreen(),
        'educationlistadmin': (context) => EducationServiceListScreen(),
        'waterlistadmin': (context) => WaterServiceListScreen(),
        'healthedit': (context) => HealthCampaignEditScreen(),
        'energyedit': (context) => EnergyCampaignEditScreen(),
        'educationedit': (context) => EducationCampaignEditScreen(),
        'wateredit': (context) => WaterCampaignEditScreen(),
        'upload_face_capture': (context) =>  FaceCaptureScreen(),
        'user_menu': (context) =>  MenuScreen(),
        'user_identification': (context) =>  IdentityScreen(),
        'user_dni': (context) =>  DNIScreen(),
        'menu': (context) => MenuScreenAutoridades(blockchain: blockchain), // Pasar la instancia de Blockchain aquí
        'resident_screen': (context) => ResidentsScreen(),
        'record_screen': (context) => TransactionHistoryScreen(blockchain: blockchain), // Pasar la instancia de Blockchain aquí
      },
    );
  }
}
