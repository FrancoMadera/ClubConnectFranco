import 'package:cloud_firestore/cloud_firestore.dart';


class Integrante {
  final String id;
  final String nombre;
  final String apellido;
  final String puesto;
  final int edad;
  final DateTime fechaNacimiento;
  final String lugarNacimiento;
  final double altura;
  final String? imagenUrl;


  Integrante({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.puesto,
    required this.edad,
    required this.fechaNacimiento,
    required this.lugarNacimiento,
    required this.altura,
    this.imagenUrl,
  });


  // Método estático para crear un Integrante a partir de un documento Firestore
  factory Integrante.fromDocument(String id, Map<String, dynamic> data) {
    return Integrante(
      id: id,
      nombre: data['nombre'] ?? '',
      apellido: data['apellido'] ?? '',
      puesto: data['puesto'] ?? '',
      edad: (data['edad'] ?? 0) is int ? data['edad'] : int.tryParse(data['edad'].toString()) ?? 0,
      fechaNacimiento: (data['fechaNacimiento'] is Timestamp)
          ? (data['fechaNacimiento'] as Timestamp).toDate()
          : DateTime.tryParse(data['fechaNacimiento'] ?? '') ?? DateTime(1900),
      lugarNacimiento: data['lugarNacimiento'] ?? '',
      altura: (data['altura'] ?? 0.0) is double
          ? data['altura']
          : double.tryParse(data['altura'].toString()) ?? 0.0,
      imagenUrl: data['imagenUrl'],
    );
  }


  // Opcional: Método para convertir a Map (útil para guardar en Firestore)
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'puesto': puesto,
      'edad': edad,
      'fechaNacimiento': Timestamp.fromDate(fechaNacimiento),
      'lugarNacimiento': lugarNacimiento,
      'altura': altura,
      'imagenUrl': imagenUrl ?? '',
    };
  }
}




