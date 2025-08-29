import 'package:flutter/material.dart';

class Styles {
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle featuredTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  );

  static const TextStyle featuredContent = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );

  static const TextStyle newsTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle newsDate = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );

  static const TextStyle matchCompetition = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle matchDate = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.blue,
  );

  static const TextStyle teamName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle vsText = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle quoteText = TextStyle(
    fontSize: 16,
    fontStyle: FontStyle.italic,
    color: Colors.black54,
  );

  static ButtonStyle betButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.blue[800],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  );
}