import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point/domain/home_model.dart';
import 'package:point/presentation/main/predict_screen.dart';
import 'package:point/presentation/main/settings_screen.dart';
import 'package:point/presentation/main/stats_screen.dart';
import 'package:point/presentation/resources/assets_manager.dart';
import 'package:point/presentation/resources/color_manager.dart';
import 'package:point/presentation/resources/strings_manager.dart';
import 'package:point/presentation/resources/values_manager.dart';
import 'package:provider/provider.dart';

import '../../components/customNavigationItem.dart';
import 'home_screen.dart';
class MainView extends StatefulWidget {

   const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentIndex = 0;



  void onTabTabbed(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final List<Widget> _children = [
    HomeScreen(),
    StatsScreen(),
    PredictScreen(),
    SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: AppSize.s0,
backgroundColor: ColorManager.backGroundColor,
        leading: Padding(
          padding:  EdgeInsets.all(AppSize.s8),
          child: Image.asset(ImageAssets.userImage,height: AppSize.s40, width: AppSize.s40,fit: BoxFit.fitHeight,),
        ),
          actions: [

            Padding(
              padding:  EdgeInsets.all(AppSize.s8),
              child: Image.asset(ImageAssets.notification,height: AppSize.s40, width: AppSize.s40,fit: BoxFit.fitHeight,),
            ),
          ],
        title: Center(
          child: Image.asset(ImageAssets.titleBarImage,height: AppSize.s32, width: AppSize.s110,fit: BoxFit.fill,),
        ),
      ),
      bottomNavigationBar:
      CupertinoTabBar(
      
        backgroundColor: ColorManager.navColor,
        currentIndex: currentIndex,
        onTap: onTabTabbed,
        activeColor: ColorManager.primary,
        items: [
          navigationitem(
              ImageAssets.home,
              AppSize.s21,AppSize.s21 ,context,AppStrings.home),

          navigationitem(
              ImageAssets.states,
              AppSize.s20,AppSize.s20 ,context,AppStrings.states),
          navigationitem(
              ImageAssets.predict,
             AppSize.s17 , AppSize.s21,context,AppStrings.predict),
          navigationitem(
              ImageAssets.settings,
              AppSize.s20,AppSize.s20 ,context,AppStrings.settings),

        ],
      )
      ,
      body: _children[currentIndex],
    );
  }
}
