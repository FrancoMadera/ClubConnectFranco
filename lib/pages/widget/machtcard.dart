import 'package:flutter/material.dart';
import '/utils/styles.dart';


class MatchCard extends StatelessWidget {
  final String competition;
  final String date;
  final String opponent;
  final bool isBettingAvailable;


  const MatchCard({
    required this.competition,
    required this.date,
    required this.opponent,
    required this.isBettingAvailable,
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              competition,
              style: Styles.matchCompetition.copyWith(color: Colors.red[800]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              date,
              style: Styles.matchDate.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: const [
                    Icon(Icons.sports_soccer, size: 40, color: Colors.red),
                    Text('9 de Julio', style: Styles.teamName),
                  ],
                ),
                const Text('VS', style: Styles.vsText),
                Column(
                  children: [
                    const Icon(Icons.sports_soccer, size: 40, color: Colors.black),
                    Text(opponent, style: Styles.teamName),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (isBettingAvailable)
              ElevatedButton(
                onPressed: () {
                  // Acción para apostar (puede ser una navegación o modal)
                },
                style: Styles.betButton.copyWith(
                  backgroundColor: WidgetStateProperty.all(Colors.red[800]),
                ),
                child: Text('APOSTÁ CONTRA $opponent'),
              ),
          ],
        ),
      ),
    );
  }
}
