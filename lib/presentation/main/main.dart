import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point/domain/home_model.dart';
import 'package:point/presentation/main/notification_screen.dart';
import 'package:point/presentation/main/predict_screen.dart';
import 'package:point/presentation/main/profile_screen.dart';
import 'package:point/presentation/main/settings_screen.dart';
import 'package:point/presentation/main/stats_screen.dart';
import 'package:point/presentation/resources/assets_manager.dart';
import 'package:point/presentation/resources/color_manager.dart';
import 'package:point/presentation/resources/strings_manager.dart';
import 'package:point/presentation/resources/values_manager.dart';
import 'package:point/providers/notification_provider.dart';
import 'package:provider/provider.dart';

import '../../components/customNavigationItem.dart';
import '../../views/fab_bottom_app_bar.dart';
import 'home_screen.dart';
class MainView extends StatefulWidget {

   const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with SingleTickerProviderStateMixin{
  int _currentIndex = 0;

  final _page1 = GlobalKey<NavigatorState>();
  final _page2 = GlobalKey<NavigatorState>();
  final _page3 = GlobalKey<NavigatorState>();
  final _page4 = GlobalKey<NavigatorState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

bool back(){
    bool press = false;

      AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      closeIcon: const Icon(Icons.close_fullscreen_outlined),
      title: "close".tr(),
      desc:
      "exit".tr(),
      btnCancelOnPress: () {
        press = false;


      },
        btnOkText: "yes".tr(),
        btnCancelText: 'no'.tr(),
      onDismissCallback: (type) {

        print('Dialog Dismiss from callback ${type.index}');
        if(type.index == 0){
          press = true;

        }else{
          press = false;
        }
      },
      btnOkOnPress: () {
        press = true;
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      },
    ).show();
      return press;
}

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return back();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: AppSize.s0,
backgroundColor: ColorManager.backGroundColor,
          leading: GestureDetector(
            onTap: (){
              Navigator.of(context,rootNavigator: true).push( MaterialPageRoute(builder: (BuildContext context){
                return  const ProfileScreen();
              }));
            },
            child: Padding(
              padding:  EdgeInsets.all(AppSize.s8),
              child: Image.asset(ImageAssets.userImage,height: AppSize.s40, width: AppSize.s40,fit: BoxFit.fitHeight,),
            ),
          ),
            actions: [
              Consumer<NotificationProvider>(

                  builder: (context, cart, child){

                    String notificationCount = cart.notification;
                    if(notificationCount == ""){

                      return  GestureDetector(
                        onTap: (){
                          Navigator.of(context,rootNavigator: true).push( MaterialPageRoute(builder: (BuildContext context){
                            return  const NotificationScreen();
                          }));
                        },
                        child: Padding(
                          padding:  EdgeInsets.all(AppSize.s8),
                          child: Image.asset(ImageAssets.notificationSilent,height: AppSize.s40, width: AppSize.s40,fit: BoxFit.fitHeight,),
                        ),
                      );
                    }else if(notificationCount == "0"){

                      return  GestureDetector(
                        onTap: (){
                          Navigator.of(context,rootNavigator: true).push( MaterialPageRoute(builder: (BuildContext context){
                            return  const NotificationScreen();
                          }));
                        },
                        child: Padding(
                          padding:  EdgeInsets.all(AppSize.s8),
                          child: Image.asset(ImageAssets.notificationSilent,height: AppSize.s40, width: AppSize.s40,fit: BoxFit.fitHeight,),
                        ),
                      );

                    }

                    else{
                      return  GestureDetector(
                        onTap: (){
                          Navigator.of(context,rootNavigator: true).push( MaterialPageRoute(builder: (BuildContext context){
                            return  const NotificationScreen();
                          }));
                        },
                        child: Padding(
                          padding:  EdgeInsets.all(AppSize.s8),
                          child: Image.asset(ImageAssets.notification,height: AppSize.s40, width: AppSize.s40,fit: BoxFit.fitHeight,),
                        ),
                      );
                    }

                  })

            ],
          title: Center(
            child: Image.asset(ImageAssets.titleBarImage,height: AppSize.s32, width: AppSize.s110,fit: BoxFit.fill,),
          ),

        ),
        bottomNavigationBar:
        FABBottomAppBar(


          backgroundColor: ColorManager.navColor,
          centerItemText: "",

          color:ColorManager.white,
          selectedColor: ColorManager.white,


          onTabSelected: (val) {

            return  _onTap(val, context);
          },
          items: [





            FABBottomAppBarItem(iconPath:  ImageAssets.home, text: "home".tr()),
            FABBottomAppBarItem(iconPath: ImageAssets.states, text: "states".tr()),
            FABBottomAppBarItem(iconPath:  ImageAssets.predict, text: "predict".tr()),
            FABBottomAppBarItem(iconPath:
            ImageAssets.settings, text:"settings".tr()),
          ],
        ),



      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          Navigator(
            key: _page1,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) =>  HomeScreen(page: _page1,),
            ),
          ),
          Navigator(
            key: _page2,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) =>  StatsScreen(page: _page2,),
            ),
          ),
          Navigator(
            key: _page3,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => const PredictScreen(),
            ),
          ),
          Navigator(
            key: _page4,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => const SettingsScreen(),
            ),
          ),
        ],
      ),


      ),
    );
  }
  void _onTap(int val, BuildContext context) {
    if (_currentIndex == val) {
      switch (val) {
        case 0:
          print(val);

          _page1.currentState?.popUntil((route) => route.isFirst);

          setState(() {

          });

          break;
        case 1:
          print(val);
          _page2.currentState?.popUntil((route) => route.isFirst);
          setState(() {

          });

          break;
        case 2:
          print(val);
          _page3.currentState?.popUntil((route) => route.isFirst);
          setState(() {

          });
          break;
        case 3:
          _page4.currentState?.popUntil((route) => route.isFirst);
          setState(() {

          });
          break;

        default:
      }
    } else {
      _currentIndex = val;
      if(_currentIndex ==3){
        _page4.currentState?.pushReplacement( MaterialPageRoute(builder: (BuildContext context){
          return  const SettingsScreen();
        }));
        setState(() {

        });


      }else if(_currentIndex == 2){
        _page3.currentState?.pushReplacement( MaterialPageRoute(builder: (BuildContext context){
          return  const PredictScreen();
        }));
        setState(() {

        });
      }else if(_currentIndex == 1){
        _page2.currentState?.pushReplacement( MaterialPageRoute(builder: (BuildContext context){
          return   StatsScreen(page: _page2,);
        }));
        setState(() {

        });

      }else if(_currentIndex == 0){
        _page1.currentState?.pushReplacement( MaterialPageRoute(builder: (BuildContext context){
          return   HomeScreen(page: _page1,);
        }));
        setState(() {

        });

      }
      _currentIndex = val;
      print('index ${_currentIndex}');



    }
  }
}
