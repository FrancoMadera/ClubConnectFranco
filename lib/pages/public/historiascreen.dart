import 'package:flutter/material.dart';


class HistoriaScreen extends StatelessWidget {
  const HistoriaScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C),
        elevation: 4,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        // Mostrar el escudo en el AppBar igual que en NoticiasScreen
        title: Image.asset(
          'images/escudo.jpeg', // misma ruta que en NoticiasScreen
          height: 50,
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      // Drawer copiado de NoticiasScreen, adaptado para que funcione aquí
      drawer: Drawer(
        child: Container(
          color: const Color(0xFFFFFFFF),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFFB71C1C),
                ),
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


              ExpansionTile(
                leading: Icon(Icons.account_balance, color: Colors.red.shade700),
                title: const Text(
                  'Club',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                children: [
                  ListTile(
                    leading: const Icon(Icons.history, size: 20),
                    title: const Text('Historia'),
                    onTap: () {
                      Navigator.pop(context);
                      // Evitar navegar a la misma pantalla
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_on, size: 20),
                    title: const Text('Ubicación'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/ubicacion');
                    },
                  ),
                ],
              ),


              _buildDrawerItem(context, Icons.sports_soccer, 'Fútbol Profesional'),
              _buildDrawerItem(context, Icons.sports_soccer, 'Fútbol Amateur'),
              _buildDrawerItem(context, Icons.sports_soccer, 'Fútbol Femenino'),
              _buildDrawerItem(context, Icons.sports_basketball, 'Básquet'),
              _buildDrawerItem(context, Icons.sports, 'Más Deportes'),
              _buildDrawerItem(context, Icons.article, 'Prensa'),
              _buildDrawerItem(context, Icons.perm_media, 'Multimedia'),
            ],
          ),
        ),
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Escudo centrado igual que en Drawer Header (pero más grande)
            Center(
              child: Image.asset(
                'images/escudo.jpeg', // usar misma ruta
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(height: 16),


            Center(
              child: Text(
                'Club 9 de Julio de Rafaela',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[800],
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),


            _buildSectionTitle('Inicios'),
            _buildSectionText(
              'A principios del siglo XX, más precisamente mediados de 1904 en Rafaela, tres jóvenes de 12 años (Eduardo Tello, Luis Gunzinger y Atilio Scarazzini) fundaron el club “Central Norte”. En 1906 adoptaron el nombre Club 9 de Julio y se establecieron en calle Ayacucho, donde aún funciona la sede social.',
            ),


            _buildSectionTitle('Torneo del Interior'),
            _buildSectionText(
              'Participó desde 1986 con destacadas actuaciones, llegando a ser campeón en 1989-90 y en 1991-92, accediendo al Zonal Noroeste por el ascenso a la B Nacional.',
            ),


            _buildSectionTitle('Argentino B'),
            _buildSectionText(
              'Debutó en la temporada 1997-98, con una destacada participación en el Grupo 2-A de la zona Litoral.',
            ),


            _buildSectionTitle('Ascenso al Argentino A'),
            _buildSectionText(
              'En la temporada 2000-01 logró el campeonato y su primer ascenso al Argentino A, tras una campaña impecable.',
            ),


            _buildSectionTitle('Descensos y retornos'),
            _buildSectionText(
              'Descendió nuevamente al Argentino B en 2003, pero volvió a ascender en 2005 tras vencer a Sp. Belgrano. En el Argentino A mantuvo varias temporadas regulares hasta un nuevo descenso en 2011.',
            ),


            _buildSectionTitle('Federal B y ascenso 2023'),
            _buildSectionText(
              'Tras años en el Federal B, en 2023 consiguió el ascenso al Torneo Federal A tras vencer 3-1 a Camioneros Argentinos del Norte.',
            ),


            const SizedBox(height: 24),
            Center(
              child: Text(
                '¡Orgullo rafaelino desde 1904!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[800],
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }


  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }


  Widget _buildSectionText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, height: 1.5),
      textAlign: TextAlign.justify,
    );
  }


  Widget _buildDrawerItem(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.red.shade700),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navegar a: $title')),
        );
      },
    );
  }
}



