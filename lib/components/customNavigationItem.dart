
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point/presentation/resources/color_manager.dart';
import 'package:point/presentation/resources/font_manager.dart';
import 'package:point/presentation/resources/values_manager.dart';

BottomNavigationBarItem navigationitem(

    String assetinActive,double height,double width,BuildContext context,String title) {
  ScreenUtil screenUtil = ScreenUtil();

  return BottomNavigationBarItem(
      icon: Container(





        child:
        Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Container(
                  padding: EdgeInsets.only(bottom: AppSize.s4),
                  child: Image.asset(
                    assetinActive,

                    width: width,
                    height: height,
                    fit: BoxFit.fill,

                  ),
                ),Text(title,style: TextStyle(
                  color: ColorManager.white,
                  fontSize: FontSize.s6,
                  fontWeight: FontWeight.bold
                ),)

              ],

            ),

          ],
        ),

      )
      ,
      activeIcon: Container(




          child:
          Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: AppSize.s4),
                    child: Image.asset(assetinActive,
                      width: width,
                      height: height,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text(title,style: TextStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s6,
                      fontWeight: FontWeight.bold
                  ),)

                ],
              ),

            ],
          ),

          ));
}
