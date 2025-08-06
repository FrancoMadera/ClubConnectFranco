// Importa el paquete principal de Flutter para construir interfaces gráficas
import 'package:flutter/material.dart';
// Importa los estilos personalizados definidos en el proyecto
import '/utils/styles.dart';


// Widget sin estado que representa una tarjeta destacada (FeaturedCard)
class FeaturedCard extends StatelessWidget {
  // Título principal de la tarjeta
  final String title;
  // Contenido textual descriptivo o informativo
  final String content;


  // Constructor con parámetros requeridos para inicializar los datos
  const FeaturedCard({
    required this.title,
    required this.content,
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Card(
      // Margen externo alrededor de la tarjeta
      margin: const EdgeInsets.all(16),
      // Define la forma de la tarjeta, con bordes redondeados y borde rojo
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.red[800]!, width: 1.5),
      ),
      // Sombra proyectada de la tarjeta
      elevation: 4,
      // Color de fondo suave (rojo claro)
      color: Colors.red[50],
      // Espaciado interno (padding) dentro de la tarjeta
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Alineación del contenido al inicio del eje horizontal
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título destacado con estilo personalizado y color rojo oscuro
            Text(
              title,
              style: Styles.featuredTitle.copyWith(color: Colors.red[900]),
            ),
            const SizedBox(height: 10), // Espaciado entre título y contenido
            // Contenido principal con estilo personalizado
            Text(
              content,
              style: Styles.featuredContent,
            ),
          ],
        ),
      ),
    );
  }
}



