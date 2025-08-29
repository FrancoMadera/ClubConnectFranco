import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_club_connect/models/integranteplantel.dart';
import 'package:flutter_club_connect/pages/public/plantel/detalleintegrantes.dart';
import 'package:flutter_club_connect/pages/widget/appmenudrawer.dart';


class PlantelYCuerpoTecnicoFutbolFemeninoScreen extends StatefulWidget {
  const PlantelYCuerpoTecnicoFutbolFemeninoScreen({super.key});


  @override
  State<PlantelYCuerpoTecnicoFutbolFemeninoScreen> createState() =>
      _PlantelYCuerpoTecnicoFutbolFemeninoScreenState();
}


class _PlantelYCuerpoTecnicoFutbolFemeninoScreenState
    extends State<PlantelYCuerpoTecnicoFutbolFemeninoScreen> {
  final Color rojoInstitucional = const Color(0xFFB71C1C);
  final Color fondoApp = const Color(0xFFFAFAFA);


  late Future<List<Integrante>> _jugadorasFuture;


  @override
  void initState() {
    super.initState();
    _jugadorasFuture = _loadJugadoras();
  }


  Future<List<Integrante>> _loadJugadoras() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('plantel_femenino') // <-- colección femenina
        .get();
    return snapshot.docs
        .map((doc) => Integrante.fromDocument(doc.id, doc.data()))
        .toList();
  }


  Future<void> _refreshJugadoras() async {
    setState(() {
      _jugadorasFuture = _loadJugadoras();
    });
    await _jugadorasFuture;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoApp,
      appBar: AppBar(
        title: const Text(
          'PLANTEL FEMENINO',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        backgroundColor: rojoInstitucional,
        centerTitle: true,
      ),
      drawer: const AppMenuDrawer(),
      body: RefreshIndicator(
        onRefresh: _refreshJugadoras,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildPositionSliver('ARQUERAS', 'Arquera'),
            _buildPositionSliver('DEFENSORAS', 'Defensora'),
            _buildPositionSliver('MEDIOCAMPISTAS', 'Mediocampista'),
            _buildPositionSliver('DELANTERAS', 'Delantera'),
            _buildPositionSliver('CUERPO TÉCNICO', 'Cuerpo Técnico'),
          ],
        ),
      ),
    );
  }


  SliverList _buildPositionSliver(String title, String position) {
    return SliverList(
      delegate: SliverChildListDelegate([
        _buildPositionHeader(title),
        _buildPlayersList(position: position),
      ]),
    );
  }


  Widget _buildPositionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: rojoInstitucional,
          letterSpacing: 1.2,
        ),
      ),
    );
  }


  Widget _buildPlayersList({required String position}) {
    return FutureBuilder<List<Integrante>>(
      future: _jugadorasFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          );
        }


        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  "Error al cargar datos",
                  style: TextStyle(
                    color: rojoInstitucional,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(snapshot.error.toString(),
                    style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
              ],
            ),
          );
        }


        final integrantes = (snapshot.data ?? [])
            .where((i) => i.puesto.toLowerCase().contains(position.toLowerCase()))
            .toList();


        if (integrantes.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text('No hay integrantes en esta posición', style: TextStyle(color: Colors.grey)),
            ),
          );
        }


        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: integrantes.length,
          itemBuilder: (context, index) => _buildPlayerCard(integrantes[index]),
        );
      },
    );
  }


  Widget _buildPlayerCard(Integrante integrante) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showPlayerDetails(integrante),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: rojoInstitucional.withAlpha(77), width: 1.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: integrante.imagenUrl != null && integrante.imagenUrl!.isNotEmpty
                      ? Image.network(
                          integrante.imagenUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
                        )
                      : _buildPlaceholderImage(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(integrante.apellido.toUpperCase(),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(integrante.nombre, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                    const SizedBox(height: 4),
                    Text(integrante.puesto,
                        style: TextStyle(fontSize: 13, color: rojoInstitucional, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey.shade100,
      child: Center(
        child: Icon(Icons.person, size: 30, color: Colors.grey.shade400),
      ),
    );
  }


  void _showPlayerDetails(Integrante integrante) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DetallesIntegranteScreen(
          integrante: integrante,
          esJugador: true,
        ),
      ),
    );
  }
}
