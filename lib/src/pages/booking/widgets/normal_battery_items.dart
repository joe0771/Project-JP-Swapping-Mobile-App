import 'package:battery_swap_station/src/constants/asset.dart';
import 'package:battery_swap_station/src/constants/color.dart';
import 'package:battery_swap_station/src/models/battery_model.dart';
import 'package:battery_swap_station/src/models/station_all_model.dart';
import 'package:battery_swap_station/src/widgets/blink_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NormalBatteryItems extends StatelessWidget {
  const NormalBatteryItems({
    Key? key,
    this.status,
    this.isBooking,
    this.battery,
    this.onPress,
  }) : super(key: key);

  final String? status;
  final bool? isBooking;
  final Battery? battery;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    if (status == 'Ready' && isBooking == false) {
      return buildCardBattery(
        CustomColors.primaryColor,
        'Ready',
        const Text(
          "Battery charge full",
          style: TextStyle(
            color: CustomColors.primaryColor,
          ),
        ),
        FontAwesomeIcons.batteryFull,
        Icons.check,
        _buildTextButtonBook(),
      );
    } else if (status == 'Ready' && isBooking == true) {
      return buildCardBattery(
        Colors.blueAccent,
        'Booked',
        const Text(
          "Battery is booked",
          style: TextStyle(
            color: CustomColors.textTherm,
          ),
        ),
        FontAwesomeIcons.batteryFull,
        Icons.check,
        const Text(''),
      );
    } else if (status == 'Charging') {
      return buildCardBattery(
        CustomColors.textCardBattery,
        'Charging',
           Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const[
              Text(
                'Charging ',
                style: TextStyle(
                  fontSize: 14,
                  color: CustomColors.textTherm,
                ),
              ),
              SizedBox(
                width: 20,
                child: BlinkWidget(
                  children: [
                    Text(
                      '',
                      style: TextStyle(
                        fontSize: 18,
                        color: CustomColors.textTherm,
                      ),
                    ),
                    Text(
                      '.',
                      style: TextStyle(
                        fontSize: 18,
                        color: CustomColors.textTherm,
                      ),
                    ),
                    Text(
                      '..',
                      style: TextStyle(
                        fontSize: 18,
                        color: CustomColors.textTherm,
                      ),
                    ),
                    Text(
                      '...',
                      style: TextStyle(
                        fontSize: 18,
                        color: CustomColors.textTherm,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        FontAwesomeIcons.batteryHalf,
        Icons.battery_charging_full,
        const Text(''),
      );
    } else if (status == 'NG') {
      return buildCardBattery(
        Colors.grey.shade700,
        'NG',
        const Text(
          "Battery broken",
          style: TextStyle(
            color: CustomColors.textTherm,
          ),
        ),
        FontAwesomeIcons.batteryEmpty,
        Icons.cancel,
        const Text(''),
      );
    } else if (status == 'Vacant') {
      return buildCardBattery(
        Colors.yellow.shade700,
        'Vacant',
        const Text(
          "Slot this vacant, don't have battery",
          style: TextStyle(
            color: CustomColors.textTherm,
          ),
        ),
        FontAwesomeIcons.batteryEmpty,
        FontAwesomeIcons.question,
        const Text(''),
      );
    }
    return buildCardBattery(
      Colors.grey,
      'No data.',
      const Text(
        "No data.",
        style: TextStyle(
          color: CustomColors.textTherm,
        ),
      ),
      FontAwesomeIcons.question,
      FontAwesomeIcons.question,
      const Text(''),
    );
  }

  buildCardBattery(
    Color color,
    String title,
    Widget subtitle,
    IconData iconMain,
    iconStatus,
      Widget book,
  ) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(
            Icons.battery_charging_full,
            color: CustomColors.primaryColor,
            size: 30,
          ),
          title: Text('Battery ${battery!.id}'),
          subtitle: subtitle,
          trailing: book,
        ),
        const Divider(),
      ],
    );
  }

  TextButton _buildTextButtonBook() {
    return TextButton(
      child: const Text(
        'Book',
        style: TextStyle(
            color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w500),
      ),
      style: TextButton.styleFrom(
        primary: Colors.blue,
        onSurface: Colors.blue,
        side: const BorderSide(color: Colors.blue, width: 2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
      ), onPressed: onPress,
    );
  }
}
