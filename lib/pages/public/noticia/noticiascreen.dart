import 'package:flutter/material.dart';
import 'package:flutter_club_connect/service/noticiasservice.dart';
import 'package:flutter_club_connect/models/noticia.dart';
import 'package:flutter_club_connect/pages/public/noticia/detallenoticia.dart';
import 'package:flutter_club_connect/pages/widget/appmenudrawer.dart'; // <- Import del Drawer


/// Pantalla principal para mostrar las noticias disponibles.
class NoticiasScreen extends StatefulWidget {
  const NoticiasScreen({super.key});


  @override
  State<NoticiasScreen> createState() => _NoticiasScreenState();
}


class _NoticiasScreenState extends State<NoticiasScreen> {
  // Instancia del servicio de noticias, puede ser reemplazada por otra implementación si se desea.
  final NoticiasService _noticiasService = FirebaseNoticiasService();


  // Variable que representa el futuro de las noticias a obtener.
  late Future<List<Noticia>> _noticiasFuture;


  // Color institucional del club usado para elementos UI.
  final Color rojoInstitucional = const Color(0xFFE20613);


  // Variables de control para activar el modo admin con múltiples toques.
  int _toquesAdmin = 0;
  bool _loginMostrado = false;


  @override
  void initState() {
    super.initState();
    // Cargamos las noticias al inicializar la pantalla.
    _noticiasFuture = _loadNoticias();
  }


  /// Obtiene las noticias desde el servicio.
  Future<List<Noticia>> _loadNoticias() async {
    return _noticiasService.obtenerNoticias();
  }


  /// Refresca la lista de noticias manualmente y cuenta los toques para activar el modo admin.
  Future<void> _refreshNews() async {
    _contarToqueAdmin(); // También suma toques desde el botón de refrescar.


    setState(() {
      _noticiasFuture = _loadNoticias();
    });


    await _noticiasFuture;
  }


  /// Lógica para activar modo admin después de 9 toques.
  void _contarToqueAdmin() {
    if (_loginMostrado) return;


    setState(() {
      _toquesAdmin++;
    });


    if (_toquesAdmin >= 9) {
      _loginMostrado = true;


      // Si el drawer está abierto, lo cerramos antes de navegar.
      if (Scaffold.of(context).isDrawerOpen) {
        Navigator.of(context).pop();
      }


      // Esperamos un poco antes de navegar para evitar conflictos visuales.
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        Navigator.pushNamed(context, '/admin/login');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('🔐 Accediendo al modo administrador...'),
            backgroundColor: rojoInstitucional,
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: rojoInstitucional,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),


        // Logo del club con detección de toques ocultos.
        title: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: GestureDetector(
            onTap: _contarToqueAdmin,
            child: Image.asset(
              'images/escudo.jpeg',
              height: 45,
              width: 45,
              fit: BoxFit.cover,
            ),
          ),
        ),


        actions: [
          // Botón de refrescar noticias manualmente.
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshNews,
            tooltip: 'Refrescar Noticias',
            color: Colors.white,
          ),
        ],
      ),


      drawer: const AppMenuDrawer(), // <- Drawer agregado


      // Contenido principal: lista de noticias
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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: noticias.length,
              itemBuilder: (context, index) =>
                  _buildNewsCard(noticias[index]),
            ),
          );
        },
      ),
    );
  }


  /// Construye una tarjeta individual de noticia.
  Widget _buildNewsCard(Noticia noticia) {
    return GestureDetector(
      onTap: () => _navigateToDetail(noticia),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de la noticia
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.network(
                noticia.imagenUrl,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 100),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Etiqueta de categoría si existe
                  if (noticia.categoria != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: rojoInstitucional.withAlpha(26),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        noticia.categoria!.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: rojoInstitucional,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  // Título de la noticia
                  Text(
                    noticia.titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Fecha formateada
                  Text(
                    '${noticia.fecha.day}/${noticia.fecha.month}/${noticia.fecha.year}',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  /// Navega a la pantalla de detalle de noticia.
  void _navigateToDetail(Noticia noticia) {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleNoticiaScreen(noticia: noticia),
      ),
    );
  }


  /// Widget mostrado si no hay noticias.
  Widget _buildEmptyWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.article_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No hay noticias disponibles', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }


  /// Widget mostrado si ocurre un error al obtener noticias.
  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Error al cargar noticias'),
          Text(error, style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}



