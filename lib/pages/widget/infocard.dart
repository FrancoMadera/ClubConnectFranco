// Importa el paquete principal de Flutter para construcción de interfaces gráficas
import 'package:flutter/material.dart';


// Widget sin estado (StatelessWidget) que representa una tarjeta informativa reutilizable
class InfoCard extends StatelessWidget {
  // Icono que se mostrará al inicio de la tarjeta
  final IconData icon;
  // Título principal (generalmente destacado o en negrita)
  final String title;
  // Subtítulo o descripción adicional debajo del título
  final String subtitle;
  // Color del ícono (para representar categoría, importancia o estado)
  final Color color;


  // Constructor con parámetros requeridos e inicialización por nombre
  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Altura de la sombra de la tarjeta
      child: ListTile(
        // Ícono principal alineado a la izquierda
        leading: Icon(icon, size: 40, color: color),
        // Título principal con estilo en negrita
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        // Subtítulo debajo del título, con estilo por defecto
        subtitle: Text(subtitle),
      ),
    );
  }
}


