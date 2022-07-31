import 'dart:async';

import 'package:flutter/material.dart';


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
    return Scaffold(

      body:  Container(
        decoration: const BoxDecoration(
        image:  DecorationImage(
        image: AssetImage(ImageAssets.splashLogo),
    fit: BoxFit.cover,
    )))

    );
  }

   _goNext() {
    Navigator.pushReplacementNamed(context, Routes.onBoardingRoute);
  }
  @override
  void dispose() {
    _timer?.cancel();
    // TODO: implement dispose
    super.dispose();

  }
}
