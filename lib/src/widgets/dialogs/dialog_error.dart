import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

Future<void> dialogError(String message) async {
  dismissLoading();
  Get.defaultDialog(
    title: '',
    titlePadding: const EdgeInsets.all(0),
    radius: 8,
    cancel: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            'Close',
            style: TextStyle(
              color: Colors.blueAccent,
            ),
          ),
        ),
      ],
    ),
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const FaIcon(
            FontAwesomeIcons.timesCircle,
            size: 45,
            color: Colors.red,
          ),
          const SizedBox(height: 10),
          const Text(
            ' Error!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
  );
}

void dismissLoading() {
  if (Get.isDialogOpen!) {
    Get.back();
  }
}
