import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_club_connect/pages/widget/appmenudrawer.dart';


/// Pantalla de Ajustes de la app
class AjustesScreen extends StatefulWidget {
  const AjustesScreen({super.key});


  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}


/// Estado de la pantalla de Ajustes
class _AjustesScreenState extends State<AjustesScreen> {
  bool _notificacionesHabilitadas = true;


  // Colores institucionales
  final Color primaryColor = const Color(0xFFB71C1C);
  final Color secondaryColor = const Color(0xFF1E88E5);
  final Color accentColor = const Color(0xFFFFD600);
  final Color backgroundColor = const Color(0xFFF8F9FA);
  final Color cardColor = const Color(0xFFFFFFFF);
  final Color textColor = const Color(0xFF212121);


  /// Compartir la app con otras personas
  void _compartirApp() {
    Share.share(
      'Descargá la app oficial del Club 9 de Julio 📲\nhttps://play.google.com/store/apps/details?id=tu.paquete.aqui',
      subject: 'Club 9 de Julio - App Oficial',
    );
  }


  /// Abrir Instagram del club en aplicación externa
  Future<void> _abrirInstagram() async {
    final uri = Uri.parse('https://www.instagram.com/club9dejuliooficial/');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('No se pudo abrir Instagram');
    }
  }


  /// Habilitar o deshabilitar notificaciones del club
  void _toggleNotificaciones(bool valor) async {
    setState(() {
      _notificacionesHabilitadas = valor;
    });


    if (valor) {
      await FirebaseMessaging.instance.subscribeToTopic('noticias');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Notificaciones activadas',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic('noticias');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Notificaciones desactivadas',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.grey[700],
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Ajustes', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppMenuDrawer(),
      body: Column(
        children: [
          // Header con icono
          Container(
            height: 120,
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
                // ignore: deprecated_member_use
                Icon(Icons.settings, size: 40, color: Colors.white.withOpacity(0.9)),
                const SizedBox(height: 8),
                const Text(
                  "Personaliza tu experiencia",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),


          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const SizedBox(height: 16),


                  // Sección de redes sociales
                  Text(
                    "REDES SOCIALES",
                    style: TextStyle(
                        // ignore: deprecated_member_use
                        color: textColor.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 8),
                  _buildInstagramCard(),
                  const SizedBox(height: 24),


                  // Sección de preferencias
                  Text(
                    "PREFERENCIAS",
                    style: TextStyle(
                        // ignore: deprecated_member_use
                        color: textColor.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 8),
                  _buildNotificacionesCard(),
                  const SizedBox(height: 16),
                  _buildCompartirCard(),
                  const SizedBox(height: 24),


                  // Sección de información
                  Text(
                    "INFORMACIÓN",
                    style: TextStyle(
                        // ignore: deprecated_member_use
                        color: textColor.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 8),
                  _buildHorariosCard(),
                ],
              ),
            ),
          ),


          _buildFooter(),
        ],
      ),
    );
  }


  /// Tarjeta para Instagram
  Widget _buildInstagramCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: _abrirInstagram,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: const Color(0xFFE1306C).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(FontAwesomeIcons.instagram, color: Color(0xFFE1306C), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Síguenos en Instagram",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@club9dejuliooficial',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }


  /// Tarjeta para notificaciones
  Widget _buildNotificacionesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: primaryColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.notifications_active, color: primaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Notificaciones",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Recibir novedades del club',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Switch(
              value: _notificacionesHabilitadas,
              onChanged: _toggleNotificaciones,
              thumbColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return primaryColor;
                  }
                  return null; // color por defecto cuando está apagado
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  /// Tarjeta para compartir la app
  Widget _buildCompartirCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: _compartirApp,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: secondaryColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.share, color: secondaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Compartir la app",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Invita a otros socios a descargarla',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }


  /// Card con horarios de atención
  Widget _buildHorariosCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time, color: primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Horarios de Atención',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildHorarioItem('Lunes a Viernes', '8:00 - 20:00'),
            _buildHorarioItem('Sábados', 'Cerrado'),
            _buildHorarioItem('Domingos', 'Cerrado'),
          ],
        ),
      ),
    );
  }


  Widget _buildHorarioItem(String dia, String horario) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dia,
            // ignore: deprecated_member_use
            style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.8)),
          ),
          Text(
            horario,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: horario == 'Cerrado' ? Colors.grey[500] : primaryColor),
          ),
        ],
      ),
    );
  }


  /// Footer con derechos de autor
  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Column(
        children: [
          Text(
            'Club Atlético 9 de Julio',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
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
