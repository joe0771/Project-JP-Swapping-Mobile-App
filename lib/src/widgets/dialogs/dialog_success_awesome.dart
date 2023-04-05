import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:battery_swap_station/src/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> dialogSuccessAwesome(BuildContext context, String title,String message, VoidCallback onPress) async {
  await AwesomeDialog(
    context: context,
    dialogType: DialogType.SUCCES,
    animType: AnimType.RIGHSLIDE,
    headerAnimationLoop: false,
    dialogBackgroundColor: Colors.grey.shade100,
    titleTextStyle: const TextStyle(
      color: CustomColors.textCardBattery,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    descTextStyle: const TextStyle(
      color: CustomColors.textCardBattery,
      fontSize: 14,
    ),
    title: title,
    desc: message,
    btnOkOnPress: () {},
    // btnOkIcon: Icons.cancel,
    btnOkColor: CustomColors.primaryColor,
  ).show();
}