import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:battery_swap_station/src/constants/asset.dart';
import 'package:battery_swap_station/src/constants/color.dart';
import 'package:battery_swap_station/src/services/network_service.dart';
import 'package:battery_swap_station/src/models/station_all_model.dart';
import 'package:battery_swap_station/src/pages/booking/booking_page.dart';
import 'package:battery_swap_station/src/config/theme.dart' as custom_theme;

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;

class MapStationPage extends StatelessWidget {
  const MapStationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jinpao Battery Swap Station',
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late Position userLocation;
  late GoogleMapController mapController;
  late BitmapDescriptor markerGreen;
  late BitmapDescriptor markerGrey;

  late Permission permission;
  PermissionStatus permissionStatus = PermissionStatus.denied;

  List<StationAllModel?> stationList = [];
  List<Marker> myMarker = [];

  int? markerFlag;

  void listenForPermission() async {
    final status = await Permission.locationWhenInUse.status;
    setState(() {
      permissionStatus = status;
    });
    switch (status) {
      case PermissionStatus.denied:
        requestForPermission();
        break;
      case PermissionStatus.granted:
        //todo
        break;
      case PermissionStatus.limited:
        Navigator.pop(context);
        break;
      case PermissionStatus.restricted:
        Navigator.pop(context);
        break;
      case PermissionStatus.permanentlyDenied:
        Navigator.pop(context);
        break;
    }
  }

  Future<void> requestForPermission() async {
    final status = await Permission.location.request();
    setState(() {
      permissionStatus = status;
    });
  }

