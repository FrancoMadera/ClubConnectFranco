import 'package:flutter/material.dart';
import 'package:flutter_club_connect/pages/public/noticiascreen.dart';
import 'package:flutter_club_connect/pages/admin/login_screen.dart';


class PantallaCarga extends StatefulWidget {
  const PantallaCarga({super.key});


  @override
  State<PantallaCarga> createState() => _PantallaCargaState();
}


class _PantallaCargaState extends State<PantallaCarga> {
  int _toques = 0;
  bool _loginMostrado = false;


  @override
  void initState() {
    super.initState();
    _irAPantallaInicio();
  }


  Future<void> _irAPantallaInicio() async {
    await Future.delayed(const Duration(seconds: 5));
    if (mounted && !_loginMostrado) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NoticiasScreen()),
      );
    }
  }


  void _incrementarToques() {
    setState(() {
      _toques++;
    });


    if (_toques >= 3 && !_loginMostrado) {
      _loginMostrado = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final imageSize = screenSize.height < 600 ? 150.0 : 220.0;


    return Scaffold(
      backgroundColor: const Color(0xFFE20613),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _incrementarToques,
              child: Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(
                    color: const Color.fromRGBO(255, 255, 255, 0.2),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'images/escudo.jpeg',
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(Icons.error, size: imageSize * 0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(255, 255, 255, 0.8),
                ),
              ),
            ),
            if (_toques > 0 && _toques < 3)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Toques: $_toques/3',
                  style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.5),
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
