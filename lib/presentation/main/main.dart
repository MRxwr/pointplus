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
      bottomNavigationBar: FABBottomAppBar(


        backgroundColor: ColorManager.navColor,
        centerItemText: "",

        color:ColorManager.white,
        selectedColor: ColorManager.white,


        onTabSelected: (val) {

          return  _onTap(val, context);
        },
        items: [





          FABBottomAppBarItem(iconPath:  ImageAssets.home, text: AppStrings.home),
          FABBottomAppBarItem(iconPath: ImageAssets.states, text: AppStrings.states),
          FABBottomAppBarItem(iconPath:  ImageAssets.predict, text: AppStrings.predict),
          FABBottomAppBarItem(iconPath:
          ImageAssets.settings, text:AppStrings.settings),
        ],
      ),



    body: IndexedStack(
      index: _currentIndex,
      children: <Widget>[
        Navigator(
          key: _page1,
          onGenerateRoute: (route) => MaterialPageRoute(
            settings: route,
            builder: (context) => const HomeScreen(),
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
        _page4.currentState?.popUntil((route) => route.isFirst);
        setState(() {

        });


      }else if(_currentIndex == 2){
        _page4.currentState?.popUntil((route) => route.isFirst);
        setState(() {

        });

      }else if(_currentIndex == 1){
        _page2.currentState?.popUntil((route) => route.isFirst);
        setState(() {

        });

      }else if(_currentIndex == 0){
        _page1.currentState?.popUntil((route) => route.isFirst);
        setState(() {

        });

      }
      _currentIndex = val;
      print('index ${_currentIndex}');



    }
  }
}
