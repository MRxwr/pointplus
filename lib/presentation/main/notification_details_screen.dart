import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(AppSize.s20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: ScreenUtil().screenWidth,
                  height: 200.h,
          
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.s8),
          
          
                    child:
                    CachedNetworkImage(
                      width: AppSize.width,
          
                      fit: BoxFit.fill,
                      imageUrl:'${widget.notification.image}',
                      imageBuilder: (context, imageProvider) => Container(
                          width: AppSize.width,
          
          
                          decoration: BoxDecoration(
          
          
          
                            image: DecorationImage(
          
          
                                fit: BoxFit.fill,
                                image: imageProvider),
                          )
                      ),
                      placeholder: (context, url) =>
                          Column(
                            children: [
                              Expanded(
                                flex: 9,
                                child: Container(
                                  height: AppSize.height,
                                  width:  AppSize.width,
          
          
                                  alignment: FractionalOffset.center,
                                  child: SizedBox(
                                      height: AppSize.s50,
                                      width: AppSize.s50,
                                      child:  const CircularProgressIndicator()),
                                ),
                              ),
                            ],
                          ),
          
          
                      errorWidget: (context, url, error) => Container(
                          height: 80.h,
                          width:  80.w,
          
          
                          child: Image.asset("assets/images/app_icon.png",fit: BoxFit.fill,),),
          
                    ),
                    // Image.network(
                    //
                    //
                    // '${kBaseUrl}${mAdsPhoto}${item.photo}'  , fit: BoxFit.fitWidth,
                    //   height: 600.h,),
                  ),
                ),
                SizedBox(height: 10.h,),
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
      ),
    );
  }
}
