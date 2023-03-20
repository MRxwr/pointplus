import 'package:flutter/material.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:point/presentation/resources/color_manager.dart';
import 'package:point/presentation/resources/font_manager.dart';
import 'package:point/presentation/resources/strings_manager.dart';

import '../resources/assets_manager.dart';
import '../resources/values_manager.dart';
class PrivacyPolicyScreen extends StatefulWidget {
  String privacy;
  String title;
   PrivacyPolicyScreen({Key? key, required this.privacy, required this.title}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
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
        appBar: AppBar(
          elevation: 0,

          backgroundColor: ColorManager.primary,
          title: Center(
            child: Center(
              child: Image.asset(ImageAssets.titleBarImage,height: AppSize.s32, width: AppSize.s110,fit: BoxFit.fill,),
            ),
          ),
          actions: [
            SizedBox(width: AppSize.s30,)
          ],
          leading:
          GestureDetector(
            onTap: (){
              Navigator.pop(context);

            },
            child: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,size: AppSize.s20,),
          ),


        ),
        body: Container(
          color: ColorManager.primary,
          child: Container(
            margin: EdgeInsets.all(AppSize.s10),
            child: ListView(
              padding: EdgeInsets.zero,
           children: [
             Text(widget.privacy,
               textAlign: TextAlign.start,
               style: TextStyle(color: ColorManager.white,fontSize: FontSize.s14,
             fontWeight: FontWeight.normal,),)
           ],

            ),
          ),

        ),
      ),
    );
  }
}
