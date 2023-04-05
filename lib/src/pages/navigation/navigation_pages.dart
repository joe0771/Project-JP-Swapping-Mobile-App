import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:battery_swap_station/src/pages/pages.dart';
import 'package:battery_swap_station/src/constants/color.dart';
import 'package:battery_swap_station/src/widgets/dialogs/dialog_error.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key, required this.indexPage}) : super(key: key);
  final int indexPage;

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  late int currentIndex = widget.indexPage;

  late StreamSubscription subscription;

  final screen = [
    const MapStationPage(),
    const SwapPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void checkStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      await dialogError('Your internet has a problem.');
    }else{
      dismissLoading();
    }
  }

  void dismissLoading() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  @override
  void initState() {
    super.initState();
    checkStatus();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.none) {
        await dialogError('Internet disconnected');
      }else{
        dismissLoading();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentIndex != 0) {
          setState(() {
            currentIndex--;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: screen,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 25,
          backgroundColor: CustomColors.primaryColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedFontSize: 15,
          unselectedFontSize: 14,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on_rounded),
              label: 'Station',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bolt),
              label: 'Swap',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle_rounded),
              label: 'Profile',
            ),
          ],
          currentIndex: currentIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
