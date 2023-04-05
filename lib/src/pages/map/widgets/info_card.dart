import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  // the values we need
  final String title;
  final String subtitle;
  final IconData icon;

  const InfoCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.blueAccent,
          ),
          title: Text(
            title,
            style: const TextStyle(color: Colors.black87, fontSize: 18),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}