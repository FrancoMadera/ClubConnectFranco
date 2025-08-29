import 'package:flutter/material.dart';
import 'package:flutter_club_connect/pages/public/noticia/noticiascreen.dart';
import 'package:flutter_club_connect/pages/admin/login_screen.dart';


class PantallaCarga extends StatefulWidget {
  const PantallaCarga({super.key});


  @override
  State<PantallaCarga> createState() => _PantallaCargaState();
}


class _PantallaCargaState extends State<PantallaCarga>
    with SingleTickerProviderStateMixin {
  int _toques = 0;
  bool _loginMostrado = false;
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _rotationAnimation;


  @override
  void initState() {
    super.initState();
    _initAnimations();
    _irAPantallaInicio();
  }


  void _initAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );


    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );


    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );


    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );


    _animationController.forward();
  }


  Future<void> _irAPantallaInicio() async {
    await Future.delayed(const Duration(seconds: 10));
    if (!mounted) return;
    if (!_loginMostrado) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const NoticiasScreen(),
          transitionDuration: const Duration(milliseconds: 800),
          transitionsBuilder: (_, a, __, c) =>
              FadeTransition(opacity: a, child: c),
        ),
      );
    }
  }


  void _incrementarToques() {
    setState(() => _toques++);


    _animationController.reset();
    _animationController.forward();


    if (_toques >= 3 && !_loginMostrado) {
      _loginMostrado = true;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionDuration: const Duration(milliseconds: 800),
          transitionsBuilder: (_, a, __, c) =>
              FadeTransition(opacity: a, child: c),
        ),
      );
    }
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.height < 600;
    final double logoSize = isSmallScreen ? 150.0 : 220.0;


    return Scaffold(
      backgroundColor: const Color(0xFFB71C1C), // Rojo institucional
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value.clamp(0.0, 1.0),
            child: Container(
              color: const Color(0xFFB71C1C),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: _scaleAnimation.value.clamp(0.0, 2.0),
                      child: _buildLogo(logoSize),
                    ),
                    const SizedBox(height: 40),
                    RotationTransition(
                      turns: _rotationAnimation,
                      child: _buildProgressIndicator(),
                    ),
                    if (_toques > 0 && _toques < 3) _buildTapCounter(),
                    if (_toques > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'Toca el escudo 3 veces para acceso administrativo',
                          style: const TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 179),
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildLogo(double size) {
    return GestureDetector(
      onTap: _incrementarToques,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFFB71C1C), // Fondo rojo institucional
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Image.asset(
            'images/escudo.jpeg',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) => Center(
              child: Icon(
                Icons.sports_soccer,
                size: size * 0.5,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildProgressIndicator() {
    return SizedBox(
      width: 30,
      height: 30,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: const AlwaysStoppedAnimation<Color>(
          Color.fromRGBO(255, 255, 255, 204),
        ),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 51),
      ),
    );
  }


  Widget _buildTapCounter() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _toques > 0 ? 1.0 : 0.0,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          'Toques: $_toques/3',
          style: const TextStyle(
            color: Color.fromRGBO(255, 255, 255, 179),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}


