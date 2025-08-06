import 'package:flutter/material.dart';


class PlantelYCuerpoTecnicoFutbolFemeninoScreen extends StatelessWidget {
  const PlantelYCuerpoTecnicoFutbolFemeninoScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantel y Cuerpo Técnico'),
        backgroundColor: const Color(0xFFB71C1C), // mismo color rojo
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Plantel - Fútbol Femenino',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._buildPlantel(),


          const SizedBox(height: 24),
          const Text(
            'Cuerpo Técnico - Fútbol Femenino',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._buildCuerpoTecnico(),
        ],
      ),
    );
  }


  List<Widget> _buildPlantel() {
    // Datos de ejemplo para fútbol femenino
    final jugadoras = [
      {'nombre': 'Valentina Ríos', 'posicion': 'Arquera'},
      {'nombre': 'Lucía Torres', 'posicion': 'Defensora'},
      {'nombre': 'Camila Fernández', 'posicion': 'Delantera'},
      {'nombre': 'Sofía Martínez', 'posicion': 'Mediocampista'},
    ];


    return jugadoras
        .map((jugadora) => Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.sports_soccer),
                title: Text(jugadora['nombre']!),
                subtitle: Text(jugadora['posicion']!),
              ),
            ))
        .toList();
  }


  List<Widget> _buildCuerpoTecnico() {
    final tecnicas = [
      {'nombre': 'Martina Gómez', 'rol': 'Entrenadora'},
      {'nombre': 'Carolina Díaz', 'rol': 'Preparadora Física'},
      {'nombre': 'Gabriela Ruiz', 'rol': 'Kinesióloga'},
    ];


    return tecnicas
        .map((tecnica) => Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(tecnica['nombre']!),
                subtitle: Text(tecnica['rol']!),
              ),
            ))
        .toList();
  }
}


