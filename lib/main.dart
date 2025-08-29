import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:logger/logger.dart';


// 📌 Páginas públicas
import 'package:flutter_club_connect/pages/public/pantallacarga.dart';
import 'package:flutter_club_connect/pages/public/historiascreen.dart';
import 'package:flutter_club_connect/pages/public/noticia/futbolprofesional.dart';
import 'package:flutter_club_connect/pages/public/plantel/plantelprofesional.dart';
import 'package:flutter_club_connect/pages/public/plantel/plantelamateur.dart';
import 'package:flutter_club_connect/pages/public/noticia/noticiafutbolamateur.dart';
import 'package:flutter_club_connect/pages/public/noticia/noticiafutbolfemenino.dart';
import 'package:flutter_club_connect/pages/public/plantel/plantelfemenino.dart';






// 📌 Páginas de administración
import 'package:flutter_club_connect/pages/admin/dashboard_admin.dart';
import 'package:flutter_club_connect/pages/admin/gestion_noticias/admin_noticias_screen.dart';
import 'package:flutter_club_connect/pages/admin/login_screen.dart';
import 'package:flutter_club_connect/pages/admin/admin_plantel_profesional_screen.dart';


final FirebaseFirestore db = FirebaseFirestore.instance;
final Logger logger = Logger();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  logger.i('🔔 Notificación en segundo plano: ${message.notification?.title}');
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}


/// ----------------- Drawer global -----------------
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFFB71C1C)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'images/escudo.jpeg',
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Club Atlético 9 de Julio',
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.red),
            title: const Text('Noticias'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/noticias');
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance, color: Colors.red),
            title: const Text('Historia'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/historia');
            },
          ),
          ListTile(
            leading: const Icon(Icons.sports_soccer, color: Colors.red),
            title: const Text('Fútbol Profesional'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/futbol-profesional');
            },
          ),
          ListTile(
            leading: const Icon(Icons.sports_soccer, color: Colors.red),
            title: const Text('Fútbol Amateur'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/futbol-amateur/noticias');
            },
          ),
          ListTile(
            leading: const Icon(Icons.sports, color: Colors.red),
            title: const Text('Fútbol Femenino'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/futbol-femenino/noticias');
            },
          ),
        ],
      ),
    );
  }
}


/// ----------------- MyApp principal -----------------
class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _pedirPermisoNotificaciones();
    _suscribirseATopics();
    _escucharNotificacionesEnPrimerPlano();
  }


  void _pedirPermisoNotificaciones() {
    FirebaseMessaging.instance.requestPermission().then((settings) {
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        logger.i('✅ Permiso para notificaciones concedido');
        _obtenerTokenFCM();
      } else {
        logger.w('⚠️ Permiso para notificaciones denegado');
      }
    });
  }


  Future<void> _obtenerTokenFCM() async {
    String? token = await FirebaseMessaging.instance.getToken();
    logger.i('📱 Token FCM: $token');
  }


  void _suscribirseATopics() {
    FirebaseMessaging.instance.subscribeToTopic('noticias');
  }


  void _escucharNotificacionesEnPrimerPlano() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        logger.i('🔔 Notificación en primer plano: ${message.notification!.title}');
        final snackBar = SnackBar(
          content: Text(message.notification!.title ?? 'Notificación',
              style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        );
        scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Club 9 de Julio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: const PantallaCarga(),
      routes: {
        // Pantallas públicas con Drawer
        '/noticias': (context) => const NoticiasScreenWithDrawer(),
        '/historia': (context) => const HistoriaScreenWithDrawer(),
        '/futbol-profesional': (context) => const NoticiasFutbolProfesionalScreen(),
        '/futbol-profesional/noticias': (context) => const NoticiasFutbolProfesionalScreen(),
        '/futbol-profesional/plantel': (context) => const PlantelYCuerpoTecnicoFutbolProfesionalScreen(),
        '/futbol-amateur/plantel': (context) => const PlantelYCuerpoTecnicoFutbolAmateurScreen(),
        '/futbol-amateur/noticias': (context) => const NoticiasFutbolAmateurScreen(),
        '/futbol-femenino/noticias': (context) => const NoticiasFutbolFemeninoScreen(),
        '/futbol-femenino/plantel': (context) => const PlantelYCuerpoTecnicoFutbolFemeninoScreen(),


        // Administración
        '/admin': (context) => const AdminDashboardScreen(),
        '/admin/login_screen': (context) => const LoginScreen(),
        '/admin/noticias': (context) => const AdminNoticiasScreen(),
        '/admin/plantel/futbol-profesional': (context) => const AdminPlantelProfesionalScreen(),
      },
    );
  }
}


/// ----------------- Wrappers con Drawer -----------------
class NoticiasScreenWithDrawer extends StatelessWidget {
  const NoticiasScreenWithDrawer({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: const NoticiasFutbolProfesionalScreen(),
    );
  }
}


class HistoriaScreenWithDrawer extends StatelessWidget {
  const HistoriaScreenWithDrawer({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: const HistoriaScreen(),
    );
  }
}


