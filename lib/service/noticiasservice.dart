import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // Para debugPrint
import '../models/noticia.dart';


/// Interfaz base que comparten ambas implementaciones
abstract class NoticiasService {
  Future<List<Noticia>> obtenerNoticias();
  Future<void> eliminarNoticia(String id);  // Método agregado
}


/// 🔥 Implementación real que trae las noticias desde Firebase Firestore
class FirebaseNoticiasService implements NoticiasService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  FirebaseNoticiasService() {
    // Configuración de persistencia (nueva forma)
    _db.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }


  @override
  Future<List<Noticia>> obtenerNoticias() async {
    try {
      final snapshot = await _db
          .collection('noticias')
          .orderBy('fecha', descending: true)
          .get(const GetOptions(source: Source.serverAndCache))
          .timeout(const Duration(seconds: 15));


      return snapshot.docs
          .map((doc) {
            try {
              return Noticia.fromDocument(doc.id, doc.data());
            } catch (e) {
              debugPrint('❌ Error al parsear noticia con id ${doc.id}: $e');
              return null;
            }
          })
          .whereType<Noticia>()
          .toList(); // Filtra nulls
    } on FirebaseException catch (e) {
      debugPrint('🔥 Firestore error: ${e.code} - ${e.message}');


      final cached = await _db
          .collection('noticias')
          .orderBy('fecha', descending: true)
          .get(const GetOptions(source: Source.cache));


      if (cached.docs.isNotEmpty) {
        return cached.docs
            .map((doc) {
              try {
                return Noticia.fromDocument(doc.id, doc.data());
              } catch (e) {
                debugPrint('❌ Error cacheando noticia ${doc.id}: $e');
                return null;
              }
            })
            .whereType<Noticia>()
            .toList();
      }


      throw Exception(
        'No se pudieron cargar las noticias. Verifica tu conexión.',
      );
    } catch (e) {
      debugPrint('💥 Error general: $e');
      throw Exception('Error al cargar noticias');
    }
  }


  @override
  Future<void> eliminarNoticia(String id) async {
    try {
      await _db.collection('noticias').doc(id).delete();
    } catch (e) {
      debugPrint('Error eliminando noticia $id: $e');
      throw Exception('No se pudo eliminar la noticia.');
    }
  }
}












