import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String text1;
  final String text2;
  final String text3;
  final Color cardColor;

  const ServiceCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.text1,
    required this.text2,
    required this.text3,
    this.cardColor = const Color(0xFF00BBC9),
  }) : super(key: key);

  @override  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16), 
            Row(
              children: [
                Expanded(
                  child: Image.network(imageUrl, height: 100, fit: BoxFit.cover), 
                ),
                const SizedBox(width: 16), 
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$text1'),
                      Text('$text2'),
                      Text('$text3'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
