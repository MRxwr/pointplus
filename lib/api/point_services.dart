import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:point/app/constant.dart';
import 'package:point/domain/add_address_model.dart';
import 'package:point/domain/add_order_model.dart';
import 'package:point/domain/change_password_model.dart';
import 'package:point/domain/coin_model.dart';
import 'package:point/domain/edit_profile_model.dart';
import 'package:point/domain/home_model.dart';
import 'package:point/domain/league_details_model.dart';
import 'package:point/domain/leagues_model.dart';
import 'package:point/domain/notification_model.dart';
import 'package:point/domain/profile_model.dart';
import 'package:point/domain/settings_model.dart';
import 'package:point/domain/shop_model.dart';
import 'package:point/domain/update_team_model.dart';
import 'package:point/domain/view_league_model.dart';
import 'package:point/domain/view_my_league_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/DeleteUserModel.dart';
import '../domain/leagues_details_model.dart';
import '../domain/prediction_model.dart';

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
    print("map---> ${map}");
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
  Future<List> teams(Map<String,dynamic> map) async{
    PredictionModel? predictionModel;
    var resp ;
    var dio = Dio();
    dio.options.headers['content-Type'] = 'multipart/form-data';
    dio.options.headers['pointsheader'] = "pointsCreateKW";
    // dio.options.headers["ezyocreate"] = "CreateEZYo";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String language = sharedPreferences.getString(LANG_CODE)??"en";
    String mToken =sharedPreferences.getString("token")??"";
    print('mToken --> ${mToken}');
    List?  result;
    FormData formData = FormData.fromMap(map);
    String body = json.encode(map);
    var response = await dio.post(TAG_BASE_URL + "?action=teams&type=list",data: formData);

    if (response.statusCode == 200) {




      resp =
          response.data;
        result = resp['data']['teams'];
      for(int i = 0;i<result!.length;i++){
        Map<String,dynamic> map = result[i];
        if(i ==0){
          map['isSelected'] = true;
        }else{
          map['isSelected'] = false;
        }

        result[i] = map;
      }



    }

    return result!;

  }
  Future<dynamic> register(Map<String,dynamic> map) async{
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
    var response = await dio.post(TAG_BASE_URL + "?action=user&type=register",data: formData);

    if (response.statusCode == 200) {




      resp =
          response.data;
      print(resp);
    }

    return resp;

  }
  Future<dynamic> leagues(String? leagueId) async{
    dynamic resp;
    LeaguesModel? leaguesModel ;
    var dio = Dio();
    dio.options.headers['content-Type'] = 'multipart/form-data';
    dio.options.headers['pointsheader'] = "pointsCreateKW";
    // dio.options.headers["ezyocreate"] = "CreateEZYo";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String language = sharedPreferences.getString(LANG_CODE)??"en";
    String mToken =sharedPreferences.getString("token")??"";
    String userId = sharedPreferences.getString("id")??"";
    print('mToken --> ${mToken}');


    var response = await dio.get(TAG_BASE_URL + "?action=league&type=list&userId=${leagueId}");

    if (response.statusCode == 200) {
      print(response.data);
      resp = response.data;
      print('resp ---> ${resp}');




      // leaguesModel =
      //     LeaguesModel.fromJson(Map<String, dynamic>.from(response.data));
    }

    return resp;

  }
  Future<dynamic> notification(String? userId) async{
    NotificationModel? homeModel ;
    var dio = Dio();
    dio.options.headers['content-Type'] = 'multipart/form-data';
    dio.options.headers['pointsheader'] = "pointsCreateKW";
    // dio.options.headers["ezyocreate"] = "CreateEZYo";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String language = sharedPreferences.getString(LANG_CODE)??"en";
    String mToken =sharedPreferences.getString("token")??"";
    print('mToken --> ${mToken}');
    dynamic resp;


    var response = await dio.get(TAG_BASE_URL + "?action=notifications&userId=${userId}");

    if (response.statusCode == 200) {
      resp =
          response.data;



      // homeModel =
      //     NotificationModel.fromJson(Map<String, dynamic>.from(response.data));
    }

    return resp;

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
    print(TAG_BASE_URL + "?action=home&id=${userId}");


    var response = await dio.get(TAG_BASE_URL + "?action=home&id=${userId}");

    if (response.statusCode == 200) {




      homeModel =
          HomeModel.fromJson(Map<String, dynamic>.from(response.data));
    }

    return homeModel;

  }
  Future<ViewleagueModel?> viewLeagues() async{
    ViewleagueModel? homeModel ;
    var dio = Dio();
    dio.options.headers['content-Type'] = 'multipart/form-data';
    dio.options.headers['pointsheader'] = "pointsCreateKW";
    // dio.options.headers["ezyocreate"] = "CreateEZYo";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String language = sharedPreferences.getString(LANG_CODE)??"en";
    String mToken =sharedPreferences.getString("token")??"";
    print('mToken --> ${mToken}');


    var response = await dio.get(TAG_BASE_URL + "?action=league&type=view&leagueId=0");

    if (response.statusCode == 200) {




      homeModel =
          ViewleagueModel.fromJson(Map<String, dynamic>.from(response.data));
    }

    return homeModel;

  }

  Future<ViewleagueModel?> viewLeague() async{
    ViewleagueModel? homeModel ;
    var dio = Dio();
    dio.options.headers['content-Type'] = 'multipart/form-data';
    dio.options.headers['pointsheader'] = "pointsCreateKW";
    // dio.options.headers["ezyocreate"] = "CreateEZYo";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String language = sharedPreferences.getString(LANG_CODE)??"en";
    String mToken =sharedPreferences.getString("token")??"";
    print('mToken --> ${mToken}');


    var response = await dio.get(TAG_BASE_URL + "?action=league&type=view&leagueId=0");

    if (response.statusCode == 200) {




      homeModel =
          ViewleagueModel.fromJson(Map<String, dynamic>.from(response.data));
    }

    return homeModel;

  }
  Future<ViewMyLeagueModel?> viewMyLeague(String id) async{
    ViewMyLeagueModel? homeModel ;
    var dio = Dio();
    dio.options.headers['content-Type'] = 'multipart/form-data';
    dio.options.headers['pointsheader'] = "pointsCreateKW";
    // dio.options.headers["ezyocreate"] = "CreateEZYo";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String language = sharedPreferences.getString(LANG_CODE)??"en";
    String mToken =sharedPreferences.getString("token")??"";
    print('mToken --> ${mToken}');


    var response = await dio.get(TAG_BASE_URL + "?action=league&type=view&leagueId=${id}");

    if (response.statusCode == 200) {




      homeModel =
          ViewMyLeagueModel.fromJson(Map<String, dynamic>.from(response.data));
    }

    return homeModel;

  }
  Future<HomeModel?> roundHome(String? userId,String? round) async{
    HomeModel? homeModel ;
    var dio = Dio();
    dio.options.headers['content-Type'] = 'multipart/form-data';
    dio.options.headers['pointsheader'] = "pointsCreateKW";
    // dio.options.headers["ezyocreate"] = "CreateEZYo";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String language = sharedPreferences.getString(LANG_CODE)??"en";
    String mToken =sharedPreferences.getString("token")??"";
    print('mToken --> ${mToken}');


    var response = await dio.get(TAG_BASE_URL + "?action=home&id=${userId}&round=${round}");

    if (response.statusCode == 200) {




      homeModel =
          HomeModel.fromJson(Map<String, dynamic>.from(response.data));
    }

    return homeModel;

  }
  Future<LeaguesDetailsModel?> leaguesDetailsModel(String? userId) async{
    LeaguesDetailsModel? homeModel ;
    var dio = Dio();
    dio.options.headers['content-Type'] = 'multipart/form-data';
    dio.options.headers['pointsheader'] = "pointsCreateKW";
    // dio.options.headers["ezyocreate"] = "CreateEZYo";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String language = sharedPreferences.getString(LANG_CODE)??"en";
    String mToken =sharedPreferences.getString("token")??"";
    print('mToken --> ${mToken}');


    var response = await dio.get(TAG_BASE_URL + "?action=league&type=view&leagueId=${userId}&lastGm=0");
    print(TAG_BASE_URL + "?action=league&type=view&leagueId=${userId}&lastGm=0");
    print(response);

    if (response.statusCode == 200) {




      homeModel =
          LeaguesDetailsModel.fromJson(Map<String, dynamic>.from(response.data));
    }

    return homeModel;

  }
 Future<LeaguesDetailsModel?> lastLeaguesDetailsModel(String? userId) async{
   LeaguesDetailsModel? homeModel ;
   var dio = Dio();
   dio.options.headers['content-Type'] = 'multipart/form-data';
   dio.options.headers['pointsheader'] = "pointsCreateKW";
   // dio.options.headers["ezyocreate"] = "CreateEZYo";
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   String language = sharedPreferences.getString(LANG_CODE)??"en";
   String mToken =sharedPreferences.getString("token")??"";
   print('mToken --> ${mToken}');


   var response = await dio.get(TAG_BASE_URL + "?action=league&type=view&leagueId=${userId}&lastGm=1");
   print(TAG_BASE_URL + "?action=league&type=view&leagueId=${userId}");
   print(response);

   if (response.statusCode == 200) {




     homeModel =
         LeaguesDetailsModel.fromJson(Map<String, dynamic>.from(response.data));
   }

   return homeModel;

 }
  Future<SettingsModel?> settings() async{
    SettingsModel? settingsModel ;
    var dio = Dio();
    dio.options.headers['content-Type'] = 'multipart/form-data';
    dio.options.headers['pointsheader'] = "pointsCreateKW";
    // dio.options.headers["ezyocreate"] = "CreateEZYo";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String language = sharedPreferences.getString(LANG_CODE)??"en";
    String mToken =sharedPreferences.getString("token")??"";
    print('mToken --> ${mToken}');


    var response = await dio.get(TAG_BASE_URL + "?action=settings");

    if (response.statusCode == 200) {




      settingsModel =
          SettingsModel.fromJson(Map<String, dynamic>.from(response.data));
    }

    return settingsModel;

  }
  Future<ShopModel?> shop() async{
    ShopModel? shopModel ;
    var dio = Dio();
    dio.options.headers['content-Type'] = 'multipart/form-data';
    dio.options.headers['pointsheader'] = "pointsCreateKW";
    // dio.options.headers["ezyocreate"] = "CreateEZYo";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String language = sharedPreferences.getString(LANG_CODE)??"en";
    String mToken =sharedPreferences.getString("token")??"";
    print('mToken --> ${mToken}');


    var response = await dio.get(TAG_BASE_URL + "?action=items");

    if (response.statusCode == 200) {




      shopModel =
          ShopModel.fromJson(Map<String, dynamic>.from(response.data));
    }

    return shopModel;

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
  Future<dynamic> sumbitPrediction(List<Teams> teams,String userId, String x2,String x3) async{
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
    Map<String,dynamic> map = {};
    map['userId']= userId;
    for(int i =0;i<teams.length;i++){
      String type = teams[i].type.toString();
      if(type == "0"){
        map['x3[${i}]'] = "0";
      }else{
        map['x3[${i}]'] = x3;
      }
      map['x2[${i}]'] = x2;
      map['matchId[${i}]'] = teams[i].matchId;
      map['goals1[${i}]'] = teams[i].goals1;
      map['goals2[${i}]'] = teams[i].goals2;
    }
    print(map);

    FormData formData = FormData.fromMap(map);
    String body = json.encode(map);
    var response = await dio.post(TAG_BASE_URL + "?action=predictions&type=update",data: formData);

    if (response.statusCode == 200) {




      resp =
          response.data;

      print(resp);
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
  Future<ProfileModel?> profile(Map<String,dynamic> map) async{
    ProfileModel? profileModel;
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
    print(TAG_BASE_URL + "?action=user&type=profile&update=0");
    print(map);
    var response = await dio.post(TAG_BASE_URL + "?action=user&type=profile&update=0",data: formData);
    print(response.data);

    if (response.statusCode == 200) {




      resp =
          response.data;
      profileModel =
          ProfileModel.fromJson(Map<String, dynamic>.from(response.data));
      print(resp);
    }

    return profileModel;

  }
  Future<EditProfileModel?> editProfile(Map<String,dynamic> map) async{
    EditProfileModel? profileModel;
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
    var response = await dio.post(TAG_BASE_URL + "?action=user&type=profile&update=1",data: formData);
print('edit profile ---> ${response.data}');
    if (response.statusCode == 200) {




      resp =
          response.data;
      profileModel =
          EditProfileModel.fromJson(Map<String, dynamic>.from(response.data));
      print(resp);
    }

    return profileModel;

  }
  Future<PredictionModel?> predictions(Map<String,dynamic> map) async{
    PredictionModel? predictionModel;
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
    var response = await dio.post(TAG_BASE_URL + "?action=predictions&type=list",data: formData);

    if (response.statusCode == 200) {




      resp =
          response.data;
      predictionModel =
          PredictionModel.fromJson(Map<String, dynamic>.from(response.data));
      print(resp);
    }

    return predictionModel;

  }
  Future<UpdateTeamModel?> updateTeam(Map<String,dynamic> map) async{
    UpdateTeamModel? updateTeamModel;
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
    var response = await dio.post(TAG_BASE_URL + "?action=teams&type=update",data: formData);

    if (response.statusCode == 200) {




      resp =
          response.data;
      updateTeamModel =
          UpdateTeamModel.fromJson(Map<String, dynamic>.from(response.data));
      print(resp);
    }

    return updateTeamModel;

  }
 Future<CoinModel?> coins(Map<String,dynamic> map,String userId) async{
   CoinModel? addAddressModel;
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
   var response = await dio.post(TAG_BASE_URL + "?action=coins&userId=${userId}",data: formData);

   if (response.statusCode == 200) {




     resp =
         response.data;
     addAddressModel =
         CoinModel.fromJson(Map<String, dynamic>.from(response.data));
     print(resp);
   }

   return addAddressModel;

 }
  Future<AddAddressModel?> addAddress(Map<String,dynamic> map) async{
    AddAddressModel? addAddressModel;
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
    var response = await dio.post(TAG_BASE_URL + "?action=address",data: formData);

    if (response.statusCode == 200) {




      resp =
          response.data;
      addAddressModel =
          AddAddressModel.fromJson(Map<String, dynamic>.from(response.data));
      print(resp);
    }

    return addAddressModel;

  }
  Future<ChangePasswordModel?> changePassword(Map<String,dynamic> map) async{
    ChangePasswordModel? addAddressModel;
    var resp ;
    var dio = Dio();
    dio.options.headers['content-Type'] = 'multipart/form-data';
    dio.options.headers['pointsheader'] = "pointsCreateKW";
    // dio.options.headers["ezyocreate"] = "CreateEZYo";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String language = sharedPreferences.getString(LANG_CODE)??"en";
    String mToken =sharedPreferences.getString("token")??"";
    print('mToken --> ${mToken}');
    print('map ---> ${map}');

    FormData formData = FormData.fromMap(map);
    String body = json.encode(map);
    var response = await dio.post(TAG_BASE_URL + "?action=user&type=changePassword",data: formData);

    if (response.statusCode == 200) {




      resp =
          response.data;
      addAddressModel =
          ChangePasswordModel.fromJson(Map<String, dynamic>.from(response.data));
      print(resp);
    }

    return addAddressModel;

  }
  Future<AddOrderModel?> addOrder(Map<String,dynamic> map) async{
    AddOrderModel? addAddressModel;
    var resp ;
    var dio = Dio();
    dio.options.headers['content-Type'] = 'multipart/form-data';
    dio.options.headers['pointsheader'] = "pointsCreateKW";
    // dio.options.headers["ezyocreate"] = "CreateEZYo";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String language = sharedPreferences.getString(LANG_CODE)??"en";
    String mToken =sharedPreferences.getString("token")??"";
    print('mToken --> ${mToken}');
    print('map ---> ${map}');

    FormData formData = FormData.fromMap(map);
    String body = json.encode(map);
    var response = await dio.post(TAG_BASE_URL + "?action=order",data: formData);

    if (response.statusCode == 200) {




      resp =
          response.data;
      addAddressModel =
          AddOrderModel.fromJson(Map<String, dynamic>.from(response.data));
      print(resp);
    }

    return addAddressModel;

  }
  Future<dynamic> joinLeague(Map<String,dynamic> map) async{
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
    var response = await dio.post(TAG_BASE_URL + "?action=league&type=join",data: formData);

    if (response.statusCode == 200) {




      resp =
          response.data;

      print(resp);
    }

    return resp;

  }


  Future<DeleteUserModel?> deleteUser(String id)async{
    var dio = Dio();
    dio.options.headers['content-Type'] = 'multipart/form-data';
    dio.options.headers['pointsheader'] = "pointsCreateKW";

    SharedPreferences sharedPreferences = await SharedPreferences
        .getInstance();



    print(TAG_BASE_URL + "?action=user&type=deleteUser&userId=${id}");
    DeleteUserModel? packageModel;
    try {

      var response = await dio.post(
        TAG_BASE_URL + "?action=user&type=deleteUser&userId=${id}",

      );


      print(response.data);


      if (response.statusCode == 200) {
        packageModel =
            DeleteUserModel.fromJson(Map<String, dynamic>.from(response.data));
      }
    }on Exception catch (_) {
      packageModel = null;
    }




    return packageModel;

  }
}