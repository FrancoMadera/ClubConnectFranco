import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class AppMenuDrawer extends StatelessWidget {
  const AppMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final Color rojoInstitucional = const Color(0xFFE20613);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: rojoInstitucional),
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
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),

          /// 🔴 Grupo Club
          ExpansionTile(
            leading: const Icon(Icons.account_balance, color: Color.fromRGBO(244, 67, 54, 1)),
            title: const Text("Club"),
            children: [
              _buildDrawerItem(
                context,
                Icons.history,
                "Historia",
                () => Navigator.pushNamed(context, "/historia"),
              ),
              _buildDrawerItem(
                context,
                Icons.location_on,
                "Ubicación",
                () async {
                  final url = Uri.parse("https://www.google.com/maps/place/Club+9+de+Julio/@-31.248152,-61.5003293,17z/data=!3m1!4b1!4m6!3m5!1s0x95caae3c4e30e021:0x56b28c02d1ad0d21!8m2!3d-31.2481566!4d-61.4977544!16s%2Fg%2F11bych7qh6?authuser=0&entry=ttu&g_ep=EgoyMDI1MDgxOC4wIKXMDSoASAFQAw%3D%3D");
                  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                    debugPrint("No se pudo abrir Google Maps");
                  }
                },
              ),
            ],
          ),

          /// ⚽ Grupo Fútbol con subcarpetas
          ExpansionTile(
            leading: const Icon(Icons.sports_soccer, color: Color.fromRGBO(244, 67, 54, 1)),
            title: const Text("Fútbol"),
            children: [
              _buildSubFutbol(
                context,
                "Profesional",
                "/futbol-profesional",
              ),
              _buildSubFutbol(
                context,
                "Amateur",
                "/futbol-amateur",
              ),
              _buildSubFutbol(
                context,
                "Femenino",
                "/futbol-femenino",
              ),
            ],
          ),

          ///  Contacto
          _buildDrawerItem(
            context,
            Icons.contact_phone,
            "Contacto",
            () => Navigator.pushNamed(context, "/contacto"),
          ),

          ///  Ajustes
          _buildDrawerItem(
            context,
            Icons.settings,
            "Ajustes",
            () => Navigator.pushNamed(context, "/ajustes"),
          ),

          /// 🚪 Cerrar App
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Cerrar App'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('¡Gracias!'),
                    content: const Text(
                      'Gracias por usar la app oficial del Club. ¡Te esperamos pronto!',
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text('Cerrar App'),
                        onPressed: () => SystemNavigator.pop(),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// Ítem genérico del drawer
  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  /// Submenú de cada sección de Fútbol
  Widget _buildSubFutbol(BuildContext context, String title, String baseRoute) {
    return ExpansionTile(
      leading: const Icon(Icons.sports),
      title: Text(title),
      children: [
        _buildDrawerItem(
          context,
          Icons.article,
          "Noticias",
          () => Navigator.pushNamed(context, "$baseRoute/noticias"),
        ),
        _buildDrawerItem(
          context,
          Icons.people,
          "Plantel",
          () => Navigator.pushNamed(context, "$baseRoute/plantel"),
        ),
      ],
    );
  }
}
