import 'package:flutter_club_connect/models/integranteplantel.dart';



abstract class PlantelService {
  Future<List<Integrante>> obtenerJugadores();
  Future<List<Integrante>> obtenerCuerpoTecnico();
}


class PlantelProfesionalService implements PlantelService {
  @override
  Future<List<Integrante>> obtenerJugadores() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Integrante(id: 'p1', nombre: 'Juan Pérez', rol: 'Delantero'),
      Integrante(id: 'p2', nombre: 'Carlos Gómez', rol: 'Defensor'),
      Integrante(id: 'p3', nombre: 'Luis Martínez', rol: 'Mediocampista'),
    ];
  }


  @override
  Future<List<Integrante>> obtenerCuerpoTecnico() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Integrante(id: 't1', nombre: 'Roberto Díaz', rol: 'Entrenador'),
      Integrante(id: 't2', nombre: 'Martín Ruiz', rol: 'Preparador Físico'),
    ];
  }
}


class PlantelAmateurService implements PlantelService {
  @override
  Future<List<Integrante>> obtenerJugadores() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Integrante(id: 'a1', nombre: 'María López', rol: 'Mediocampista'),
      Integrante(id: 'a2', nombre: 'Jorge Martínez', rol: 'Defensor'),
      Integrante(id: 'a3', nombre: 'Ana García', rol: 'Delantera'),
    ];
  }


  @override
  Future<List<Integrante>> obtenerCuerpoTecnico() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Integrante(id: 't3', nombre: 'Laura Fernández', rol: 'Entrenadora'),
      Integrante(id: 't4', nombre: 'Pablo Sánchez', rol: 'Preparador Físico'),
    ];
  }
}


class PlantelFemeninoService implements PlantelService {
  @override
  Future<List<Integrante>> obtenerJugadores() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Integrante(id: 'f1', nombre: 'Sofía Ramírez', rol: 'Delantera'),
      Integrante(id: 'f2', nombre: 'Valeria Gómez', rol: 'Mediocampista'),
      Integrante(id: 'f3', nombre: 'Florencia Díaz', rol: 'Defensora'),
    ];
  }


  @override
  Future<List<Integrante>> obtenerCuerpoTecnico() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Integrante(id: 't5', nombre: 'Marta Pérez', rol: 'Entrenadora'),
      Integrante(id: 't6', nombre: 'Carolina Silva', rol: 'Preparadora Física'),
    ];
  }
}
