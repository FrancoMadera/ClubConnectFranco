import 'package:flutter/material.dart';
import 'package:flutter_club_connect/models/noticia.dart';


// 🔴 Import del Drawer reutilizable
import 'package:flutter_club_connect/pages/widget/appmenudrawer.dart';


class DetalleNoticiaScreen extends StatelessWidget {
  final Noticia noticia;


  const DetalleNoticiaScreen({super.key, required this.noticia});


  @override
  Widget build(BuildContext context) {
    final Color rojoInstitucional = const Color(0xFFE20613);


    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: rojoInstitucional,
        centerTitle: true,
        elevation: 4,
        title: Text(
          noticia.titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),


      // 🔹 Aquí agregamos el Drawer
      drawer: const AppMenuDrawer(),


      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    noticia.imagenUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Icon(Icons.image, size: 60, color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(153),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _formatDate(noticia.fecha),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 12),
                  Text(
                    noticia.titulo,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    noticia.contenido,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
}



