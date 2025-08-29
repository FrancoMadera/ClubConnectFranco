import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_club_connect/pages/public/contacto.dart';
import 'package:flutter_club_connect/pages/public/ajustes.dart';
import 'package:flutter/services.dart';
import 'package:flutter_club_connect/pages/public/inicioscreen.dart'; // <-- Import de InicioScreen


class AppMenuDrawer extends StatefulWidget {
  const AppMenuDrawer({super.key});


  @override
  State<AppMenuDrawer> createState() => _AppMenuDrawerState();
}


class _AppMenuDrawerState extends State<AppMenuDrawer> {
  final Color rojoInstitucional = const Color(0xFFE20613);
  final Color grisOscuro = const Color(0xFF2C2C2C);
  final Color grisClaro = const Color(0xFFF5F5F5);


  int _toquesAdmin = 0;
  bool _loginMostrado = false;
  bool _expandedSobreNosotros = false;
  bool _expandedFutbolProfesional = false;
  bool _expandedFutbolAmateur = false;
  bool _expandedFutbolFemenino = false;


  Future<void> _abrirUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("No se pudo abrir $url");
    }
  }


  void _contarToqueAdmin() {
    if (_loginMostrado) return;


    setState(() {
      _toquesAdmin++;
    });


    if (_toquesAdmin >= 7) {
      _loginMostrado = true;


      if (Scaffold.of(context).isDrawerOpen) {
        Navigator.of(context).pop();
      }


      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        Navigator.pushNamed(context, '/admin/login');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('🔐 Accediendo al modo administrador...'),
            backgroundColor: rojoInstitucional,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: MediaQuery.of(context).size.width * 0.85,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: rojoInstitucional,
              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: rojoInstitucional.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              image: const DecorationImage(
                image: AssetImage('images/escudo.jpeg'),
                fit: BoxFit.cover,
                opacity: 0.15,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: GestureDetector(
                    onTap: _contarToqueAdmin,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Club A. 9 de Julio',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black26,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Primer Club de la Ciudad',
                          style: TextStyle(
                            // ignore: deprecated_member_use
                            color: rojoInstitucional.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (_toquesAdmin > 0 && _toquesAdmin < 7)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${7 - _toquesAdmin} toques más',
                              style: TextStyle(
                                // ignore: deprecated_member_use
                                color: rojoInstitucional.withOpacity(0.7),
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),


          const SizedBox(height: 8),


          // 🔵 Inicio
          _buildDrawerItem(
            icon: Icons.home,
            title: 'Inicio',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const InicioScreen()));
            },
          ),
          const Divider(height: 1, thickness: 0.5),


          // 🔴 Sobre Nosotros
          _buildExpansionTile(
            icon: Icons.info,
            title: 'Sobre Nosotros',
            isExpanded: _expandedSobreNosotros,
            onExpansionChanged: (expanded) {
              setState(() => _expandedSobreNosotros = expanded);
            },
            children: [
              _buildSubItem(
                icon: Icons.account_balance,
                title: 'Historia',
                onTap: () => Navigator.pushNamed(context, '/historia'),
              ),
              _buildSubItem(
                icon: Icons.location_on,
                title: 'Ubicación',
                onTap: () async {
                  await _abrirUrl(
                      "https://www.google.com/maps/place/Club+9+de+Julio/@-31.248152,-61.5003293,17z/data=!3m1!4b1!4m6!3m5!1s0x95caae3c4e30e021:0x56b28c02d1ad0d21!8m2!3d-31.2481566!4d-61.4977544!16s%2Fg%2F11bych7qh6?authuser=0&entry=ttu&g_ep=EgoyMDI1MDgyNS4wIKXMDSoASAFQAw%3D%3Dz");
                },
              ),
              _buildSubItem(
                icon: Icons.contact_page,
                title: 'Contacto',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactoScreen()),
                ),
              ),
            ],
          ),


          const Divider(height: 1, thickness: 0.5),


          // ⚽ Fútbol Profesional
          _buildExpansionTile(
            icon: Icons.sports_soccer,
            title: 'Fútbol Profesional',
            isExpanded: _expandedFutbolProfesional,
            onExpansionChanged: (expanded) {
              setState(() => _expandedFutbolProfesional = expanded);
            },
            children: [
              _buildSubItem(
                icon: Icons.article,
                title: 'Noticias',
                onTap: () => Navigator.pushNamed(context, '/futbol-profesional/noticias'),
              ),
              _buildSubItem(
                icon: Icons.people,
                title: 'Plantel',
                onTap: () => Navigator.pushNamed(context, '/futbol-profesional/plantel'),
              ),
              _buildSubItem(
                icon: Icons.calendar_today,
                title: 'Calendario',
                onTap: () => Navigator.pushNamed(context, '/futbol-profesional/calendario'),
              ),
              _buildSubItem(
                icon: Icons.emoji_events,
                title: 'Resultados',
                onTap: () => Navigator.pushNamed(context, '/futbol-profesional/resultados'),
              ),
            ],
          ),


          const Divider(height: 1, thickness: 0.5),


          // ⚽ Fútbol Amateur
          _buildExpansionTile(
            icon: Icons.sports,
            title: 'Fútbol Amateur',
            isExpanded: _expandedFutbolAmateur,
            onExpansionChanged: (expanded) {
              setState(() => _expandedFutbolAmateur = expanded);
            },
            children: [
              _buildSubItem(
                icon: Icons.article,
                title: 'Noticias',
                onTap: () => Navigator.pushNamed(context, '/futbol-amateur/noticias'),
              ),
              _buildSubItem(
                icon: Icons.people,
                title: 'Planteles',
                onTap: () => Navigator.pushNamed(context, '/futbol-amateur/plantel'),
              ),
              _buildSubItem(
                icon: Icons.calendar_today,
                title: 'Calendario',
                onTap: () => Navigator.pushNamed(context, '/futbol-amateur/calendario'),
              ),
            ],
          ),


          const Divider(height: 1, thickness: 0.5),


          // ⚽ Fútbol Femenino
          _buildExpansionTile(
            icon: Icons.female,
            title: 'Fútbol Femenino',
            isExpanded: _expandedFutbolFemenino,
            onExpansionChanged: (expanded) {
              setState(() => _expandedFutbolFemenino = expanded);
            },
            children: [
              _buildSubItem(
                icon: Icons.article,
                title: 'Noticias',
                onTap: () => Navigator.pushNamed(context, '/futbol-femenino/noticias'),
              ),
              _buildSubItem(
                icon: Icons.people,
                title: 'Plantel',
                onTap: () => Navigator.pushNamed(context, '/futbol-femenino/plantel'),
              ),
              _buildSubItem(
                icon: Icons.calendar_today,
                title: 'Calendario',
                onTap: () => Navigator.pushNamed(context, '/futbol-femenino/calendario'),
              ),
            ],
          ),


          const Divider(height: 1, thickness: 0.5),


        /*  // 🎥 Multimedia
          _buildDrawerItem(
            icon: Icons.photo_library,
            title: 'Multimedia',
            onTap: () => Navigator.pushNamed(context, '/multimedia'),
          ),*/


          const Divider(height: 1, thickness: 0.5),


          // 🛒 Tienda -> Instagram
          _buildDrawerItem(
            icon: Icons.shopping_cart,
            title: 'Tienda Oficial',
            onTap: () async {
              await _abrirUrl("https://www.instagram.com/tienda.del.leon/");
            },
          ),


          const Divider(height: 1, thickness: 0.5),


          // ⚙ Ajustes
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Ajustes',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AjustesScreen()),
            ),
          ),


          const Divider(height: 1, thickness: 0.5),


          // 🚪 Cerrar App
          _buildDrawerItem(
            icon: Icons.exit_to_app,
            title: 'Cerrar App',
            // ignore: deprecated_member_use
            color: rojoInstitucional.withOpacity(0.8),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('¿Cerrar aplicación?', style: TextStyle(fontWeight: FontWeight.bold)),
                  content: const Text('¿Estás seguro de que quieres salir de la aplicación?'),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => SystemNavigator.pop(),
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
              );
            },
          ),


          const SizedBox(height: 20),


          // Footer
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'v1.2.0 • Club 9 de Julio © 2025',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? rojoInstitucional, size: 24),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color ?? grisOscuro)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      minLeadingWidth: 24,
    );
  }


  Widget _buildSubItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      // ignore: deprecated_member_use
      leading: Icon(icon, color: rojoInstitucional.withOpacity(0.7), size: 20),
      // ignore: deprecated_member_use
      title: Text(title, style: TextStyle(fontSize: 14, color: grisOscuro.withOpacity(0.8))),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 36, vertical: 2),
      minLeadingWidth: 24,
      dense: true,
    );
  }


  Widget _buildExpansionTile({
    required IconData icon,
    required String title,
    required bool isExpanded,
    required Function(bool) onExpansionChanged,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      leading: Icon(icon, color: rojoInstitucional, size: 24),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: rojoInstitucional),
      onExpansionChanged: onExpansionChanged,
      initiallyExpanded: isExpanded,
      childrenPadding: const EdgeInsets.only(left: 16, bottom: 8),
      tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      collapsedBackgroundColor: Colors.transparent,
      backgroundColor: grisClaro,
      shape: const RoundedRectangleBorder(),
      collapsedShape: const RoundedRectangleBorder(),
      children: children,
    );
  }
}
