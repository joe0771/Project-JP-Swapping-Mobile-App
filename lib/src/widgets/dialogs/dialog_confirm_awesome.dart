import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:battery_swap_station/src/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> dialogConfirmAwesome(BuildContext context,String title,String message, VoidCallback onPress) async {
  await AwesomeDialog(
    context: context,
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
    headerAnimationLoop: false,
    dialogType: DialogType.NO_HEADER,
    title: title,
    desc: message,
    btnOkOnPress: onPress,
    btnCancelOnPress: () {},
    btnOkColor: CustomColors.primaryColor,
    btnCancelColor: Colors.grey.shade500,
    btnOkIcon: Icons.check_circle,
  ).show();
}