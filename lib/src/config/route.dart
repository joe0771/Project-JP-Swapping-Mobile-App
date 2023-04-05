import 'package:battery_swap_station/src/pages/pages.dart';
import 'package:flutter/cupertino.dart';

class Route {
  static const swap = '/swap';
  static const login = '/login';
  static const register = '/register';
  static const mapStation = '/map';
  static const management = '/management';
  static const booking = '/booking';
  static const profile = '/profile';
  static const navigation = '/navigation';
  static const credit = '/credit';
  static const home = '/home';

  static Map<String, WidgetBuilder> getAll() => _route;

  static final Map<String, WidgetBuilder> _route = {
    login: (context) =>  const LoginPage(),
    register: (context) =>  const RegPage(),
    mapStation: (context) =>  const MapStationPage(),
    swap: (context) =>  const SwapPage(),
    profile: (context) =>  const ProfilePage(),
    navigation: (context) =>  const NavigationPage(indexPage: 0),
    credit: (context) =>  const CreditPage(),
    home: (context) =>  const HomePage(),
  };
}
