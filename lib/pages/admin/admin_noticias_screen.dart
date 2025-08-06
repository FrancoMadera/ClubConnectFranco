
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_club_connect/pages/admin/admin_crear_noticia_screen.dart';
import 'package:flutter_club_connect/pages/admin/admin_editar_noticia_screen.dart';


class AdminNoticiasScreen extends StatelessWidget {
  const AdminNoticiasScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final rojoInstitucional = const Color(0xFFE20613);


    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: rojoInstitucional,
        centerTitle: true,
        elevation: 4,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.manage_search, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Gestión de Noticias',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AdminCrearNoticiaScreen()),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nueva Noticia',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: rojoInstitucional,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('noticias')
            .orderBy('fecha', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }


          if (snapshot.hasError) {
            return const Center(child: Text('❌ Error al cargar las noticias'));
          }


          final docs = snapshot.data!.docs;


          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No hay noticias cargadas.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }


          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final titulo = data['titulo'] as String? ?? 'Sin título';
              final imagenUrl = data['imagenUrl'] as String? ?? '';
              final timestamp = data['fecha'];
              final fecha = timestamp is Timestamp
                  ? DateFormat('dd/MM/yyyy').format(timestamp.toDate())
                  : 'Sin fecha';
              final destacada = data['destacada'] as bool? ?? false;
              final categoria = data['categoria'] as String? ?? '';


              return Container(
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
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: imagenUrl.isNotEmpty
                              ? Image.network(
                                  imagenUrl,
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image, size: 100),
                                )
                              : Container(
                                  width: double.infinity,
                                  height: 180,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported, size: 60),
                                ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'eliminar') {
                              FirebaseFirestore.instance
                                  .collection('noticias')
                                  .doc(docs[index].id)
                                  .delete();
                            } else if (value == 'editar') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AdminEditarNoticiaScreen(
                                    noticiaDoc: docs[index],
                                  ),
                                ),
                              );
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 'editar',
                              child: Text('✏️ Editar'),
                            ),
                            PopupMenuItem(
                              value: 'eliminar',
                              child: Text('🗑️ Eliminar'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (categoria.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                // ignore: deprecated_member_use
                                color: rojoInstitucional.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                categoria.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: rojoInstitucional,
                                ),
                              ),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            titulo,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            fecha,
                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          if (destacada)
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                '🌟 NOTICIA DESTACADA',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
