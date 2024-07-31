import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../app/app_prefrences.dart';
import '../../app/constant.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "Content-Type";
const String ACCEPT = "accept";
const String MULTI_FORM_DATA="multipart/form-data";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";

class DioFactory {
  final AppPreferences _appPreferences;

  DioFactory(this._appPreferences);

  Future<Dio> getDio() async {
    Dio dio = Dio();

    String language = await _appPreferences.getAppLanguage();
    Map<String, String> headers = {
      CONTENT_TYPE: MULTI_FORM_DATA,
      ACCEPT: APPLICATION_JSON,
      DEFAULT_LANGUAGE: language,
      Constant.headerKey:Constant.headerValue

    };

    dio.options = BaseOptions(
        baseUrl: Constant.baseUrl,
        headers: headers,
        contentType: MULTI_FORM_DATA,
        receiveTimeout:const Duration(milliseconds:Constant.apiTimeOut ) ,
        followRedirects: true,

        validateStatus: (status) => true,
        sendTimeout: const Duration(milliseconds:Constant.apiTimeOut ) );

    if (!kReleaseMode) {
      // its debug mode so print app logs
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ));
    }

    return dio;
  }
}