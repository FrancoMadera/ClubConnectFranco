import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class AdminEditarNoticiaScreen extends StatefulWidget {
  final DocumentSnapshot noticiaDoc;


  const AdminEditarNoticiaScreen({super.key, required this.noticiaDoc});


  @override
  State<AdminEditarNoticiaScreen> createState() => _AdminEditarNoticiaScreenState();
}


class _AdminEditarNoticiaScreenState extends State<AdminEditarNoticiaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _contenidoController;
  late TextEditingController _categoriaController;
  bool _destacada = false;


  @override
  void initState() {
    super.initState();
    final data = widget.noticiaDoc.data() as Map<String, dynamic>;
    _tituloController = TextEditingController(text: data['titulo']);
    _contenidoController = TextEditingController(text: data['contenido']);
    _categoriaController = TextEditingController(text: data['categoria'] ?? '');
    _destacada = data['destacada'] ?? false;
  }


  @override
  void dispose() {
    _tituloController.dispose();
    _contenidoController.dispose();
    _categoriaController.dispose();
    super.dispose();
  }


  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      try {
        await widget.noticiaDoc.reference.update({
          'titulo': _tituloController.text.trim(),
          'contenido': _contenidoController.text.trim(),
          'categoria': _categoriaController.text.trim(),
          'destacada': _destacada,
        });


        if (!mounted) return;


        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cambios guardados exitosamente')),
        );


        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar cambios: $e')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final data = widget.noticiaDoc.data() as Map<String, dynamic>;
    final fecha = (data['fecha'] as Timestamp).toDate();
    final imagenUrl = data['imagenUrl'] ?? '';


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Noticia',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.red.shade900,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese un título' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoriaController,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Publicado: ${DateFormat('dd/MM/yyyy HH:mm').format(fecha)}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imagenUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[300],
                    height: 200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image, size: 60, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _contenidoController,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: 'Contenido',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingrese el contenido'
                    : null,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Destacada'),
                value: _destacada,
                onChanged: (val) => setState(() => _destacada = val),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _guardarCambios,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade900,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Center(
                  child: Text(
                    'Guardar Cambios',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.red.shade900,
        child: const Center(
          child: Text(
            'Club 9 de Julio de Rafaela',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}


