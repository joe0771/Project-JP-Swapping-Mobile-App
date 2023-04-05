import 'package:battery_swap_station/src/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class InfoCard extends StatelessWidget {
  // the values we need
  final String title;
  final String subtitle;
  final IconData icon;

  InfoCard({
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
            color: CustomColors.primaryColor,
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
