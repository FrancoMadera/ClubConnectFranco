import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:io';
import 'dart:convert';

class AdminCrearNoticiaScreen extends StatefulWidget {
  // Pantalla para que un administrador pueda crear una nueva noticia
  const AdminCrearNoticiaScreen({super.key});

  @override
  State<AdminCrearNoticiaScreen> createState() => _AdminCrearNoticiaScreenState();
}

class _AdminCrearNoticiaScreenState extends State<AdminCrearNoticiaScreen> {
  // Llave para el formulario, permite validar inputs
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto del formulario
  final _tituloController = TextEditingController();
  final _contenidoController = TextEditingController();
  final _categoriaController = TextEditingController();

  // Estado para el switch que indica si la noticia es destacada
  bool _destacada = false;

  // Variable que almacenará la imagen seleccionada (si hay)
  File? _imagen;

  // Color institucional para consistencia visual en toda la pantalla
  final Color rojoInstitucional = const Color(0xFFE20613);

  // Logger para imprimir mensajes de depuración y errores
  final Logger logger = Logger();

  /// Método para abrir la galería y permitir que el usuario seleccione una imagen
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Si se seleccionó una imagen, actualizar el estado para mostrarla en UI
      setState(() => _imagen = File(pickedFile.path));
    }
  }

  /// Método para subir la imagen seleccionada a Cloudinary y obtener la URL pública
  Future<String?> _subirImagenACloudinary(File imagen) async {
    // Datos para la API de Cloudinary
    const cloudName = 'dqiqdsw5c';
    const uploadPreset = 'ml_default';
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    // Crear la petición multipart/form-data para subir la imagen
    final request = http.MultipartRequest('POST', url);
    request.fields['upload_preset'] = uploadPreset;
    request.files.add(await http.MultipartFile.fromPath('file', imagen.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      // Leer respuesta y decodificar JSON para extraer la URL segura
      final responseData = await response.stream.bytesToString();
      final data = jsonDecode(responseData);
      return data['secure_url']; // URL pública de la imagen subida
    } else {
      // Loguear error en caso de fallo
      logger.e('Error al subir imagen: ${response.statusCode}');
      return null;
    }
  }

  /// Método que valida el formulario, sube la imagen si existe y guarda la noticia en Firestore
  Future<void> _guardarNoticia() async {
    if (_formKey.currentState!.validate()) {
      try {
        String imagenUrl = '';

        // Si hay imagen seleccionada, subirla a Cloudinary
        if (_imagen != null) {
          final url = await _subirImagenACloudinary(_imagen!);
          if (url != null) imagenUrl = url;
        }

        // Guardar noticia en colección 'noticias' de Firestore con todos los datos
        await FirebaseFirestore.instance.collection('noticias').add({
          'titulo': _tituloController.text.trim(),
          'contenido': _contenidoController.text.trim(),
          'categoria': _categoriaController.text.trim(),
          'imagenUrl': imagenUrl,
          'destacada': _destacada,
          'fecha': Timestamp.now(), // Fecha actual
        });

        if (!mounted) return;

        // Mostrar mensaje de éxito y volver a la pantalla anterior
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Noticia guardada exitosamente')),
        );
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;

        // Mostrar mensaje de error en caso de excepción
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error al guardar: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    // Liberar recursos de los controladores al destruir el widget
    _tituloController.dispose();
    _contenidoController.dispose();
    _categoriaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // AppBar con título e ícono que representan la acción actual
      appBar: AppBar(
        backgroundColor: rojoInstitucional,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.newspaper_outlined, color: Colors.white),
            SizedBox(width: 8),
            Text('Crear Noticia', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),

      // Cuerpo con formulario y scroll vertical para manejar teclados y contenido largo
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Sección para datos básicos: título y categoría
              _buildSectionCard(
                title: 'Información Básica',
                child: Column(
                  children: [
                    _buildTextField(_tituloController, 'Título', 'Ingrese un título'),
                    const SizedBox(height: 16),
                    _buildTextField(_categoriaController, 'Categoría (opcional)', null),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Sección para seleccionar imagen desde galería
              _buildSectionCard(
                title: 'Imagen de Portada',
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text('Seleccionar Imagen'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade800,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Vista previa de la imagen seleccionada
                    if (_imagen != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _imagen!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                    // Mensaje si no hay imagen seleccionada
                    if (_imagen == null)
                      const Text('No hay imagen seleccionada', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Sección para contenido textual de la noticia
              _buildSectionCard(
                title: 'Contenido',
                child: TextFormField(
                  controller: _contenidoController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: 'Ingrese el contenido de la noticia...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Ingrese contenido' : null,
                ),
              ),

              const SizedBox(height: 20),

              // Sección con switch para marcar noticia como destacada o no
              _buildSectionCard(
                title: 'Opciones',
                child: SwitchListTile(
                  title: const Text('¿Marcar como destacada?'),
                  value: _destacada,
                  onChanged: (val) => setState(() => _destacada = val),
                  activeColor: rojoInstitucional,
                ),
              ),

              const SizedBox(height: 30),

              // Botón para guardar y publicar la noticia
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _guardarNoticia,
                  icon: const Icon(Icons.save),
                  label: const Text('Publicar Noticia', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rojoInstitucional,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // Barra inferior con texto institucional fijo
      bottomNavigationBar: Container(
        height: 50,
        color: rojoInstitucional,
        child: const Center(
          child: Text(
            'Club 9 de Julio de Rafaela',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  /// Método reutilizable para construir campos de texto con validación opcional
  Widget _buildTextField(TextEditingController controller, String label, String? errorMsg) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      validator: (value) {
        if (errorMsg != null && (value == null || value.trim().isEmpty)) {
          return errorMsg;
        }
        return null;
      },
    );
  }

  /// Método para construir secciones con título y contenido con estilo uniforme
  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}