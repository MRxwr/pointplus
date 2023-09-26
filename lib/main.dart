import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point/presentation/resources/routes_manager.dart';
import 'package:point/presentation/resources/theme_manager.dart';
import 'package:point/providers/model_hud.dart';
import 'package:point/providers/notification_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'app/constant.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
// description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
void main()async {



  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  await EasyLocalization.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  runApp(
      EasyLocalization(child: MyApp(),
    supportedLocales: const [Locale('en', 'US'), Locale('ar', 'KW')],
    path: 'assets/translations',

    fallbackLocale: const Locale('en', 'US'),
    saveLocale: true,));
}

class MyApp extends StatefulWidget {


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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      SharedPreferences sharedPrefrences = await SharedPreferences.getInstance();
      bool NotificationEnabled = sharedPrefrences.getBool(NotificationStatus )??true;
      if(NotificationEnabled) {
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
              ChangeNotifierProvider<NotificationProvider>(create: (context) => NotificationProvider()),
            ],
            child: MaterialApp(

              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
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
    String mLanguage = _preferences.getString(LANG_CODE)??"";
    print('token --> ${mToken}');
    if(mToken ==""){

      String? toke = await   FirebaseMessaging.instance.getToken();

      print('token --> ${toke}');
      SharedPreferences _preferences = await SharedPreferences.getInstance();



      _preferences.setString("token", toke!);
      _preferences.setString(LANG_CODE, "en");




    }


  }
}


