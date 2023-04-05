import 'package:battery_swap_station/src/constants/color.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  var btnText = '';
  var onClick;

  ButtonWidget({Key? key, required this.btnText, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: CustomColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      // margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(30.0),
        onTap: onClick,
        child: ListTile(
          title: Center(
            child: Text(
              btnText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
