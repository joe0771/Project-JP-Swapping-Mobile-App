import 'package:battery_swap_station/src/models/battery_model.dart';
import 'package:battery_swap_station/src/models/return_status_model.dart';
import 'package:dio/dio.dart';
import 'package:battery_swap_station/src/models/booking_model.dart';
import 'package:battery_swap_station/src/models/cr_code_model.dart';
import 'package:battery_swap_station/src/models/data_booked_model.dart';
import 'package:battery_swap_station/src/models/login_model.dart';
import 'package:battery_swap_station/src/models/profile_model.dart';
import 'package:battery_swap_station/src/models/register_model.dart';
import 'package:battery_swap_station/src/services/api_base.dart';
import 'package:battery_swap_station/src/utils/pretty_print.dart';
import 'package:battery_swap_station/src/models/station_all_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class NetworkService {
  NetworkService._internal();
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;

  static Future<List<StationAllModel?>> fetchStation() async {
    try {
      Response response = await API_BASE.get('api/station=all');
      List json = response.data;
      List<StationAllModel> list = [];
      list = json.map((data) => StationAllModel.fromJson(data)).toList();
      return list;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Battery>> fetchBatteryListByStation(String station) async {
    try {
      Response response = await API_BASE.get('api/station=$station');
      Map<String, dynamic> mapJson = response.data;
      List<dynamic> dataBattery = mapJson["battery"];
      final battery = dataBattery.map((B) => Battery.fromJson(B)).toList();
      return battery;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<BookingModel?> postBookingBattery(
    int batteryId,
    String station,
  ) async {
    Map<String, Map<String, dynamic>> body = {
      'data': {
        'stationId': station,
        'booking': batteryId,
      }
    };
    try {
      Response response = await API_BASE.post('api/booking', data: body);
      return BookingModel.fromJson(response.data);
    } on DioError catch (e) {
      if (e.response!.statusCode! == 400) {
        return BookingModel.fromJson(e.response!.data);
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
    return null;
  }

  Future<QrCodeModel?> fetchQRCode(String qrCode) async {
    try {
      Response response = await API_BASE.get('api/bookingHistory/payment/$qrCode');
      return QrCodeModel.fromJson(response.data);
    } on DioError catch (e) {
      if (e.response!.statusCode! == 400) {
        return QrCodeModel.fromJson(e.response!.data);
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
    return null;
  }

  Future<DataBookedModel?> fetchDataBooked() async {
    try {
      Response response = await API_BASE.get('api/bookingHistory');
      return DataBookedModel.fromJson(response.data);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<BookingModel?> postCancelBooking(int batteryId, String station) async {
    Map<String, Map<String, dynamic>> body = {
      "data": {
        "stationId": station,
        "booking": batteryId,
        "cancelBooking": true
      }
    };
    try {
      Response response = await API_BASE.post(
        'api/booking',
        data: body,
      );
      return BookingModel.fromJson(response.data);
    } on DioError catch (e) {
      if (e.response!.statusCode! == 400) {
        return BookingModel.fromJson(e.response!.data);
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
    return null;
  }

  Future<ReturnStatusModel?> postRating(
      String station, String username, int rating, String comment) async {
    Map<String, dynamic> body = {
      "station": station,
      "username": username,
      "rating": rating,
      "comment": comment
    };

    try {
      Response response = await API_BASE.post(
        'api/rating',
        data: body,
      );
      return ReturnStatusModel.fromJson(response.data);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<ProfileModel?> fetchProfile() async {
    try {
      Response response = await API_BASE.get('users/user');
      return ProfileModel.fromJson(response.data);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<LoginModel?> postLogin(String username, String password) async {
    final _dio = Dio();
    const url = 'http://jinpaoauto.com/users/login';
    Map<String, dynamic> body = {"username": username, "password": password};
    try {
      Response response = await _dio.post(
        url,
        data: body,
      );
      return LoginModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<RegisterModel?> postRegister(
    String email,
    String phone,
    String fullName,
    String username,
    String password,
  ) async {
    final _dio = Dio();
    const url = 'http://jinpaoauto.com/users/register';
    Map<String, dynamic> body = {
      "email": email,
      "mobilePhone": phone,
      "fullName": fullName,
      "username": username,
      "password": password
    };
    try {
      Response response = await _dio.post(
        url,
        data: body,
      );
      print('RESPONSE : ' + prettyPrint(response.data));
      return RegisterModel.fromJson(response.data);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
