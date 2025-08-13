import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class ContactoScreen extends StatelessWidget {
  const ContactoScreen({super.key});

  Future<void> _abrirWhatsApp() async {
    final Uri url = Uri.parse("https://wa.me/+5493492564591?text=Hola,%20quiero%20hacer%20una%20consulta");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir WhatsApp';
    }
  }

  Future<void> _hacerLlamada() async {
    final Uri url = Uri.parse("tel:+5493492412393");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo hacer la llamada';
    }
  }

  Future<void> _enviarEmail() async {
    final Uri url = Uri.parse(
        "mailto:francomadera8@gmail.com?subject=Consulta%20desde%20la%20App&body=Hola,%20quisiera%20más%20información...");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo enviar el email';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacto Rápido"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
           ListTile(
              leading: Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
              title: const Text("WhatsApp"),
              onTap: _abrirWhatsApp,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.blue),
              title: const Text("Llamar"),
              onTap: _hacerLlamada,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.orange),
              title: const Text("Enviar Email"),
              onTap: _enviarEmail,
            ),
          ],
        ),
      ),
    );
  }
}
