import 'dart:io';

import 'package:dio/dio.dart';

class ApiServer {
  static ApiServer? _instance;
  Dio? _dio;

  ApiServer._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "",
      ),
    );
  }

  factory ApiServer() {
    _instance ??= ApiServer._internal();
    return _instance!;
  }

  void setDio(Dio dio) => _dio = dio;

  Dio get dio => _dio!;

  Future<Map<String, dynamic>> get({
    required String uri,
    // String? token,
    // String? lang,
    // Map<String, String>? additionalHeaders,
  }) async {
    String url = uri;

    // if (token != null) {
    //   headers.addAll({
    //     "Authorization": "Bearer $token",
    //   });
    // }
    // if (additionalHeaders != null) {
    //   headers.addAll(additionalHeaders);
    // }

    _dio!.options.headers = {
      "Content-Type": "application/json",
    };

    Response response = await _dio!.get(url);
    return response.data;
  }

  Future<bool> cheekInterentConnection() async {
    try {
      final foo = await InternetAddress.lookup('google.com');
      return foo.isNotEmpty && foo[0].rawAddress.isNotEmpty ? true : false;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> post({
    required String endPoint,
    required String baseUrl,
    required Object data,
    // String? phoneNumber,
  }) async {
    _dio!.options.headers = {
      "Content-Type": "application/json",
    };
    String url = "$baseUrl$endPoint";
    print(url);

    var response = await _dio!.post(
      url,
      data: data,
    );

    if (response.data is String) {
      return {"message": response.data};
    }
    return response.data;
  }
}
