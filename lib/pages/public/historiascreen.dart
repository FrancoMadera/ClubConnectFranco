import 'package:flutter/material.dart';
import 'package:flutter_club_connect/pages/widget/appmenudrawer.dart';


class HistoriaScreen extends StatelessWidget {
  const HistoriaScreen({super.key});


  final Color primaryColor = const Color(0xFFB71C1C);
  final Color secondaryColor = const Color(0xFF0D47A1);
  final Color goldColor = const Color(0xFFFFD700);
  final Color backgroundColor = const Color(0xFFFAFAFA);
  final Color textColor = const Color(0xFF212121);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'NUESTRA HISTORIA',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
      ),
      drawer: const AppMenuDrawer(),
      body: CustomScrollView(
        slivers: [
          // Header hero section
          SliverAppBar(
            expandedHeight: 250,
            automaticallyImplyLeading: false,
            backgroundColor: primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(183, 28, 28, 0.8), // primaryColor.withOpacity(0.8)
                          Color.fromRGBO(13, 71, 161, 0.6), // secondaryColor.withOpacity(0.6)
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Círculo con escudo centrado
                        ClipOval(
                          child: Image.asset(
                            'images/escudo.jpeg',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'CLUB 9 DE JULIO',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 2,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black.withAlpha(77), // equivalente a 0.3 opacidad
                                offset: const Offset(2, 2),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Desde 1904',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: goldColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),


          //Contenido principal
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline section
                  _buildTimelineSection(),


                  const SizedBox(height: 40),


                  // Quote section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(183, 28, 28, 0.1), // primaryColor.withOpacity(0.1)
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color.fromRGBO(183, 28, 28, 0.3), // primaryColor.withOpacity(0.3)
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.sports_soccer,
                          size: 36,
                          color: primaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '"¡Orgullo rafaelino desde 1904!"',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Más de un siglo de pasión, gloria y tradición',
                          style: TextStyle(
                            fontSize: 14,
                            color: textColor.withAlpha(179), // textColor.withOpacity(0.7)
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTimelineSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LINEA DE TIEMPO',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: primaryColor,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 3,
          width: 60,
          color: goldColor,
          margin: const EdgeInsets.only(bottom: 24),
        ),


        // Timeline items
        _buildTimelineItem(
          year: '1904',
          title: 'Fundación',
          description:
              'Tres jóvenes de 12 años (Eduardo Tello, Luis Gunzinger y Atilio Scarazzini) fundaron el club "Central Norte". En 1906 adoptaron el nombre Club 9 de Julio y se establecieron en calle Ayacucho, donde aún funciona la sede social.',
          isFirst: true,
        ),


        _buildTimelineItem(
          year: '1986-1992',
          title: 'Torneo del Interior',
          description:
              'Participó desde 1986 con destacadas actuaciones, llegando a ser campeón en 1989-90 y en 1991-92, accediendo al Zonal Noroeste por el ascenso a la B Nacional.',
        ),


        _buildTimelineItem(
          year: '1997-98',
          title: 'Debut en Argentino B',
          description:
              'Debutó en la temporada 1997-98, con una destacada participación en el Grupo 2-A de la zona Litoral.',
        ),


        _buildTimelineItem(
          year: '2000-01',
          title: 'Ascenso al Argentino A',
          description:
              'Logró el campeonato y su primer ascenso al Argentino A, tras una campaña impecable.',
        ),


        _buildTimelineItem(
          year: '2003-2005',
          title: 'Descensos y retornos',
          description:
              'Descendió nuevamente al Argentino B en 2003, pero volvió a ascender en 2005 tras vencer a Sp. Belgrano. En el Argentino A mantuvo varias temporadas regulares hasta un nuevo descenso en 2011.',
        ),


        _buildTimelineItem(
          year: '2023',
          title: 'Federal B y gran ascenso',
          description:
              'Tras años en el Federal B, en 2023 consiguió el ascenso al Torneo Federal A tras vencer 3-1 a Camioneros Argentinos del Norte.',
          isLast: true,
        ),
      ],
    );
  }


  Widget _buildTimelineItem({
    required String year,
    required String title,
    required String description,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: primaryColor,
              width: 2,
            ),
          ),
        ),
        child: Stack(
          children: [
            // Línea de tiempo
            if (!isLast)
              Positioned(
                left: -21,
                top: 40,
                child: Container(
                  height: 80,
                  width: 2,
                  color: primaryColor,
                ),
              ),


            // Contenido
            Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Punto de timeline
                  Transform.translate(
                    offset: const Offset(-31, 0),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                    ),
                  ),


                  // Año
                  Text(
                    year,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),


                  // Título
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),


                  const SizedBox(height: 8),


                  // Descripción
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: textColor.withAlpha(204), // textColor.withOpacity(0.8)
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


