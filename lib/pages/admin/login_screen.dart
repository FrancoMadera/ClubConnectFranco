import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


/// Pantalla de Login Administrativo
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  // Formulario y controladores de campos
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  // Estados de la UI
  bool _loading = false; // Indica si se está procesando login
  bool _obscurePassword = true; // Para ocultar/mostrar la contraseña


  // FocusNodes para manejar el enfoque en campos
  final _focusNodeEmail = FocusNode();
  final _focusNodePassword = FocusNode();


  // Animaciones
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;


  @override
  void initState() {
    super.initState();


    // Inicialización del AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );


    // Fade de entrada
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    );


    // Slide desde abajo
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutBack),
    ));


    _animationController.forward();
  }


  @override
  void dispose() {
    // Liberar recursos
    _emailController.dispose();
    _passwordController.dispose();
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    _animationController.dispose();
    super.dispose();
  }


  /// Función de login usando FirebaseAuth
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;


    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 300)); // Pequeña pausa para animaciones


    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );


      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/admin');
    } on FirebaseAuthException catch (e) {
      _showErrorSnackbar(_getMensajeError(e.code));
    } catch (_) {
      _showErrorSnackbar('Error inesperado. Intenta de nuevo.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }


  /// Muestra un snackbar de error profesional
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }


  /// Traduce códigos de error de Firebase a mensajes legibles
  String _getMensajeError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Correo electrónico inválido';
      case 'user-not-found':
        return 'Usuario no encontrado';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'user-disabled':
        return 'Usuario deshabilitado';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde';
      default:
        return 'Error al iniciar sesión';
    }
  }


  @override
  Widget build(BuildContext context) {
    // Colores institucionales
    final colorPrimario = const Color(0xFFE20613);
    final colorSecundario = Colors.grey.shade100;
    final colorTexto = Colors.grey.shade800;


    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorPrimario, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
          // Reemplazamos withOpacity por withAlpha para evitar deprecación
          labelStyle: TextStyle(color: colorTexto.withAlpha((0.7 * 255).toInt())),
          floatingLabelStyle: TextStyle(color: colorPrimario),
        ),
      ),
      child: Scaffold(
        backgroundColor: colorSecundario,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(), // Oculta teclado al tocar fuera
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Hero(
                        tag: 'app-logo',
                        child: Image.asset(
                          'images/escudo.jpeg',
                          height: 120,
                          width: 120,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(28),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Text(
                                  'Acceso Administrativo',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: colorPrimario,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 28),
                                _buildEmailField(colorPrimario),
                                const SizedBox(height: 20),
                                _buildPasswordField(colorPrimario),
                                const SizedBox(height: 32),
                                _buildLoginButton(colorPrimario),
                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: _loading
                                      ? null
                                      : () {
                                          // Aquí se podría implementar recuperación de contraseña
                                        },
                                  child: Text(
                                    '¿Olvidaste tu contraseña?',
                                    style: TextStyle(
                                      color: colorPrimario.withAlpha((0.8 * 255).toInt()),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  /// Campo de correo electrónico
  Widget _buildEmailField(Color primaryColor) {
    return TextFormField(
      controller: _emailController,
      focusNode: _focusNodeEmail,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Correo electrónico',
        prefixIcon: Icon(Icons.email_outlined, color: primaryColor),
        suffixIcon: _emailController.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: Colors.grey.shade500),
                onPressed: () => setState(() => _emailController.clear()),
              )
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Ingresa tu correo electrónico';
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Correo electrónico inválido';
        }
        return null;
      },
      onChanged: (_) => setState(() {}),
    );
  }


  /// Campo de contraseña
  Widget _buildPasswordField(Color primaryColor) {
    return TextFormField(
      controller: _passwordController,
      focusNode: _focusNodePassword,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_passwordController.text.isNotEmpty)
              IconButton(
                icon: Icon(Icons.clear, color: Colors.grey.shade500),
                onPressed: () => setState(() => _passwordController.clear()),
              ),
            IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey.shade500,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ],
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Ingresa tu contraseña';
        if (value.length < 6) return 'Mínimo 6 caracteres';
        return null;
      },
      onFieldSubmitted: (_) => _login(),
      onChanged: (_) => setState(() {}),
    );
  }


  /// Botón de login con indicador de carga
  Widget _buildLoginButton(Color primaryColor) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: _loading ? null : _login,
        child: _loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              )
            : const Text(
                'INICIAR SESIÓN',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
      ),
    );
  }
}


