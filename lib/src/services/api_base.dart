import 'package:dio/dio.dart';
import 'package:battery_swap_station/src/services/logout.dart';
import 'package:battery_swap_station/src/constants/setting.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:battery_swap_station/src/widgets/dialogs/dialog_error.dart';

// Create storage
const storage = FlutterSecureStorage();

Dio previous = Dio();
Dio refreshTokenDio = Dio();

// String _baseUrl = 'http://192.168.1.200:8003/';
String _baseUrl = 'http://jinpaoauto.com/';

var API_BASE = Dio(BaseOptions(
  baseUrl: _baseUrl,
  connectTimeout: 10000,
  receiveTimeout: 8000,
  // connectTimeout: 15000,
  // receiveTimeout: 10000,
))
  ..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Do something before request is sent
        print('REQUEST[${options.method}] => PATH: ${options.path}');
        // add token
        String accessToken =
            await storage.read(key: Setting.TOKEN_STORAGE) ?? '';
        options.headers['Authorization'] = 'Bearer $accessToken';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Do something with response data
        print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (DioError err, handler) async {
        // Do something with response error\
        if (err.response != null) {
          switch (err.response!.statusCode) {
            case 400:
              // print('RESPONSE[${err.response!.statusCode}] => PATH: ${err.response!.requestOptions.path}');
              await dialogError('Unauthorised request');
              break;
            case 401:
              // print('RESPONSE[${err.response!.statusCode}] => PATH: ${err.response!.requestOptions.path}');
              print('=> Access Token was expired ⏳');
              await logOut();
              break;
            case 403:
              // print('RESPONSE[${err.response!.statusCode}] => PATH: ${err.response!.requestOptions.path}');
              await dialogError('Unauthorised request');
              break;
            case 404:
              // print('RESPONSE[${err.response!.statusCode}] => PATH: ${err.response!.requestOptions.path}');
              await dialogError('Not found, Please check your internet connection.');
              break;
            case 408:
              // print('RESPONSE[${err.response!.statusCode}] => PATH: ${err.response!.requestOptions.path}');
              await dialogError('Connection request timeout');
              break;
            case 409:
              // print('RESPONSE[${err.response!.statusCode}] => PATH: ${err.response!.requestOptions.path}');
              await dialogError('Error due to a conflict');
              break;
            case 500:
              // print('RESPONSE[${err.response!.statusCode}] => PATH: ${err.response!.requestOptions.path}');
              await dialogError('Internal Server Error');
              break;
            case 503:
              // print('RESPONSE[${err.response!.statusCode}] => PATH: ${err.response!.requestOptions.path}');
              await dialogError('Service unavailable or internet not connect');
              break;
            default:
              // print('RESPONSE[${err.response!.statusCode}] => PATH: ${err.response!.requestOptions.path}');
              await dialogError('Service unavailable or internet not connect');
          }
        } else {
          // print('RESPONSE[${err.response!.statusCode}] => PATH: ${err.response!.requestOptions.path}');
          await dialogError('Service provider network disrupted');
        }

        // Access Token was expired
        // if (err.response?.statusCode == 401) {
        //   print("=> Access Token was expired ⏳");

        //   RequestOptions requestOptions = err.requestOptions;

        //   try {
        //     final refreshToken = await storage.read(key: Setting.TOKEN_REFRESH);
        //     Response _responseRfToken = await refreshTokenDio.post(
        //       requestOptions.baseUrl +
        //           'refreshToken', /////////////////////////////////////////////////////////
        //       options: Options(
        //         headers: {
        //           "Authorization": "Bearer $refreshToken",
        //         },
        //       ),
        //     );

        //     if (_responseRfToken.statusCode == 200) {
        //       print("=> Renew Access Token 🎉");

        //       final oldToken = await storage.read(key: Setting.TOKEN_STORAGE);
        //       print('oldToken: $oldToken');

        //       final newAccessToken = _responseRfToken.data[
        //           'accessToken']; /////////////////////////////////////////////////////////

        //       // update token
        //       requestOptions.headers["Authorization"] =
        //           "Bearer $newAccessToken";

        //       // storage token
        //       await storage.write(
        //           key: Setting.TOKEN_STORAGE, value: newAccessToken);

        //       final newToken = await storage.read(key: Setting.TOKEN_STORAGE);
        //       print('newToken: $newToken');

        //       // repeat
        //       print("=> Repeat 🔃");
        //       Response? responseResolve = await previous.request(
        //         requestOptions.baseUrl + requestOptions.path,
        //         data: requestOptions.data,
        //         queryParameters: requestOptions.queryParameters,
        //         options: Options(
        //           method: requestOptions.method,
        //           headers: requestOptions.headers,
        //         ),
        //       );
        //       print(
        //         'RESOLVE[${responseResolve.statusCode}] => DATA: ${responseResolve.data}',
        //       );
        //       return handler.resolve(responseResolve);
        //     }
        //   } catch (e) {
        //     print(e.toString());
        //     print("=> Refresh Token was expired ❌");
        //     await logOut();
        //   }
        // }

        return handler.next(err);
      },
    ),
  );
