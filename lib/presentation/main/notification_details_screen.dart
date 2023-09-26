import 'package:flutter/material.dart';
import 'package:point/domain/notification_model.dart' as Model;

import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/values_manager.dart';
class NotificationDetailsScreen extends StatefulWidget {
  Model.Notification notification;
   NotificationDetailsScreen({Key? key,required this.notification}) : super(key: key);

  @override
  State<NotificationDetailsScreen> createState() => _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
        width: AppSize.width,
        height: AppSize.height,
        decoration: const BoxDecoration(
            image:  DecorationImage(
              image: AssetImage(ImageAssets.background),
              fit: BoxFit.cover,
            )),
        child: Container(
          margin: EdgeInsets.all(AppSize.s20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: AppSize.s20),
                child: Text(widget.notification.notification.toString(),
                  style: TextStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s18,
                      fontWeight: FontWeight.normal
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
