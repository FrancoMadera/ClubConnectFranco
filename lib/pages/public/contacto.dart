import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_club_connect/pages/widget/appmenudrawer.dart';


class ContactoScreen extends StatelessWidget {
  const ContactoScreen({super.key});


  final Color primaryColor = const Color(0xFFB71C1C); // Rojo institucional
  final Color secondaryColor = const Color(0xFF1E88E5); // Azul complementario
  final Color accentColor = const Color(0xFFFFD600); // Amarillo/accento
  final Color backgroundColor = const Color(0xFFF8F9FA);
  final Color textColor = const Color(0xFF212121);


  Future<void> _abrirWhatsApp() async {
    final Uri url = Uri.parse(
        "https://wa.me/+5493492564591?text=Hola,%20quiero%20hacer%20una%20consulta");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('No se pudo abrir WhatsApp');
    }
  }


  Future<void> _hacerLlamada() async {
    final Uri url = Uri.parse("tel:+5493492412393");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('No se pudo hacer la llamada');
    }
  }


  Future<void> _enviarEmail() async {
    final Uri url = Uri.parse(
        "mailto:francomadera8@gmail.com?subject=Consulta%20desde%20la%20App&body=Hola,%20quisiera%20más%20información...");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('No se pudo enviar el email');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Contacto",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppMenuDrawer(),
      body: Column(
        children: [
          // Header con imagen/icono
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.contact_support,
                  size: 60,
                  color: Colors.white.withValues(alpha: 0.9), // ✅ FIX
                ),
                const SizedBox(height: 12),
                const Text(
                  "¿Cómo podemos ayudarte?",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),


          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "Elige tu método de contacto preferido",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),


                  // Tarjetas de contacto
                  _buildContactoCard(
                    icon: FontAwesomeIcons.whatsapp,
                    color: const Color(0xFF25D366),
                    title: "WhatsApp",
                    subtitle: "Chatear instantáneamente",
                    onTap: _abrirWhatsApp,
                  ),
                  const SizedBox(height: 16),
                  _buildContactoCard(
                    icon: Icons.phone,
                    color: secondaryColor,
                    title: "Llamar",
                    subtitle: "Hablar directamente",
                    onTap: _hacerLlamada,
                  ),
                  const SizedBox(height: 16),
                  _buildContactoCard(
                    icon: Icons.email,
                    color: const Color(0xFFEA4335),
                    title: "Correo electrónico",
                    subtitle: "Enviar un mensaje detallado",
                    onTap: _enviarEmail,
                  ),


                  const Spacer(),


                  // Información adicional
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "También nos puedes visitar",
                          style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: primaryColor, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Ayacucho 309",
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                color: primaryColor, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              "Lunes a Viernes: 9:00 - 18:00",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 24),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildContactoCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15), // ✅ FIX
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Divider(color: Colors.grey[300], height: 1),
          const SizedBox(height: 16),
          Text(
            'Club Atlético 9 de Julio',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor),
          ),
          const SizedBox(height: 4),
          Text(
            '© 2025 - Todos los derechos reservados',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


