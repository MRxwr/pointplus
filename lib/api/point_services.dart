import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:point/app/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PointServices{
  static String TAG_BASE_URL= "https://createkwservers.com/points/request/";
  Future<dynamic> login(String email,String password) async{
    var resp ;
    var dio = Dio();
    dio.options.headers['content-Type'] = 'multipart/form-data';
    dio.options.headers['pointsheader'] = "pointsCreateKW";
    // dio.options.headers["ezyocreate"] = "CreateEZYo";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String language = sharedPreferences.getString(LANG_CODE)??"en";
    String mToken =sharedPreferences.getString("token")??"";
    print('mToken --> ${mToken}');
    Map<String,String> map = Map();
    map['email'] = email;
    map['password'] = password;

    map['deviceToken'] = mToken;
    FormData formData = FormData.fromMap(map);
    String body = json.encode(map);
    var response = await dio.post(TAG_BASE_URL + "?action=user&type=login&lang=${language}",data: formData);

    if (response.statusCode == 200) {




      resp =
          response.data;
      print(resp);
    }

    return resp;

  }
  Future<dynamic> forgetPassword(String email) async{
    var resp ;
    var dio = Dio();
    // dio.options.headers["ezyocreate"] = "CreateEZYo";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String language = sharedPreferences.getString(LANG_CODE)??"en";

    dio.options.headers['content-Type'] = 'multipart/form-data';
    dio.options.headers['pointsheader'] = "pointsCreateKW";

    var response = await dio.get(TAG_BASE_URL + "?action=user&type=forgetPassword&email=${email}");

    if (response.statusCode == 200) {




      resp =
          response.data;
    }

    return resp;

  }
}