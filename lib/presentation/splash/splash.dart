import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:point/presentation/login/login.dart';
import 'package:point/presentation/resources/values_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../main/main.dart';
import '../main/teams_screen.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';
class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;

  _startDelay(){
  _timer = Timer(Duration(seconds: 3), _goNext);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startDelay();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(

        body:  Container(
          decoration: const BoxDecoration(
          image:  DecorationImage(
          image: AssetImage(ImageAssets.background),
      fit: BoxFit.cover,
      )),
        child: Container(
          height: AppSize.height,
          width: AppSize.width,
          child: Column(
   children: [
     SizedBox(height: AppSize.s100,),
     SvgPicture.asset(
           'assets/images/app_logo.svg',
       height: AppSize.s90,


     ),
     Expanded(flex:1,child: Column(
       children: [
         Container(
           height: AppSize.s200,
         ),
         Container(
           alignment: AlignmentDirectional.topCenter,
           child: Image.asset('assets/images/play_btn.png',width: AppSize.s80,height: AppSize.s50,
           fit: BoxFit.fill,),

         ),
       ],
     ))
   ],

          ),
        ),)

      ),
    );
  }

   _goNext()async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("id")??"";

    if(id.trim() == ""){
      Navigator.pushReplacementNamed(context, Routes.onBoardingRoute);
    }else{
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainView()),
      );
    }


    //  Navigator.pushReplacement(
    //    context,
    //    MaterialPageRoute(builder: (context) => const TeamsScreen()),
    //  );
  }
  @override
  void dispose() {
    _timer?.cancel();
    // TODO: implement dispose
    super.dispose();

  }
}
