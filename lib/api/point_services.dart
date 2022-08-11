import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:point/app/constant.dart';
import 'package:point/domain/home_model.dart';
import 'package:point/domain/league_details_model.dart';
import 'package:point/domain/leagues_model.dart';
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
  Future<LeaguesModel?> leagues(String? leagueId) async{
    LeaguesModel? leaguesModel ;
    var dio = Dio();
    dio.options.headers['content-Type'] = 'multipart/form-data';
    dio.options.headers['pointsheader'] = "pointsCreateKW";
    // dio.options.headers["ezyocreate"] = "CreateEZYo";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String language = sharedPreferences.getString(LANG_CODE)??"en";
    String mToken =sharedPreferences.getString("token")??"";
    print('mToken --> ${mToken}');


    var response = await dio.get(TAG_BASE_URL + "?action=league&type=view&leagueId=${leagueId}");

    if (response.statusCode == 200) {




      leaguesModel =
          LeaguesModel.fromJson(Map<String, dynamic>.from(response.data));
    }

    return leaguesModel;

  }
  Future<HomeModel?> home(String? userId) async{
    HomeModel? homeModel ;
    var dio = Dio();
    dio.options.headers['content-Type'] = 'multipart/form-data';
    dio.options.headers['pointsheader'] = "pointsCreateKW";
    // dio.options.headers["ezyocreate"] = "CreateEZYo";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String language = sharedPreferences.getString(LANG_CODE)??"en";
    String mToken =sharedPreferences.getString("token")??"";
    print('mToken --> ${mToken}');


    var response = await dio.get(TAG_BASE_URL + "?action=home&id=${userId}");

    if (response.statusCode == 200) {




      homeModel =
          HomeModel.fromJson(Map<String, dynamic>.from(response.data));
    }

    return homeModel;

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
  Future<LeagueDetailsModel?> addLeague(Map<String,dynamic> map) async{
    LeagueDetailsModel? leagueDetailsModel;
    var resp ;
    var dio = Dio();
    dio.options.headers['content-Type'] = 'multipart/form-data';
    dio.options.headers['pointsheader'] = "pointsCreateKW";
    // dio.options.headers["ezyocreate"] = "CreateEZYo";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String language = sharedPreferences.getString(LANG_CODE)??"en";
    String mToken =sharedPreferences.getString("token")??"";
    print('mToken --> ${mToken}');

    FormData formData = FormData.fromMap(map);
    String body = json.encode(map);
    var response = await dio.post(TAG_BASE_URL + "?action=league&type=create",data: formData);

    if (response.statusCode == 200) {




      resp =
          response.data;
      leagueDetailsModel =
          LeagueDetailsModel.fromJson(Map<String, dynamic>.from(response.data));
      print(resp);
    }

    return leagueDetailsModel;

  }
}