import 'package:flutter/material.dart';
import 'package:flutter_club_connect/service/noticiasservice.dart';
import 'package:flutter_club_connect/models/noticia.dart';
import 'package:flutter_club_connect/pages/public/noticia/detallenoticia.dart';
import '/utils/styles.dart';
import 'package:flutter_club_connect/pages/widget/appmenudrawer.dart'; // Drawer institucional


class NoticiasFutbolFemeninoScreen extends StatefulWidget {
  const NoticiasFutbolFemeninoScreen({super.key});


  @override
  State<NoticiasFutbolFemeninoScreen> createState() =>
      _NoticiasFutbolFemeninoScreenState();
}


class _NoticiasFutbolFemeninoScreenState extends State<NoticiasFutbolFemeninoScreen> {
  // Servicio para obtener noticias desde Firestore
  final NoticiasService _noticiasService = FirebaseNoticiasService();


  // Future que contendrá la lista de noticias filtradas
  late Future<List<Noticia>> _noticiasFuture;


  @override
  void initState() {
    super.initState();
    _noticiasFuture = _obtenerNoticiasFutbolFemenino();
  }


  /// Método para obtener únicamente las noticias de "Fútbol Femenino"
  Future<List<Noticia>> _obtenerNoticiasFutbolFemenino() async {
    final todas = await _noticiasService.obtenerNoticias();
    // Filtrar solo las noticias con categoria 'Fútbol Femenino' (insensible a mayúsculas/minúsculas)
    return todas.where((n) =>
        (n.categoria ?? '').toLowerCase() == 'fútbol femenino'.toLowerCase()
    ).toList();
  }


  /// Método para refrescar la lista de noticias
  void _refreshNews() {
    setState(() {
      _noticiasFuture = _obtenerNoticiasFutbolFemenino();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C),
        elevation: 4,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Noticias - Fútbol Femenino',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshNews,
          ),
        ],
      ),
      drawer: const AppMenuDrawer(), // Drawer institucional
      body: FutureBuilder<List<Noticia>>(
        future: _noticiasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error.toString());
          }
          final noticias = snapshot.data ?? [];
          if (noticias.isEmpty) return _buildEmptyWidget();
          return _buildNewsList(noticias);
        },
      ),
    );
  }


  /// Construye la lista de noticias
  Widget _buildNewsList(List<Noticia> noticias) {
    return RefreshIndicator(
      onRefresh: () async => _refreshNews(),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: noticias.length,
        itemBuilder: (context, index) => _buildNewsCard(noticias[index]),
      ),
    );
  }


  /// Construye cada tarjeta individual de noticia
  Widget _buildNewsCard(Noticia noticia) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _navigateToDetail(noticia),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Imagen de la noticia con placeholder por si falla
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  noticia.imagenUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 80),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      noticia.titulo,
                      style: Styles.newsTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${noticia.fecha.day}/${noticia.fecha.month}/${noticia.fecha.year}',
                      style: Styles.newsDate,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  /// Navega a la pantalla de detalle de noticia
  void _navigateToDetail(Noticia noticia) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleNoticiaScreen(noticia: noticia),
      ),
    );
  }


  /// Widget cuando no hay noticias disponibles
  Widget _buildEmptyWidget() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.article_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('No hay noticias de fútbol femenino', style: Styles.newsDate),
            TextButton(onPressed: _refreshNews, child: const Text('Reintentar')),
          ],
        ),
      );


  /// Widget cuando ocurre un error al cargar noticias
  Widget _buildErrorWidget(String error) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Error al cargar noticias'),
            Text(error, style: const TextStyle(color: Colors.red)),
            TextButton(onPressed: _refreshNews, child: const Text('Reintentar')),
          ],
        ),
      );
}



