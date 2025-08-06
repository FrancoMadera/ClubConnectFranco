import 'package:flutter/material.dart';


class PlantelYCuerpoTecnicoFutbolAmateurScreen extends StatelessWidget {
  const PlantelYCuerpoTecnicoFutbolAmateurScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantel y Cuerpo Técnico'),
        backgroundColor: const Color(0xFFB71C1C), // mismo color que usaste
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Plantel - Fútbol Amateur',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._buildPlantel(),


          const SizedBox(height: 24),
          const Text(
            'Cuerpo Técnico - Fútbol Amateur',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._buildCuerpoTecnico(),
        ],
      ),
    );
  }


  List<Widget> _buildPlantel() {
    // Datos de ejemplo para fútbol amateur
    final jugadores = [
      {'nombre': 'María López', 'posicion': 'Mediocampista'},
      {'nombre': 'Jorge Martínez', 'posicion': 'Defensor'},
      {'nombre': 'Ana García', 'posicion': 'Delantera'},
    ];


    return jugadores
        .map((jugador) => Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.sports_soccer),
                title: Text(jugador['nombre']!),
                subtitle: Text(jugador['posicion']!),
              ),
            ))
        .toList();
  }


  List<Widget> _buildCuerpoTecnico() {
    final tecnicos = [
      {'nombre': 'Laura Fernández', 'rol': 'Entrenadora'},
      {'nombre': 'Pablo Sánchez', 'rol': 'Preparador Físico'},
    ];


    return tecnicos
        .map((tecnico) => Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(tecnico['nombre']!),
                subtitle: Text(tecnico['rol']!),
              ),
            ))
        .toList();
  }
}


