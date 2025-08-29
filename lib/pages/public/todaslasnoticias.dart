import 'package:flutter/material.dart';
import 'package:flutter_club_connect/models/noticia.dart';
import 'package:flutter_club_connect/service/noticiasservice.dart';
import 'noticia/detallenoticia.dart';
import '/utils/styles.dart';

class TodasNoticiasScreen extends StatefulWidget {
  const TodasNoticiasScreen({super.key});

  @override
  State<TodasNoticiasScreen> createState() => _TodasNoticiasScreenState();
}

class _TodasNoticiasScreenState extends State<TodasNoticiasScreen> {
  final NoticiasService _noticiasService = FirebaseNoticiasService();
  late Future<List<Noticia>> _noticiasFuture;

  @override
  void initState() {
    super.initState();
    _noticiasFuture = _noticiasService.obtenerNoticias();
  }

  Future<void> _refreshNews() async {
    setState(() {
      _noticiasFuture = _noticiasService.obtenerNoticias();
    });
    await _noticiasFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Todas las Noticias",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFB71C1C),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Noticia>>(
        future: _noticiasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final noticias = snapshot.data ?? [];
          if (noticias.isEmpty) {
            return const Center(child: Text("No hay noticias disponibles"));
          }

          return RefreshIndicator(
            onRefresh: _refreshNews,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: noticias.length,
              itemBuilder: (context, index) {
                final noticia = noticias[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DetalleNoticiaScreen(noticia: noticia),
                      ),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: Image.network(
                            noticia.imagenUrl,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image, size: 80),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (noticia.categoria != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    noticia.categoria!.toUpperCase(),
                                    style: Styles.sectionTitle
                                        .copyWith(fontSize: 12),
                                  ),
                                ),
                              const SizedBox(height: 6),
                              Text(
                                noticia.titulo,
                                style: Styles.newsTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${noticia.fecha.day}/${noticia.fecha.month}/${noticia.fecha.year}',
                                    style: Styles.newsDate,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
