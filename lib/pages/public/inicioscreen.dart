// Importación de los componentes principales de Flutter para UI.
import 'package:flutter/material.dart';


// Importación de widgets personalizados usados en esta pantalla.
import '../widget/noticiadestacada.dart';
import '../widget/newcard.dart';
import '../widget/machtcard.dart';
import '../widget/navbutton.dart';


// Importación del archivo de estilos globales personalizados.
import '/utils/styles.dart';


// Declaración de la pantalla de inicio como un widget sin estado (StatelessWidget).
class InicioScreen extends StatelessWidget {
  // Constructor constante, sin parámetros obligatorios.
  const InicioScreen({super.key});


  // Método que construye la interfaz de usuario.
  @override
  Widget build(BuildContext context) {
    // Datos simulados para la sección destacada.
    final featuredContent = {
      'title': 'Victoria clave', // Título destacado.
      'content': '9 de Julio venció 2-0 a Unión de Sunchales por el Torneo Federal A.', // Contenido detallado.
    };


    // Lista de noticias simuladas, cada una con título, fecha y si es destacada o no.
    final newsItems = [
      {'title': 'Goleada histórica en casa', 'date': 'Hoy', 'featured': true},
      {'title': 'Nuevo refuerzo en el mediocampo', 'date': 'Ayer', 'featured': false},
    ];


    // Datos del próximo partido (competencia, fecha, rival y disponibilidad de apuestas).
    final nextMatch = {
      'competition': 'Federal A - Fecha 10',
      'date': 'DOM. 2 JUN. 16:00',
      'opponent': 'Gimnasia de Concepción del Uruguay',
      'betting': false,
    };


    return Scaffold( // Widget base para estructurar la pantalla.
      backgroundColor: Colors.white, // Fondo blanco para toda la pantalla.
      appBar: AppBar( // Barra superior de la aplicación.
        title: const Text( // Título estático del club.
          'Club 9 de Julio de Rafaela',
          style: Styles.appBarTitle, // Estilo personalizado para AppBar.
        ),
        backgroundColor: Colors.red[800], // Color de fondo institucional.
        elevation: 0, // Sin sombra debajo de la AppBar.
      ),
      body: SingleChildScrollView( // Permite desplazar el contenido verticalmente.
        child: Column( // Organización vertical de los widgets hijos.
          children: [
            // Espacio superior antes del escudo.
            const SizedBox(height: 16),
           
            // Imagen del escudo del club, centrado.
            Center(
              child: Image.asset(
                'images/escudo.jpeg', // Ruta local de la imagen del escudo.
                height: 100, // Altura fija.
              ),
            ),


            // Espacio después del escudo.
            const SizedBox(height: 16),


            // Sección destacada con victoria reciente.
            FeaturedCard(
              title: featuredContent['title'] as String, // Título de la noticia destacada.
              content: featuredContent['content'] as String, // Contenido de la noticia destacada.
            ),


            const SizedBox(height: 20), // Separación antes de la sección de noticias.


            // Encabezado de la sección de noticias con ícono y texto.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Margen lateral.
              child: Row( // Distribución horizontal.
                children: [
                  Icon(Icons.new_releases, color: Colors.red[800]), // Ícono de noticias.
                  const SizedBox(width: 8), // Espacio entre ícono y texto.
                  const Text('Noticias del Club', style: Styles.sectionTitle), // Título de sección.
                  const Spacer(), // Empuja el siguiente texto hacia la derecha.
                  const Text('Destacado', style: Styles.sectionTitle), // Filtro (no funcional).
                  Checkbox(value: false, onChanged: (value) {}), // Checkbox sin lógica implementada aún.
                ],
              ),
            ),


            // Lista de tarjetas de noticias generada dinámicamente desde newsItems.
            ...newsItems.map((news) => NewsCard(
              title: news['title'] as String, // Título de la noticia.
              date: news['date'] as String, // Fecha de publicación.
              isFeatured: news['featured'] as bool, // Indicador si es destacada.
            )),


            const Divider(thickness: 1), // Línea divisoria antes de la siguiente sección.


            // Sección del próximo partido con los datos simulados.
            MatchCard(
              competition: nextMatch['competition'] as String, // Competencia del partido.
              date: nextMatch['date'] as String, // Fecha del partido.
              opponent: nextMatch['opponent'] as String, // Rival.
              isBettingAvailable: nextMatch['betting'] as bool, // Apuestas disponibles.
            ),


            // Frase motivacional atribuida al director técnico (puede reemplazarse por una real).
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '"El esfuerzo nos hace fuertes" - DT 9 de Julio',
                style: Styles.quoteText, // Estilo personalizado para citas.
                textAlign: TextAlign.center, // Alineado al centro.
              ),
            ),
          ],
        ),
      ),


      // Barra de navegación inferior reutilizable (BottomNav personalizado).
      bottomNavigationBar: const BottomNav(),
    );
  }
}
