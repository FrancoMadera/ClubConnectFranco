import 'package:flutter/material.dart';
import 'package:flutter_club_connect/pages/widget/appmenudrawer.dart'; 

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
        title: Column(
          children: [
            Image.asset(
              'images/escudo.jpeg', // ⚠️ Asegurate que esté bien en pubspec.yaml
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 4),
            const Text(
              "Club 9 de Julio",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),

      /// 🔴 Drawer centralizado con todas las secciones
      drawer: const AppMenuDrawer(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Escudo principal
            Center(
              child: Image.asset(
                'images/escudo.jpeg',
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(height: 16),

            Center(
              child: Text(
                'Historia del Club',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[800],
                    ),
              ),
            ),
            const SizedBox(height: 24),

            // 🔴 Secciones en tarjetas
            _buildSectionCard(
              'Inicios',
              'A principios del siglo XX, más precisamente mediados de 1904 en Rafaela, tres jóvenes de 12 años (Eduardo Tello, Luis Gunzinger y Atilio Scarazzini) fundaron el club “Central Norte”. En 1906 adoptaron el nombre Club 9 de Julio y se establecieron en calle Ayacucho, donde aún funciona la sede social.',
            ),
            _buildSectionCard(
              'Torneo del Interior',
              'Participó desde 1986 con destacadas actuaciones, llegando a ser campeón en 1989-90 y en 1991-92, accediendo al Zonal Noroeste por el ascenso a la B Nacional.',
            ),
            _buildSectionCard(
              'Argentino B',
              'Debutó en la temporada 1997-98, con una destacada participación en el Grupo 2-A de la zona Litoral.',
            ),
            _buildSectionCard(
              'Ascenso al Argentino A',
              'En la temporada 2000-01 logró el campeonato y su primer ascenso al Argentino A, tras una campaña impecable.',
            ),
            _buildSectionCard(
              'Descensos y retornos',
              'Descendió nuevamente al Argentino B en 2003, pero volvió a ascender en 2005 tras vencer a Sp. Belgrano. En el Argentino A mantuvo varias temporadas regulares hasta un nuevo descenso en 2011.',
            ),
            _buildSectionCard(
              'Federal B y ascenso 2023',
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
          ],
        ),
      ),
    );
  }
  

  // 🟢 Widget auxiliar para cada sección en Card
  Widget _buildSectionCard(String title, String text) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
