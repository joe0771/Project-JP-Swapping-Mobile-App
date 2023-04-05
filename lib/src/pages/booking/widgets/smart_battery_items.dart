import 'package:flutter/material.dart';
import 'package:battery_swap_station/src/constants/asset.dart';
import 'package:battery_swap_station/src/constants/color.dart';
import 'package:battery_swap_station/src/widgets/blink_widget.dart';
import 'package:battery_swap_station/src/models/station_all_model.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SmartBatteryItems extends StatelessWidget {
  const SmartBatteryItems({
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
    Color bgCard =  CustomColors.bgCardBattery;
    const Color colorTextReady = CustomColors.primaryColor;
    const Color redText = Color(0xFFb50000);
    const Color colorTextBooked = CustomColors.textCardBattery;
    const Color colorTextCharging = CustomColors.textCardBattery;
    const Color colorButtonEnable = CustomColors.primaryColor;
    Color greyButton = Colors.grey.shade500;

    int levelBattery;

    if (battery!.soc! >= 100) {
      levelBattery = 110;
    } else {
      levelBattery = battery!.soc!.toInt();
    }

    if (status == 'Ready' && isBooking == false) {
      return buildBattery(
        context,
        bgCard,
        battery!.id!,
        battery!.soc!.toInt(),
        battery!.soh!.toInt(),
        battery!.temperature!.toInt(),
        levelBattery,
        battery!.voltage!.toInt(),
        textReady(colorTextReady),
        'battery charge full',
        MdiIcons.batteryCheck,
        colorTextCharging,
        colorButtonEnable,
      );
    } else if (status == 'Ready' || status == 'Charging' && isBooking == true) {
      return buildBattery(
        context,
        bgCard,
        battery!.id!,
        battery!.soc!.toInt(),
        battery!.soh!.toInt(),
        battery!.temperature!.toInt(),
        levelBattery,
        battery!.voltage!.toInt(),
        textBooked(colorTextBooked),
        'battery is booked',
        MdiIcons.batteryCheck,
        colorTextCharging,
        greyButton,
      );
    }
    if (status == 'Charging') {
      if (battery!.soc! >= 50) {
        return buildBattery(
          context,
          bgCard,
          battery!.id!,
          battery!.soc!.toInt(),
          battery!.soh!.toInt(),
          battery!.temperature!.toInt(),
          levelBattery,
          battery!.voltage!.toInt(),
          textCharging(colorTextCharging),
          'battery is charging',
          MdiIcons.batteryCharging,
          colorTextCharging,
          colorButtonEnable,
        );
      }else{
        return buildBattery(
          context,
          bgCard,
          battery!.id!,
          battery!.soc!.toInt(),
          battery!.soh!.toInt(),
          battery!.temperature!.toInt(),
          levelBattery,
          battery!.voltage!.toInt(),
          textCharging(colorTextCharging),
          'battery is charging',
          MdiIcons.batteryCharging,
          colorTextCharging,
          greyButton,
        );
      }
    }
    if (status == 'Stop Charge') {
      return buildBattery(
        context,
        bgCard,
        battery!.id!,
        battery!.soc!.toInt(),
        battery!.soh!.toInt(),
        battery!.temperature!.toInt(),
        levelBattery,
        battery!.voltage!.toInt(),
        textStopCharging(colorTextCharging),
        'battery is stop charging',
        MdiIcons.cancel,
        colorTextCharging,
        greyButton,
      );
    }
    if (battery!.status! == 'NG') {
      return buildBattery(
        context,
        bgCard,
        battery!.id!,
        0,
        0,
        0,
        levelBattery,
        0,
        textNG(redText),
        'battery does not work',
        MdiIcons.batteryRemove,
        colorTextCharging,
        greyButton,
      );
    }
    if (battery!.status! == 'Vacant') {
      return buildCardVacant(
        context,
        battery!.id!,
        bgCard,
      );
    }
    return Container(
      color: CustomColors.bgColor,
    );
  }

  Card buildBattery(
      BuildContext context,
      Color bgCard,
      int id,
      int soc,
      int soh,
      int temp,
      int level,
      int voltage,
      Widget status,
      String description,
      IconData iconStatus,
      Color colorText,
      Color colorButton,
      ) {
    return Card(
      color: bgCard,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$id',
                  style: const TextStyle(
                    fontSize: 12,
                    color: CustomColors.textCardBattery,
                  ),
                  textAlign: TextAlign.left,
                ),
                const Text(
                  'Battery info',
                  style: TextStyle(
                    fontSize: 12,
                    color: CustomColors.textCardBattery,
                  ),
                  textAlign: TextAlign.left,
                ),
                const Text(
                  '',
                  style: TextStyle(
                    fontSize: 12,
                    color: CustomColors.textCardBattery,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 50,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Positioned(
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            boxShadow: [
                              BoxShadow(
                                color: CustomColors.textCardBattery.withOpacity(0.6),
                                spreadRadius: 10,
                                blurRadius: 40,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        child: Image.asset(
                          Asset.ICON_BATTERY_BASE,
                          // scale: 12,
                        ),
                      ),
                      if (battery!.status == 'NG') ...[
                        //todo
                      ] else ...[
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 14,
                            bottom: 8.5,
                            left: 4.5,
                            right: 4.5,
                          ),
                          child: LiquidLinearProgressIndicator(
                            value: (level.toDouble()) / 100,
                            valueColor:
                            const AlwaysStoppedAnimation(CustomColors.primaryColor),
                            backgroundColor: Colors.transparent,
                            borderColor: Colors.transparent,
                            borderWidth: 0.0,
                            borderRadius: 0.0,
                            direction: Axis.vertical,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        '$soc%',
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'TAHOMAB0',
                          color: CustomColors.textCardBattery,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.bolt,
                          size: 20,
                          color: CustomColors.textCardBattery,
                        ),
                        Column(
                          children: [
                            Text(
                              '${voltage}V',
                              style: const TextStyle(
                                fontSize: 14,
                                color: CustomColors.textCardBattery,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const Text(
                              'Voltage',
                              style: TextStyle(
                                fontSize: 12,
                                color: CustomColors.textCardBattery,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 5),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    status,
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CustomColors.textCardBattery,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      const Icon(
                        MdiIcons.thermometer,
                        size: 20,
                        color: CustomColors.textCardBattery,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '$temp °C',
                        style: const TextStyle(
                          fontSize: 12,
                          color: CustomColors.textCardBattery,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      const Icon(
                        MdiIcons.medicalBag,
                        size: 20,
                        color: CustomColors.textCardBattery,
                      ),
                      const SizedBox(width: 5),
                      if (soh < 50) ...[
                        const Text(
                          'poor',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ] else ...[
                        const Text(
                          'Good',
                          style: TextStyle(
                            fontSize: 12,
                            color: CustomColors.textCardBattery,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                child: const Text(
                  'Book',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'TAHOMAB0',
                    color: Colors.white,
                  ),
                ),
                onPressed: onPress,
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(colorButton),
                  foregroundColor:
                  MaterialStateProperty.all<Color>(CustomColors.textCardBattery),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildCardVacant(
      BuildContext context,
      int id,
      Color bgCard,
      ) {
    return Card(
      color: bgCard,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$id',
                style: const TextStyle(
                  fontSize: 12,
                  color: CustomColors.textCardBattery,
                ),
                textAlign: TextAlign.left,
              ),
              const Text(
                "Empty!",
                style: TextStyle(
                  fontSize: 25,
                  color: CustomColors.textCardBattery,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                "Slot this vacant, don't have battery",
                style: TextStyle(
                  fontSize: 12,
                  color: CustomColors.textCardBattery,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textCharging(Color colorText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Charging',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'TAHOMAB0',
            color: colorText,
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
                  fontFamily: 'TAHOMAB0',
                  color: colorText,
                ),
              ),
              Text(
                '.',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'TAHOMAB0',
                  color: colorText,
                ),
              ),
              Text(
                '..',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'TAHOMAB0',
                  color: colorText,
                ),
              ),
              Text(
                '...',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'TAHOMAB0',
                  color: colorText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget textStopCharging(Color colorText) {
    return Text(
      'Stop Charge',
      style: TextStyle(
        fontSize: 18,
        fontFamily: 'TAHOMAB0',
        color: colorText,
      ),
    );
  }

  Widget textReady(Color colorText) {
    return Row(
      children: [
        const Icon(
          MdiIcons.batteryCheck,
          size: 20,
          color: CustomColors.textCardBattery,
        ),
        const SizedBox(width: 2),
        Text(
          'Ready',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'TAHOMAB0',
            color: colorText,
          ),
        ),
      ],
    );
  }

  Widget textBooked(Color colorText) {
    return Text(
      'Booked',
      style: TextStyle(
        fontSize: 18,
        fontFamily: 'TAHOMAB0',
        color: colorText,
      ),
    );
  }

  Widget textNG(Color colorText) {
    return Text(
      'Error',
      style: TextStyle(
        fontSize: 18,
        fontFamily: 'TAHOMAB0',
        color: colorText,
      ),
    );
  }
}
