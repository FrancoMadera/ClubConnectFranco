
import 'package:flutter/material.dart';
import '/utils/styles.dart';


class NewsCard extends StatelessWidget {
  final String title;
  final String date;
  final bool isFeatured;


  const NewsCard({
    required this.title,
    required this.date,
    required this.isFeatured,
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: isFeatured ? 6 : 2,
      color: isFeatured ? Colors.red[50] : Colors.white,
      child: ListTile(
        leading: Icon(Icons.article, color: Colors.red[700]),
        title: Text(
          title,
          style: Styles.newsTitle.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.red[800],
          ),
        ),
        subtitle: Text(
          date,
          style: Styles.newsDate.copyWith(
            color: Colors.grey[700],
          ),
        ),
        trailing: isFeatured
            ? const Icon(Icons.star, color: Colors.amber)
            : null,
      ),
    );
  }
}


