import 'package:flutter/material.dart';
import '/utils/styles.dart';
// Importa la pantalla correcta del plantel profesional


import 'package:flutter_club_connect/pages/admin/admin_plantel_profesional_screen.dart';






class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});


  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}


class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C),
        elevation: 4,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Image.asset(
          'images/escudo.jpeg',
          height: 50,
          width: 50,
          fit: BoxFit.contain,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            color: Colors.white,
            onPressed: () {
              setState(() {});
            },
            tooltip: 'Refrescar Datos',
          ),
        ],
      ),
      drawer: _buildAdminDrawer(context),
      body: _buildDashboardBody(),
    );
  }


  Widget _buildAdminDrawer(BuildContext context) {
    final Color redColor = const Color(0xFFB71C1C);


    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: redColor),
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
                  'Admin Club Atlético 9 de Julio',
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


          // Gestión Noticias
          ListTile(
            leading: Icon(Icons.article, color: redColor),
            title: const Text(
              'Gestionar Noticias',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin/noticias');
            },
          ),


          // Gestión Planteles
          ExpansionTile(
            leading: Icon(Icons.sports_soccer, color: redColor),
            title: const Text(
              'Gestionar Planteles',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            children: [
              ListTile(
                contentPadding: const EdgeInsets.only(left: 48, right: 16),
                leading: Icon(Icons.sports_soccer, size: 20),
                title: const Text('Fútbol Profesional'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:  (context) => const AdminPlantelProfesionalScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 48, right: 16),
                leading: Icon(Icons.sports_soccer, size: 20),
                title: const Text('Fútbol Amateur'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/admin/plantel/futbol-amateur');
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 48, right: 16),
                leading: Icon(Icons.sports_soccer, size: 20),
                title: const Text('Fútbol Femenino'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/admin/plantel/futbol-femenino');
                },
              ),
            ],
          ),


          // Configuración general
          ListTile(
            leading: Icon(Icons.settings, color: redColor),
            title: const Text(
              'Configuración',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin/configuracion');
            },
          ),
        ],
      ),
    );
  }


  Widget _buildDashboardBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.admin_panel_settings, size: 100, color: Colors.grey.shade400),
          const SizedBox(height: 20),
          Text(
            'Panel de Administración',
            style: Styles.sectionTitle.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 12),
          Text(
            'Accede a las diferentes secciones para gestionar el contenido del club.',
            textAlign: TextAlign.center,
            style: Styles.newsDate,
          ),
        ],
      ),
    );
  }
}


