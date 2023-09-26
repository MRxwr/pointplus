import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:point/domain/notification_model.dart';
import 'package:point/presentation/main/notification_details_screen.dart';
import 'package:point/presentation/resources/font_manager.dart';
import 'package:point/presentation/resources/strings_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/point_services.dart';
import '../../domain/home_model.dart';
import '../../providers/notification_provider.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/values_manager.dart';
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationModel? notificationModel;
  bool?  isOk;
  String message = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notification().then((value) {
        isOk  = value['ok'];
        Provider.of<NotificationProvider>(context,listen: false).changeNotification("0");
      if(isOk!){
        notificationModel =  NotificationModel.fromJson(value);
      }else{
        message = "noNotification".tr();

      }
      setState(() {

      });


    });

  }
  Future<dynamic> notification()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("id")??"";
    PointServices pointServices = PointServices();
    dynamic response = await pointServices.notification(id);

    return response;
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
                  child: Text("notifications".tr(),
                    style: TextStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s18,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                Expanded(flex:1,child:
                    isOk == null?
                    Container(
                      child: const CircularProgressIndicator(


                      ),
                      alignment: AlignmentDirectional.center,
                    ):
                    isOk!?


                ListView.separated(itemBuilder: (context,index){
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (BuildContext context){
                        return  NotificationDetailsScreen(notification: notificationModel!.data!.notification![index]
                          );
                      }));
                    },
                    child: Container(
                      height: AppSize.s50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDFEBEE),
                        borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex:4,
                            child: Container(
                              margin: EdgeInsetsDirectional.only(start: AppSize.s5),
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(



                         notificationModel!.data!.notification![index].notification.toString(),

                                style: TextStyle(
                                  color: Color(0xFF0E3151),
                                  fontSize: FontSize.s11,
                                  fontWeight: FontWeight.normal,
                                  overflow: TextOverflow.ellipsis,)

                                ,),
                              ),
                            ),

                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsetsDirectional.only(end: AppSize.s5),
                              alignment: AlignmentDirectional.centerEnd,
                              child: Text(
                                  formatDuration(getRemainingTime(notificationModel!.data!.notification![index].date.toString())),

                                style: TextStyle(
                                  color: ColorManager.secondary,
                                  fontSize: FontSize.s8
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                    ),
                  );
                }, separatorBuilder: (context,index){
                  return Container(height: AppSize.s10,);
                }, itemCount: notificationModel!.data!.notification!.length): Container(
                      alignment: AlignmentDirectional.center,
                      child: Text(message,style: TextStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s18,
                        fontWeight: FontWeight.normal
                      ),),
                    ))
              ],
            ),

          ),
        ),
      ),
    );
  }

  int  getRemainingTime(String date ){
    var now = new DateTime.now();
    print(now);
    DateTime tempDate =  DateTime.parse(date);
    print(date);
    Duration difference = now.difference(tempDate);
    return difference.inSeconds;
  }
  String formatDuration(int d) {
    var seconds = d;
    final days = seconds~/Duration.secondsPerDay;
    seconds -= days*Duration.secondsPerDay;
    final hours = seconds~/Duration.secondsPerHour;
    seconds -= hours*Duration.secondsPerHour;
    final minutes = seconds~/Duration.secondsPerMinute;
    seconds -= minutes*Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('${days}d');
    }
    if (tokens.isNotEmpty || hours != 0){
      tokens.add('${hours}h');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes}m');
    }
    tokens.add('${seconds}s');

    return tokens.join(':');
  }
}
