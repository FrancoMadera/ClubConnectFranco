import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_club_connect/models/integranteplantel.dart';
import 'package:flutter_club_connect/pages/widget/appmenudrawer.dart';


/// Pantalla que muestra los detalles de un integrante (jugador o técnico)
class DetallesIntegranteScreen extends StatelessWidget {
  final Integrante integrante;
  final bool esJugador;


  const DetallesIntegranteScreen({
    super.key,
    required this.integrante,
    required this.esJugador,
  });


  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
   
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C),
        title: Text('${integrante.nombre} ${integrante.apellido}'),
      ),
      drawer: const AppMenuDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'integrante-${integrante.id}',
              child: _buildFotoIntegrante(),
            ),
            const SizedBox(height: 20),
            Text(
              '${integrante.nombre} ${integrante.apellido}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              integrante.puesto,
              style: TextStyle(
                fontSize: 18,
                color: const Color(0xFFB71C1C), // Color institucional sin withOpacity
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
            _buildInfoCard(
              title: 'Información Básica',
              children: [
                _buildInfoItem('Edad', '${integrante.edad} años'),
                _buildInfoItem('Nacimiento',
                  '${dateFormat.format(integrante.fechaNacimiento)}\n${integrante.lugarNacimiento}'),
                if (esJugador) _buildInfoItem('Altura', '${integrante.altura.toStringAsFixed(2)} m'),
              ],
            ),
            if (esJugador) _buildInfoJugador(),
            if (!esJugador) _buildInfoTecnico(),
          ],
        ),
      ),
    );
  }


  /// Foto del integrante con borde circular y sombra
  Widget _buildFotoIntegrante() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFB71C1C), width: 3),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.1), // Opacidad segura
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipOval(
        child: integrante.imagenUrl != null
            ? Image.network(
                integrante.imagenUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              )
            : _buildPlaceholderImage(),
      ),
    );
  }


  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
              ),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }


  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }


  /// Información adicional para jugadores (estadísticas)
  Widget _buildInfoJugador() {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('jugadores_stats')
          .doc(integrante.id)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }


        final stats = snapshot.data?.data() as Map<String, dynamic>? ?? {};


        return _buildInfoCard(
          title: 'Estadísticas',
          children: [
            _buildInfoItem('Partidos jugados', stats['partidos']?.toString() ?? '0'),
            _buildInfoItem('Goles', stats['goles']?.toString() ?? '0'),
            _buildInfoItem('Asistencias', stats['asistencias']?.toString() ?? '0'),
            _buildInfoItem('Amarillas', stats['amarillas']?.toString() ?? '0'),
            _buildInfoItem('Rojas', stats['rojas']?.toString() ?? '0'),
          ],
        );
      },
    );
  }


  /// Información adicional para técnicos
  Widget _buildInfoTecnico() {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('tecnicos_stats')
          .doc(integrante.id)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }


        final stats = snapshot.data?.data() as Map<String, dynamic>? ?? {};


        return _buildInfoCard(
          title: 'Información Técnica',
          children: [
            _buildInfoItem('Experiencia', '${stats['experiencia'] ?? '0'} años'),
            _buildInfoItem('Títulos ganados', stats['titulos']?.toString() ?? '0'),
            _buildInfoItem('Especialidad', stats['especialidad']?.toString() ?? integrante.puesto),
          ],
        );
      },
    );
  }


  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.person,
          size: 60,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
