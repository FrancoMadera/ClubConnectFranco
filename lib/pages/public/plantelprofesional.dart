import 'package:flutter/material.dart';


class PlantelYCuerpoTecnicoFutbolProfesionalScreen extends StatelessWidget {
  const PlantelYCuerpoTecnicoFutbolProfesionalScreen({super.key});


  final Color rojoInstitucional = const Color(0xFFB71C1C);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantel y Cuerpo Técnico'),
        backgroundColor: rojoInstitucional,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Plantel - Fútbol Profesional',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._buildPlantel(),


          const SizedBox(height: 24),
          const Text(
            'Cuerpo Técnico - Fútbol Profesional',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._buildCuerpoTecnico(),
        ],
      ),
    );
  }


  List<Widget> _buildPlantel() {
    final jugadores = [
      {
        'nombre': 'Lionel Messi',
        'posicion': 'Delantero',
        'foto': 'https://cdn.pixabay.com/photo/2016/11/29/09/55/man-1869716_960_720.jpg'
      },
      {
        'nombre': 'Kylian Mbappé',
        'posicion': 'Delantero',
        'foto': 'https://cdn.pixabay.com/photo/2017/08/06/22/59/man-2593429_960_720.jpg'
      },
      {
        'nombre': 'Neymar Jr.',
        'posicion': 'Delantero',
        'foto': 'https://cdn.pixabay.com/photo/2015/01/08/18/29/man-593333_960_720.jpg'
      },
      {
        'nombre': 'Marquinhos',
        'posicion': 'Defensor',
        'foto': 'https://cdn.pixabay.com/photo/2017/02/01/17/38/people-2031209_960_720.jpg'
      },
      {
        'nombre': 'Gianluigi Donnarumma',
        'posicion': 'Arquero',
        'foto': 'https://cdn.pixabay.com/photo/2015/03/04/22/35/man-659512_960_720.jpg'
      },
    ];


    return jugadores
        .map(
          (jugador) => Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  jugador['foto']!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 60),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      width: 60,
                      height: 60,
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    );
                  },
                ),
              ),
              title: Text(
                jugador['nombre']!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(
                jugador['posicion']!,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ),
        )
        .toList();
  }


  List<Widget> _buildCuerpoTecnico() {
    final tecnicos = [
      {
        'nombre': 'Mauricio Pochettino',
        'rol': 'Director Técnico',
        'foto': 'https://cdn.pixabay.com/photo/2017/03/06/22/29/man-2125881_960_720.jpg'
      },
      {
        'nombre': 'Jesus Perez',
        'rol': 'Asistente Técnico',
        'foto': 'https://cdn.pixabay.com/photo/2016/03/27/19/45/man-1281562_960_720.jpg'
      },
      {
        'nombre': 'Miguel D’Agostino',
        'rol': 'Preparador Físico',
        'foto': 'https://cdn.pixabay.com/photo/2016/11/29/03/53/man-1867972_960_720.jpg'
      },
    ];


    return tecnicos
        .map(
          (tecnico) => Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  tecnico['foto']!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 60),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      width: 60,
                      height: 60,
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    );
                  },
                ),
              ),
              title: Text(
                tecnico['nombre']!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(
                tecnico['rol']!,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ),
        )
        .toList();
  }
}



