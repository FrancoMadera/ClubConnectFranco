import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_club_connect/models/integranteplantel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';


class AdminPlantelProfesionalScreen extends StatefulWidget {
  const AdminPlantelProfesionalScreen({super.key});


  @override
  State<AdminPlantelProfesionalScreen> createState() => _AdminPlantelProfesionalScreenState();
}


class _AdminPlantelProfesionalScreenState extends State<AdminPlantelProfesionalScreen> {
  List<Integrante> jugadores = [];
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _puestoController = TextEditingController();
  final _edadController = TextEditingController();
  final _lugarNacimientoController = TextEditingController();
  final _alturaController = TextEditingController();
  DateTime? _fechaNacimiento;
  File? _imagen;
  final Logger logger = Logger();
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    _cargarJugadores();
  }


  Future<void> _cargarJugadores() async {
    setState(() => _isLoading = true);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('plantel_profesional')
          .orderBy('fechaRegistro', descending: true)
          .get();


      setState(() {
        jugadores = snapshot.docs.map((doc) {
          final data = doc.data();
          return Integrante(
            id: doc.id,
            nombre: data['nombre'] ?? '',
            apellido: data['apellido'] ?? '',
            puesto: data['puesto'] ?? '',
            edad: data['edad'] ?? 0,
            fechaNacimiento: (data['fechaNacimiento'] as Timestamp).toDate(),
            lugarNacimiento: data['lugarNacimiento'] ?? '',
            altura: (data['altura'] ?? 0.0).toDouble(),
            imagenUrl: data['imagenUrl'] ?? '',
          );
        }).toList();
      });
    } catch (e) {
      logger.e('Error cargando jugadores: $e');
      _mostrarError('Error al cargar jugadores');
    } finally {
      setState(() => _isLoading = false);
    }
  }


  Future<void> _seleccionarImagen() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      setState(() => _imagen = File(pickedFile.path));
    }
  }


  Future<void> _seleccionarFechaNacimiento(BuildContext context) async {
    final hoy = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ?? DateTime(hoy.year - 20),
      firstDate: DateTime(hoy.year - 100),
      lastDate: hoy,
    );


    if (pickedDate != null) {
      setState(() => _fechaNacimiento = pickedDate);
    }
  }


  Future<String?> _subirImagenACloudinary(File imagen) async {
    try {
      const cloudName = 'dqiqdsw5c';
      const uploadPreset = 'ml_default';
      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
     
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imagen.path));
     
      final response = await request.send();
     
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        return data['secure_url'];
      } else {
        logger.e('Error al subir imagen: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      logger.e('Error subiendo imagen: $e');
      return null;
    }
  }


  Future<void> _agregarJugador() async {
    if (!_validarFormulario()) return;


    setState(() => _isLoading = true);
   
    try {
      String? imagenUrl;
      if (_imagen != null) {
        imagenUrl = await _subirImagenACloudinary(_imagen!);
        if (imagenUrl == null) {
          _mostrarError('Error al subir la imagen');
          return;
        }
      }


      final docRef = await FirebaseFirestore.instance.collection('plantel_profesional').add({
        'nombre': _nombreController.text.trim(),
        'apellido': _apellidoController.text.trim(),
        'puesto': _puestoController.text.trim(),
        'edad': int.parse(_edadController.text.trim()),
        'fechaNacimiento': Timestamp.fromDate(_fechaNacimiento!),
        'lugarNacimiento': _lugarNacimientoController.text.trim(),
        'altura': double.parse(_alturaController.text.replaceAll(',', '.')),
        'imagenUrl': imagenUrl ?? '',
        'fechaRegistro': Timestamp.now(),
      });


      final nuevoJugador = Integrante(
        id: docRef.id,
        nombre: _nombreController.text.trim(),
        apellido: _apellidoController.text.trim(),
        puesto: _puestoController.text.trim(),
        edad: int.parse(_edadController.text.trim()),
        fechaNacimiento: _fechaNacimiento!,
        lugarNacimiento: _lugarNacimientoController.text.trim(),
        altura: double.parse(_alturaController.text.replaceAll(',', '.')),
        imagenUrl: imagenUrl,
      );


      setState(() {
        jugadores.insert(0, nuevoJugador);
        _limpiarFormulario();
      });


      _mostrarExito('Jugador agregado correctamente');
    } catch (e) {
      logger.e('Error al guardar jugador: $e');
      _mostrarError('Error al guardar jugador');
    } finally {
      setState(() => _isLoading = false);
    }
  }


  bool _validarFormulario() {
    if (_nombreController.text.trim().isEmpty ||
        _apellidoController.text.trim().isEmpty ||
        _puestoController.text.trim().isEmpty ||
        _edadController.text.trim().isEmpty ||
        _fechaNacimiento == null ||
        _lugarNacimientoController.text.trim().isEmpty ||
        _alturaController.text.trim().isEmpty) {
      _mostrarError('Por favor completa todos los campos');
      return false;
    }


    final edad = int.tryParse(_edadController.text.trim());
    if (edad == null || edad < 15 || edad > 50) {
      _mostrarError('Edad debe ser entre 15 y 50 años');
      return false;
    }


    final altura = double.tryParse(_alturaController.text.replaceAll(',', '.'));
    if (altura == null || altura < 1.5 || altura > 2.3) {
      _mostrarError('Altura debe ser entre 1.50 y 2.30 m');
      return false;
    }


    return true;
  }


  void _limpiarFormulario() {
    _nombreController.clear();
    _apellidoController.clear();
    _puestoController.clear();
    _edadController.clear();
    _lugarNacimientoController.clear();
    _alturaController.clear();
    setState(() {
      _fechaNacimiento = null;
      _imagen = null;
    });
  }


  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }


  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }


  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _puestoController.dispose();
    _edadController.dispose();
    _lugarNacimientoController.dispose();
    _alturaController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final rojoInstitucional = Colors.red.shade700;


    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Plantel Profesional'),
        backgroundColor: rojoInstitucional,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Formulario de agregar jugador
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'AGREGAR NUEVO JUGADOR',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildFormField(_nombreController, 'Nombre', Icons.person),
                          const SizedBox(height: 12),
                          _buildFormField(_apellidoController, 'Apellido', Icons.person_outline),
                          const SizedBox(height: 12),
                          _buildFormField(_puestoController, 'Puesto', Icons.sports_soccer),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildFormField(_edadController, 'Edad', Icons.cake,
                                    keyboardType: TextInputType.number),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: _buildDateField(context)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildFormField(_lugarNacimientoController, 'Lugar de nacimiento', Icons.location_on),
                          const SizedBox(height: 12),
                          _buildFormField(_alturaController, 'Altura (m)', Icons.height,
                              keyboardType: TextInputType.numberWithOptions(decimal: true)),
                          const SizedBox(height: 16),
                          _buildImagePicker(),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _agregarJugador,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: rojoInstitucional,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle_outline, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'AGREGAR JUGADOR',
                                  style: TextStyle(fontSize: 16, letterSpacing: 0.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Listado de jugadores
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'JUGADORES REGISTRADOS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildJugadoresList(),
                ],
              ),
            ),
    );
  }


  Widget _buildFormField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }


  Widget _buildDateField(BuildContext context) {
    return InkWell(
      onTap: () => _seleccionarFechaNacimiento(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Fecha Nacimiento',
          prefixIcon: const Icon(Icons.calendar_today, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _fechaNacimiento == null
                  ? 'Seleccionar'
                  : DateFormat('dd/MM/yyyy').format(_fechaNacimiento!),
              style: TextStyle(
                color: _fechaNacimiento == null ? Colors.grey.shade500 : Colors.black87,
              ),
            ),
            const Icon(Icons.arrow_drop_down, size: 24),
          ],
        ),
      ),
    );
  }


  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Foto del Jugador',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _seleccionarImagen,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.grey.shade50,
            ),
            child: _imagen == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 40, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text(
                        'Toca para seleccionar imagen',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(_imagen!, fit: BoxFit.cover),
                  ),
          ),
        ),
      ],
    );
  }


  Widget _buildJugadoresList() {
    if (jugadores.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.people_alt_outlined, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text(
              'No hay jugadores registrados',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }


    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: jugadores.length,
      itemBuilder: (ctx, index) {
        final jugador = jugadores[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Hero(
                    tag: 'jugador-${jugador.id}',
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200, width: 2),
                      ),
                      child: ClipOval(
                        child: jugador.imagenUrl != null && jugador.imagenUrl!.isNotEmpty
                            ? Image.network(
                                jugador.imagenUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _buildPlaceholderAvatar(),
                              )
                            : _buildPlaceholderAvatar(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${jugador.nombre} ${jugador.apellido}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          jugador.puesto,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${jugador.edad} años • ${jugador.altura.toStringAsFixed(2)} m',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Nac: ${DateFormat('dd/MM/yyyy').format(jugador.fechaNacimiento)}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert, color: Colors.grey.shade500),
                    onPressed: () => _showOptionsMenu(ctx, jugador),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildPlaceholderAvatar() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.person, size: 30, color: Colors.grey),
      ),
    );
  }


  void _showOptionsMenu(BuildContext context, Integrante jugador) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Editar Jugador'),
              onTap: () {
                Navigator.pop(ctx);
                _editarJugador(context, jugador);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Eliminar Jugador'),
              onTap: () {
                Navigator.pop(ctx);
                _confirmarEliminacion(context, jugador);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancelar'),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }


  void _editarJugador(BuildContext context, Integrante jugador) {
    // Implementar lógica de edición
    _mostrarError('Funcionalidad de edición en desarrollo');
  }


  Future<void> _confirmarEliminacion(BuildContext context, Integrante jugador) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: const Text('¿Estás seguro de eliminar este jugador del plantel?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );


    if (confirm == true) {
      try {
        setState(() => _isLoading = true);
        await FirebaseFirestore.instance
            .collection('plantel_profesional')
            .doc(jugador.id)
            .delete();
       
        setState(() {
          jugadores.removeWhere((j) => j.id == jugador.id);
        });
       
        _mostrarExito('Jugador eliminado correctamente');
      } catch (e) {
        logger.e('Error eliminando jugador: $e');
        _mostrarError('Error al eliminar jugador');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
