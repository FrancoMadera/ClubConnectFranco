import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';

class AjustesScreen extends StatefulWidget {
  const AjustesScreen({super.key});

  @override
  _AjustesScreenState createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  bool _notificacionesHabilitadas = true;

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
      body: ListView(
        children: [
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.instagram, color: Colors.purple),
            title: const Text('Instagram del Club'),
            subtitle: const Text('@club9dejuliooficial'),
            onTap: _abrirInstagram,
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Notificaciones'),
            subtitle: const Text('Habilitar o deshabilitar notificaciones del club'),
            value: _notificacionesHabilitadas,
            onChanged: _toggleNotificaciones,
            secondary: const Icon(Icons.notifications_active, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
