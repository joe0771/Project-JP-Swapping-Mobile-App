import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class InfoListItem extends StatelessWidget {
  // the values we need
  final String title;
  final String subtitle;
  final IconData icon;

  const InfoListItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.blueAccent,
      ),
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.black87,
            fontSize: 18),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
            fontSize: 14),
      ),
    );
  }
}
