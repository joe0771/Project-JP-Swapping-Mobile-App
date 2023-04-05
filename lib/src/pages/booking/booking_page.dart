import 'dart:async';
import 'dart:developer';
import 'package:battery_swap_station/src/pages/booking/widgets/normal_battery_items.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:battery_swap_station/src/constants/color.dart';
import 'package:battery_swap_station/src/models/booking_model.dart';
import 'package:battery_swap_station/src/services/network_service.dart';
import 'package:battery_swap_station/src/models/station_all_model.dart';
import 'package:battery_swap_station/src/widgets/dialogs/dialog_error_awesome.dart';
import 'package:battery_swap_station/src/pages/navigation/navigation_pages.dart';
import 'package:battery_swap_station/src/pages/booking/widgets/smart_battery_items.dart';
import 'package:battery_swap_station/src/widgets/dialogs/dialog_confirm_awesome.dart';
import 'package:battery_swap_station/src/widgets/dialogs/dialog_loading.dart';

class BookingPage extends StatefulWidget with WidgetsBindingObserver {
  const BookingPage({
    Key? key,
    required this.stationId,
    required this.stationName,
    required this.address,
    required this.batteryType,
  }) : super(key: key);

  final String stationId;
  final String stationName;
  final String address;
  final String batteryType;

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> with WidgetsBindingObserver {
  AppLifecycleState? _lastLifecycleState;
  late Future<List<Battery?>> future;
  StreamSubscription? _subscriptionBattery;
  bool loopBattery = true;

  Stream<List<Battery>?> batteryStream() async* {
    while (loopBattery) {
      _subscriptionBattery = await Future.delayed(const Duration(milliseconds: 2000));
      List<Battery>? battery = await NetworkService().fetchBatteryListByStation(widget.stationId);
      yield battery;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _subscriptionBattery?.cancel();
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (AppLifecycleState.paused == state) {
      loopBattery = false;
      _subscriptionBattery?.pause();
    }
    if (AppLifecycleState.resumed == state) {
      loopBattery = true;
      _subscriptionBattery?.resume();
    }
    setState(() {
      _lastLifecycleState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: CustomColors.bgColor,
      body: StreamBuilder(
        stream: batteryStream(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            List<Battery>? battery = snapshot.data;
            if (battery == null || battery.isEmpty) {
              return const Center(
                child: Text(
                  'Not have data !',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              );
            }
            return _buildBatteryGridView(battery, widget.batteryType);
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                ' Error data !',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  _buildBatteryGridView(List<Battery> batteryData, String batteryType) {
    final batteryList = batteryData;

    if (batteryType == "Smart") {
      return Container(
        color: CustomColors.bgColor,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: GridView.builder(
            shrinkWrap: true,
            // scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              crossAxisCount: 2,
              mainAxisExtent: 320,
              // childAspectRatio: 0.6,
            ),
            itemBuilder: (context, index) => LayoutBuilder(
              builder: (context, BoxConstraints constraints) {
                final product = batteryList[index];
                return SmartBatteryItems(
                  status: product.status,
                  isBooking: product.isBooking,
                  battery: product,
                  onPress: () {
                    if (product.status == 'Ready' && product.isBooking == false ||
                        product.status == 'Charging' && product.soc! >= 50) {
                      dialogConfirmAwesome(
                        context,
                        'Booking Battery?',
                        'Would you like to booking battery ${product.id}',
                            () async {
                          //todo
                          log('Battery >>>>>> ${product.id}');
                          dialogLoading('Booking ...');
                          try {
                            BookingModel? dataBody = await NetworkService()
                                .postBookingBattery(
                                product.id!, widget.stationId);

                            if (dataBody?.success == true) {
                              Get.back();
                              dismissLoading();
                              _subscriptionBattery?.cancel();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const NavigationPage(indexPage: 1),
                                ),
                              );
                            }
                            if (dataBody?.success == false &&
                                dataBody?.error == false) {
                              Get.back();
                              dismissLoading();
                              dialogErrorAwesome(
                                context,
                                'Fail!',
                                dataBody!.message.toString(),
                                    () {},
                              );
                            }
                            if (dataBody?.success == false &&
                                dataBody?.error == true) {
                              Get.back();
                              dismissLoading();
                              dialogErrorAwesome(
                                context,
                                'Fail!',
                                dataBody!.message.toString(),
                                    () {},
                              );
                            }
                          } on Exception catch (e) {
                            Get.back();
                            dismissLoading();
                            await dialogErrorAwesome(
                              context,
                              'Fail!',
                              'Error internet not connect',
                                  () {},
                            );
                          }
                        },
                      );
                    } else {
                      log('Battery >>>>>> Null');
                    }
                  },
                );
              },
            ),
            itemCount: batteryList.length,
          ),
        ),
      );
    }  else{
      return Container(
        color: CustomColors.bgColor,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) =>
                LayoutBuilder(
                  builder: (context, BoxConstraints constraints) {
                    final product = batteryList[index];
                    return NormalBatteryItems(
                      status: product.status,
                      isBooking: product.isBooking,
                      battery: product,
                      onPress: () {
                        if (product.status == 'Ready' &&
                            product.isBooking == false ||
                            product.status == 'Charging' && product.soc! >= 50) {
                          dialogConfirmAwesome(
                            context,
                            'Booking Battery?',
                            'Would you like to booking battery ${product.id}',
                                () async {
                              //todo
                              log('Battery >>>>>> ${product.id}');
                              dialogLoading('Booking ...');
                              try {
                                BookingModel? dataBody = await NetworkService()
                                    .postBookingBattery(
                                    product.id!, widget.stationId);

                                if (dataBody?.success == true) {
                                  Get.back();
                                  dismissLoading();
                                  _subscriptionBattery?.cancel();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const NavigationPage(indexPage: 1),
                                    ),
                                  );
                                }
                                if (dataBody?.success == false &&
                                    dataBody?.error == false) {
                                  Get.back();
                                  dismissLoading();
                                  dialogErrorAwesome(
                                    context,
                                    'Fail!',
                                    dataBody!.message.toString(),
                                        () {},
                                  );
                                }
                                if (dataBody?.success == false &&
                                    dataBody?.error == true) {
                                  Get.back();
                                  dismissLoading();
                                  dialogErrorAwesome(
                                    context,
                                    'Fail!',
                                    dataBody!.message.toString(),
                                        () {},
                                  );
                                }
                              } on Exception catch (e) {
                                Get.back();
                                dismissLoading();
                                await dialogErrorAwesome(
                                  context,
                                  'Fail!',
                                  'Error internet not connect',
                                      () {},
                                );
                              }
                            },
                          );
                        } else {
                          log('Battery >>>>>> Null');
                        }
                      },
                    );
                  },
                ),
            itemCount: batteryList.length,
          ),
        ),
      );
    }
  }

  void dismissLoading() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        widget.stationName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      backgroundColor: CustomColors.primaryColor,
    );
  }
}
