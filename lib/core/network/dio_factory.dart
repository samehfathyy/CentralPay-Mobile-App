import 'dart:io';

import 'package:budgeta/core/constansts/shared_pref_cons.dart';
import 'package:budgeta/main.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  /// private constructor as I don't want to allow creating an instance of this class
  DioFactory._();

  static Dio? dio;

  static Future<Dio> getDio() async {
    Duration timeOut = const Duration(seconds: 30);

    if (dio == null) {
      dio = Dio();
      //
      (dio!.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
  final client = HttpClient();
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;
  return client;
};
//
      dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;
      addDioHeaders();
      await setTokenIntoHeader();
      addDioInterceptor();
      return dio!;
    } else {
      return dio!;
    }
  }

  static void addDioHeaders() async{
    // String token = await sharedPrefs.getString(SharedPrefCons.token) ?? "";
    // token = token.trim().replaceAll('\n', '').replaceAll('\r', '');
    // String token =await  sharedPrefs.getString(SharedPrefCons.token) ?? "";
    dio?.options.headers = {
      'Accept': 'application/json',
      // 'Authorization':
      //     'Bearer ${token}',
    };
  }

  static void setTokenIntoHeaderAfterLogin(String token) {
    token = token.trim().replaceAll('\n', '').replaceAll('\r', '');
    dio?.options.headers.addEntries([
      MapEntry('Authorization', 'Bearer $token'),
    ]);
  }

  static Future<void> setTokenIntoHeader() async {
    String token = sharedPrefs.getString(SharedPrefCons.token) ?? "";
    token = token.trim().replaceAll('\n', '').replaceAll('\r', '');
    print("TOKEN RAW: [$token]");
    print("TOKEN LENGTH: ${token.length}");
    dio?.options.headers.addEntries([
      MapEntry('Authorization', 'Bearer $token'),
    ]);
  }

  static void removeTokenFromHeaderAfterLogout() {
    dio?.options.headers.remove('Authorization');
  }

  static void addDioInterceptor() {
    dio?.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );
  }
}
