import 'package:battery_swap_station/src/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:battery_swap_station/src/config/theme.dart' as custom_theme;

class HeaderRegister extends StatelessWidget {
  const HeaderRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.32,
      decoration: const BoxDecoration(
        color: CustomColors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100),
        ),
      ),
      child: Stack(
        children: const <Widget>[
          Positioned(
            bottom: 20,
            right: 20,
            child: Text(
              'Register',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Center(
            child: Icon(
              Icons.supervised_user_circle_rounded,
              size: 100,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
