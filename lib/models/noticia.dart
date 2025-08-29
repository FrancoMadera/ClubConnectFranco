import 'package:cloud_firestore/cloud_firestore.dart';




class Noticia {
  final String id;
  final String titulo;
  final String imagenUrl;
  final DateTime fecha;
  final String contenido;
  final String? categoria;








  Noticia({
    required this.id,
    required this.titulo,
    required this.imagenUrl,
    required this.fecha,
    required this.contenido,
    this.categoria,
  });








  factory Noticia.fromDocument(String id, Map<String, dynamic> json) {
  return Noticia(
    id: id,
    titulo: json['titulo'] ?? 'Sin título',
    imagenUrl: json['imagenUrl'] ?? '',
    fecha: (json['fecha'] as Timestamp?)?.toDate() ?? DateTime.now(),
    contenido: json['contenido'] ?? '',
    categoria: json['categoria'],
  );
}
}


