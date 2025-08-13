import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_club_connect/pages/public/pantallacarga.dart';
import 'package:logger/logger.dart';
import 'firebase_options.dart';
import 'package:flutter_club_connect/pages/admin/dashboard_admin.dart';
import 'package:flutter_club_connect/pages/public/historiascreen.dart';
import 'package:flutter_club_connect/pages/public/futbolprofesional.dart';
import 'package:flutter_club_connect/pages/public/plantelprofesional.dart';
import 'package:flutter_club_connect/pages/public/plantelamateur.dart';
import 'package:flutter_club_connect/pages/public/noticiafutbolamateur.dart';
import 'package:flutter_club_connect/pages/public/noticiafutbolfemenino.dart';
import 'package:flutter_club_connect/pages/public/plantelfemenino.dart';
import 'package:flutter_club_connect/pages/admin/admin_noticias_screen.dart';
import 'package:flutter_club_connect/pages/admin/login_screen.dart';
import 'package:flutter_club_connect/pages/public/contacto.dart';







FirebaseFirestore db = FirebaseFirestore.instance;
var logger = Logger();


final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();


/// 🔔 Manejador de notificaciones en segundo plano
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  logger.i('🔔 Notificación (fondo): ${message.notification?.title}');
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();


    // 🟢 Pedir permiso para notificaciones
    FirebaseMessaging.instance.requestPermission().then((settings) {
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        logger.i('✅ Permiso para notificaciones concedido');
        _obtenerTokenFCM(); // 👉 Obtener token después de autorización
      } else {
        logger.w('⚠️ Permiso para notificaciones denegado');
      }
    });


    // 🔔 Suscribirse a un topic
    FirebaseMessaging.instance.subscribeToTopic('noticias');


    // 🔔 Escuchar notificaciones en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        logger.i('🔔 Notificación (frente): ${message.notification!.title}');
        final snackBar = SnackBar(
          content: Text(
            message.notification!.title ?? 'Notificación',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        );
        scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
      }
    });
  }


  /// 🔑 Obtener y mostrar el token FCM
  void _obtenerTokenFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    logger.i('📱 Token FCM: $token');
    // También podés guardar el token en Firestore si querés
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Club 9 de Julio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      scaffoldMessengerKey: scaffoldMessengerKey,
      home:  const  PantallaCarga(),


      routes: {
        '/historia': (context) => const HistoriaScreen(),
        '/futbol-profesional': (context) => const NoticiasFutbolProfesionalScreen(),
        '/futbol-profesional/noticias': (context) => const NoticiasFutbolProfesionalScreen(),
        '/futbol-profesional/plantel-cuerpo-tecnico': (context) => const PlantelYCuerpoTecnicoFutbolProfesionalScreen(),
        '/futbol-profesional/plantel': (context) => const PlantelYCuerpoTecnicoFutbolProfesionalScreen(),
        '/futbol-amateur/plantel': (context) => const PlantelYCuerpoTecnicoFutbolAmateurScreen(),
        '/futbol-amateur/noticias': (context) => const NoticiasFutbolAmateurScreen(),
        '/futbol-femenino/noticias': (context) => const NoticiasFutbolFemeninoScreen(),
        '/futbol-femenino/plantel': (context) => const PlantelYCuerpoTecnicoFutbolFemeninoScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
        '/admin/noticias': (context) => const AdminNoticiasScreen(),
        '/admin/login_screen': (context) => const LoginScreen(),
        '/contacto': (context) => const ContactoScreen(),



      },
    );
  }
}




