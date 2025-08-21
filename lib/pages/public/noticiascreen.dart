import 'package:flutter/material.dart';
import 'package:flutter_club_connect/service/noticiasservice.dart';
import 'package:flutter_club_connect/models/noticia.dart';
import 'package:flutter_club_connect/pages/public/detallenoticia.dart';
import '/utils/styles.dart';
import 'package:flutter_club_connect/pages/widget/appmenudrawer.dart';  //  Drawer centralizado

class NoticiasScreen extends StatefulWidget {
  const NoticiasScreen({super.key});

  @override
  State<NoticiasScreen> createState() => _NoticiasScreenState();
}

class _NoticiasScreenState extends State<NoticiasScreen> {
  final NoticiasService _noticiasService = FirebaseNoticiasService();
  late Future<List<Noticia>> _noticiasFuture;

  @override
  void initState() {
    super.initState();
    _noticiasFuture = _loadNoticias();
  }

  Future<List<Noticia>> _loadNoticias() async {
    return _noticiasService.obtenerNoticias();
  }

  Future<void> _refreshNews() async {
    setState(() {
      _noticiasFuture = _loadNoticias();
    });
    await _noticiasFuture;
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
            onPressed: _refreshNews,
            tooltip: 'Refrescar Noticias',
          ),
        ],
      ),

      /// 🔴 Usamos el Drawer centralizado
      drawer: const AppMenuDrawer(),

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

          return RefreshIndicator(
            onRefresh: _refreshNews,
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _buildHeroNews(noticias.first), // 🟢 Noticia destacada
                // ignore: unnecessary_to_list_in_spreads
                ...noticias.skip(1).map(_buildNewsCard).toList(), // 🔴 Secundarias
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/todas-las-noticias');
                    },
                    child: const Text(
                      "Ver más noticias",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 🔥 Noticia destacada tipo banner
  Widget _buildHeroNews(Noticia noticia) {
    return GestureDetector(
      onTap: () => _navigateToDetail(noticia),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(noticia.imagenUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              // ignore: deprecated_member_use
              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          padding: const EdgeInsets.all(16),
          alignment: Alignment.bottomLeft,
          child: Text(
            noticia.titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  /// 🔴 Noticias secundarias
  Widget _buildNewsCard(Noticia noticia) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToDetail(noticia),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                noticia.imagenUrl,
                height: 160,
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
                        style: Styles.sectionTitle.copyWith(fontSize: 12),
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
                      const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
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
  }

  void _navigateToDetail(Noticia noticia) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleNoticiaScreen(noticia: noticia),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.article_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text('No hay noticias disponibles', style: Styles.newsDate),
          TextButton(onPressed: _refreshNews, child: const Text('Reintentar')),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
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
}
