import 'package:flutter/material.dart';


class BottomNav extends StatelessWidget {
  const BottomNav({super.key});


  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.red[800],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Inicio',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Plantel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Multimedia',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Tienda',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Club',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}


