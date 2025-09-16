import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:ztech_mobile_application/firebase_options.dart';
import 'package:ztech_mobile_application/profile/presentation/views/distrito_servicio_alimentacion.dart';
import 'package:ztech_mobile_application/profile/presentation/views/distrito_servicio_educacion.dart';
import 'package:ztech_mobile_application/profile/presentation/views/distrito_servicio_salud.dart';
import 'package:ztech_mobile_application/profile/presentation/views/distrito_servicio_social.dart';
import 'package:ztech_mobile_application/profile/presentation/views/menu_screen.dart';
import 'package:ztech_mobile_application/menu/identity/DNI_screen.dart';
import 'package:ztech_mobile_application/menu/identity/face_capture_screen.dart';
import 'package:ztech_mobile_application/menu/identity/identity_screen.dart';
import 'package:ztech_mobile_application/menu/identity/identity_admin_screen.dart';

import 'package:ztech_mobile_application/menu/menu_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/register_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/resident_detail_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/search_resident_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/pantalla_carga.dart';
import 'package:ztech_mobile_application/profile/presentation/views/transaction_history_screen.dart';
import 'package:ztech_mobile_application/profile/presentation/views/inicio_sesion.dart';
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
import 'package:ztech_mobile_application/menu/soporte_registro.dart';
import 'package:ztech_mobile_application/InAppServices/views/services_screen.dart';
import 'package:ztech_mobile_application/menu/successregister_popup.dart';
import 'package:ztech_mobile_application/services/successregister_Salud_popup.dart';
import 'package:ztech_mobile_application/services/deleteregister_Salud_popup.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ztech_mobile_application/core/http/ApiService.dart';
import 'package:ztech_mobile_application/core/http/SocialServicesService.dart';

// 🔹 Notificaciones locales
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// 🔹 Handler para notificaciones en background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 Mensaje en background: ${message.notification?.title}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ Crear canal de notificación (Android 8+)
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'default_channel',
    'General Notifications',
    description: 'Canal para notificaciones generales',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // ✅ Inicialización de notificaciones locales
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // ✅ Configuración Firebase Messaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ Suscribirse al topic
  await FirebaseMessaging.instance.subscribeToTopic("services-basics");

  // ✅ Pedir permiso (Android 13+)
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  print("🔔 Permiso notificaciones: ${settings.authorizationStatus}");

  // ✅ Foreground (app abierta)
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📩 Notificación foreground: ${message.notification?.title}");
    _showLocalNotification(message);
  });

  // ✅ Cuando el usuario toca la notificación
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("👉 Usuario tocó la notificación: ${message.notification?.title}");
    // Aquí podrías navegar a otra pantalla
  });

  runApp(MyApp());
}

void _showLocalNotification(RemoteMessage message) {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'default_channel',
    'General Notifications',
    channelDescription: 'Canal para notificaciones generales',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.notification?.title ?? "Sin título",
    message.notification?.body ?? "Sin contenido",
    platformChannelSpecifics,
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Crear la instancia de Blockchain aquí
    final blockchain = Blockchain();

    return MaterialApp(
      locale: const Locale('es'), // <- Español
      supportedLocales: const [
        Locale('es'), // Español
        Locale('en'), // Inglés (opcional)
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Ztech',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(), //Carga de pantalla completo
        'welcome': (context) => WelcomeScreen(), //Pantalla de bienvenida completo
        'registro_exitoso': (context) => SuccessPopup(onProfileClick: () {}),
        'upload_front_dni': (context) => UploadFrontDNIScreen(),
        'upload_back_dni': (context) => UploadBackDNIScreen(),
        'register': (context) => SignUpScreen(),
        'register2': (context) => SignUpScreen2(firstData: {}), // Envía un mapa vacío o los datos reales
        'servicios_administrador': (context) => ServicesAdminScreen(), // services para editores
        'registerhealth': (context) => SaludServiceRegistrationScreen(),
        'registerenergy': (context) => EnergyServiceRegistrationScreen(),
        'registereducation': (context) => EducationServiceRegistrationScreen(),
        'registerwater': (ServicesScreencontext) => WaterServiceRegistrationScreen(),
        'healthlistadmin': (context) => HealthServiceListScreen(),
        'energylistadmin': (context) => EnergyServiceListScreen(),
        'educationlistadmin': (context) => EducationServiceListScreen(),
        'waterlistadmin': (context) => WaterServiceListScreen(),
        'healthedit': (context) => HealthCampaignEditScreen(),
        'energyedit': (context) => EnergyCampaignEditScreen(),
        'educationedit': (context) => EducationCampaignEditScreen(),
        'upload_face_capture': (context) => FaceCaptureScreen(),
        'menu_residentes': (context) => MenuScreen(),

        'distrito_servicio_salud': (context) => DistritoServicioSalud(),
        'distrito_servicio_social': (context) => DistritoServicioSocial(),
        'distrito_servicio_educacion': (context) => DistritoServicioEducacion(),
        'distrito_servicio_alimentacion': (context) => DistritoServicioAlimentacion(),

        'identificacion': (context) => IdentityScreen(),
                //'identificacion_admin': (context) => IdentityAdminScreen(),

        'user_dni': (context) => DNIScreen(),
        'menu': (context) => MenuScreenAutoridades(blockchain: blockchain), // Pasar la instancia de Blockchain aquí
        'resident_screen': (context) => ResidentsScreen(),
        'record_screen': (context) => TransactionHistoryScreen(), // Pasar la instancia de Blockchain aquí
        'servicios_residentes': (context) => ServicesScreen(),
        'registro_exitoso_adulto_mayor': (context) => SuccessRegisterPopup(onProfileClick: () {}),
        'servicio_creado_general': (context) => SuccessRegisterSaludPopup(onProfileClick: () {}),
        'servicio_eliminar_general': (context) {
          // Obtener el serviceId que se pasó desde la pantalla anterior
          final int serviceId = ModalRoute.of(context)?.settings.arguments as int;

          // Crear la instancia del servicio, o utilizar la existente
          final socialServicesService = SocialServicesService(apiService: ApiService());

          // Devolver la vista de eliminación con los parámetros requeridos
          return DeleteRegisterSaludPopup(
            onProfileClick: () {
              // Acción a realizar cuando se confirma la eliminación
            },
            serviceId: serviceId, // Pasar el serviceId
            socialServicesService: socialServicesService, // Pasar la instancia del servicio
          );
        },
      },
    );
  }
}
