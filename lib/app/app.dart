import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../presentation/resources/routes_manager.dart';
import '../presentation/resources/theme_manager.dart';
import '../providers/model_hud.dart';
import 'constant.dart';

class MyApp extends StatefulWidget {

  MyApp._internal() ;//private named Constructor
  static final MyApp instance = MyApp._internal();//single instance --singleton
 factory MyApp() => instance;
  @override
  State<MyApp> createState() => _MyAppState();// factory for the class instance
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {




    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,

                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      String remoteMessgae = message.data.toString();
      dynamic dataObject=  message.data;
      print('dataObject ---> ${dataObject.toString()}');


      // Navigator.pushNamed(context, '/message',
      //     arguments: MessageArguments(message, true));
    });

    getToken().then((value) {

    });

  }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<ModelHud>(create: (context) => ModelHud()),

          ],
          child: MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute:RouteGenerator.getRoute ,
      initialRoute: Routes.splashRoute,
      theme: getApplicationTheme(),
    ),
        );});
  }
  Future <void> getToken() async{
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String mToken =_preferences.getString("token")??"";
    print('token --> ${mToken}');
    if(mToken ==""){

       String? toke = await   FirebaseMessaging.instance.getToken();

      print('token --> ${toke}');
      SharedPreferences _preferences = await SharedPreferences.getInstance();



      _preferences.setString("token", toke!);




    }


  }
}
