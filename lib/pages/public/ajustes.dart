import 'package:flutter/material.dart';

class AjustesScreen extends StatefulWidget {
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const AjustesScreen({
    super.key,
    required this.currentThemeMode,
    required this.onThemeChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AjustesScreenState createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  late ThemeMode _selectedThemeMode;

  @override
  void initState() {
    super.initState();
    _selectedThemeMode = widget.currentThemeMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        children: [
          RadioListTile<ThemeMode>(
            title: const Text('Claro'),
            value: ThemeMode.light,
            groupValue: _selectedThemeMode,
            onChanged: (modo) {
              if (modo != null) {
                setState(() {
                  _selectedThemeMode = modo;
                  widget.onThemeChanged(modo);
                });
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Oscuro'),
            value: ThemeMode.dark,
            groupValue: _selectedThemeMode,
            onChanged: (modo) {
              if (modo != null) {
                setState(() {
                  _selectedThemeMode = modo;
                  widget.onThemeChanged(modo);
                });
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Automático'),
            value: ThemeMode.system,
            groupValue: _selectedThemeMode,
            onChanged: (modo) {
              if (modo != null) {
                setState(() {
                  _selectedThemeMode = modo;
                  widget.onThemeChanged(modo);
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
