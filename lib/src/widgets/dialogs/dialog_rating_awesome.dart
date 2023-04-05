import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:battery_swap_station/src/constants/color.dart';
import 'package:battery_swap_station/src/models/return_status_model.dart';
import 'package:battery_swap_station/src/services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

Future<void> dialogRatingAwesome(BuildContext context, String station,
    String user, VoidCallback onPress) async {
  double ratingValue = 5.0;
  await AwesomeDialog(
    context: context,
    dialogType: DialogType.SUCCES,
    animType: AnimType.RIGHSLIDE,
    headerAnimationLoop: false,
    dialogBackgroundColor: Colors.grey.shade100,
    dismissOnTouchOutside: false,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Thank you!',
          style: TextStyle(
            fontSize: 18,
            color: CustomColors.textTherm,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'You scan payment successful.',
          style: TextStyle(
            fontSize: 14,
            color: CustomColors.textTherm,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'How would you rate you',
          style: TextStyle(
            fontSize: 14,
            color: CustomColors.textTherm,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'experience at ',
              style: TextStyle(
                fontSize: 14,
                color: CustomColors.textTherm,
              ),
            ),
            Text(
              'JP Swapping?',
              style: TextStyle(
                fontSize: 14,
                color: CustomColors.textTherm,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        RatingBar.builder(
          initialRating: ratingValue,
          minRating: 1,
          direction: Axis.horizontal,
          itemCount: 5,
          itemSize: 35,
          itemPadding: const EdgeInsets.symmetric(horizontal: 5.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            ratingValue = rating;
          },
        ),
        const SizedBox(height: 10),
      ],
    ),
    btnOkOnPress: () async {
      log('Rating ==== ${ratingValue.toInt()}');
      final ReturnStatusModel? postRating = await NetworkService().postRating(
        station,
        user,
        ratingValue.toInt(),
        '',
      );
      if (postRating?.success == true) {
        log('Rating ==== Success');
      }
    },
    // btnOkIcon: Icons.cancel,
    btnOkColor: Colors.amber,
  ).show();
}
