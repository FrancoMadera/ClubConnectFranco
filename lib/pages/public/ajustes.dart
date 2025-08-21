import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class AjustesScreen extends StatefulWidget {
  const AjustesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AjustesScreenState createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  bool _notificacionesHabilitadas = true;

  // 📤 Compartir la app
  void _compartirApp() {
    Share.share(
      'Descargá la app oficial del Club 9 de Julio 📲\nhttps://play.google.com/store/apps/details?id=tu.paquete.aqui',
      subject: 'Club 9 de Julio - App Oficial',
    );
  }

  Future<void> _abrirInstagram() async {
    final uri = Uri.parse('https://www.instagram.com/club9dejuliooficial/');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('No se pudo abrir Instagram');
    }
  }

  void _toggleNotificaciones(bool valor) async {
    setState(() {
      _notificacionesHabilitadas = valor;
    });

    if (valor) {
      // Suscribirse al topic "noticias"
      await FirebaseMessaging.instance.subscribeToTopic('noticias');
    } else {
      // Cancelar suscripción
      await FirebaseMessaging.instance.unsubscribeFromTopic('noticias');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const FaIcon(
                    FontAwesomeIcons.instagram,
                    color: Colors.purple,
                  ),
                  title: const Text('Instagram del Club'),
                  subtitle: const Text('@club9dejuliooficial'),
                  onTap: _abrirInstagram,
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Notificaciones'),
                  subtitle: const Text(
                    'Habilitar o deshabilitar notificaciones del club',
                  ),
                  value: _notificacionesHabilitadas,
                  onChanged: _toggleNotificaciones,
                  secondary: const Icon(
                    Icons.notifications_active,
                    color: Colors.red,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Compartir la app'),
                  onTap: _compartirApp,
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: Colors.grey[100],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Horarios de Atención',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Lunes a Viernes: 8:00 - 20:00'),
                          Text('Sábados: Cerrado'),
                          Text('Domingos: Cerrado'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                '© 2025 Club Atlético 9 de Julio - Todos los derechos reservados',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
