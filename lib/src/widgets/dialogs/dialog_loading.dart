import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:battery_swap_station/src/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> dialogLoading(String message) async {
  Get.defaultDialog(
    title: '',
    titlePadding: const EdgeInsets.all(0),
    radius: 8,
    content: Column(
      children: [
        const CircularProgressIndicator(
          // value: 2,
          strokeWidth: 6.0,
          color: CustomColors.primaryColor,
        ),
        const SizedBox(height: 10),
        Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}

// Future<void> dialogLoadingAwesome(BuildContext context,String message) async {
//    await AwesomeDialog(
//     context: context,
//     dialogType: DialogType.NO_HEADER,
//     animType: AnimType.RIGHSLIDE,
//     headerAnimationLoop: false,
//     barrierColor: Colors.black87,
//     body: Center(
//       child: Padding(
//         padding: const EdgeInsets.only(
//           top: 10,
//           bottom: 40,
//           left: 40,
//           right: 40,
//         ),
//         child: Column(
//           children:  [
//             const SizedBox(height: 10),
//             const CircularProgressIndicator(
//               // value: 2,
//               strokeWidth: 6.0,
//               color: CustomColors.primaryColor,
//             ),
//             const SizedBox(height: 10),
//             Text(
//               message,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//     // dismissOnBackKeyPress: false,
//     dismissOnTouchOutside: false,
//   ).show();
// }
