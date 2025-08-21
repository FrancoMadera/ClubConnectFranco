import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/integranteplantel.dart';

abstract class PlantelService {
  Future<List<Integrante>> obtenerJugadores();
  Future<List<Integrante>> obtenerCuerpoTecnico();

  Future<void> agregarIntegrante(Integrante integrante);
  Future<void> eliminarIntegrante(String id);
}

class FirebasePlantelService implements PlantelService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirebasePlantelService() {
    _db.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  @override
  Future<List<Integrante>> obtenerJugadores() async {
    return _obtenerIntegrantesPorTipo('jugadores');
  }

  @override
  Future<List<Integrante>> obtenerCuerpoTecnico() async {
    return _obtenerIntegrantesPorTipo('cuerpo_tecnico');
  }

  Future<List<Integrante>> _obtenerIntegrantesPorTipo(String tipo) async {
    try {
      final snapshot = await _db
          .collection('plantel_profesional')
          .where('tipo', isEqualTo: tipo)
          .orderBy('apellido')
          .get(const GetOptions(source: Source.serverAndCache))
          .timeout(const Duration(seconds: 15));

      return snapshot.docs
          .map((doc) {
            try {
              return Integrante.fromDocument(doc.id, doc.data());
            } catch (e) {
              debugPrint('❌ Error al parsear integrante ${doc.id}: $e');
              return null;
            }
          })
          .whereType<Integrante>()
          .toList();
    } on FirebaseException catch (e) {
      debugPrint('🔥 Firestore error: ${e.code} - ${e.message}');
      // Intentar traer de cache
      final cached = await _db
          .collection('plantel_profesional')
          .where('tipo', isEqualTo: tipo)
          .orderBy('apellido')
          .get(const GetOptions(source: Source.cache));

      if (cached.docs.isNotEmpty) {
        return cached.docs
            .map((doc) {
              try {
                return Integrante.fromDocument(doc.id, doc.data());
              } catch (e) {
                debugPrint('❌ Error cacheando integrante ${doc.id}: $e');
                return null;
              }
            })
            .whereType<Integrante>()
            .toList();
      }
      throw Exception(
        'No se pudieron cargar los integrantes. Verifica tu conexión.',
      );
    } catch (e) {
      debugPrint('💥 Error general: $e');
      throw Exception('Error al cargar integrantes');
    }
  }

  @override
  Future<void> agregarIntegrante(Integrante integrante) async {
    try {
      await _db.collection('plantel_profesional').add({
        'nombre': integrante.nombre,
        'apellido': integrante.apellido,
        'puesto': integrante.puesto,
        'edad': integrante.edad,
        'fechaNacimiento': Timestamp.fromDate(integrante.fechaNacimiento),
        'lugarNacimiento': integrante.lugarNacimiento,
        'altura': integrante.altura,
        'imagenUrl': integrante.imagenUrl ?? '',
        'tipo': integrante.puesto.toLowerCase().contains('entrenador') || integrante.puesto.toLowerCase().contains('preparador') ? 'cuerpo_tecnico' : 'jugadores',
        'fechaRegistro': Timestamp.now(),
      });
    } catch (e) {
      debugPrint('Error agregando integrante: $e');
      throw Exception('No se pudo agregar el integrante');
    }
  }

  @override
  Future<void> eliminarIntegrante(String id) async {
    try {
      await _db.collection('plantel_profesional').doc(id).delete();
    } catch (e) {
      debugPrint('Error eliminando integrante $id: $e');
      throw Exception('No se pudo eliminar el integrante');
    }
  }
}