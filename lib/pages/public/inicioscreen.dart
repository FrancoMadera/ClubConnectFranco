import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_club_connect/models/noticia.dart';
import 'package:flutter_club_connect/pages/widget/appmenudrawer.dart'; // Drawer centralizado

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  final Color rojoInstitucional = const Color(0xFFE20613);

  // 🔴 Noticias desde Firestore en tiempo real
  Stream<List<Noticia>> _obtenerNoticias() {
    return FirebaseFirestore.instance
        .collection('noticias')
        .orderBy('fecha', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Noticia.fromDocument(doc.id, doc.data()))
              .toList(),
        );
  }

  // 🟢 Widget si no hay noticias
  Widget _buildEmptyWidget() {
    return const Center(
      child: Text(
        'No hay noticias para mostrar',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  // 🟢 Card para una noticia dentro de sección
  Widget _buildSection(String titulo, Noticia noticia) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          // Aquí podrías abrir un detalle de noticia
          debugPrint("Abrir detalle de: ${noticia.titulo}");
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen destacada
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                noticia.imagenUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 180,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image, size: 60),
                ),
              ),
            ),
            // Texto
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    noticia.titulo,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    noticia.fecha.toLocal().toString().split(' ')[0],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: rojoInstitucional,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Club 9 de Julio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const AppMenuDrawer(),
      body: StreamBuilder<List<Noticia>>(
        stream: _obtenerNoticias(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyWidget();
          }

          final noticias = snapshot.data!;

          // Filtrar por categoría
          final institucional = noticias.where((n) => n.categoria == 'Institucional').toList();
          final profesional = noticias.where((n) => n.categoria == 'Fútbol Profesional').toList();
          final femenino = noticias.where((n) => n.categoria == 'Fútbol Femenino').toList();

          // 🔴 SIEMPRE devolver algo
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              if (institucional.isNotEmpty)
                _buildSection("Institucional", institucional.first),
              if (profesional.isNotEmpty)
                _buildSection("Fútbol Profesional", profesional.first),
              if (femenino.isNotEmpty)
                _buildSection("Fútbol Femenino", femenino.first),

              const SizedBox(height: 20),
              Center(
                child: Text(
                  "⚽ Últimas novedades del club",
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade700,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
