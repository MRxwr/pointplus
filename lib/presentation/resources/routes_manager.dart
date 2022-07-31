import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point/presentation/resources/strings_manager.dart';

import '../forget_password/forget_password.dart';
import '../login/login.dart';
import '../main/main.dart';
import '../onboarding/onboarding.dart';
import '../register/register.dart';
import '../splash/splash.dart';


class Routes{
  static const String splashRoute= "/";
  static const String onBoardingRoute= "/onboarding";
  static const String loginRoute= "/login";
  static const String registerRoute= "/register";
  static const String forgetPasswordRoute= "/forgetPassword";
  static const String mainRoute= "/main";
  static const String storeDetailsRoute= "/storeDetails";
}
class RouteGenerator{
  static Route<dynamic> getRoute(RouteSettings routeSettings){
    switch(routeSettings.name){
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_)=>const SplashView());
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_)=>const OnBoardingView());

      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_)=>const LoginView());

      case Routes.registerRoute:
        return MaterialPageRoute(builder: (_)=>const RegisterView());

      case Routes.forgetPasswordRoute:
        return MaterialPageRoute(builder: (_)=>const ForgetPassworView());

      case Routes.mainRoute:
        return MaterialPageRoute(builder: (_)=>const MainView());

      // case Routes.storeDetailsRoute:
      //   return MaterialPageRoute(builder: (_)=>const StoreDetailsView());
      default:
     return unDefinedRoute();

    }
    
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(builder: (_)=>
    Scaffold(
      appBar: AppBar(title: const Text(AppStrings.noRouteFound),),
      body: const Center(child: Text(AppStrings.noRouteFound))
    ));

  }
}