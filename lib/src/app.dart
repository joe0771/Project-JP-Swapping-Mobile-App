import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:battery_swap_station/src/pages/pages.dart';
import 'package:battery_swap_station/src/constants/asset.dart';
import 'package:battery_swap_station/src/constants/color.dart';
import 'package:battery_swap_station/src/constants/setting.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:battery_swap_station/src/config/route.dart' as custom_route;

// Create storage
const storage = FlutterSecureStorage();

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late Future<String> future;

  Future<String> initApp() async {
    await Future.delayed(const Duration(seconds: 2));
    String value = await storage.read(key: Setting.TOKEN_STORAGE) ?? '';
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      routes: custom_route.Route.getAll(),
      title: 'Battery Swap Station',
      theme: ThemeData(
        fontFamily: 'TAHOMA',
        primaryColor: CustomColors.primaryColor,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: CustomColors.textTherm,
          displayColor: CustomColors.textTherm,
        ),
        colorScheme: ThemeData().colorScheme.copyWith(
          primary: CustomColors.primaryColor,
        ),


      ),
      home: FutureBuilder<String>(
        future: initApp(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final token = snapshot.data;
            if (token!.isNotEmpty) {
              return const NavigationPage(indexPage: 0);
            }
            return const LoginPage();
          }
          return const SplashScreen();
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Image.asset(
            Asset.LOGO_JINPAO,
            height: 80,
          ),
        ),
      ),
    );
  }
}
