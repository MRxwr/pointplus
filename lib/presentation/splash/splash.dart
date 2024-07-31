import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:point/api/point_services.dart';
import 'package:point/presentation/login/login.dart';
import 'package:point/presentation/resources/values_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../app/di.dart';
import '../../systemConfig/cubits/systemConfigCubit.dart';
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
  _timer = Timer(Duration(seconds: 3), _checkAppUpdate);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchSystemConfig();


  }

  Future<void> _fetchSystemConfig() async {
    await context.read<SystemConfigCubit>().getSystemConfig();
    // await MobileAds.instance.initialize();
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

        body:  BlocConsumer<SystemConfigCubit, SystemConfigState>(
  listener: (context, state) {
    if(state is SystemConfigFetchSuccess){
      _startDelay();
    }
    // TODO: implement listener
  },
  builder: (context, state) {
    return Container(
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
        ),);
  },
)

      ),
    );
  }
  _checkAppUpdate() async{
    try {
      AppUpdateInfo? _updateInfo = await InAppUpdate.checkForUpdate();
      if (_updateInfo.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate().then((value) {
          if (value == AppUpdateResult.success) {
            _goNext();
          }
        });
      }else{
        _goNext();
      }
        }catch(e){
      _goNext();
    }
  }

   _goNext()async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("id")??"";
    bool isLoggedIn = sharedPreferences.getBool("isLoggedIn")??false;

    // initLoginModule();

    if(id.trim() == ""){
      Navigator.pushReplacementNamed(context, Routes.onBoardingRoute);
    }else{
      if(!isLoggedIn){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      }else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainView()),
        );
      }
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