  Future<void> permissionLocation() async {
    if (Platform.isAndroid) {
      var status = await Permission.locationWhenInUse.status;
      if (status.isGranted) {
        print('Location Granted =======================');
      } else if (status.isDenied) {
        await Permission.location.request();
        print('Location Denied ========================');
      } else {
        print('Location Error =========================');
      }
    }

    // if (Platform.isAndroid) {
    //   var status = await Permission.locationWhenInUse.status;
    //   if (status.isGranted) {
    //     //todo
    //     print('Location Granted ======================');
    //   } else if (status.isDenied) {
    //
    //     //todo
    //     // requestForPermission();
    //     print('Location Denied  ======================');
    //     // showAllowDialog();
    //     showDialog(
    //       context: context,
    //       builder: (BuildContext context) => CupertinoAlertDialog(
    //         title: const Text('Location Permission'),
    //         content: const Text(
    //             "This app needs access to your location for you to locate Jinpao Precision Industry's battery swap station on a map near you."),
    //         actions: <Widget>[
    //           CupertinoDialogAction(
    //             child: const Text('Deny'),
    //             onPressed: () => Get.back(),
    //           ),
    //           CupertinoDialogAction(
    //             child: const Text('Settings'),
    //             onPressed: () {
    //               Get.back();
    //               openAppSettings();
    //             },
    //           ),
    //         ],
    //       ),
    //     );
    //   } else {
    //     requestForPermission();
    //     print('Location Error   ======================');
    //     showDialog(
    //       context: context,
    //       builder: (BuildContext context) => CupertinoAlertDialog(
    //         title: const Text('Location Permission'),
    //         content: const Text(
    //             "This app needs access to your location for you to locate Jinpao Precision Industry's battery swap station on a map near you."),
    //         actions: <Widget>[
    //           CupertinoDialogAction(
    //             child: const Text('Deny'),
    //             onPressed: () => Get.back(),
    //           ),
    //           CupertinoDialogAction(
    //             child: const Text('Settings'),
    //             onPressed: () {
    //               Get.back();
    //               openAppSettings();
    //             },
    //           ),
    //         ],
    //       ),
    //     );
    //   }
    // }

    if (Platform.isIOS) {
      var status = await Permission.locationWhenInUse.status;
      if (status.isGranted) {
        //todo
      } else if (status.isDenied) {
        //todo
        // showAllowDialog();
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: const Text('Location Permission'),
            content: const Text(
                "This app needs access to your location for you to locate Jinpao Precision Industry's battery swap station on a map near you."),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('Deny'),
                onPressed: () => Get.back(),
              ),
              CupertinoDialogAction(
                child: const Text('Settings'),
                onPressed: () {
                  Get.back();
                  openAppSettings();
                },
              ),
            ],
          ),
        );
      }
    }
  }

  void customMarkerGreen() {
    if (Platform.isAndroid) {
      BitmapDescriptor.fromAssetImage(const ImageConfiguration(),
              'assets/images/icon_marker_mobile_a_true.png')
          .then((value) => {markerGreen = value});
    } else {
      BitmapDescriptor.fromAssetImage(const ImageConfiguration(),
              'assets/images/icon_marker_iphone_true.png')
          .then((value) => {markerGreen = value});
    }
  }

  void customMarkerGrey() {
    if (Platform.isAndroid) {
      BitmapDescriptor.fromAssetImage(const ImageConfiguration(),
              'assets/images/icon_marker_mobile_a_false.png')
          .then((value) => {markerGrey = value});
    } else {
      BitmapDescriptor.fromAssetImage(const ImageConfiguration(),
              'assets/images/icon_marker_iphone_false.png')
          .then((value) => {markerGrey = value});
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Position> _getLocation() async {
    try {
      userLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            userLocation.latitude,
            userLocation.longitude,
          ),
          16,
        ),
      );
    } catch (e) {
      userLocation;
    }
    return userLocation;
  }

  Future<void> getStationLocation() async {
    final list = await NetworkService.fetchStation();

    if (mounted) {
      setState(() {
        stationList = list;
      });
    }
    _setStationMarker();
  }

  _setStationMarker() {
    for (var item in stationList) {
      Iterable<Battery> filteredBattery = item!.battery!
          .where((val) => val.status == 'Ready' && val.isBooking == false || val.status == 'Charging' && val.soc >= 50 && val.isBooking == false)
          .toList();
      int batterySwappable = filteredBattery.length;

      String batteryType = item.batteryType!;

      if (item.latitude != null && item.longitude != null) {
        setState(
          () {
            if (item.statusStation == false || item.statusBattery == false) {
              myMarker.add(
                Marker(
                  markerId: MarkerId(item.id!),
                  position: LatLng(item.latitude!, item.longitude!),
                  icon: markerGrey,
                  onTap: () {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      backgroundColor: Colors.white,
                      context: context,
                      barrierColor: Colors.transparent,
                      builder: ((builder) => bottomSheetNotReady(
                            item.stationId!,
                            item.stationName!,
                            item.address!,
                            batterySwappable,
                            batteryType,
                          )),
                    );
                  },
                ),
              );
            } else {
              myMarker.add(
                Marker(
                  markerId: MarkerId(item.id!),
                  position: LatLng(item.latitude!, item.longitude!),
                  icon: markerGreen,
                  onTap: () {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      backgroundColor: Colors.white,
                      context: context,
                      barrierColor: Colors.transparent,
                      builder: ((builder) => bottomSheetReady(
                            item.stationId!,
                            item.stationName!,
                            item.address!,
                            item.battery!,
                            batterySwappable,
                            batteryType,
                          )),
                    );
                  },
                ),
              );
            }
          },
        );
      }
    }
  }

  @override
  void initState() {
    permissionLocation();
    getStationLocation();
    customMarkerGreen();
    customMarkerGrey();
    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: FutureBuilder(
        future: _getLocation(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              markers: Set.from(myMarker),
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  userLocation.latitude,
                  userLocation.longitude,
                ),
                zoom: CAMERA_ZOOM,
                // tilt: CAMERA_TILT,
                bearing: CAMERA_BEARING,
              ),
              zoomGesturesEnabled: true,
              tiltGesturesEnabled: false,
              // onCameraMove: (CameraPosition userLocation) {},
            );
          } else {
            return GoogleMap(
                markers: Set.from(myMarker),
                initialCameraPosition: const CameraPosition(
                    target: LatLng(
                      13.736717,
                      100.523186,
                    ),
                    // tilt: CAMERA_TILT,
                    zoom: 6.5),
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                minMaxZoomPreference: const MinMaxZoomPreference(6, 20));
          }
        },
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
        title: const Text(
          'Swap Station',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              getStationLocation();
              customMarkerGreen();
              customMarkerGrey();
            },
          ),
        ],
        backgroundColor: CustomColors.primaryColor,
        centerTitle: true,
      );

  bottomSheetReady(
    String stationId,
    String stationName,
    String address,
    List<Battery> battery,
    int batterySwappable,
    String batteryType,
  ) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Image border
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(25), // Image radius
                    child: Image.asset(Asset.BG_JINPAO, fit: BoxFit.cover),
                  ),
                ),
                title: Row(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.access_time_rounded,
                              color: Colors.deepOrangeAccent,
                              size: 15,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Open',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.deepOrangeAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.bolt,
                              color: Colors.green,
                              size: 15,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '$batterySwappable Battery swappable',
                              style: const TextStyle(
                                fontSize: 10,
                                color: CustomColors.buttonColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  stationName,
                  style: const TextStyle(
                    color: CustomColors.textTherm,
                    fontSize: 14,
                    fontFamily: 'TAHOMAB0',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: CustomColors.textTherm,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          address,
                          style: const TextStyle(
                            fontSize: 10,
                            color: CustomColors.textTherm,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: const [
                      Icon(
                        Icons.timer,
                        color: CustomColors.textTherm,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          'Everyday, 10:00-21:00',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children:  [
                      const Icon(
                        Icons.battery_charging_full,
                        color: CustomColors.textTherm,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Row(
                          children:  [
                            const Text(
                              'Battery type : ',
                              style: TextStyle(
                                fontSize: 10,
                                color: CustomColors.textTherm,
                              ),
                            ),
                            if (batteryType == "Smart")...[
                             const Text(
                                'Smart',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.primaryColor,
                                ),
                              ),
                            ] else...[
                              const Text(
                                'Normal',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.textTherm,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 5,
                bottom: 5,
                left: 15,
                right: 15,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      child: const Padding(
                        padding: EdgeInsets.all(2),
                        child: Text('Close',
                            style: TextStyle(
                                color: CustomColors.buttonColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      ),
                      style: TextButton.styleFrom(
                        primary: CustomColors.buttonColor,
                        onSurface: CustomColors.buttonColor,
                        side: const BorderSide(
                            color: CustomColors.buttonColor, width: 2),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                      ),
                      onPressed: () async {
                        // Get.back();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      child: const Padding(
                        padding: EdgeInsets.all(2),
                        child: Text(
                          'Book Now',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: CustomColors.buttonColor,
                        primary: CustomColors.buttonColor,
                        onSurface: CustomColors.buttonColor,
                        side: const BorderSide(
                            color: CustomColors.buttonColor, width: 2),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => BookingPage(
                              stationId: stationId,
                              stationName: stationName,
                              address: address,
                              batteryType: batteryType,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheetNotReady(
    String stationId,
    String stationName,
    String address,
    int batterySwappable,
    String batteryType,
  ) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Image border
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(25), // Image radius
                    child: Image.asset(Asset.BG_JINPAO, fit: BoxFit.cover),
                  ),
                ),
                title: Row(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.access_time_rounded,
                              color: CustomColors.textTherm,
                              size: 15,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Close',
                              style: TextStyle(
                                fontSize: 10,
                                color: CustomColors.textTherm,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.bolt,
                              color: CustomColors.textTherm,
                              size: 15,
                            ),
                            SizedBox(width: 5),
                            Text(
                              '0 Battery swappable',
                              style: TextStyle(
                                fontSize: 10,
                                color: CustomColors.textTherm,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  stationName,
                  style: const TextStyle(
                    color: CustomColors.textTherm,
                    fontSize: 14,
                    fontFamily: 'TAHOMAB0',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: CustomColors.textTherm,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          address,
                          style: const TextStyle(
                            fontSize: 10,
                            color: CustomColors.textTherm,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: const [
                      Icon(
                        Icons.timer,
                        color: CustomColors.textTherm,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          'Everyday, 10:00-21:00',
                          style: TextStyle(
                            fontSize: 10,
                            color: CustomColors.textTherm,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children:  [
                      const Icon(
                        Icons.battery_charging_full,
                        color: CustomColors.textTherm,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Row(
                          children:  [
                            const Text(
                              'Battery type : ',
                              style: TextStyle(
                                fontSize: 10,
                                color: CustomColors.textTherm,
                              ),
                            ),
                            if (batteryType == "Smart")...[
                              const Text(
                                'Smart',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.primaryColor,
                                ),
                              ),
                            ] else...[
                              const Text(
                                'Normal',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.textTherm,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 5,
                bottom: 5,
                left: 15,
                right: 15,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      child: const Padding(
                        padding: EdgeInsets.all(2),
                        child: Text('Close',
                            style: TextStyle(
                                color: CustomColors.textTherm,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      ),
                      style: TextButton.styleFrom(
                        primary: CustomColors.textTherm,
                        onSurface: Colors.blue,
                        side: const BorderSide(
                            color: CustomColors.textTherm, width: 2),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                      ),
                      onPressed: () async {
                        // Get.back();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAllowDialog() {
    Get.defaultDialog(
      title: '',
      titlePadding: const EdgeInsets.all(5),
      radius: 10,
      content: Column(
        children: const [
          Icon(Icons.location_on_rounded),
          SizedBox(height: 15),
          Text(
            "Allow to access this device's location?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: Text(
              "This app needs access to your location for you to locate Jinpao Precision Industry's battery swap station on a map near you.",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
      cancel: TextButton(
        onPressed: () {
          openAppSettings();
        },
        child: const Text(
          "Don't allow   ",
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.red,
          ),
        ),
      ),
      confirm: TextButton(
        onPressed: () async {
          Get.back();
          openAppSettings();
        },
        child: const Text(
          '   Allow in setting',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }

  void dismissDialog() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
}
