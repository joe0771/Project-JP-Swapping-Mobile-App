import 'package:battery_swap_station/src/pages/login/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/route_manager.dart';

const storage = FlutterSecureStorage();

Future<void> logOut() async {
  await storage.deleteAll();
  Get.offAll(const LoginPage());
}
