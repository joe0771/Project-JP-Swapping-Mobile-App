import 'package:battery_swap_station/src/constants/color.dart';
import 'package:battery_swap_station/src/models/return_status_model.dart';
import 'package:battery_swap_station/src/widgets/dialogs/dialog_confirm_awesome.dart';
import 'package:battery_swap_station/src/widgets/dialogs/dialog_error_awesome.dart';
import 'package:battery_swap_station/src/widgets/dialogs/dialog_rating_awesome.dart';
import 'package:battery_swap_station/src/widgets/dialogs/dialog_success_awesome.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:battery_swap_station/src/models/booking_model.dart';
import 'package:battery_swap_station/src/models/cr_code_model.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:battery_swap_station/src/models/data_booked_model.dart';
import 'package:battery_swap_station/src/services/network_service.dart';
import 'package:battery_swap_station/src/widgets/dialogs/dialog_loading.dart';

class SwapPage extends StatefulWidget {
  const SwapPage({Key? key}) : super(key: key);

  @override
  State<SwapPage> createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> {
  late Future<DataBookedModel?> dataBookedAll;
  String station = '';
  String scanQRCode = '';

  Future<void> refreshFuture() async {
    setState(() {
      dataBookedAll = NetworkService().fetchDataBooked();
    });
  }

  @override
  void initState() {
    super.initState();
    dataBookedAll = NetworkService().fetchDataBooked();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.grey.shade50,
      body: FutureBuilder<DataBookedModel?>(
        future: dataBookedAll,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DataBookedModel? dataBooked = snapshot.data;
            if (dataBooked!.id == '') {
              return RefreshIndicator(
                onRefresh: refreshFuture,
                child: _buildCardNotData(),
              );
            }
            return RefreshIndicator(
              onRefresh: refreshFuture,
              child: _buildCardHaveData(dataBooked),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Service error ...',
                style: TextStyle(
                  fontSize: 18.0,
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

  _buildCardNotData() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: const [
            ListTile(
              title: Text(
                "Don't have data booking!",
                style: TextStyle(
                  fontSize: 18.0,
                  color: CustomColors.textCardBattery,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 10.0,
                right: 10.0,
              ),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  "You don't have a battery booked. Please book the battery to swap the battery at your booked station.",
                  style: TextStyle(
                    fontSize: 14,
                    color: CustomColors.textCardBattery,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildCardHaveData(DataBookedModel dataAll) {
    final dataUser = dataAll;
    int endTime = dataUser.bookingTime!;
    String? station = dataUser.station;
    String? user = dataUser.bookingBy;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                leading: Icon(
                  Icons.check_circle,
                  color: CustomColors.primaryColor,
                  size: 35.0,
                ),
                title: Text(
                  'Booking success',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: CustomColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                ),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'OTP code for swap battery',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: CustomColors.textCardBattery,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                dataUser.secretCode!,
                style: const TextStyle(
                  fontSize: 45.0,
                  letterSpacing: 10.0,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.textCardBattery,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Expire in',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: CustomColors.textCardBattery,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 20.0),
                    CountdownTimer(
                      endTime: endTime,
                      widgetBuilder: (_, time) {
                        if (time == null) {
                          return const Text(
                            '00 : 00',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.red,
                            ),
                          );
                        } else {
                          if (time.min == null) {
                            return Text(
                              '${'00'} : ${time.sec.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: CustomColors.textCardBattery,
                              ),
                            );
                          } else {
                            return Text(
                              '${time.min.toString().padLeft(2, '0')} : ${time.sec.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.blue,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                ),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.supervised_user_circle_rounded,
                  color: CustomColors.textCardBattery,
                  size: 35,
                ),
                title: Text(
                  dataUser.bookingBy.toString(),
                  style: const TextStyle(
                    color: CustomColors.textCardBattery,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  top: 10.0,
                ),
                child: Row(
                  children: <Widget>[
                    const Text(
                      'Station',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.textCardBattery),
                    ),
                    const Spacer(), // use Spacer
                    Text(
                      dataUser.station!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: CustomColors.textCardBattery,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  top: 10.0,
                ),
                child: Row(
                  children: <Widget>[
                    const Text(
                      'Battery No.',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.textCardBattery),
                    ),
                    const Spacer(), // use Spacer
                    Text(
                      'Battery ${dataUser.batteryId}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: CustomColors.textCardBattery,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  top: 10.0,
                ),
                child: Row(
                  children: <Widget>[
                    const Text(
                      'Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: CustomColors.textCardBattery,
                      ),
                    ),
                    const Spacer(), // use Spacer
                    Text(
                      dataUser.createdAt.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: CustomColors.textCardBattery,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 10.0,
                  left: 10.0,
                  right: 10.0,
                ),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    'Please keep the battery swap code secret.',
                    style: TextStyle(
                      fontSize: 12,
                      color: CustomColors.textCardBattery,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  child: const Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      'Scan now',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor,
                    primary: CustomColors.primaryColor,
                    onSurface: CustomColors.primaryColor,
                    side: const BorderSide(
                        color: CustomColors.primaryColor, width: 2),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                  ),
                  onPressed: () async {
                    scanQR(station, user);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  child: const Padding(
                    padding: EdgeInsets.all(5),
                    child: Text('Cancel',
                        style: TextStyle(
                            color: CustomColors.primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                  ),
                  style: TextButton.styleFrom(
                    primary: CustomColors.primaryColor,
                    onSurface: CustomColors.primaryColor,
                    side: const BorderSide(
                        color: CustomColors.primaryColor, width: 2),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                  ),
                  onPressed: () async {
                    dialogConfirmAwesome(
                      context,
                      'Cancel booking!',
                      'Are you sure you want to \n cancel booking?',
                      () async {
                        try {
                          final BookingModel? cancelBooked =
                              await NetworkService().postCancelBooking(
                                  dataUser.batteryId!.toInt(),
                                  dataUser.station.toString());

                          if (cancelBooked!.success == true) {
                            await dialogSuccessAwesome(
                              context,
                              'Success!',
                              cancelBooked.message.toString(),
                              () {},
                            );
                            setState(() {
                              refreshFuture();
                            });
                          } else {
                            await dialogErrorAwesome(
                              context,
                              'Fail!',
                              cancelBooked.message.toString(),
                              () {},
                            );
                            setState(() {
                              refreshFuture();
                            });
                          }
                        } on Exception catch (e) {
                          await dialogErrorAwesome(
                            context,
                            'Fail!',
                            'Error process',
                            () {},
                          );
                          setState(() {
                            refreshFuture();
                          });
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> scanQR(String? station, String? user) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Close', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    scanQRCode = barcodeScanRes;
    print('scanQRCode >>>>>>>>>>>>>>>>>>>>>>>' + scanQRCode);
    if (scanQRCode == '-1') {
      //todo
    } else {
      dialogLoading('Payment ...');
      final QrCodeModel? scanQR =
          await NetworkService().fetchQRCode(barcodeScanRes);
      if (scanQR!.success == true) {
        // Get.back();
        dismissLoading();
        await dialogSuccessAwesome(context, 'Success!', scanQR.message, (){});
        setState(() {
          refreshFuture();
        });
        // dialogRatingAwesome(
        //   context,
        //   station!,
        //   user!,
        //   () {
        //   },
        // );
      } else {
        // Get.back();
        dismissLoading();
        dialogErrorAwesome(context, 'Fail!', scanQR.message, () {});
        setState(() {
          refreshFuture();
        });
      }
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Swap Battery',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.refresh_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            refreshFuture();
          },
        ),
      ],
      backgroundColor: CustomColors.primaryColor,
    );
  }

  void dismissLoading() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

}
